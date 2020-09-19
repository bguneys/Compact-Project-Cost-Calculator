import 'package:bgsapp02082020/data/AppStrings.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      appBar: AppBar(
        title: Text(AppStrings.aboutAppScreenTitle, style: Theme.of(context).textTheme.headline6),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        centerTitle: true,
      ),

      body: Container(
        color: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                      child: Text("Time-Cost App is a minimalist cost and time calculation app built for helping managing projects easily.\n\nFor each projects necessary work items can be added into projects by specifying hourly rate, duration and cost required to finish each work. This helps the users to see a broader picture of their project costs and estimated time to complete the project.",
                          style: Theme.of(context).textTheme.bodyText1)
                  ),
                )
            ),
          ],
        ),
      ) ,
    );
  }
}
