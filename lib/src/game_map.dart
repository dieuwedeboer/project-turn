part of turn;

/**
 * Map class
*/
class GameMap {
  /**
   * Properties
   */
  num tilesWide;
  num tilesHigh;
  Tile selectedTile;
  Unit activeUnit;
  List tiles = new List<List>();
  num offsetX = 0;
  num offsetY = 0;
  /**
   * Getters
   */
  num get size => tilesWide * tilesHigh;
  num get width => tilesWide * tileSize();
  num get height => tilesHigh * tileSize();
  /**
   * Constructors
   */
  GameMap(num this.tilesWide, num this.tilesHigh) {
    // @TODO: Decide how to handle canvas and map relation
    // Calculate canvas size
    Rectangle rect = canvas.getBoundingClientRect();
    num maxWidth = window.innerWidth - rect.left.floor() * 2;
    maxWidth -= maxWidth % tileSize();
    num maxHeight = window.innerHeight - rect.top.floor() - 5;
    maxHeight -= maxHeight % tileSize();
    //canvas.width = canvas.height = Math.min(maxWidth, maxHeight) - 10;
    canvas.width = maxWidth;
    canvas.height = maxHeight;
    // Listen for left clicks
    canvas.onClick.listen((MouseEvent e) {
      _canvasClicked(e);
    });
    // Listen for right clicks
    canvas.onContextMenu.listen((MouseEvent e) {
      _canvasRightClicked(e);
    });
    // Keyboard
    document.onKeyDown.listen((KeyEvent e) {
      _keyboardEvent(e);
    });
  }
  /**
   * Functions
   */
  // Draw map
  void draw() {
    // @TODO: Only attempt to draw tiles that we know are visible
    for (List list in tiles) {
      for (Tile tile in list) {
        tile.draw();
      }
    }
  }
  // Generate tiles
  void generate() {
    num x = 0;
    num y = 0;
    Tile tile;
    int column = 0;
    int row = 0;
    //window.console.log(tiles);
    for (int i = 0; i < size; i++) {
      tile = new Tile(i, tileSize(), x, y); // Create new tile
      tile.row = row;
      tile.column = column;
      tile.draw(); // Draw new tile
      if (tiles.length == row) {
        tiles.add(new List<Tile>());
      }
      tiles[row].add(tile); // Add new tile to list.
      // Increment counters
      x += tile.width;
      column++;
      if (column == tilesWide) {
        y += tile.height;
        x = 0;
        column = 0;
        row++;
      }
    }
  }
  // Tile size
  num tileSize() {
    // @TODO: Is this deprecated as a function?
    // ... Will have to decide on fixed or fluid size.
    // New fixed size
    return 64;
    // Original fluid size
    //num maxTileWidth = canvas.width / tilesWide;
    //num maxTileHeight = canvas.height / tilesHigh;
    //num tileSize = Math.min(maxTileWidth, maxTileHeight);
    //return tileSize.floor();
  }
  // Click event
  void _canvasClicked(MouseEvent e) {
    // Close the context menu if it is open. @TODO: Properly.
    for (var element in contextMenu.children) {
      element.remove();
    }
    // Get relative coordinates
    GamePoint click = _getXandY(e);
    // Find clicked tile
    Tile tile = _findClickedTile(click);
    // 'Select' tile
    Tile selected = map.selectedTile;
    if (selected != null) {
      selected.draw();
    }
    selectedTile = tile;
    tile.select();
  }
  // Find clicked tile
  Tile _findClickedTile(GamePoint click) {
    // @TODO: Don't iterate, just divide location by num of tiles and select
    for (List list in tiles) {
      for (Tile tile in list) {
        num endX = tile.x + tile.width;
        num endY = tile.y + tile.height;
        // Check: X & Y are greater that start and less than end = within boundary
        if (tile.x < click.x && tile.endX > click.x
            && tile.y < click.y && tile.endY > click.y ) {
          return tile;
        }
      }
    }
  }
  // Right click event
  void _canvasRightClicked(MouseEvent e) {
    e.preventDefault();
    // Get relative coordinates
    GamePoint click = _getXandY(e);
    // @TODO: Better way of doing this with polymer?
    // @TODO: Menu should only be built once either way.
    // Build menu
    for (var element in contextMenu.children) {
      element.remove();
    }
    ButtonElement moveButton = new ButtonElement();
    moveButton.text = "Move";
    moveButton.onClick.listen((MouseEvent e) {
      // Get tile by click
      Tile tile = _findClickedTile(click);
      // Move unit
      if (tile.units.isNotEmpty && tile.units[0].player != "User") {
        window.console.log("Fight");
        // @TODO: Damage calculations
        // @TODO: Fight *strongest* unit in tile stack
      }
      else {
        Unit unit = map.activeUnit;
        List path = findPath(map, unit.tile, tile);
        window.console.log(path);
        if (path.isNotEmpty) {
          for (Tile tile in path) {
            //tile.selected = true;
            bool removed = unit.tile.units.remove(unit);
            tile.units.add(unit);
            unit.tile = tile;
            break;
          };
        }
        else {
          window.console.log('Destination unreachable');
        }
      }
      // Redraw
      draw();
      // Close menu. @TODO: Properly.
      for (var element in contextMenu.children) {
        element.remove();
      }
    });
    contextMenu.append(moveButton);
    // Show menu
    contextMenu.style.left = e.client.x.toString() + "px";
    contextMenu.style.top = e.client.y.toString() + "px";
    // @TODO: close menu on left click?
  }
  // Calculate relative coordinates of click event
  GamePoint _getXandY(MouseEvent e) {;
    Rectangle rect = canvas.getBoundingClientRect(); // @TODO: global?
    num x = e.client.x - rect.left;
    num y = e.client.y - rect.top;
    return new GamePoint(x, y);
  }
  // Keyboard events
  void _keyboardEvent(KeyEvent e) {
    if ((e.keyCode == KeyCode.UP || e.keyCode == KeyCode.W)
        && offsetY >= 10) {
      offsetY -= 10;
    }
    else if ((e.keyCode == KeyCode.LEFT || e.keyCode == KeyCode.A)
        && offsetX >= 10) {
      offsetX -= 10;
    }
    else if ((e.keyCode == KeyCode.DOWN || e.keyCode == KeyCode.S)
        && offsetY <= height - (canvas.height + 10)) {
      offsetY += 10;
    }
    else if ((e.keyCode == KeyCode.RIGHT || e.keyCode == KeyCode.D)
        && offsetX <= width - (canvas.width + 10)) {
      offsetX += 10;
    }
    draw();
  }
}
