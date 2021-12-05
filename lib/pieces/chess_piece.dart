enum PlayerColor { black, white }

class Location {
  final int x;
  final int y;

  Location(this.x, this.y);

  bool get isValid => x <= 7 && y <= 7;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Location && (x == other.x && y == other.y);
  }

  @override
  String toString() => "Location($x, $y)";
}

abstract class ChessPiece {
  final PlayerColor pieceColor;
  Location location;

  String get name;

  String get fileName =>
      "assets/${pieceColor.toString().split(".").last}_$name.png";

  int get x => location.x;

  int get y => location.y;

  ChessPiece(
    this.pieceColor,
    this.location,
  );

  List<Location> moves(List<ChessPiece> others);

  List<Location> captures(List<ChessPiece> others);

  bool canMoveTo(int x, int y, List<ChessPiece> others) =>
      moves(others).contains(Location(x, y));

  bool canCapture(int x, int y, List<ChessPiece> others) =>
      captures(others).contains(Location(x, y));

  @override
  String toString() => "$name($x, $y)";
}
