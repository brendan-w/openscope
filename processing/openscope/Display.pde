/*
private class Display
{
  //root class
  private PApplet root;
  
  //display arrangment
  private final Point graphP = new Point(15, 15);
  private final Point graphD = new Point(655, 375);
  private final Point graphS = new Point(500, 5);
  private final int handleThick = 10;
  private final int handleLength = 30;
  //click/drag locks
  private int offset = 0;
  private boolean trigLock = false;
  //buttons
  public Button connect = new Button("Connect", graphP.x + graphD.x + 15, graphP.y + graphD.y + 20, 100, 15);
  public Button exclusive = new Button("Exclusive", graphP.x + graphD.x - 55, graphP.y + graphD.y + 20, 50, 15);
  public Button trigger = new Button("Trigger", graphP.x + graphD.x + 15, graphP.y + graphD.y + 60, 100, 15);
  public Button upSlope = new Button("+ Slope", graphP.x + graphD.x - 110, graphP.y + graphD.y + 60, 50, 15);
  public Button downSlope = new Button("- Slope", graphP.x + graphD.x - 55, graphP.y + graphD.y + 60, 50, 15);
  
  public Button[] pinButtons = new Button[20];
  public Button[] trigButtons = new Button[20];
  
  //constructor
  public Display(PApplet app)
  {
    root = app;
    colorMode(RGB);
    size(800, 500);
    strokeCap(SQUARE);
    textSize(12);
    smooth();
    //create pin buttons
    for(int i = 0; i < pinButtons.length; i++)
    {
      String name;
      if(i <= 5)
      {
        name = "A" + i;
      }
      else
      {
        name = Integer.toString(i - 6);
        if(i-6 == 0) name += "<";
        if(i-6 == 1) name += ">";
      }
      pinButtons[i] = new Button(name, 20 + (i * 25), graphP.y + graphD.y + 20, 20, 15);
      pinButtons[i].enabled = false;
      trigButtons[i] = new Button(name, 20 + (i * 25), graphP.y + graphD.y + 60, 20, 15);
    }
    //preset special buttons
    upSlope.value = true;
    //sweep the enabler
    enable();
  }
  
  //redraws the display, with the latest data
  public void refresh()
  {
    //clear the display
    background(0,0,0);
    //draw the graph
    drawGraph();
    //draw the control bars
    stroke(40,40,40);
    strokeWeight(1);
    fill(25,25,25);
    rect(15, graphP.y + graphD.y + 15, graphD.x, 25);
    rect(15, graphP.y + graphD.y + 55, graphD.x, 25);
    //draw buttons
    connect.drawButton();
    exclusive.drawButton();
    trigger.drawButton();
    upSlope.drawButton();
    downSlope.drawButton();
    
    for(int i = 0; i < pinButtons.length; i++)
    {
      pinButtons[i].drawButton();
      trigButtons[i].drawButton();
    }
  }
  
  private void drawGraph()
  {
    //background
    stroke(40,40,40);
    strokeWeight(1);
    fill(25,25,25);
    rect(graphP.x, graphP.y, graphD.x, graphD.y);
    //draw input handles if connected
    if(connection.connected)
    {
      stroke(50, 100, 30);
      fill(50, 100, 30);
      int pix = int(map(4.12, 0, graphS.y, (graphP.y + graphD.y), graphP.y));
      drawHandle(pix, "4.12 V", "Digital 2");
    }
    //draw voltage marks
    stroke(40,40,40);
    for(int i = 1; i < graphS.y; i++)
    {
      int pix = int(map(i, 0, graphS.y, (graphP.y + graphD.y), graphP.y));
      line(graphP.x, pix, graphP.x + graphD.x, pix);
    }
    //draw time marks
    //draw trigger
    if(trigger.value && connection.connected)
    {
      //update trig level if locked by mouse
      if(trigLock)
      {
        //update the value
        int pix = mouseY + offset;
        data.trigLevel = map(pix, (graphP.y + graphD.y), graphP.y, 0, graphS.y);
        //clamp the value
        if(data.trigLevel > graphS.y) data.trigLevel = graphS.y;
        if(data.trigLevel < 0) data.trigLevel = 0;
      }
      //trig line
      stroke(70,20,20);
      fill(70,20,20);
      strokeWeight(2);
      int pix = int(map(data.trigLevel, 0, graphS.y, (graphP.y + graphD.y), graphP.y));
      line(graphP.x, pix, graphP.x + graphD.x, pix);
      //trig handle
      String readout = Float.toString(data.trigLevel);
      if(readout.length() - readout.indexOf('.') > 3)
      {
        readout = readout.substring(0, readout.indexOf('.') + 3);
      }
      readout += " V";
      drawHandle(pix, readout, "Trigger");
    }
    //draw waveforms if connected
    if(connection.connected)
    {
      stroke(50, 100, 30);
      fill(50, 100, 30);
      //refresh the screen buffer
      data.getBuffer(graphS.x);
      
      if(data.screen[0] != null)
      {
        println(data.screen[0].pinB);
      }
      
      //loop through the screen buffer
      int i = 0;
      int time = 0;
      while(i < (data.BUFFER_SIZE - 1))
      {
        Sample newer = data.screen[i];
        Sample older = data.screen[i + 1];
        //make sure there's samples at this element
        if(newer != null && older != null)
        {
          //compute horizontal pix based on times & scale
          int oldTime = time;
          int newTime = time + newer.time;
          int oldPix = int(map(oldTime, 0, graphS.x, graphP.x + graphD.x, graphP.x));
          int newPix = int(map(newTime, 0, graphS.x, graphP.x + graphD.x, graphP.x));
          //draw pinD lines
          if(newer.pinD != -1 && older.pinD != -1)
          {
            for(int j = 6; j < 14; j++)
            {
              if(pinButtons[j].value) //only draw pins that are requested
              {
                int oldV = int(map(int(bitRead(older.pinD, j - 6)), 0, graphS.y, (graphP.y + graphD.y), graphP.y));
                int newV = int(map(int(bitRead(newer.pinD, j - 6)), 0, graphS.y, (graphP.y + graphD.y), graphP.y));
                line(newPix, oldV, oldPix, newV);
              }
            }
          }
          
          //draw pinB lines
          if(newer.pinB != -1 && older.pinB != -1)
          {
            for(int j = 14; j < 20; j++)
            {
              if(pinButtons[j].value) //only draw pins that are requested
              {
                int oldV = int(map(int(bitRead(older.pinB, j - 6)), 0, graphS.y, (graphP.y + graphD.y), graphP.y));
                int newV = int(map(int(bitRead(newer.pinB, j - 6)), 0, graphS.y, (graphP.y + graphD.y), graphP.y));
                line(newPix, oldV, oldPix, newV);
              }
            }
          }
          
          //advance the time;
          time = newTime;
        }
        i++;
      }
    }
  }
  
  private void drawHandle(int pix, String label1, String label2)
  {
    beginShape();
    vertex(graphP.x + graphD.x, pix);
    vertex(graphP.x + graphD.x + handleThick, pix - (handleThick / 2));
    vertex(graphP.x + graphD.x + handleThick + handleLength, pix - (handleThick / 2));
    vertex(graphP.x + graphD.x + handleThick + handleLength, pix + (handleThick / 2));
    vertex(graphP.x + graphD.x + handleThick, pix + (handleThick / 2));
    endShape(CLOSE);
    //readout
    fill(255,255,255);
    textSize(16);
    textAlign(LEFT, BASELINE);
    if(label1 != "")
    {
      text(label1, graphP.x + graphD.x + handleThick + handleLength + 5, pix + (handleThick / 2));
    }
    fill(128,128,128);
    textSize(9);
    if(label2 != "")
    {
      text(label2, graphP.x + graphD.x + handleThick + handleLength + 5, pix + (handleThick / 2) * 3);
    }
  }
  
  private void enable()
  {
    boolean master = connect.value;
    boolean trigSettings = trigger.value && master;
    
    exclusive.enabled = master;
    trigger.enabled = master;
    for(int i = 0; i < pinButtons.length; i++)
    {
      pinButtons[i].enabled = master;
      trigButtons[i].enabled = trigSettings;
    }
    
    upSlope.enabled = trigSettings;
    downSlope.enabled = trigSettings;
  }
  
  
  //Mouse click function, check EVERYTHING!!
  public void click(boolean mouseDown)
  {
    if(mouseDown)
    {
      //trigger handle---------------------------------
      if(trigger.value)
      {
        if(mouseX > (graphP.x + graphD.x) && mouseX < (graphP.x + graphD.x + handleThick + handleLength))
        {
          int pix = int(map(data.trigLevel, 0, graphS.y, (graphP.y + graphD.y), graphP.y));
          if(mouseY > (pix - (handleThick / 2)) && mouseY < (pix + (handleThick / 2)))
          {
            trigLock = true;
            offset = pix - mouseY;
          }
        }
      }
      
      //special buttons--------------------------------
      if(connect.inButton()) //connect button was clicked
      {
        if(connection.connected == false)
        {
          if(connection.connect()) //connect command
          {
             connect.value = true;
             connect.caption = "Disconnect";
          }
        }
        else
        {
          connection.disconnect(); //disconnect command
          connect.value = false;
          connect.caption = "Connect";
        }
        enable(); //sweep the enabler
      }
      
      if(exclusive.inButton())
      {
        exclusive.value = !exclusive.value;
      }
      
      if(trigger.inButton()) //trigger on/off button was clicked
      {
        trigger.value = !trigger.value;
        enable(); //sweep the enabler
      }
      
      if(upSlope.inButton() || downSlope.inButton())
      {
        upSlope.value = !upSlope.value;
        downSlope.value = !downSlope.value;
      }
      
      //pin buttons------------------------------
      for(int i = 0; i < pinButtons.length; i++)
      {
        if(pinButtons[i].inButton())
        {
          pinButtons[i].value = !pinButtons[i].value;
          if(exclusive.value)
          {
            for(int j = 0; j < pinButtons.length; j++)
            {
              if(i != j) pinButtons[j].value = false;
            }
          }
          //update connection
          connection.updateArduino(false);
        }
        
        if(trigButtons[i].inButton())
        {
          trigButtons[i].value = !trigButtons[i].value;
          for(int j = 0; j < pinButtons.length; j++)
          {
            if(i != j) trigButtons[j].value = false;
          }
          //update connection
          if(trigButtons[i].value)
          {
            data.trigPin = i;
          }
          else
          {
            data.trigPin = -1;
          }
        }
      }
    }
    else //mouseup events
    {
      trigLock = false;
    }
  }
}
*/
