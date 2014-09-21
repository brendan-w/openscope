private class Controls
{
    private PApplet root;
    private ControlP5 cp5;
    private Settings settings;
    
    private Group connection_group;
    private DropdownList port_list;
    private Button connect_button;
    
    private Group pin_group;
    private Toggle[] pin_toggle;
    
    private Group graph_scales;
    private Range voltage_scale;
    private Slider time_scale;
    
    private Group trig_pin_group;
    private RadioButton trig_pin_toggle;
    
    private Group trig_set_group;
    private RadioButton trig_slope;
    private Slider trig_voltage;
    
    //constructor
    public Controls(PApplet _root)
    {
        root = _root;
        cp5 = new ControlP5(root);
        settings = new Settings();
        
        buildControllers();
    }

    public Settings getSettings()
    {   
        return settings;
    }
    
    //method called on every controlEvent() in main
    public void event(ControlEvent e)
    {
        boolean updateRequired = false;
        
        if(e.isFrom(connect_button)) //CONNECT
        {
          settings.port = int(port_list.getValue());
          connect();
        }
        else if(e.isFrom(voltage_scale)) //VOLTAGE SCALE CHANGE
        {
          settings.setV(voltage_scale.getLowValue(),
                        voltage_scale.getHighValue());
        }
        else if(e.isFrom(time_scale)) //TIME SCALE CHANGE
        {
          settings.sample_delay = (int) time_scale.getValue();
          updateRequired = true;
        }
        else if(e.isFrom(trig_voltage))
        {
          settings.trigger_voltage = trig_voltage.getValue();
          updateRequired = true;
        }
        else if(e.isFrom(trig_pin_toggle))
        {
          settings.trigger_pin = (int) trig_pin_toggle.value();
          updateRequired = true;
        }
        else if(e.isFrom(trig_slope))
        {
          settings.trigger_slope = (int) trig_slope.value();
          updateRequired = true;
        }
        else
        {
          //PIN TOGGLES
          for(int i = 0; i < pin_toggle.length; i++)
          {
            if(e.isFrom(pin_toggle[i]))
            {
              settings.pins[i] = pin_toggle[i].getState();
              updateRequired = true;
            }
          }
          
        }
        
        //update the arduino is neccessary
        if(updateRequired)
        {
          updateArduino();
        }
    }
      
      
    private void buildControllers()
    {
        //GROUPS
      
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
                       
        trig_pin_group = cp5.addGroup("Trigger")
                            .setPosition(150, 520)
                            .setSize(190, 60)
                            .setBackgroundColor(30);
                            
        trig_set_group = cp5.addGroup("Trigger Settings")
                            .setPosition(350, 520)
                            .setSize(560, 60)
                            .setBackgroundColor(30);
                       
        //PIN TOGGLES
        pin_toggle = new Toggle[NUM_PINS];
        
        trig_pin_toggle = cp5.addRadioButton("Trigger Pin")
                                   .setPosition(10, 10)
                                   .setSize(20, 20)
                                   .setNoneSelectedAllowed(true)
                                   .setSpacingColumn(10)
                                   .setGroup(trig_pin_group)
                                   .setItemsPerRow(NUM_PINS);
        
        for(int i = 0; i < NUM_PINS; i++)
        {
            pin_toggle[i] = cp5.addToggle("A" + i)
                               .setPosition(10 + (i * 30), 10)
                               .setSize(20, 20)
                               .setGroup(pin_group)
                               .setState(settings.pins[i]);
            trig_pin_toggle.addItem("tA" + i, i);
            trig_pin_toggle.getItem(i).getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE)
                                                        .setPaddingX(0)
                                                        .setPaddingY(5);
        }
        
        if(settings.trigger_pin == -1)
          trig_pin_toggle.deactivateAll();
        else
          trig_pin_toggle.activate(settings.trigger_pin);
        
        
        //VOLTAGE AND TIME
        voltage_scale = cp5.addRange("Voltage")
                           .setBroadcast(false)
                           .setPosition(10, 10)
                           .setSize(500, 15)
                           .setRange(0, VOLTAGE_MAX)
                           .setRangeValues(settings.v_min, settings.v_max)
                           .setHandleSize(15)
                           .setGroup(graph_scales)
                           .setBroadcast(true);
                           
        time_scale = cp5.addSlider("Time")
                           .setBroadcast(false)
                           .setPosition(10, 35)
                           .setSize(500, 15)
                           .setRange(0, 1023)
                           .setValue(settings.sample_delay)
                           .setHandleSize(15)
                           .setGroup(graph_scales)
                           .setBroadcast(true);
        
        
        //TRIGGER
        trig_slope = cp5.addRadioButton("Trigger Slope")
                        .setPosition(10, 10)
                        .setSize(40, 20)
                        .setGroup(trig_set_group)
                        .setNoneSelectedAllowed(false)
                        .setItemsPerRow(1)
                        .setSpacingColumn(50)
                        .addItem("+ Slope", 0)
                        .addItem("- Slope", 1)
                        .activate(0);
                        
        trig_voltage = cp5.addSlider("Trigger Voltage")
                        .setSize(350, 15)
                        .setPosition(120, 10)
                        .setGroup(trig_set_group)
                        .setRange(0, VOLTAGE_MAX)
                        .setValue(settings.trigger_voltage);

                        
        String[] ports = Util.getPorts();
        
        port_list = cp5.addDropdownList("Port")
                       .setPosition(10, 70)
                       .setItemHeight(15)
                       .setBarHeight(15)
                       .setGroup(connection_group);
                       
        port_list.captionLabel().style().marginTop = 3;
                       
        for(int i = 0; i < ports.length; i++)
        {
          port_list.addItem(ports[i], i);
        }
        
        connect_button = cp5.addButton("Connect")
                            .setPosition(10, 10)
                            .setSize(100, 30)
                            .setGroup(connection_group);
         
     }
}
