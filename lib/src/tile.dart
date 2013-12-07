part of turn;

// Tile class
class Tile {
  // Properties
  int id;
  num _size;
  num _x;
  num _y;
  List units = new List<Unit>();
  // Getters
  num get x => _x - map.offsetX;
  num get y => _y - map.offsetY;
  num get width => _size;
  num get height => _size;
  num get centerX => x + (width / 2);
  num get centerY => y + (height / 2);
  num get endX => x + width;
  num get endY => y + height;
  // Constructors
  Tile(int this.id, num this._size, num this._x, num this._y);
  // Functions
  void draw() {
    _clear();
    context.strokeRect(x, y, width, height);
    //context.font = "12px Arial";
    context.fillText(id.toString(), centerX, centerY);
    // Draw containing units. @TODO: We probably only want to draw one ;)
    if (units.isNotEmpty) {
      for (Unit unit in units) {
        unit.draw();
      }
    }
  }
  void select() {
    _clear();
    context.fillRect(x, y, width, height);
  }
  void _clear() {
    context.clearRect(x, y, width, height);
  }
}
