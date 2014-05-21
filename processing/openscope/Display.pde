private class Display
{
    private PApplet main;
  
    private Graph graph;
    private ControlP5 cp5;
    
    private Group connection_group;
    private DropdownList port_list;
    private Button connect_button;
    
    
    private Group pin_group;
    private Toggle[] pin_toggle;
    
    private Group graph_scales;
    private Range voltage_scale;
    private Range time_scale;
    
    private Group trig_pin_group;
    private Toggle[] trig_pin_toggle;
    
    private Group trig_set_group;
    private Toggle trigger;
    private RadioButton trig_slope;
    
    //constructor
    public Display(PApplet root)
    {
        main = root;
        graph = new Graph();
        cp5 = new ControlP5(root);
        buildControllers();
    }

    public void frame()
    {
        background(0);
        
        int min = (int) voltage_scale.getLowValue();
        int max = (int) voltage_scale.getHighValue();
        graph.frame(min, max);
        
        for(int i = 0; i < NUM_PINS; i++)
        {
          if(pins[i])
          {
            graph.drawData(buffer.getBuffer(), pinColors[0]);  
          }
        }
    }
    
    //method called on every control event
    public void controlEvent(ControlEvent e)
    {
      if(e.isController())
      {
        Controller c = e.getController();
        
        if(c == connect_button)
        {
          //call the connect function
          int selectedPort = int(port_list.getValue());
          Connection.connect(selectedPort, pins);
        }
        
        for(int i = 0; i < pin_toggle.length; i++)
        {
          if(c == pin_toggle[i])
          {
            pins[i] = pin_toggle[i].getState();
            Connection.pushSettings(pins);
          }
        }
      }
    }

    private void buildControllers()
    {
        connection_group = cp5.addGroup("Connection")
                              .setPosition(10, 440)
                              .setSize(120, 140)
                              .setBackgroundColor(30);
      
        pin_group = cp5.addGroup("Pins")
                       .setPosition(150, 440)
                       .setSize(190, 60)
                       .setBackgroundColor(30);
                       
        graph_scales = cp5.addGroup("Scales")
                            .setPosition(350, 440)
                            .setSize(560, 60)
                            .setBackgroundColor(30);
                       
        trig_pin_group = cp5.addGroup("Trigger Pin")
                            .setPosition(150, 520)
                            .setSize(190, 60)
                            .setBackgroundColor(30);
                            
        trig_set_group = cp5.addGroup("Trigger Settings")
                            .setPosition(350, 520)
                            .setSize(560, 60)
                            .setBackgroundColor(30);
                       
        pin_toggle = new Toggle[NUM_PINS];
        trig_pin_toggle = new Toggle[NUM_PINS];
        for(int i = 0; i < NUM_PINS; i++)
        {
            pin_toggle[i] = cp5.addToggle("A" + i)
                               .setPosition(10 + (i * 30), 10)
                               .setSize(20, 20)
                               .setGroup(pin_group);
            trig_pin_toggle[i] = cp5.addToggle("A" + i + " ")
                                   .setPosition(10 + (i * 30), 10)
                                   .setSize(20, 20)
                                   .setGroup(trig_pin_group);
        }
        
        voltage_scale = cp5.addRange("Voltage")
                           .setBroadcast(false)
                           .setPosition(10, 10)
                           .setSize(500, 15)
                           .setRange(0, 1024)
                           .setRangeValues(0, 1024)
                           .setHandleSize(15)
                           .setGroup(graph_scales)
                           .setBroadcast(true);
                           
        time_scale = cp5.addRange("Time")
                           .setBroadcast(false)
                           .setPosition(10, 35)
                           .setSize(500, 15)
                           .setRange(0, 100)
                           .setRangeValues(0, 50)
                           .setHandleSize(15)
                           .setGroup(graph_scales)
                           .setBroadcast(true);
        
        /*
trig_slope = cp5.addRadioButton("Trigger Slope")
.setPosition(10, 10)
.setSize(40, 20)
.setGroup(trig_set_group)
.setItemsPerRow(1)
.setSpacingColumn(50)
.addItem("+ Slope", 0)
.addItem("- Slope", 1);
*/
                        
        String[] ports = Connection.getPorts();
        
        port_list = cp5.addDropdownList("Port")
                       .setPosition(10, 25)
                       .setItemHeight(15)
                       .setBarHeight(15)
                       .setGroup(connection_group);
                       
        port_list.captionLabel().style().marginTop = 3;
                       
        for(int i = 0; i < ports.length; i++)
        {
          port_list.addItem(ports[i], i);
        }
        
        connect_button = cp5.addButton("Connect")
                            .setPosition(10, 96)
                            .setSize(100, 30)
                            .setGroup(connection_group);
         
     }
}
