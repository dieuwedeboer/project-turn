library turn;

import 'dart:html';
import 'dart:math' as Math;

part 'src/game_map.dart';
part 'src/tile.dart';
part 'src/unit.dart';
part 'src/game_point.dart';

// Global variables
final CanvasElement canvas = querySelector("#canvas");
final CanvasRenderingContext2D context = canvas.context2D;
GameMap map = new GameMap(10, 10);