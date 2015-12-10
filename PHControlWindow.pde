class PHControlWindow extends ControlWindow {
  
  float rawPh;
  float graphStartTime,graphEndTime;
  Textfield startTimeTextfield, endTimeTextfield;
  float graphStartPH,graphEndPH;
  Textfield startPHTextfield, endPHTextfield;
  PFont myFont;
  
  public PHControlWindow(){
    super("pH","ph",50.0f); //Tab name, Data prefix, Frequency of data updates
    graphStartTime = 0;
    graphEndTime = 10;
    graphStartPH = 0;
    graphEndPH = 300;
  }
  
  public void setup(){
    myFont = createFont("Arial",20,true);
    ControlFont font = new ControlFont(myFont,241);
    
    UIElements.add(cp5.addButton("addAcidButton").setPosition(100,400).setSize(100,25).setCaptionLabel("Add acid").setId(301));
    UIElements.add(cp5.addButton("addBaseButton").setPosition(100,430).setSize(100,25).setCaptionLabel("Add base").setId(302));
    startTimeTextfield = cp5.addTextfield("startTimeTextField").setPosition(100,460).setSize(100,25).setId(303);
    UIElements.add(startTimeTextfield);
    endTimeTextfield = cp5.addTextfield("endTimeTextField").setPosition(220,460).setSize(100,25).setId(304);
    UIElements.add(endTimeTextfield);
    UIElements.add(cp5.addButton("submitTime").setPosition(340,460).setSize(100,25).setCaptionLabel("Set time interval").setId(305));
    startPHTextfield = cp5.addTextfield("startPHTextField").setPosition(100,490).setSize(100,25).setId(306);
    UIElements.add(startPHTextfield);
    endPHTextfield = cp5.addTextfield("endPHTextField").setPosition(220,490).setSize(100,25).setId(307);
    UIElements.add(endPHTextfield);
    UIElements.add(cp5.addButton("submitData").setPosition(340,490).setSize(100,25).setCaptionLabel("Set pH interval").setId(308));
    UIElements.add(cp5.addButton("lastMinute").setPosition(460,460).setSize(100,25).setCaptionLabel("Last minute").setId(309));
    
    for(Controller c : UIElements){
      c.getCaptionLabel().setFont(font).setSize(12).toUpperCase(false);
    }
  }
  
  public void draw(){
    //float timeScale = pow(2,ceil(log(graphData.size())/log(2)))/frequencyOfDataUpdates;
    //float timeScale = graphEndTime-graphStartTime;
    int graphX = 100; int graphY = 100;
    int graphWidth = 550; int graphHeight = 200;
    drawGraph(graphX,graphY,graphWidth,graphHeight,graphStartTime,graphEndTime,graphStartPH,graphEndPH);
    stroke(0);
    noFill();
    line(graphX-5,graphY,graphX-5,graphY+graphHeight+5);
    line(graphX-5,graphY+graphHeight+5,graphX+graphWidth,graphY+graphHeight+5);
    
    textFont(myFont);
    textSize(12);
    fill(0);
    stroke(0);
    String t = ""+graphStartTime;
    text(t,graphX-textWidth(t)/2,graphY+graphHeight+25);
    t = ""+graphEndTime;
    text(t,graphX+graphWidth-textWidth(t)/2,graphY+graphHeight+25);
    t = ""+graphStartPH;
    text(t,graphX-10-textWidth(t),graphY+graphHeight+5);
    t = ""+graphEndPH;
    text(t,graphX-10-textWidth(t),graphY+5);
  }
  
  public void serialEvent(String data){
    String datas[] = data.split(",");
    rawPh = Float.parseFloat(datas[0]);
    addDataToGraph(rawPh);
  }
  
  public void controlEvent(ControlEvent e) {
    int id = e.getController().getId();
    switch(id){
      /* Add acid button */         case 301: addAcid(); break;
      /* Add base button */         case 302: addBase(); break;
      /* Set time scale button */   case 305: submitTimeScale(); break;
      /* Set data scale button */   case 308: submitDataScale(); break;
      /* Last minute button */      case 309: submitTimeScaleLastMinute(); break;
    }
  }
  
  private void addAcid(){
    port.write("a5000p30\n");
  }
  
  private void addBase(){
    port.write("b5000p30\n");
  }
  
  private void submitTimeScaleLastMinute(){
    startTimeTextfield.setText(""+(graphData.size()/frequencyOfDataUpdates-10));
    endTimeTextfield.setText(""+(graphData.size()/frequencyOfDataUpdates+50));
    submitTimeScale();
  }
  
  private void submitTimeScale(){
    try{
      graphStartTime = Float.parseFloat(startTimeTextfield.getText());
      graphEndTime = Float.parseFloat(endTimeTextfield.getText());
    } catch(NumberFormatException e){}
  }
  
  private void submitDataScale(){
    try{
      graphStartPH = Float.parseFloat(startPHTextfield.getText());
      graphEndPH = Float.parseFloat(endPHTextfield.getText());
    } catch(NumberFormatException e){}
  }
  
}