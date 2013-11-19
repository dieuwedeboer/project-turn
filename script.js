// Canvas and context. @TODO: Should be a class?
var canvas = null;
var context = null;
var map = null;

// Testing image thing. @TODO: Get rid of.
var img = null;

// Map class
function Map(width, height) {
  // Dimentions of map
  this.width = width;
  this.height = height;
  this.size = this.width * this.height;
  // Array of tiles
  this.tiles = [];
  // Draw function. @TODO: Pixel precision is going to be an issue.
  this.draw = function() {
    console.log('Drawing');
    var x = 0;
    var y = 0;
    var tile;
    var column = 0;
    console.log(this.size);

    // Generate tiles (Separate function?)
    for (var i = 0; i < this.size; i++) {
      // Create new tile
      tile = new Tile(i, this.tileSize(), x, y);
      this.tiles.push(tile);
      // Draw. @TODO: Let the tile draw itself.
      context.strokeRect(x, y, tile.width, tile.height);
      // Increment counters
      x += tile.width;
      column++;
      if (column == this.width) {
	y += tile.height;
	column = 0;
	x = 0;
      }
    }
  }
  // Function to get the ideal tile size for this map
  this.tileSize = function() {
    var maxTileWidth = canvas.width / this.width;
    var maxTileHeight = canvas.height / this.height;
    var tileSize = maxTileWidth;
    if (maxTileWidth > maxTileHeight) {
      tileSize = maxTileHeight;
    }
    return tileSize;
  }
  this.selectedTile = null;
}

// Tile class
function Tile(id, size, x, y) {
  // Unique identifier
  this.id = id;
  // Dimentions of the tile
  this.width = size;
  this.height = size;
  // Location of the tile
  this.x = x;
  this.y = y;
  this.units = [];
}

// Base unit class
function Unit() {
  this.tile = null; // Current location
  this.movement = 1; // 0 for none
  this.name = "";
  this.range = 1; // 0 for none, 1 for most, 2-5 for artilery
  this.damage = 2; // Different types of damage?
  this.defense = 5; // Different types of defense?
}

// Click function
function getClickCoordinates(event){
  var totalOffsetX = 0;
  var totalOffsetY = 0;
  var canvasCoordinates = {
    x: 0,
    y: 0,
  };
  var currentElement = this;

  do {
    totalOffsetX += currentElement.offsetLeft - currentElement.scrollLeft;
    totalOffsetY += currentElement.offsetTop - currentElement.scrollTop;
  }
  while (currentElement = currentElement.offsetParent)

  canvasCoordinates.x = event.pageX - totalOffsetX;
  canvasCoordinates.y = event.pageY - totalOffsetY;

  return canvasCoordinates;
}
HTMLCanvasElement.prototype.getClickCoordinates = getClickCoordinates;

// Main()
setup = function() {

  canvas = document.getElementById("my-canvas");
  context = canvas.getContext('2d');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  map = new Map(10, 10);
  map.draw();
  console.log(map);

  // Clicky thing
  canvas.onclick = function(e) {
    //console.log(e);
    coords = canvas.getClickCoordinates(e);
    canvasX = coords.x;
    canvasY = coords.y;
    console.log(coords);
    // Find clicked tile
    for (var i = 0; i < map.tiles.length; i++) {
      var tile = map.tiles[i];
      // @TODO: Should we store startXY, endXY in tiles and other objects?
      if (tile.x < coords.x && tile.x + tile.width > coords.x && tile.y < coords.y && tile.y + tile.height > coords.y ) {
        console.log(tile);
	// Create new unit (naf)
	var unit = new Unit();
	unit.name = "Tester";
	unit.tile = tile;
	tile.units.push(unit);
	// 'Select' tile (naf)
	var selected = map.selectedTile;
	if (selected != null) {
	  context.clearRect(selected.x, selected.y, selected.width, selected.height);
	  context.strokeRect(selected.x, selected.y, selected.width, selected.height);
	}
	map.selectedTile = tile;
	context.fillRect(tile.x, tile.y, tile.width, tile.height);
      }
    }
  }

};


// setup();
window.onload = function()
{
  setup();
};
