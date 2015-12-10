class HeatingControlWindow extends ControlWindow {
  public HeatingControlWindow(){
    super("Heating","h",50.0f); //Tab name, Data prefix, Frequency of data updates
  }
  
  public void setup(){
    
  }
  
  public void draw(){
    
  }
  
  public void serialEvent(String data){
    
  }
  
  public void controlEvent(ControlEvent e) {
    int id = e.getController().getId();
  }
}