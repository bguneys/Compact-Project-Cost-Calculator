import 'package:bgsapp02082020/data/AppStrings.dart';
import 'package:flutter/material.dart';

import 'AboutScreen.dart';
import 'DisclaimerScreen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      appBar: AppBar(
        title: Text(AppStrings.aboutScreenTitle, style: Theme.of(context).textTheme.headline6),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        centerTitle: true,
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                    child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DisclaimerScreen()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(AppStrings.disclaimerLabel, style: Theme.of(context).textTheme.subtitle2),
                        ),
                      ),
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Expanded(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(AppStrings.aboutLabel, style: Theme.of(context).textTheme.subtitle2),
                      ),
                    ),
                ),
              ],
            ),
          ],
        ),
      ) ,
    );
  }
}
