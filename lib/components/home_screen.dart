import 'package:chess/game_coordinator.dart';
import 'package:chess/pieces/chess_piece.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final double tileWidth = MediaQuery.of(context).size.width / 8.0;

  final Color green = const Color.fromRGBO(119, 149, 86, 100);
  final Color listGreen = const Color.fromRGBO(235, 236, 208, 100);

  final GameCoordinator coordinator = GameCoordinator.newGame();

  List<ChessPiece> get pieces => coordinator.pieces;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chess"),
      ),
      body: Column(
        children: [
          const Spacer(),
          buildBoard(),
          const Spacer(),
        ],
      ),
    );
  }

  Column buildBoard() {
    return Column(
      children: [
        ...List.generate(
            8,
            (y) => Row(
                  children: [
                    ...List.generate(
                      8,
                      (x) => buildDragTarget(x, y),
                    ),
                  ],
                )).reversed,
      ],
    );
  }

  DragTarget<ChessPiece> buildDragTarget(int x, int y) {
    return DragTarget<ChessPiece>(
      onAccept: (piece) {
        final capturedPiece = coordinator.pieceOfTile(x, y);

        setState(() {
          piece.location = Location(x, y);
          if (capturedPiece != null) {
            print("$capturedPiece captured!!");
            pieces.remove(capturedPiece);
          }
        });
      },
      onWillAccept: (piece) {
        if (piece == null) {
          return false;
        }

        final canMoveTo = piece.canMoveTo(x, y, pieces);
        final canCapture = piece.canCapture(x, y, pieces);

        return canMoveTo || canCapture;
      },
      builder: (context, data, rejects) => Container(
        decoration: BoxDecoration(
          color: buildTileColor(x, y),
        ),
        width: tileWidth,
        height: tileWidth,
        child: _buildChessPieces(x, y),
      ),
    );
  }

  Color buildTileColor(int x, int y) {
    int value = x;
    if (y.isOdd) {
      value++;
    }
    return value.isEven ? green : listGreen;
  }

  Widget? _buildChessPieces(int x, int y) {
    final piece = coordinator.pieceOfTile(x, y);
    if (piece != null) {
      final child = Container(
        alignment: Alignment.center,
        child: Image.asset(
          piece.fileName,
          height: tileWidth * 0.8,
          width: tileWidth * 0.8,
        ),
      );

      return Draggable<ChessPiece>(
        data: piece,
        feedback: child,
        child: child,
        childWhenDragging: const SizedBox.shrink(),
      );
    }
  }
}
