/*
*
*/
import processing.serial.*;

MindSet m3band;

final static int gHistSize = 128;
int[] gAttention= new int[256];
int[] gMeditation = new int[256];
int[] gRawWave = new int[256];
int gHistMax;

Serial openSerial(String portname, int baud) {
  Serial tmp = null;
  for(String s : Serial.list()) {
    if ( match(s, portname) != null ) {
      println("Opening serial port: " + s);
      tmp = new Serial(this, s, baud);
      break;
    }
  }
  return tmp;
}


void setup() {
  Serial serport;
  gHistMax = 0;
  serport = openSerial("cu.BrainBand-DevB", 57600);
  if ( serport != null ) {
    m3band = new MindSet(serport);
  }
  //
  PFont font;
  font = loadFont("LucidaSans-12.vlw");
  textFont(font);
  size(400,240);
  frameRate(15);
}


void draw() {
  background(80);
  
  m3band.parsePacket();
  update(m3band.attention, m3band.meditation, m3band.rawWave);  
  int xb = 0;
  int[] yb = {40, 40, 160};
  int xd = 2;
  for(int i = 2; i+1 < gHistMax; i++) {
    stroke(220,100,100);
    line(xb, yb[0]+(gAttention[i-2]+gAttention[i-1]+gAttention[i])/3, 
        xb+xd, yb[0]+(gAttention[i-1]+gAttention[i]+gAttention[i+1])/3 );
    stroke(100,220,100);
    line(xb, yb[1]+gMeditation[i], xb+xd, yb[1]+gMeditation[i+1]);
    stroke(100,120,140);
    line(xb, yb[2]+gRawWave[i]/8, xb+xd, yb[2]+gRawWave[i+1]/8);
    xb += xd;
  }
  text("attention",xb+10,yb[0]+gAttention[gHistMax-1]);
  text("Meditation",xb+10,yb[1]+gMeditation[gHistMax-1]);
}

void update(int attn, int medi, int raw) {
  if ( gHistMax < gHistSize ) {
      gHistMax++;
  } else {
    for (int i = 0; i+1 < gHistMax; i++) {
      gAttention[i] = gAttention[i+1];
      gMeditation[i] = gMeditation[i+1];
      gRawWave[i] = gRawWave[i+1];
    }
  }
  gAttention[gHistMax-1] = attn;
  gMeditation[gHistMax-1] = medi;
  gRawWave[gHistMax-1] = raw;
}

