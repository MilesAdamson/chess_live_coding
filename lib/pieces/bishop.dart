import 'package:chess/pieces/chess_piece.dart';

class Bishop extends ChessPiece {
  @override
  String get name => "bishop";

  Bishop(
    PlayerColor pieceColor,
    Location location,
  ) : super(pieceColor, location);

  @override
  List<Location> moves(List<ChessPiece> others) {
    return <Location>[
      ..._generateMovesOnDiagonal(true, true, others),
      ..._generateMovesOnDiagonal(false, true, others),
      ..._generateMovesOnDiagonal(true, false, others),
      ..._generateMovesOnDiagonal(false, false, others),
    ].toList();
  }

  @override
  List<Location> captures(List<ChessPiece> others) {
    return <Location>[
      ..._generateCapturesOnDiagonal(true, true, others),
      ..._generateCapturesOnDiagonal(false, true, others),
      ..._generateCapturesOnDiagonal(true, false, others),
      ..._generateCapturesOnDiagonal(false, false, others),
    ].toList();
  }

  List<Location> _generateMovesOnDiagonal(
    bool isUp,
    bool isRight,
    List<ChessPiece> pieces,
  ) {
    bool obstructed = false;

    return List<Location?>.generate(8, (i) {
      if (obstructed) return null;

      int dx = (isRight ? 1 : -1) * i;
      int dy = (isUp ? 1 : -1) * i;

      final destination = Location(x + dx, y + dy);

      final pieceOnLocation =
          pieces.any((piece) => piece.location == destination);

      if (pieceOnLocation && location != destination) {
        obstructed = true;
        return null;
      }

      return destination;
    }).whereType<Location>().where((location) => location.isValid).toList();
  }

  List<Location> _generateCapturesOnDiagonal(
    bool isUp,
    bool isRight,
    List<ChessPiece> pieces,
  ) {
    bool hasFoundCapture = false;

    return List<Location?>.generate(8, (i) {
      if (hasFoundCapture) return null;

      int dx = (isRight ? 1 : -1) * i;
      int dy = (isUp ? 1 : -1) * i;

      final destination = Location(x + dx, y + dy);

      final pieceOnLocation =
          pieces.any((piece) => piece.location == destination);

      if (pieceOnLocation && location != destination) {
        hasFoundCapture = true;
        return destination;
      }
    }).whereType<Location>().where((location) => location.isValid).toList();
  }
}
