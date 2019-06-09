import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nsysu_ap/res/resource.dart' as Resource;
import 'package:nsysu_ap/utils/app_localizations.dart';
import 'package:nsysu_ap/utils/firebase_analytics_utils.dart';
import 'package:nsysu_ap/utils/utils.dart';

import 'open_source_page.dart';

class AboutUsPageRoute extends MaterialPageRoute {
  AboutUsPageRoute()
      : super(builder: (BuildContext context) => new AboutUsPage());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new AboutUsPage());
  }
}

class AboutUsPage extends StatefulWidget {
  static const String routerName = "/aboutUs";

  @override
  AboutUsPageState createState() => new AboutUsPageState();
}

class AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  AppLocalizations app;

  @override
  void initState() {
    super.initState();
    FA.setCurrentScreen("AboutUsPage", "about_us_page.dart");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    app = AppLocalizations.of(context);
    var expandedHeight = MediaQuery.of(context).size.height * 0.25;
    return new Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: expandedHeight,
              floating: false,
              pinned: true,
              title: new Text(app.about),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.code),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(OpenSourcePage.routerName);
                      FA.logAction('open_source', 'click');
                    })
              ],
              backgroundColor: Resource.Colors.blue,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "assets/images/kuasap2.webp",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            _item(app.aboutAuthorTitle, app.aboutAuthorContent),
            _item(app.about, app.aboutUsContent),
            _item(app.aboutRecruitTitle, app.aboutRecruitContent),
            Stack(
              children: <Widget>[
                _item(app.aboutItcTitle, app.aboutItcContent),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 26.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      "assets/images/kuas_itc.webp",
                      width: 64.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 4.0,
              child: Container(
                padding: EdgeInsets.only(
                    top: 24.0, left: 16.0, bottom: 16.0, right: 16.0),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      app.aboutContactUsTitle,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset("assets/images/ic_fb.webp"),
                            onPressed: () {
                              if (Platform.isAndroid)
                                Utils.launchUrl('fb://page/735951703168873')
                                    .catchError((onError) => Utils.launchUrl(
                                        'https://www.facebook.com/NKUST.ITC/'));
                              if (Platform.isIOS)
                                Utils.launchUrl('fb://profile/735951703168873')
                                    .catchError((onError) => Utils.launchUrl(
                                        'https://www.facebook.com/NKUST.ITC/'));
                              else
                                Utils.launchUrl(
                                        'https://www.facebook.com/NKUST.ITC/')
                                    .catchError((onError) => Utils.showToast(
                                        context, app.platformError));
                              FA.logAction('fb', 'click');
                            },
                            iconSize: 48.0,
                          ),
                          IconButton(
                            icon: Image.asset("assets/images/ic_github.webp"),
                            onPressed: () {
                              if (Platform.isAndroid)
                                Utils.launchUrl(
                                        'github://organization/NKUST-ITC')
                                    .catchError((onError) => Utils.launchUrl(
                                        'https://github.com/NKUST-ITC'));
                              else if (Platform.isIOS)
                                Utils.launchUrl('https://github.com/NKUST-ITC');
                              else
                                Utils.launchUrl('https://github.com/NKUST-ITC')
                                    .catchError((onError) => Utils.showToast(
                                        context, app.platformError));
                              FA.logAction('github', 'click');
                            },
                            iconSize: 48.0,
                          ),
                          IconButton(
                            icon: Image.asset("assets/images/ic_email.webp"),
                            onPressed: () {
                              Utils.launchUrl('mailto:abc873693@gmail.com')
                                  .catchError((onError) => Utils.showToast(
                                      context, app.platformError));
                              FA.logAction('email', 'click');
                            },
                            iconSize: 48.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _item(app.aboutOpenSourceTitle, app.aboutOpenSourceContent),
          ],
        ),
      ),
    );
  }

  _item(String text, String subText) => Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 4.0,
        child: Container(
          padding:
              EdgeInsets.only(top: 24.0, left: 16.0, bottom: 16.0, right: 16.0),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(
                height: 4.0,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14.0, color: Resource.Colors.grey),
                  text: subText,
                ),
              ),
            ],
          ),
        ),
      );
}
