part of turn;

/**
 * Tile class
 */
class Tile {
  /**
   * Properties
   */
  int id;
  num _size;
  num _x; // absolute x/y with relation to the whole map
  num _y;
  num row;
  num column;
  List units = new List<Unit>();
  ImageElement image;
  bool selected;
  /**
   * Getters
   */
  num get x => _x - map.offsetX; // relative x/y with relation to the canvas
  num get y => _y - map.offsetY;
  num get width => _size;
  num get height => _size;
  num get centerX => x + (width / 2);
  num get centerY => y + (height / 2);
  num get endX => x + width;
  num get endY => y + height;
  /**
   * Constructors
   */
  Tile(int this.id, num this._size, num this._x, num this._y) {
    // @TODO: Check if asset really is in cache? (Load properly)
    image = gCachedAssets['/images/grass_1.png'];
  }
  /**
   * Functions
   */
  void draw() {
    _clear();
    // @TODO: Loading screen for assets
    ctx.drawImageScaled(image, x, y, width, height);
    ctx.strokeRect(x, y, width, height);
    ctx.fillText(id.toString(), centerX, centerY);
    // If selected
    if (selected) {
      select();
    }
    // Draw containing units. @TODO: We probably only want to draw one.
    if (units.isNotEmpty) {
      for (Unit unit in units) {
        unit.draw();
      }
    }
  }
  void select() {
    _clear();
    ctx.fillRect(x, y, width, height);
  }
  void _clear() {
    ctx.clearRect(x, y, width, height);
  }
}
