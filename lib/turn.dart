library turn;

import 'dart:html';
import 'dart:math' as Math;

part 'src/data.dart';
part 'src/path.dart';
part 'src/path_node.dart';

part 'src/game_map.dart';
part 'src/tile.dart';
part 'src/unit.dart';
part 'src/game_point.dart';

/**
 * Global variables
 */
final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D ctx = canvas.context2D;
MenuElement contextMenu = querySelector("#context-menu");
// @TODO: Performance for extra large maps?
GameMap map = new GameMap(25, 25);
