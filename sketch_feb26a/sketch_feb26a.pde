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
  size(512,240);
  frameRate(15);
}


void draw() {
  background(80);
  
  m3band.parsePacket();
  update(m3band.attention, m3band.meditation, m3band.rawWave);  
  int xb = 0;
  int[] yb = {80, 120, 160};
  int xd = 3;
  for(int i = 0; i+1 < gHistMax; i++) {
    stroke(200);
    line(xb, yb[0]+gAttention[i], xb+xd, yb[0]+gAttention[i+1]);
    xb += xd;
  }
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

