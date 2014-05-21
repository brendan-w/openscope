
private class Display
{
    private PApplet main;
  
    private Graph graph;
    
    private Button[] pinButtons;
    private Point pinButton_pos = new Point(680, 420);
    private Point pinButton_size = new Point(30, 30);
    
    private Button[] portButtons;
    private Point portButton_pos = new Point(10, 420);
    private Point portButton_size = new Point(80, 20);
    
    
    
    //constructor
    public Display(PApplet root)
    {
        main = root;
        graph = new Graph();
        buildUI();
    }

    public void frame()
    {
        background(0);
        graph.frame(buffer.getBuffer());
        refreshUI();
    }
  
    public void click()
    {
        for(int i = 0; i < pinButtons.length; i++)
        {
            if(pinButtons[i].isClicked())
            {
              pinButtons[i].value = !pinButtons[i].value;
            }
        }
        
        for(int i = 0; i < portButtons.length; i++)
        {
            if(portButtons[i].isClicked())
            {
                //connect to the requested port
                Connection.connect(i, pins);
            }
        }
    }
    
    public void refreshUI()
    {
        for(int i = 0; i < pinButtons.length; i++)
        {
            pinButtons[i].frame();
        }
        
        for(int i = 0; i < portButtons.length; i++)
        {
            portButtons[i].frame();
        }
    }

    private void buildUI()
    { 
        pinButtons = new Button[NUM_PINS];

        for(int i = 0; i < NUM_PINS; i++)
        {
            int offset = i * (pinButton_size.x + 10);
            pinButtons[i] = new Button("A"+i, pinButton_pos.x + offset, pinButton_pos.y,
                                              pinButton_size.x, pinButton_size.y);
        }

        String[] ports = Connection.getPorts();
        portButtons = new Button[ports.length];
        for(int i = 0; i < ports.length; i++)
        {
            int offset = i * (portButton_size.x + 10);
            portButtons[i] = new Button(ports[i], portButton_pos.x + offset, portButton_pos.y,
                                                 portButton_size.x, portButton_size.y);
        }

         
     }
}
