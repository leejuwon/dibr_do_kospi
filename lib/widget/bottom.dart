import 'package:flutter/material.dart';
class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Container(
          height: 50,
          child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.transparent,
              tabs: <Widget>[
                Tab(
                    icon: Icon(Icons.calendar_today, size: 18),
                    child: Text(
                      'Today',
                      style: TextStyle(fontSize: 10),
                    )),
                Tab(
                    icon: Icon(Icons.history, size: 18),
                    child: Text(
                      'History',
                      style: TextStyle(fontSize: 10),
                    )),
                Tab(
                    icon: Icon(Icons.info, size: 18),
                    child: Text(
                      'INFO',
                      style: TextStyle(fontSize: 10),
                    )),
              ])),
    );
  }
}