
/*
  A silly class to compute the edged of the rect
  I cant believe this isn't already in the Rectangle Class...
*/

public class Rect extends Rectangle
{ 
  public Rect(int x, int y, int w, int h)
  {
    super(x, y, w, h);
  }
  
  public int top()    { return this.x; }
  public int right()  { return this.y + this.width; }
  public int bottom() { return this.x + this.height; }
  public int left()   { return this.y; }
  
  public boolean containsV(int y)
  {
    return (y > top()) && (y < bottom());
  }
}
