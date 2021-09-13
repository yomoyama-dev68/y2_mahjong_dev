import 'package:flutter/material.dart';

import '../game_controller.dart' as game;
import '../table_controller.dart' as tbl;

class MyWallWidget extends StatefulWidget {
  const MyWallWidget({Key? key, required this.gameData, required this.imageMap})
      : super(key: key);

  final game.Game gameData;
  final Map<String, Image> imageMap;

  @override
  MyWallWidgetState createState() => MyWallWidgetState();
}

class MyWallWidgetState extends State<MyWallWidget> {
  game.Game g() {
    return widget.gameData;
  }

  @override
  void initState() {
    widget.gameData.onChangeMyTurnTempState = _onChangeMyTurnTempState;
  }

  @override
  Widget build(BuildContext context) {
    return _buildMyWall();
  }

  Widget _buildMyWall() {
    final tappable = _isTappableState();

    final selectingTiles = g().myTurnTempState.selectingTiles;
    final myData = g().table.playerData(g().myPeerId)!;
    final widgets = <Widget>[];
    final builder = tappable ? _buildTile : _buildDisabledTile;

    // 持ち牌
    for (final tile in myData.tiles) {
      widgets.add(builder(tile, selectingTiles.contains(tile)));
    }
    // ツモ牌
    if (myData.drawnTile.isNotEmpty) {
      widgets.add(const SizedBox(width: (33 / 0.8) / 2));
      final tile = myData.drawnTile.first;
      widgets.add(builder(tile, selectingTiles.contains(tile)));
    }

    final row = Row(
      children: widgets,
    );
    final content = tappable
        ? Material(child: row)
        : Opacity(
            opacity: 0.5,
            child: row,
          );

    return SingleChildScrollView(
        child: content, scrollDirection: Axis.horizontal);
  }

  Widget _buildDisabledTile(int tile, bool _) {
    const scale = 0.8;
    return SizedBox(
      child: getTileImage(tile),
      height: 59.0 / scale,
      width: 33.0 / scale,
    );
  }

  Widget _buildTile(int tile, bool selecting) {
    const scale = 0.8;
    return Container(
        child: Ink.image(
          image: getTileImage(tile).image,
          height: 59.0 / scale,
          width: 33.0 / scale,
          child: InkWell(
            onTap: () => _onTapTile(tile),
            child: const SizedBox(),
          ),
        ),
        decoration: selecting
            ? BoxDecoration(
                border: Border.all(color: Colors.red),
              )
            : null);
  }

  bool _isTappableState() {
    int limit = g().selectableTilesQuantity();
    if (limit > 0) {
      return true;
    }
    if ([
      tbl.TableState.waitToDiscard,
      tbl.TableState.waitToDiscardForPongOrChow,
      tbl.TableState.waitToDiscardForOpenOrLateKan,
    ].contains(g().table.state)) {
      return true;
    }
    return false;
  }

  void _onChangeMyTurnTempState() {
    setState(() {});
  }

  void _onTapTile(int tile) {
    setState(() {
      int limit = g().selectableTilesQuantity();
      if (limit > 0) {
        _selectTile(tile, limit);
        return;
      }

      if ([
        tbl.TableState.waitToDiscard,
        tbl.TableState.waitToDiscardForPongOrChow,
        tbl.TableState.waitToDiscardForOpenOrLateKan,
      ].contains(g().table.state)) {
        _selectDiscardTile(tile);
        return;
      }
    });
  }

  void _selectDiscardTile(int tile) {
    final selectingTiles = g().myTurnTempState.selectingTiles;
    if (selectingTiles.isEmpty) {
      selectingTiles.add(tile);
    } else if (selectingTiles.contains(tile)) {
      g().discardTile(tile);
      selectingTiles.clear();
    } else {
      selectingTiles.clear();
      selectingTiles.add(tile);
    }
  }

  void _selectTile(int tile, limit) {
    final selectingTiles = g().myTurnTempState.selectingTiles;
    if (selectingTiles.contains(tile)) {
      selectingTiles.remove(tile);
      g().onChangeSelectingTiles?.call();
    } else {
      if (selectingTiles.length < limit) {
        selectingTiles.add(tile);
        g().onChangeSelectingTiles?.call();
      }
    }
  }

  Image getTileImage(int tile, [direction = 4]) {
    // direction = 0: 打牌(上向, 1: 打牌(左向, 2: 打牌(下向, 3: 打牌(右向, 4: 自牌(上向,
    final info = tbl.TileInfo(tile);
    final key = "${info.type}_${info.number}_${direction}";
    final image = widget.imageMap[key]!;
    return image;
  }
}