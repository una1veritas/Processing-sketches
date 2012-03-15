/*
*
 */
import processing.serial.*;

MindSet m3band;

final static int gHistSize = 256;
int[] gAttention= new int[256];
int[] gMeditation = new int[256];
int[] gRawWave = new int[256];
int gHistMax;

final static int gWidth = 200;
final static int gHight = 64;

Serial openSerial(String portname, int baud) {
  Serial tmp = null;
  for (String s : Serial.list()) {
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
  serport = openSerial("cu.usbserial-A700eDD9", 57600);
  if ( serport != null ) {
    m3band = new MindSet(serport);
  }
  //
  PFont font;
  font = loadFont("LucidaSans-12.vlw");
  textFont(font);
  size(400, 360);
  frameRate(15);
}


void draw() {
  background(80);

  m3band.parsePacket();
  update(m3band.attention, m3band.meditation, m3band.rawWave);  
  int xb = 20;
  int yb[] = {64+16, 64+16, 240};
  int xd = 1;
  for (int i = 0; i+1 < gHistMax; i++) {
    stroke(80+i, 80+i, 100+i);
    line(xb+xd*i, yb[2]+gRawWave[i]/10, xb+xd*(i+1), yb[2]+gRawWave[i+1]/10);
  }
  xd = 1;
  for (int i = 0; i+1 < gHistMax; i++) {
    stroke(240, 120, 80);
    line(xb+xd*i, yb[0]-map(gAttention[i],0,100,0,48), xb+xd*(i+1), yb[0]-map(gAttention[i+1],0,100,0,48) );
    stroke(80, 240, 120);
    line(xb+xd*i, yb[1]-map(gMeditation[i],0,100,0,48), xb+xd*(i+1), yb[1]-map(gMeditation[i+1],0,100,0,48) );
  }
  fill(240, 120, 80);
  text("attention", xb+260, yb[0]-map(gAttention[gHistMax-1],0,100,0,48));
  fill(80, 240, 120);
  text("meditation", xb+260, yb[1]-map(gMeditation[gHistMax-1],0,100,0,48));
}

void update(int attn, int medi, int raw) {
  if ( gHistMax < gHistSize ) {
    gHistMax++;
  } 
  else {
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

