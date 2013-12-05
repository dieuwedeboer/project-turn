part of turn;

// Map class
class GameMap {
  // Properties
  num width;
  num height;
  Tile selectedTile;
  Unit activeUnit;
  List tiles = new List<Tile>();
  num get size => width * height;
  // Constructors
  GameMap(num this.width, num this.height);
  // Functions
  void draw() {
    for (Tile tile in tiles) {
      tile.draw();
    }
  }
  // Generate tiles
  void generate() {
    num x = 0;
    num y = 0;
    Tile tile;
    int column = 0;
    // Generate tiles (@TODO: Separate function(s)?)
    for (int i = 0; i < size; i++) {
      tile = new Tile(i, tileSize(), x, y); // Create new tile
      tile.draw(); // Draw new tile
      tiles.add(tile); // Add new tile to list.
      // Increment counters
      x += tile.width;
      column++;
      if (column == width) {
        y += tile.height;
        column = 0;
        x = 0;
      }
    }
  }
  // Tile size
  num tileSize() {
    num maxTileWidth = canvas.width / width;
    num maxTileHeight = canvas.height / height;
    num tileSize = Math.min(maxTileWidth, maxTileHeight);
    return tileSize.floor();
  }
}
