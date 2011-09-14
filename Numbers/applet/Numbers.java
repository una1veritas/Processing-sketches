import processing.core.*; 
import processing.xml.*; 

import java.util.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Numbers extends PApplet {



PFont font;
Vector numbers = new Vector();
int numberLimit;
long lastMillis;

public void setup() {
  size(480, 120);
  background(102);
  
  font = loadFont("Souvenir-Demi-32.vlw");
  textFont(font, 32);  

  numbers.clear();
  randomSeed(millis());
  noiseSeed(0);
  random(1,43+1);

  numberLimit = 1;
  //  noLoop();
  lastMillis = millis();  
}

public void draw() {
  int i, num;
  String str;
  int x = 30;
  int dx, dy;

  
  if ( numberLimit < 6 && (millis() - lastMillis > 1200) ) {
    numberLimit = numberLimit+1;
    lastMillis = millis();
  }
  
  if ( numbers.size() < numberLimit) { 
    num = (int)random(1, 43+1);
    str = ""+num;
    if ( !numbers.contains(str) ) {
      numbers.add(str);
    }
  }
  
  background(102);

  for (i = 0; i < numbers.size(); i++) {
    fill(244);
    str = (String)numbers.elementAt(i);
    if ( mousePressed ) {
      dx = (int) random(-2,2);
      dy = (int) random(-2,2);
    } else {
      dx = 0;
      dy = 0;
    }
    text(str, x+dx, 60+dy);
    x += textWidth(str) + 16;
  }
  
}

public void mouseReleased() {
  if ( numbers.size() == 6 ) {
    numbers.clear();
    numberLimit = 0;
  }
}


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "Numbers" });
  }
}
