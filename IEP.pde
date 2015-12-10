import processing.serial.*;
import controlP5.*;

ArrayList<ControlWindow> cwList;

//Serial port variables
Serial port;
byte[] inputBuffer;
public static final int BAUD = 9600;

//Control Windows - UI Elements
ControlWindow activeControlWindow;
PHControlWindow phcw;
HeatingControlWindow hcw;
StirringControlWindow scw;

ControlP5 cp5;
Button phPortButton;
Button hPortButton;
Button sPortButton;

void setup() {
  size(800, 600);
  frameRate(60);
  
  cp5 = new ControlP5(this);
  
  cwList = new ArrayList<ControlWindow>();
  phcw = new PHControlWindow();
  hcw = new HeatingControlWindow();
  scw = new StirringControlWindow();
  activeControlWindow = phcw;
  
  cp5.addButton(phcw.getTabName()).setPosition(1,1).setSize(80,20).setId(1);
  cp5.addButton(hcw.getTabName()).setPosition(82,1).setSize(80,20).setId(2);
  cp5.addButton(scw.getTabName()).setPosition(163,1).setSize(80,20).setId(3);
  
  phPortButton = cp5.addButton("phPortButton").setPosition(1,22).setSize(80,20).setId(4);
  hPortButton = cp5.addButton("hPortButton").setPosition(82,22).setSize(80,20).setId(5);
  sPortButton = cp5.addButton("sPortButton").setPosition(163,22).setSize(80,20).setId(6);
  phPortButton.hide(); hPortButton.hide(); sPortButton.hide();
  
  for(ControlWindow cw : cwList){
    cw.setup();
  }
  
  String s[] = Serial.list();
  printArray(s);
  if(s.length > 0){
    port = new Serial(this,s[0],BAUD);
    phPortButton.setCaptionLabel(s[0]); hPortButton.setCaptionLabel(s[0]); sPortButton.setCaptionLabel(s[0]);
    port.clear();
    port.bufferUntil('\n');
  }
  
  phcw.showUI(); hcw.hideUI(); scw.hideUI();
}

void draw() {
  background(255);
  
  activeControlWindow.draw();
}

void serialEvent(Serial p) {
  String data = p.readStringUntil('\n');
  for(ControlWindow cw : cwList){
    if(data.startsWith(cw.getDataPrefix())){
      cw.serialEvent(data.substring(cw.getDataPrefix().length()));
    }
  }
}

public void controlEvent(ControlEvent e) {
  for(ControlWindow cw : cwList){
    cw.controlEvent(e);
  }
  switch(e.getController().getId()){
    case 1: activeControlWindow = phcw; phcw.showUI(); hcw.hideUI(); scw.hideUI(); break;
    case 2: activeControlWindow = hcw; phcw.hideUI(); hcw.showUI(); scw.hideUI(); break;
    case 3: activeControlWindow = scw; phcw.hideUI(); hcw.hideUI(); scw.showUI(); break;
    case 4: println("yea1"); break;
    case 5: println("yea2"); break;
    case 6: println("yea3"); break;
  }
}