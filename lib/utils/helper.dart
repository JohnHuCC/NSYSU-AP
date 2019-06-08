import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:nsysu_ap/models/login_response.dart';
import 'package:nsysu_ap/models/score_data.dart';
import 'package:nsysu_ap/models/score_semester_data.dart';

import 'app_localizations.dart';
import 'big5.dart';

const HOST = "nsysu-ap.rainvisitor.me";
const PORT = '8443';
const BASE_URL = 'https://$HOST:$PORT';

class Helper {
  static Helper _instance;
  static String cookie = 'ASPSESSIONIDSCRQARTB=GFBKIHCBPGELFHFMBLAPJINC';

  static Helper get instance {
    if (_instance == null) {
      _instance = Helper();
    }
    return _instance;
  }

  String get language {
    switch (AppLocalizations.locale.languageCode) {
      case 'zh':
        return 'cht';
        break;
      case 'en':
        return 'eng';
        break;
      default:
        return 'cht';
        break;
    }
  }

  Future<int> login(String username, String password) async {
    print(DateTime.now());
    var response = await http.post(
      '$BASE_URL/selcrs/login',
      headers: {
        'Content-Type': 'application/json',
      },
      body: '{\"username\": \"$username\",\"password\": \"$password\"}',
    );
    print(DateTime.now());
    var loginResponse = LoginResponse.fromJson(
      jsonDecode(response.body),
    );
    if (loginResponse.data != null) {
      cookie = '${loginResponse.data[0].name}=${loginResponse.data[0].value}';
      return 200;
    } else {
      return 500;
    }
  }

  Future<ScoreSemesterData> getScoreSemesterData() async {
    var url =
        'http://selcrs.nsysu.edu.tw/scoreqry/sco_query.asp?ACTION=702&KIND=2&LANGS=$language';
    var response = await http.post(
      url,
      headers: {'Cookie': cookie},
      encoding: Encoding.getByName('BIG-5'),
    );
    String text = big5.decode(response.bodyBytes);
    //print('text =  ${text}');
    var document = parse(text, encoding: 'BIG-5');
    var selectDoc = document.getElementsByTagName('select');
    var scoreSemesterData = ScoreSemesterData(
      semesters: [],
      years: [],
    );
    if (selectDoc.length >= 2) {
      var options = selectDoc[0].getElementsByTagName('option');
      for (var i = 0; i < options.length; i++) {
        scoreSemesterData.years.add(
          Options(
            text: options[i].text,
            value: options[i].attributes['value'],
          ),
        );
      }
      options = selectDoc[1].getElementsByTagName('option');
      for (var i = 0; i < options.length; i++) {
        scoreSemesterData.semesters.add(
          Options(
            text: options[i].text,
            value: options[i].attributes['value'],
          ),
        );
        if (options[i].attributes['selected'] != null)
          scoreSemesterData.selectSemesterIndex = i;
      }
    } else {
      print('document.text = ${document.text}');
    }
    return scoreSemesterData;
  }

  Future<ScoreData> getScoreData(String year, String semester) async {
    var url =
        'http://selcrs.nsysu.edu.tw/scoreqry/sco_query.asp?ACTION=804&KIND=2&LANGS=$language';
    var response = await http.post(
      url,
      headers: {'Cookie': cookie},
      body: {
        'SYEAR': year,
        'SEM': semester,
      },
      encoding: Encoding.getByName('BIG-5'),
    );
    String text = big5.decode(response.bodyBytes);
    var document = parse(text, encoding: 'BIG-5');
    List<Score> list = [];
    Detail detail = Detail();
    var tableDoc = document.getElementsByTagName('tbody');
    if (tableDoc.length >= 2) {
//      for (var i = 0; i < tableDoc.length; i++) {
//        //print('i => ${tableDoc[i].text}');
//        var fontDoc = tableDoc[i].getElementsByTagName('tr');
//        for (var j = 0; j < fontDoc.length; j++) {
//          print("i $i j $j => ${fontDoc[j].text}");
//        }
//      }
      if (tableDoc.length == 3) {
        var fontDoc = tableDoc[1].getElementsByTagName('font');
        detail.conduct =
            '${fontDoc[0].text.split('：')[1]}/${fontDoc[1].text.split('：')[1]}';
        detail.average = fontDoc[2].text.split('：')[1];
        detail.classRank =
            '${fontDoc[4].text.split('：')[1]}/${fontDoc[5].text.split('：')[1]}';
        var percentage = double.parse(fontDoc[4].text.split('：')[1]) /
            double.parse(fontDoc[5].text.split('：')[1]);
        percentage = 1.0 - percentage;
        percentage *= 100;
        detail.classPercentage = '${percentage.toStringAsFixed(2)}';
      }
      var trDoc = tableDoc[0].getElementsByTagName('tr');
      for (var i = 0; i < trDoc.length; i++) {
        var fontDoc = trDoc[i].getElementsByTagName('font');
        if (fontDoc.length != 6) continue;
        if (i != 0)
          list.add(Score(
            title: //'${trDoc[i].getElementsByTagName('font')[2].text}'
                '${fontDoc[3].text}',
            middleScore: '${fontDoc[4].text}',
            finalScore: fontDoc[5].text,
          ));
      }
    }
    /*var trDoc = document.getElementsByTagName('tr');
    for (var i = 0; i < trDoc.length; i++) {
      if (trDoc[i].getElementsByTagName('font').length != 6) continue;
      if (i != 0)
        list.add(Score(
          title: //'${trDoc[i].getElementsByTagName('font')[2].text}'
              '${trDoc[i].getElementsByTagName('font')[3].text}',
          middleScore: '${trDoc[i].getElementsByTagName('font')[4].text}',
          finalScore: trDoc[i].getElementsByTagName('font')[5].text,
        ));
      for (var j in trDoc[i].getElementsByTagName('font')) {
        //print('${j.text}');
      }
    }*/
    var scoreData = ScoreData(
      status: 200,
      messages: '',
      content: Content(
        scores: list,
        detail: detail,
      ),
    );
    if (list.length == 0) scoreData.status = 204;
    return scoreData;
  }
}