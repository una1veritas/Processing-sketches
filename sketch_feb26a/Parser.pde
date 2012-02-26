class MindSet {

int SYNC = 0xAA;
int EXCODE = 0x55;

//MindSet readings
int rawWave = 0;        // raw brain wave value
int attention = 0;      // attention esense value
int meditation = 0;     // meditation esense value
boolean signal = true;  // poor signal flag: true = good signal, false = poor signal

// EEG Readings
long delta = 0;         // 0.5 - 2.75Hz
long theta = 0;         // 3.5 - 6.75Hz
long lowAlpha = 0;      // 7.5 - 9.25Hz
long highAlpha = 0;     // 10 - 11.75Hz
long lowBeta = 0;       // 13 - 16.75Hz
long highBeta = 0;      // 18 - 29.75Hz
long lowGamma = 0;      // 31 - 39.75Hz
long midGamma = 0;      // 41 - 49.75Hz

Serial btPort;

public MindSet(Serial port) {
  btPort = port;
}

void parsePacket()
{
  while (btPort.available () > 0)
  {
    char[] payload = new char[256];
    char pLength = 256;

    /* Synchronize on [SYNC] bytes */
    char c = btPort.readChar(); //fread( &c, 1, 1, stream ); 
    if ( c != SYNC ) continue;

    c = btPort.readChar(); //fread( &c, 1, 1, stream ); 
    if ( c != SYNC ) continue;

    // Parse [PLENGTH] byte
    while ( true && btPort.available () > 0) { 
      pLength = btPort.readChar(); //fread( &pLength, 1, 1, stream );

      if (pLength != 170) break;
    } 
    if ( pLength > 170 ) continue;

    // Collect [PAYLOAD...] bytes
    int count = 0;
    while (btPort.available () > 0 && count < pLength)
    {
      payload[count] = btPort.readChar();
      //print((int)payload[count] + ",");
      count++;
    }
    if (count < pLength) continue;

    // Calculate [PAYLOAD...] checksum 
    int checksum = 0; 
    for (char i=0; i<pLength; i++ ) checksum += payload[i]; 

    checksum &= 0xFF; 
    checksum = ~checksum & 0xFF; 

    // Parse [CKSUM] byte
    if (btPort.available() > 0) c = btPort.readChar(); //fread( &c, 1, 1, stream );
    else continue;

    // Verify [CKSUM] byte against calculated [PAYLOAD...] checksum
    if ( c != checksum ) continue;

    /*print("Length: " + (int)pLength + ", Payload: ");
     
     for(int i = 0; i < pLength; i++)
     {
     print(payload[i]);
     }
     
     println(", Checksum: " + checksum);*/

    // Since [CKSUM] is OK, parse the Data Payload
    parsePayload(payload, pLength);
  }
}

void parsePayload(char[] payload, char pLength)
{
  int bytesParsed = 0;
  int code;
  int len;
  int extendedCodeLevel;

  while (bytesParsed < pLength)
  {
    extendedCodeLevel = 0;
    while (payload[bytesParsed] == EXCODE) {
      extendedCodeLevel++;
      bytesParsed++;
    }
    code = (int)payload[bytesParsed++];

    if (code >= 0x80)  len = (int)payload[bytesParsed++];
    else              len = 1;

    switch(code) {

    case 0x80:  // RAW WAVE
      int highValue = (int)payload[bytesParsed++];
      int lowValue = (int)payload[bytesParsed];

      rawWave = (highValue << 8) | lowValue;

      if (rawWave > 32768) rawWave = rawWave - 65536;

      if (signal) {
        //println("Raw Wave: " + rawWave);      // do not print if you are experiencing a poor signal
      }
      break;

    case 0x02:  // POOR SIGNAL
      if ((int)payload[bytesParsed] == 200) signal = false;
      else signal = true;

      if (!signal) println("POOR SIGNAL");
      break;

    case 0x83:  // EEG DATA
      int[] eegData = new int[24];

      for (int i = 0; i < len; i++) eegData[i] = (int)payload[bytesParsed + i];

      delta = ((eegData[0] << 16) | (eegData[1] << 8)) | eegData[2];
      theta = ((eegData[3] << 16) | (eegData[4] << 8)) | eegData[5];
      lowAlpha = ((eegData[6] << 16) | (eegData[7] << 8)) | eegData[8];
      highAlpha = ((eegData[9] << 16) | (eegData[10] << 8)) | eegData[11];
      lowBeta = ((eegData[12] << 16) | (eegData[13] << 8)) | eegData[14];
      highBeta = ((eegData[15] << 16) | (eegData[16] << 8)) | eegData[17];
      lowGamma = ((eegData[18] << 16) | (eegData[19] << 8)) | eegData[20];
      midGamma = ((eegData[21] << 16) | (eegData[22] << 8)) | eegData[23];

      // do not print if you are experiencing a poor signal
      if (signal) println("EEG Power Values: " + delta + "," + theta + "," + lowAlpha + "," + highAlpha + "," + lowBeta + "," + highBeta + "," + lowGamma + "," + midGamma);
      break;

    case 0x04:  // ATTENTION
      attention = (int)payload[bytesParsed];
      if (signal) println("Attention: " + attention);    // do not print if you are experiencing a poor signal
      break;

    case 0x05:  // MEDITATION
      meditation = (int)payload[bytesParsed];
      if (signal) println("Meditation: " + meditation);  // do not print if you are experiencing a poor signal
      break;
    }

    //println("EXCODE level: " + (int)extendedCodeLevel + " CODE: 0x" + hex(code,2) + " length: " + len);
    //print("Data value(s):");

    /*for(int i = 0; i < len; i++)
     {
     print(int(payload[bytesParsed + i]) & 0xFF);
     print(",");
     }*/

    bytesParsed += len;
  }
}

};

