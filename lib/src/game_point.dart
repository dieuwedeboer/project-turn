part of turn;

/**
 * Game point class
 */
// @TODO: Extend 'Point'?
// @TODO: Make this something that can be used by all classes for any and every
// ... reference to any and every location purposed.
class GamePoint {
  /**
   * Properties
   */
  num x;
  num y;
  // @TODO: Can have height and width?
  /**
   * Constructors
   */
  GamePoint(num this.x, num this.y);
  GamePoint.zero() : x = 0, y = 0;
}
