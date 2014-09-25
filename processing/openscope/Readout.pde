public class Readout
{
  private Rectangle rect = new Rectangle(10, 530, 130, 50);
  
  public Readout()
  {
    
  }
  
  public void frame(Settings s)
  {
    fill(FILL_COLOR);
    noStroke();
    //rect(rect.x, rect.y, rect.width, rect.height);
    
    fill(255);
    text("Sample Rate", rect.x + TEXT_PAD, rect.y + 15 + TEXT_PAD);
    String rate = Util.prettyFloat(s.sample_rate) + " kHz";
    text(rate, rect.x + TEXT_PAD, rect.y + 30 + TEXT_PAD);
  }
  
  
}
