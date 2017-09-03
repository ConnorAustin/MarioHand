class Item
{
  PImage image;
  
  final float itemSoundVolume = 0f;
  
  float x;
  float y;
  
  float yVel;
  
  int xDir;
  float xVel;
  
  float scale;
  
  float angle;
  float angleDir;
  
  float scaleSinAngle = 0.001f;
  
  //Should be an even number
  final int lineCount = 200;
  PVector lines[];
  color lineColors[];
  
  public Item()
  {
    lines = new PVector[lineCount];
    lineColors = new color[lineCount / 2];
  }
  
  PImage pickRandomItemImage()
  {
    float choice = random(0, 101);
      
    switch(floor(random(0, 6)))
    {
      case 0: return oneupImage;
      case 1: return goombaImage;
      case 2: return starImage; 
      case 3: return mushroomImage;
      case 4: return marioImage;
      case 5: return coinImage;
    }
    return coinImage;
  }
  
  public void reset(float xStart, float yStart)
  {
    //Reset lines
    for(int i = 0; i < lineCount; i++)
    {
      lines[i] = null;
    }
    image = pickRandomItemImage();
    xDir = round(random(0, 2)) == 1 ? -1 : 1;
    angleDir = xDir;
    angle = 0;
    xVel = random(0.13f, 0.3f) * xDir;
    
    x = xStart;  
    y = yStart;
    yVel = random(-0.7f, -0.5f);
    scale = 0.4f;
  }
  
  void addNewLinePart()
  {
    for(int i = 0; i < lineCount; i++)
    {
      if(lines[i] == null)
      {
        if(i % 2 == 0)
        {
          newLineTimer = 25;
        }
        else
        {
          lineColors[i / 2] = color(255);
          newLineTimer = 10;
        }
        lines[i] = new PVector(x, y);
        break;
      }
    }
  }
  
  float newLineTimer = 0;
  
  public void update(float deltaTime)
  {
    newLineTimer -= deltaTime;
    
    if(newLineTimer < 0)
    {
      addNewLinePart();
    }
    
    for(int i = 0; i < lineCount / 2; i++)
    {
      lineColors[i] = color(255, 255, 255, alpha(lineColors[i]) - deltaTime * 0.6f);
    }
    
    y += yVel * deltaTime;
    x += xVel * deltaTime;
    yVel += 0.001f * deltaTime;
    
    angle += 0.001f * angleDir * deltaTime;
    
    scale = min(1, scale + 0.0025f * deltaTime);
  }
  
  public void drawSelf()
  {
    if(image == null || y > height + 700)
      return;
    
    for(int i = 1; i < lineCount; i+=2)
    {
      if(lines[i] == null || lines[i - 1] == null)
      {
        break;
      }
       
      stroke(lineColors[(i - 1) / 2]);
      strokeWeight(i / 25.0f + 3);
      line(lines[i].x, lines[i].y, lines[i - 1].x, lines[i - 1].y);
    }
    
    pushMatrix();
    translate(x, y);
    rotate(angle);
    scale(scale * 2);
    image(image, 0, 0);
    popMatrix();  
  }
}
