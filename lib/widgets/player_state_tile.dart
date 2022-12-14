import 'dart:async';

import 'package:flutter/material.dart';
import 'package:y2_mahjong/widgets/voiced_icon.dart';

class PlayerStateTile extends StatelessWidget {
  const PlayerStateTile(this.wind, this.name, this.score, this.riichi,
      this.turned, this.peerId, this.streamController, this.muted,
      {Key? key})
      : super(key: key); // コンストラクタで引数を受け取る

  static const windTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
  );

  static const contentTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
  );

  static const turnedColor = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.deepOrange,
  );

  final String wind;
  final String name;
  final int score;
  final bool riichi;
  final bool turned;
  final String peerId;
  final StreamController<String> streamController;
  final bool muted;

  int _score() {
    if (riichi) return score - 1000;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final windTS = turned ? windTextStyle.merge(turnedColor) : windTextStyle;
    final contentTs =
        turned ? contentTextStyle.merge(turnedColor) : contentTextStyle;

    return Opacity(
        opacity: 0.6,
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                    child: Text(wind, style: windTS)),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                        width: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: contentTs,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis),
                            Text(
                              '${_score()}',
                              style: contentTs,
                              textAlign: TextAlign.right,
                            )
                          ],
                        ))),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: VoicedIcon(
                      peerId: peerId,
                      streamController: streamController,
                      color: Colors.white,
                      micOff: muted,
                    ))
              ],
            )));
  }
}
