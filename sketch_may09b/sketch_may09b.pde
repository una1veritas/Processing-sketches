import processing.serial.*;
import cc.arduino.*;

Arduino dino;
int ledpin = 13;

void setup(){
  dino = new Arduino(this,Arduino.list()[0], 115200);
  println(Arduino.list());
      
  dino.pinMode(ledpin, Arduino.OUTPUT);
  
}

void draw() {
  
    dino.digitalWrite(ledpin,Arduino.HIGH);
}
