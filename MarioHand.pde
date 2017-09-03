import ddf.minim.*;

PImage handImage;
PImage blockImage;
PImage mushroomImage;
PImage coinImage;
PImage starImage;
PImage oneupImage;
PImage goombaImage;
PImage marioImage;
PImage backgroundImage;

PVector handPos;
PVector handOffset;
PVector blockPos;
PVector blockOffset;

boolean handPoking = false;
float handSinAngle = 0;

boolean blockPoked = false;
float blockSinAngle = 0;

final int fallingItemCount = 10;
Item[] fallingItems;
int availableItemIndex;
int bgTilesWide;
int bgTilesTall;

AudioPlayer song;

float lastUpdateTime;

String getTitle()
{
  return "The pokey thing.";
}

String getName()
{
  return "Connor 'Superhandsome' Austin";
}

void setup()
{
  size(1080, 720);
  
  handImage = loadImage("hand.png");
  blockImage = loadImage("block.jpg");
  mushroomImage = loadImage("mushroom.png");
  coinImage = loadImage("coin.gif");
  starImage = loadImage("star.png");
  oneupImage = loadImage("oneup.png");
  goombaImage = loadImage("goomba.png");
  marioImage = loadImage("deadMario.png");
  backgroundImage = loadImage("background.png");
  
  handPos = new PVector(width / 2 + 90, height - 100);
  handOffset = new PVector(0, 0);
  
  blockPos = new PVector(width / 2, handPos.y - 350);
  blockOffset = new PVector(0, 0);
  
  fallingItems = new Item[fallingItemCount];
  for(int i = 0; i < fallingItemCount; i++)
  {
    fallingItems[i] = new Item();
  }
  bgTilesWide = width / backgroundImage.width + 1;
  bgTilesTall = height / backgroundImage.height + 1;
  
  availableItemIndex = 0;
  
  loadRecording();
  
  playSong();
  lastUpdateTime = millis();
}

void playSong()
{
  song = new Minim(this).loadFile("marioTheme.mp3", 512);
  song.play();
}

void stopSong()
{
  song.pause(
);
}

void poke()
{
  if(handPoking)
  {
    //Poke the block from the interrupted poke before we start this poke
    pokeBlock();
  }
  
  handPoking = true;
  blockSinAngle = 0;
  handSinAngle = 0;
}

void pokeBlock()
{
  blockPoked = true;
  blockOffset.y = 0;
  fallingItems[availableItemIndex].reset(blockPos.x, blockPos.y - blockImage.height / 2);
  ++availableItemIndex;
  if(availableItemIndex == fallingItems.length)
  {
    availableItemIndex = 0;
  }
}

void updateHand(float deltaTime)
{
  float prevHandSinAngle = handSinAngle;
  handSinAngle = min(handSinAngle + 0.015f * deltaTime, TWO_PI);
  if(handPoking)
  {
    if(prevHandSinAngle < PI / 2 && handSinAngle >= PI / 2)
    {
      handPoking = false;
      pokeBlock();
    }
  }
  handOffset.y = -sin(handSinAngle) * 50;
}

void update(float deltaTime)
{
  updateMaestro(deltaTime);
  
  for(Item item : fallingItems)
  {
    item.update(deltaTime);
  }
  
  updateHand(deltaTime);
  
  if(blockPoked)
  {
    blockSinAngle += 0.015f * deltaTime;
    if(blockSinAngle > PI)
    {
      blockOffset.y = 0;
      blockSinAngle = 0;
      blockPoked = false;
    }
    blockOffset.y = -sin(blockSinAngle) * 16.5f;
  }
}

void draw()
{
  float curTime = millis();
  update(curTime - lastUpdateTime);
  lastUpdateTime = curTime;
  
  imageMode(CORNER);
  tint(255, 97, 29);
  for(int y = 0; y < bgTilesTall; y++)
  for(int x = 0; x < bgTilesWide; x++)
  {
    image(backgroundImage, x * backgroundImage.width, y * backgroundImage.height);
  }
  tint(255);
  
  imageMode(CENTER);
  for(Item item : fallingItems)
  {
    item.drawSelf();
  }
  
  image(handImage, handPos.x + handOffset.x, handPos.y + handOffset.y);
  
  if(blockPoked)
  {
    float leftSideOfBlock = blockPos.x - blockImage.width / 2 - 30;
    float blockYPos = blockPos.y + blockOffset.y;
    
    strokeWeight(5);
    stroke(255, 255, 50);
    
    float bottomSideOfBlock = blockPos.y + blockImage.height / 2 + 2;
    line(blockPos.x - 20, bottomSideOfBlock, blockPos.x - 30, bottomSideOfBlock + 4);
    line(blockPos.x, bottomSideOfBlock, blockPos.x, bottomSideOfBlock + 20);
    line(blockPos.x + 20, bottomSideOfBlock, blockPos.x + 30, bottomSideOfBlock + 4);
  }
  image(blockImage, blockPos.x + blockOffset.x, blockPos.y + blockOffset.y);
}
