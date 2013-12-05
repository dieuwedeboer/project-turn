/**
 * Project Turn
 */

import 'package:turn/turn.dart';
import 'dart:html';
import 'dart:math' as Math;
//import 'package:bot_web/bot_texture.dart';

// Main (setup function)
void main() {
  // Calculate canvas size
  Rectangle rect = canvas.getBoundingClientRect();
  num maxWidth = window.innerWidth - rect.left.floor();
  num maxHeight = window.innerHeight - rect.top.floor();
  canvas.width = canvas.height = Math.min(maxWidth, maxHeight) - 10;
  // Render the viewport
  map.generate();
  map.draw();
  window.console.log(map);
  // Create new unit (dev)
  Unit unit = new Unit(map.tiles[0]);
  unit.name = "Tester";
  map.activeUnit = unit;
  map.tiles[0].units.add(unit);
  unit.draw();
  // Listen for left clicks
  canvas.onClick.listen((MouseEvent e) {
    canvasClicked(e);
  });
  // Listen for right clicks
  canvas.onContextMenu.listen((MouseEvent e) {
    canvasRightClicked(e);
  });
}

// Click event
void canvasClicked(MouseEvent e) {
  // Get relative coordinates
  GamePoint click = getXandY(e);
  // Find clicked tile
  Tile tile = findClickedTile(click);
  // 'Select' tile
  Tile selected = map.selectedTile;
  if (selected != null) {
    selected.draw();
  }
  map.selectedTile = tile;
  tile.select();
}

// Find clicked tile
Tile findClickedTile(GamePoint click) {
  for (Tile tile in map.tiles) {
    num endX = tile.x + tile.width;
    num endY = tile.y + tile.height;
    // Check: X & Y are greater that start and less than end = within boundary
    if (tile.x < click.x && tile.endX > click.x && tile.y < click.y && tile.endY > click.y ) {
      return tile;
    }
  }
}

// Right click event
void canvasRightClicked(MouseEvent e) {
  e.preventDefault();
  // Get relative coordinates
  GamePoint click = getXandY(e);
  // @TODO: Better way of doing this with polymer?
  // Get and build menu
  MenuElement contextMenu = querySelector("#context-menu");
  for (var element in contextMenu.children) {
    element.remove();
  }
  ButtonElement moveButton = new ButtonElement();
  moveButton.text = "Move";
  moveButton.onClick.listen((MouseEvent e) {
    // Get tile by click
    Tile tile = findClickedTile(click);
    // Move unit
    Unit unit = map.activeUnit;
    bool removed = unit.tile.units.remove(unit);
    tile.units.add(unit);
    unit.tile = tile;
    window.console.log(unit);
    window.console.log(tile);
    // Redraw
    map.draw();
    //tile.draw();
    // Close menu
  });
  contextMenu.append(moveButton);
  // Show menu
  contextMenu.style.left = e.client.x.toString() + "px";
  contextMenu.style.top = e.client.y.toString() + "px";
  // @TODO: close menu on left click?
}

// Calculate relative coordinates of click event
GamePoint getXandY(MouseEvent e) {;
  Rectangle rect = canvas.getBoundingClientRect(); // @TODO: global?
  num x = e.client.x - rect.left;
  num y = e.client.y - rect.top;
  return new GamePoint (x, y);
}
