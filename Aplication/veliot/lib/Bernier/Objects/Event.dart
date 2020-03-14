class Event {
  String _eventType;
  String _description;
  String _title;
  DateTime _end;
  DateTime _begin;

  String getType(){
    return _eventType;
  }

  String getTitle(){
    return _title;
  }

  String getDescription(){
    return _description;
  }

  DateTime getEnd(){
    return _end;
  }

  DateTime getBegin(){
    return _begin;
  }
  Event.fromJson(Map<String, dynamic> json)
      : _title = json['titre'],
        _eventType = json['event_type'],
        _description = json['description'],
        _end = DateTime.parse(json['end']),
        _begin = DateTime.parse(json['begin']);

}
