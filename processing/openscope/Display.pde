
private class Display
{
    private Graph graph;
    private ControlP5 cp5;
    
    private Group pin_group;
    private Toggle[] pin_toggle;
    
    private Group trig_pin_group;
    private Toggle[] trig_pin_toggle;
    
    //constructor
    public Display(PApplet root)
    {
        graph = new Graph();
        cp5 = new ControlP5(root);
        buildControllers();
    }

    public void frame()
    {
        background(0);
        graph.frame();
    }
    
    //method called on every control event
    public void controlEvent(ControlEvent e)
    {
        Controller c = e.getController();
    }

    private void buildControllers()
    {
        pin_group = cp5.addGroup("Pins")
                       .setPosition(10, 440)
                       .setSize(190, 60)
                       .setBackgroundColor(30);
                       
        trig_pin_group = cp5.addGroup("Trigger Pin")
                            .setPosition(210, 440)
                            .setSize(190, 60)
                            .setBackgroundColor(30);
                       
        pin_toggle = new Toggle[num_pins];
        trig_pin_toggle = new Toggle[num_pins];
        for(int i = 0; i < num_pins; i++)
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
        
    }

}
