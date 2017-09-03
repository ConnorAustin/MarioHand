//Activates record mode to generate the file to record the times you poke the block
boolean recordMode = false;

boolean donePlaying = false;
boolean donePlayingSong = false;

float[] beatTimings;

float fineTuningOffset = 1000;

//For recording
ArrayList<String> pokeTimeStamps = new ArrayList<String>();

float curTime;

int nextPokeIndex = 0;

void updateMaestro(float deltaTime)
{
  curTime += deltaTime;
  
  if(recordMode)
    return;
  
  if(!donePlayingSong && curTime >= beatTimings[beatTimings.length - 1] + 200)
  {
    donePlaying = true;
    stopSong();
  }
  if(!donePlaying && curTime >= beatTimings[nextPokeIndex] + fineTuningOffset)
  {
    ++nextPokeIndex;
    poke();
    
    if(nextPokeIndex == beatTimings.length)
    {
      donePlaying = true;
    }
  }
}

void loadRecording()
{
  if(!recordMode)
  {
    donePlaying = false;
    
    //Much load, very sweg
    String[] beatData = loadStrings("mario.beat"); 
    
    beatTimings = new float[beatData.length];
    
    for(int i = 0; i < beatData.length; i++)
    {
      beatTimings[i] = Float.parseFloat(beatData[i]);
    }
  }
  
  curTime = 0;
}

void saveRecording()
{
  String[] timeStampsArray = pokeTimeStamps.toArray(new String[pokeTimeStamps.size()]);
  
  saveStrings("beat.swegbeat", timeStampsArray);
}

void keyPressed()
{
  if(recordMode)
  {
    if(key == 's')
    {
      saveRecording();        
    }
    else
    {
      if(pokeTimeStamps.size() == 0)
      {
        curTime = 0;
      }
      pokeTimeStamps.add(Float.toString(curTime));
    }
  }
}
