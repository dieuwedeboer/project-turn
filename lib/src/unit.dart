part of turn;

// Base unit class
class Unit {
  // Properties
  Tile tile = null; // Current location
  int movement = 1; // 0 for none
  String name = "";
  String type = "";
  int range = 1; // 0 for none, 1 for most, 2-5 for artilery
  int damage = 2; // Different types of damage?
  int defense = 5; // Different types of defense?
  int health = 10; // Custom type? Total and current
  // Constructors
  Unit(this.tile);
  // Functions
  void draw() {
    var size = tile.height / 2; // make unit half of tile for now
    var offset = size / 2; // put it in the middle;
    context.fillRect(tile.x + offset, tile.y + offset, size, size);
  }
}