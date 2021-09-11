import 'package:flutter/material.dart';
import 'table_widget.dart';

class TopWidget extends StatefulWidget {
  const TopWidget({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  TopWidgetState createState() => TopWidgetState();
}

class TopWidgetState extends State<TopWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: buildGameTable()),
    );
  }

  Widget buildGameTable() {
    print("buildGameTable");
    return SingleChildScrollView(
        child: Column(children: [
      GameTableWidget(roomId: widget.roomId),
      //GameTableWidget(roomId: widget.roomId, playerName: "Player2"),
      //GameTableWidget(roomId: widget.roomId, playerName: "Player3"),
      //GameTableWidget(roomId: widget.roomId, playerName: "Player4"),
    ]));
  }
}
