abstract class ControlWindow {
  
  protected String tabName;
  protected String dataPrefix;
  protected ArrayList<Float> graphData;
  protected ArrayList<Controller> UIElements;
  protected float frequencyOfDataUpdates; //Per second, i.e. 50.0f means 50 Hz
  
  public ControlWindow(String tabName, String dataPrefix, float frequencyOfDataUpdates){
    cwList.add(this);
    this.tabName = tabName;
    this.dataPrefix = dataPrefix;
    this.frequencyOfDataUpdates = frequencyOfDataUpdates;
    
    graphData = new ArrayList<Float>();
    UIElements = new ArrayList<Controller>();
  }
  
  public abstract void setup();
  
  public abstract void draw();
  
  public void showUI(){
    for(Controller c : UIElements){
      c.show();
    }
  }
  
  public void hideUI(){
    for(Controller c : UIElements){
      c.hide();
    }
  }
  
  public abstract void serialEvent(String data);
  public abstract void controlEvent(ControlEvent e);
  
  protected void addDataToGraph(Float data){ graphData.add(data); }
  
  /**
  x, y, width, height - where to draw the graph
  xAxisTimeStart - at what time does the x-axis start?
  xAxisTimeEnd - at what time does the x-axis end? 1.0 means 1 second, 60.0 means 60 seconds, etc.
  yAxisDataStart - at what data value does the y-axis start?
  yAxisDataEnd - at what data value does the y-axis end? I.e. 20.0 would mean 20 degrees C if the data stored in graphData is in degrees celsius.
  */
  protected void drawGraph(int x, int y, int width, int height, float xAxisTimeStart, float xAxisTimeEnd, float yAxisDataStart, float yAxisDataEnd){
    float xAxisScale = xAxisTimeEnd - xAxisTimeStart;
    float yAxisScale = yAxisDataEnd - yAxisDataStart;
    
    noStroke();
    fill(255);
    rect(x,y,width,height);
    Float oldF = 0.0f;
    int xAxis = -1;
    if(!graphData.isEmpty()) oldF = graphData.get(0);

    stroke(0);
    noFill();
    for(Float f : new ArrayList<Float>(graphData)){
      xAxis++;
      if((xAxis-1)/frequencyOfDataUpdates<xAxisTimeStart) continue;
      if((xAxis)/frequencyOfDataUpdates>xAxisTimeEnd) break;
      if(oldF<yAxisDataStart || f<yAxisDataStart) continue;
      if(oldF>yAxisDataEnd   || f>yAxisDataEnd  ) continue;
      line( x+((xAxis-1)/frequencyOfDataUpdates-xAxisTimeStart)/xAxisScale*width,
            y+height-(oldF-yAxisDataStart)/yAxisScale*height,
            x+(xAxis/frequencyOfDataUpdates-xAxisTimeStart)/xAxisScale*width,
            y+height-(f-yAxisDataStart)/yAxisScale*height);
      oldF=f;
    }
  }
  
  public String getTabName(){ return tabName; }
  public String getDataPrefix(){ return dataPrefix; }
}