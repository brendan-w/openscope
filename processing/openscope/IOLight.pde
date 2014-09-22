public class IOLight
{
  private int status;
  
  private Rectangle rect = new Rectangle(130, 430, 10, 30);
  
  private final int FAIL_COLOR = color(100, 0, 0);
  private final int NULL_COLOR = color(40);
  private final int IDLE_COLOR = color(0, 100, 0);
  private final int DATA_COLOR = color(0, 200, 0);
  
  
  public IOLight()
  {
    status = STATUS_IDLE;
  }
  
  public void frame()
  {
    noStroke();
    switch(status)
    {
      case STATUS_FAIL: fill(FAIL_COLOR); break;
      case STATUS_NULL: fill(NULL_COLOR); break;
      case STATUS_IDLE: fill(IDLE_COLOR); break;
      case STATUS_DATA: fill(DATA_COLOR); break;
    }
    rect(rect.x, rect.y, rect.width, rect.height);
  }
  
  public void set(int i)
  {
    status = i;
  }
}

