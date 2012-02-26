import processing.serial.*;


import pt.citar.diablu.processing.mindset.*;



MindSet r;
int attention;
int strength;

int numSamples = 60;
ArrayList attSamples;

void setup() {
  size(512, 512);
  attSamples = new Arrimport processing.net.*;

Client tgc;
int meditation, attention;
float[] waves;
int port = 13854;
String ip = "127.0.0.1";
int updates;

void setup() {
  size(200,200);
  tgc = new Client(this, ip, port);
  waves = new float[8];
  meditation = attention = updates = 0;
}

void draw() {

  // Look for available bytes
  if(tgc.available() > 0) {
    
    // Grab bytes and save to waves array and att-med
    updateMindSet();
    println("Attention is "+attention+" Meditation is "+meditation);
    updates++;
    
    stroke(255,0,0);
    line(updates,height/2,updates,height/2-attention);
    stroke(0,0,255);
    line(updates,height,updates,height-meditation);
  }
  
  // Draw something based off of wave information
}

void updateMindSet(){
  // Typical data string from NeuroSky Device:
  // aaaa0200 04390500 812036ec 237b3687 87c73734 edc73870 c7f136f2 af4f3690 bf783513 2d0535bd ab96
  // aaaa sync
  // 0200 signal (0-200, 0 is good, 200 is off-head)
  // 0439 attention  (0 is non
  // 0500 meditation
  // 8120 wave code + length (20 is Hexidecimal for 32, 8 numbers x 4 bytes each (for a float)
  // 36ec 237b3687 87c73734 edc73870 c7f136f2 af4f3690 bf783513 2d0535bd ab96			

  byte[] buffer = new byte[42];
  int byteCount = tgc.readBytes(buffer);
  if(byteCount == 42) {
    meditation = buffer[7];
    attention = buffer[5];
    for (int i = 0; i<8; i++) {
      byte[] floatBuffer = new byte[4];
      for(int j=0; j<4; j++) {
        floatBuffer[j] = buffer[10 + i*4 + j];
      }
      waves[i] = byteArrayToFloat(floatBuffer);
    }
  }
  tgc.clear();
}

float byteArrayToFloat(byte test[]) {
  int bits = 0;
  int i = 0;
  for (int shifter = 3; shifter >= 0; shifter--) {
    bits |= ((int) test[i] & 0xff) << (shifter * 8);
    i++;
  }
  return Float.intBitsToFloat(bits);
}ayList();
  r = new MindSet(this, "/dev/cu.MindSet-DevB");
}


void draw() {
  background(0);
  
  
  stroke(255);
  if (attSamples.size() != 0) {
    float w = width*1.0/numSamples;
    int sum = 0;
    for (int i = 0; i< attSamples.size(); i++) {
    
      int v = ((Integer)attSamples.get(i)).intValue();
      sum += v;
      line(i*w, height, i*w, height-v*height/100.0);
    }
    float avg = sum/attSamples.size();
    fill(255, 100);
    noStroke();
    rect(0, height-avg*height/100.0, width, avg*height/100.0);
    stroke(255);
    line(0, height/2, width, height/2);
  }
  
  fill(255, 0, 0, 100);
  stroke(255, 100);
  rect(width/2-50, height-attention*height/100.0, 100, attention*height/100.0);
 
 //signal strength
 stroke(255);
 line(0, 50, 50, 50); 
 fill(0, 255,0);
 rect(12, 50, 25, -(50-strength*50/200.0));
}


void keyPressed() {
  if (key == 'q') {
    r.quit();
  }
}


public void poorSignalEvent(int sig) {
  strength = sig;
  println(sig);
}

public void attentionEvent(int attentionLevel) {
  //println("Attention Level: " + attentionLevel);
  attention = attentionLevel;
  attSamples.add(new Integer(attention));
  if (attSamples.size() > numSamples) {
    attSamples.remove(0);
  }
}

   
