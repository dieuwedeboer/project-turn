part of turn;

/**
**************************************************
 * Basic pathfinding algorithm (work in progress)
 * Using A-star
 **************************
 * @TODO: wrap this is some class or something. A static one.
 */

/**
 * Heuristic distance calculation function.
 * @return - integer value for shortest possible steps to destination.
 */
num heuristicDistance(Tile current, Tile goal) {
  // Euclidean distance
  num dx = Math.pow(current.row - goal.row, 2);
  num dy = Math.pow(current.column - goal.column, 2);
  return Math.sqrt(dx + dy);
}

/**
 * Neighbours function.
 * @return - a list of every available adjacent tile.
 */
List listFreeNeighbours(Tile tile) {
  int column = tile.column,
    row = tile.row;
  int north = row - 1,
    south = row + 1,
    east = column + 1,
    west = column - 1;
  // @TODO: simplify so that "canWalkHere" does ALL checks (inc out-of-bounds)?
  bool northIsFree = north > -1 && canWalkHere(north, column),
    southIsFree = south < map.tilesHigh && canWalkHere(south, column),
    eastIsFree = east < map.tilesWide && canWalkHere(row, east),
    westIsFree = west > -1 && canWalkHere(row, west);
  // Build list of neighbours including diagonals.
  List result = new List<Tile>();
  if (northIsFree) {
    result.add(map.tiles[north][column]); // Add north tile.
    if (eastIsFree && canWalkHere(north, east)) {
      result.add(map.tiles[north][east]); // Add northeast tile.
    }
    if (westIsFree && canWalkHere(north, west)) {
      result.add(map.tiles[north][west]); // Add northwest tile.
    }
  }
  if (southIsFree) {
    result.add(map.tiles[south][column]); // Add south tile.
    if (eastIsFree && canWalkHere(south, east)) {
      result.add(map.tiles[south][east]); // Add southeast tile.
    }
    if (westIsFree && canWalkHere(south, west)) {
      result.add(map.tiles[south][west]); // Add southwest tile.
    }
  }
  if (eastIsFree) {
    result.add(map.tiles[row][east]); // Add east tile.
  }
  if (westIsFree) {
    result.add(map.tiles[row][west]); // Add west tile.
  }
  // Return list of free neighbours.
  return result;
}

// Returns boolean value (tile is available and open).
bool canWalkHere(int row, int column) {
  // @TODO: Is this actually a tile? See comment in neighbours.
  Tile tile = map.tiles[row][column];
  if (tile.units.isNotEmpty) {
    return false;
  }
  return true;
}

// A* (a-star) path function, executes algorithm.
List<Tile> findPath(GameMap map, Tile startTile, Tile endTile) {
  // Create PathNodes from the start and end tiles
  PathNode startNode = new PathNode(null, startTile);
  PathNode endNode = new PathNode(null, endTile);
  // Create a list that will contain all map tiles
  List AStar = new List<bool>(map.size);
  // List of currently open PathNodes
  List openList = [startNode];
  // List of closed PathNodes
  List closedList = new List<PathNode>();
  // List of the final output array
  List resultPath = new List<Tile>();
  // List of tiles (that are nearby)
  List neighbourList;
  // Reference to a PathNode (that we are considering now)
  PathNode currentNode;
  // Reference to a PathNode (that starts a path in question)
  PathNode pathNode;

  // Iterate through the open list until none are left
  while (openList.isNotEmpty) {
    int maxF = openList[0].f; // Default.
    int minIndex = 0; // Default.
    // Find the index of the node with lowest f value.
    for (int i = 0; i < openList.length; i++) {
      if (openList[i].f < maxF) {
        minIndex = i;
      }
    }
    // Grab the lowest f value node and remove it from openList array
    currentNode = openList[minIndex];
    openList.remove(currentNode);

    // Is the current node the destination node?
    if (currentNode.index == endNode.index) {
      resultPath = reconstructPath(currentNode);
      return resultPath;
    }

    // Find which nearby nodes are walkable
    neighbourList = listFreeNeighbours(currentNode.tile);
    // Test each neighbour that hasn't been tried already.
    for (Tile tile in neighbourList) {
      pathNode = new PathNode(currentNode, tile);
      if (!AStar[pathNode.index]) {
        // Estimated cost of this particular route so far.
        pathNode.g = currentNode.g + heuristicDistance(tile, currentNode.tile);
        // Estimated cost of entire guessed route to the destination.
        pathNode.f = pathNode.g + heuristicDistance(tile, endNode.tile);
        // Remember this new path for testing above.
        openList.add(pathNode);
        // Mark this node in the world graph as visited
        AStar[pathNode.index] = true; // @TODO: needed?
      }
    }
    // Remember this route as having no more untested options
    closedList.add(currentNode);
  }
  // Keep iterating until until the openList is empty.
  // If we get to here then we have failed, so return the empty list.
  return resultPath;
}

// Takes last node uses it to reconstruct the path.
// Returns a list of tiles
List<Tile> reconstructPath(PathNode pathNode) {
  List result = new List<PathNode>();
  do {
    result.add(pathNode.tile);
    pathNode = pathNode.parent;
  }
  while (pathNode.parent != null);
  // We want to return start to finish
  return result.reversed.toList();
}
