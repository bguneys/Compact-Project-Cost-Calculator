import 'package:bgsapp02082020/data/AppStrings.dart';
import 'package:flutter/material.dart';

class DisclaimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      appBar: AppBar(
        title: Text(AppStrings.disclaimerScreenTitle, style: Theme.of(context).textTheme.headline6),
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
                        child: Text(AppStrings.disclaimerText,
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
