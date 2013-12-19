part of turn;

/**
 * PathNode class
 */
class PathNode {
  /**
   * Properties
   */
  PathNode parent; // Pointer to another Node.
  Tile tile; // Pointer to the tile.
  int x; // The location coordinates of this Node.
  int y;
  int f = 0; // Movement cost to get TO this Node from the START.
  int g = 0; // Movement cost to get to the GOAL from this Node.
  /**
   * Getters
   */
  int get index => tile.id; // Index of Node in world list.
  /**
   * Constructor
   */
  PathNode(this.parent, this.tile) {
    x = tile.column;
    y = tile.row;
  }
}
