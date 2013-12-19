/**
 * Project Turn
 */

import 'package:turn/turn.dart';
import 'dart:html';
//import 'dart:math' as Math;
//import 'package:bot_web/bot_texture.dart';

/**
 * Main (setup function)
 */
void main() {
  // Load assets. @TODO: nicely
  assetList.add('/images/grass_1.png');
  //window.console.log(assetList);
  loadAssets(assetList, loaded);
}

void loaded(ImageElement asset) {
  window.console.log('All assets loaded');
  //window.console.log(gCachedAssets);
  // Render the viewport
  map.generate();
  map.draw();
  window.console.log(map);
  // Create new unit (dev)
  Unit unit = new Unit(map.tiles[0][0]);
  unit.name = "Tester";
  unit.player = "User";
  map.activeUnit = unit;
  map.tiles[0][0].units.add(unit);
  unit.draw();
  // Create a second unit
  Unit unit2 = new Unit(map.tiles[0][2]);
  unit2.name = "Bot";
  unit2.player = "Computer";
  map.tiles[0][2].units.add(unit2); // @TODO: Unit should add itself
  unit2.draw();
  // Create a third unit
  //Unit unit3 = new Unit(map.tiles[1][0]);
  //unit3.name = "Bot2";
  //unit3.player = "Computer";
  //map.tiles[1][0].units.add(unit3);
  //unit3.draw();
}
