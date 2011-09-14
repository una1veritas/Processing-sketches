import java.util.*;

PFont font;
Vector numbers = new Vector();
int numberLimit;
long lastMillis;

void setup() {
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

void draw() {
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

void mouseReleased() {
  if ( numbers.size() == 6 ) {
    numbers.clear();
    numberLimit = 0;
  }
}

