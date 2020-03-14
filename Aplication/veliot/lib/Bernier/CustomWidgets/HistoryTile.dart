import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../home.dart';

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription(
      {Key key,
      this.title,
      this.description,
      this.type,
      this.beginDate,
      this.endDate,
      this.distance})
      : super(key: key);

  final String title;
  final String description;
  final String type;
  final DateTime beginDate;
  final DateTime endDate;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$title',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.title),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$description',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    size: 16,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text( endDate.difference(beginDate).inMinutes<300?endDate.difference(beginDate).inMinutes.toString()+" minutes":endDate.difference(beginDate).inHours.toString()+" heures",
                      ))
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$type',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                new DateFormat.yMMMd('fr_FR').add_jm().format(beginDate) +
                    "· " +
                    new DateFormat.yMMMd('fr_FR').add_jm().format(endDate),
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo(
      {Key key,
      this.thumbnail,
      this.title,
      this.description,
      this.type,
      this.beginDate,
      this.endDate,
      this.distance})
      : super(key: key);

  final Widget thumbnail;
  final String title;
  final String description;
  final String type;
  final DateTime beginDate;
  final DateTime endDate;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: new GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Home()
          ));
        },
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: thumbnail,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: _ArticleDescription(
                    title: title,
                    description: description,
                    type: type,
                    beginDate: beginDate,
                    endDate: endDate,
                    distance: distance,
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
