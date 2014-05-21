private class Button
{
  //properties
  public boolean value = false;
  public boolean enabled = true;
  public Point buttonP = new Point(0, 0);
  public Point buttonD = new Point(0, 0);
  public color disColor = color(45, 45, 45);
  public color offColor = color(19, 51, 64);
  public color onColor = color(50, 100, 30);
  public color hoverOffColor = color(30, 80, 100);
  public color hoverOnColor = color(66, 133, 40);
  public color textColor = color(255, 255, 255);
  public int textSize = 10;
  public String caption = "Button";
  private final float hoverColor = 1.33;
  
  //constructor
  public Button(String cap, int xP, int yP, int xD, int yD)
  {
    caption = cap;
    buttonP.x = xP;
    buttonP.y = yP;
    buttonD.x = xD;
    buttonD.y = yD;
  }
  
  public void frame()
  {
    noStroke();
    if(enabled)
    {
      if(value)
      {
        fill(onColor);
        if(isClicked()) fill(hoverOnColor);
      }
      else
      {
        fill(offColor);
        if(isClicked()) fill(hoverOffColor);
      }
    }
    else
    {
      fill(disColor);
    }
    rect(buttonP.x, buttonP.y, buttonD.x, buttonD.y);
    fill(textColor);
    textSize(textSize);
    textAlign(CENTER, CENTER);
    text(caption, buttonP.x + ((buttonP.x + buttonD.x - buttonP.x) / 2), buttonP.y + ((buttonP.y + buttonD.y - buttonP.y) / 2));
  }
  
  public boolean isClicked()
  {
    boolean result = false;
    if(enabled)
    {
      if(mouseX > buttonP.x && mouseX < (buttonP.x + buttonD.x))
      {
        if(mouseY > buttonP.y && mouseY < (buttonP.y + buttonD.y))
        {
          result = true;
        }
      }
    }
    return result;
  }
}
