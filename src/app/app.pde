ArrayList<ArrayList<Block>> blocksArray;  // Contains the blocks which are fixed on the grid
ArrayList<BurstBlock> burstBlocksArray;  // Contains the blocks which give the burst effect

Block currentBlock;  // Current moving block

Timer timer;  // Game timer
Timer universalTimer;  // Universal timer

PImage heirloomImage;  // Heirloom image variable
PImage clockImage;  // Clock image variable
PImage scoreImage;  // Score image variable
PImage islamicPatternImage;  // Islamic pattern image variable
PImage islamicPatternBlurImage; // Islamic pattern blur image variable
PImage gameLoseImage;  // Game lose image variable

SoundFile backgroundSound;  // Sound which plays in the background
SoundFile screenTransitionSound;  // Sound which plays at the time of screen transition
SoundFile burstSound;  // Sound of a block cracking

int currentBlockX;  // Starting "x" of current block
int currentBlockY;  // Starting "y" of current block
int currentBlockSize;  // Size of current current block
int currentBlockRow;  // Row of current current block
int currentBlockCol;  // Column of current block
int blockSize;  // Size of one block
int difficultyLevel;  // Number of blocks in a row or column in which blocks will be eliminated
int burstX;  // Starting "x" of burst block
int burstY;  // Starting "y" of burst block
int burstSize;  // Size of burst block
int lineX;  // Starting "x" of grid line
int lineY;  // Starting "y" of grid line
int totalScore;  // Total score
int gameWidth;  // Width of game play screen
int gameHeight; // Height of game play screen
int splashEffect; // Gives splash effect
int heirloomBlurIntensity;  // Stores the blur intensity of heirloom image
int patternBlurIntensity;  // Stores the blur intensity of islamic pattern image

boolean isGameOver;  // Tracks game over
boolean isTransitionSoundPlayed;  // Checks if screen transition sound is played
boolean isBackgroundSoundPlayed;  // Checks if background sound is played

void setup()
{
  size(500, 600);
  background(255);
  splashEffect = 255;
  
  // Initialising global variables
  gameWidth = width;
  gameHeight = height - 100;
  totalScore = 0;
  blockSize = 50;
  difficultyLevel = 6;
  heirloomBlurIntensity = 6;
  patternBlurIntensity = 6;
  isGameOver = false;
  isTransitionSoundPlayed = false;
  isBackgroundSoundPlayed = false;
  
  // Loading images
  clockImage = loadImage("../assets/images/clock_image.png");
  scoreImage = loadImage("../assets/images/score_image.png");
  gameLoseImage = loadImage("../assets/images/gamelose_image.png");
  islamicPatternImage = loadImage("../assets/images/islamic_pattern.png");
  islamicPatternBlurImage = loadImage("../assets/images/islamic_pattern_blur.png");
  heirloomImage = loadImage("../assets/images/heirloom_image.png");
  
  // Loading sounds
  backgroundSound = new SoundFile(this, "../assets/sounds/background.wav");
  //screenTransitionSound = new SoundFile(this, "../assets/sounds/screen-transition.wav");
  burstSound = new SoundFile(this, "../assets/sounds/block-crack.wav");
  backgroundSound.rate(1);
  //screenTransitionSound.rate(1);
  burstSound.rate(1);
  
  // Initialising timers
  universalTimer = new Timer(3);
  timer = new Timer(150);
  //timer = new Timer(60);
  
  // Initialising blocks arrays
  blocksArray = new ArrayList<ArrayList<Block>>();
  burstBlocksArray = new ArrayList<BurstBlock>();
  
  for(int i=0; i<gameWidth/blockSize; i++)
  {
    blocksArray.add(new ArrayList<Block>());
    for(int j=0; j<gameHeight/blockSize; j++)
    {
      blocksArray.get(i).add(new Block(0, 0, 0));
    }
  }
  
  //Generating first moving block
  currentBlock = new Block(0, 0, blockSize);
  
  lineX = blockSize;
  lineY = blockSize;
}

void draw()
{ 
  background(255);
  
  // Switches to game play mode
  universalTimer.countDown();
  if(universalTimer.getTime() < 0)
  {
    // Heirloom image in the background
    image(heirloomImage, 0, 0);
    //filter(BLUR, heirloomBlurIntensity);
    
    // Plays background sound
    if(isBackgroundSoundPlayed == false)
    {
      backgroundSound.play();
      isBackgroundSoundPlayed = true;
    }
    
    currentBlock.show();
    
    /* Displays game info starts ... */
    //Timer
    image(clockImage, width-350, height-95);
    timer.countDown();
    fill(255, 255, 255);
    textSize(15);
    text("Time Remaining", width - 305, height - 80);
    textSize(20);
    text(timer.getTime(), width - 320, height - 55);
    textSize(15);
    text("sec", width - 225, height - 55);
    
    //Score
    image(scoreImage, 0, height-105);
    if(timer.getTime() > 0)
    {
      timer.countDown();
    }
    fill(255, 255, 255);
    textSize(15);
    text("Points Scored", 40, height - 80);
    textSize(40);
    text(totalScore, 50, height - 40);
    /* Displays game info ends */
    
    //// Checks the win condition
    //if(timer.getTime() < 0)
    //{
    //  // Show picture of islamic art pattern as splash screen
    //  isGameOver = true;
    //  image(islamicPatternImage, 0, 0);
    //}
    
    // Checks the game over condition
    int counter = 0;
    for(int j=0; j<blocksArray.get(0).size(); j++)
    {
      if(blocksArray.get(0).get(j).getSize() != 0)
      {
        counter++;
      }
    }
    if(counter >= blocksArray.get(0).size())
    {
      isGameOver = true;
      image(islamicPatternImage, 0, 0);
    }

    // Removes burst blocks from the array which are no longer on screen
    for(int i=0; i<burstBlocksArray.size(); i++)
    {
      if(burstBlocksArray.get(i).getX() > gameWidth || burstBlocksArray.get(i).getY() > gameHeight)
      {
        burstBlocksArray.remove(i);
      }
    }
    
    // Draws burst blocks on screen
    for(BurstBlock burstBlock: burstBlocksArray)
    {
      burstBlock.show();
      burstBlock.fall();
    }
    
    //Draws the grid
    lineX = blockSize;
    lineY = blockSize;
    while(lineX <= gameHeight)
    {
      stroke(150);
      line(0, lineX, gameWidth, lineX);
      lineX += blockSize;
    }
    while(lineY <= gameWidth)
    {
      stroke(150);
      line(lineY, 0, lineY, gameHeight);
      lineY += blockSize;
    }
    stroke(0);
    line(0, gameHeight, gameWidth, gameHeight);
    
    //Draws the blocks
    noStroke();
    for(int i=0; i<gameWidth/blockSize; i++)
    {
      for(int j=0; j<gameHeight/blockSize; j++)
      {
        blocksArray.get(i).get(j).show();
      }
    }
    
    // Eliminates horizontal blocks
    for(int i=0; i<gameWidth/blockSize; i++)
    {
      for(int j=0; j<gameHeight/blockSize - (difficultyLevel - 1); j++)
      {
        if(blocksArray.get(i).get(j).getSize() != 0 
        && blocksArray.get(i).get(j+1).getSize() != 0 && 
        blocksArray.get(i).get(j+2).getSize() != 0 &&
        blocksArray.get(i).get(j+3).getSize() != 0 &&
        blocksArray.get(i).get(j+4).getSize() != 0 &&
        blocksArray.get(i).get(j+5).getSize() != 0 &&
        blocksArray.get(i).get(j).getType() == blocksArray.get(i).get(j+1).getType() && blocksArray.get(i).get(j).getType() != 0 &&
        blocksArray.get(i).get(j+1).getType() == blocksArray.get(i).get(j+2).getType() && blocksArray.get(i).get(j+1).getType() != 0 &&
        blocksArray.get(i).get(j+2).getType() == blocksArray.get(i).get(j+3).getType() && blocksArray.get(i).get(j+2).getType() != 0 &&
        blocksArray.get(i).get(j+3).getType() == blocksArray.get(i).get(j+4).getType() && blocksArray.get(i).get(j+3).getType() != 0 &&
        blocksArray.get(i).get(j+4).getType() == blocksArray.get(i).get(j+5).getType() && blocksArray.get(i).get(j+4).getType() != 0
        )
        {
          // Incrementing the score
          totalScore += 10;
          
          // Playing the burst sound
          burstSound.play();
          
          // Adds burst blocks to the array
          for(int b=0; b<10; b++)
          {
            burstX = blocksArray.get(i).get(j).getX() + 2*b;
            burstY = blocksArray.get(i).get(j).getY() + b;
            burstSize = blocksArray.get(i).get(j).getSize() / 4;
            
            burstBlocksArray.add(new BurstBlock(burstX, burstY, burstSize));
            
            burstBlocksArray.get(b).setType(blocksArray.get(i).get(j).getType());
          }
          
          for(int k=0; k<difficultyLevel; k++)
          {  
            blocksArray.get(i).get(j+k).setType(0);
          }
        }
      }
    }
    
    // Eliminates vertical blocks
    for(int i=0; i<gameWidth/blockSize - (difficultyLevel - 1); i++)
    {
      for(int j=0; j<gameHeight/blockSize; j++)
      {
        if(blocksArray.get(i).get(j).getSize() != 0 
        && blocksArray.get(i+1).get(j).getSize() != 0 && 
        blocksArray.get(i+2).get(j).getSize() != 0 &&
        blocksArray.get(i+3).get(j).getSize() != 0 &&
        blocksArray.get(i+4).get(j).getSize() != 0 &&
        blocksArray.get(i+5).get(j).getSize() != 0 &&
        blocksArray.get(i).get(j).getType() == blocksArray.get(i+1).get(j).getType() && blocksArray.get(i).get(j).getType() != 0 &&
        blocksArray.get(i+1).get(j).getType() == blocksArray.get(i+2).get(j).getType() && blocksArray.get(i+1).get(j).getType() != 0 &&
        blocksArray.get(i+2).get(j).getType() == blocksArray.get(i+3).get(j).getType() && blocksArray.get(i+2).get(j).getType() != 0 &&
        blocksArray.get(i+3).get(j).getType() == blocksArray.get(i+4).get(j).getType() && blocksArray.get(i+3).get(j).getType() != 0 &&
        blocksArray.get(i+4).get(j).getType() == blocksArray.get(i+5).get(j).getType() && blocksArray.get(i+4).get(j).getType() != 0
        )
        {
          // Incrementing the score
          totalScore += 10;
          
          // Playing the burst sound
          burstSound.play();
          
          // Adds burst blocks to the array
          for(int b=0; b<10; b++)
          {
            burstX = blocksArray.get(i).get(j).getX() + 2*b;
            burstY = blocksArray.get(i).get(j).getY() + b;
            burstSize = blocksArray.get(i).get(j).getSize() / 4;
            
            burstBlocksArray.add(new BurstBlock(burstX, burstY, burstSize));
            
            burstBlocksArray.get(b).setType(blocksArray.get(i).get(j).getType());
          }
          
          for(int k=0; k<difficultyLevel; k++)
          {  
            blocksArray.get(i+k).get(j).setType(0);
          }
        }
      }
    }
    
    // Checks the win condition
    if(timer.getTime() < 0)
    {
      // Show picture of islamic art pattern as splash screen
      isGameOver = true;
      image(islamicPatternImage, 0, 0);
      fill(0);
      textSize(40);
      
      fill(255, 255, 255, 100);
      rect(60, height/2 - 45, 405, 190);
      fill(255, 255, 255);
      
      text("Game Over", width/2 - 100, height/2);
      text("Well Played", width/2 - 100, height/2 + 40);
      textSize(40);
      text("Points Scored: ", width/2 - 100, height/2 + 100);
      text(totalScore, width/2, height/2 + 140);
    }
    
    // Checks the game over condition
    counter = 0;
    for(int j=0; j<blocksArray.get(0).size(); j++)
    {
      if(blocksArray.get(0).get(j).getSize() != 0)
      {
        counter++;
      }
    }
    if(counter >= blocksArray.get(0).size())
    {
      isGameOver = true;
      image(islamicPatternImage, 0, 0);
      fill(0);
      textSize(40);
      
      fill(255, 255, 255, 100);
      rect(60, height/2 - 45, 405, 190);
      fill(255, 255, 255);
      
      text("Game Over", width/2 - 100, height/2);
      text("You lost!", width/2 - 100, height/2 + 40);
      textSize(40);
      text("Points Scored: ", width/2 - 100, height/2 + 100);
      text(totalScore, width/2, height/2 + 140);
    }
  }
  else  // Splash screen part
  {
    // Show picture of islamic art pattern as splash screen
    image(islamicPatternBlurImage, 0, 0);
    //filter(BLUR, 5);
    fill(255, 255, 50);
    textSize(40);
    noStroke();
    fill(255, 150, 0, 70);
    rect(40, height/2 - 35, 425, 65);
    fill(255, 255, 50);
    text("The Heirloom Project", 50, height/2 + 10);
    
    if(universalTimer.getTime() < 1.5)
    {
      //// Plays screen transition sound
      //if(isTransitionSoundPlayed == false)
      //{
      //  screenTransitionSound.play();
      //  isTransitionSoundPlayed = true;
      //}
      splashEffect--;
      background(splashEffect % 255);
      fill(255, 100, 100);
      textSize(55);
      text("Let's Play!", 130, height/2);
      textSize(17);
      text("Place six blocks horizontally or vertically to reveal", 50, height/2 + 100);
      text("the Heirloom Image", 170, height/2 + 130);
    }
  }
}

void keyReleased()
{
  if(!isGameOver)
  {
    if(keyCode == DOWN)
    {
      currentBlockX = currentBlock.getX();
      currentBlockY = currentBlock.getY();
      currentBlockSize = currentBlock.getSize();
      
      currentBlockRow = currentBlockY/blockSize;
      currentBlockCol = currentBlockX/blockSize;
      
      if(currentBlockRow < gameHeight/blockSize - 1)
      {
        if(blocksArray.get(currentBlockRow + 1).get(currentBlockCol).getSize() == 0 && blocksArray.get(currentBlockRow + 1).get(currentBlockCol).getType() != 0)
        {
          currentBlock.moveDown();
        }
      }
    }
          
    if(keyCode == UP)
    {
      currentBlockX = currentBlock.getX();
      currentBlockY = currentBlock.getY();
      currentBlockSize = currentBlock.getSize();
      
      currentBlockRow = currentBlockY/blockSize;
      currentBlockCol = currentBlockX/blockSize;
      
      // To avoid ArrayOutOfBound Error
      if(currentBlockRow > 0)
      {
        if(blocksArray.get(currentBlockRow - 1).get(currentBlockCol).getSize() == 0 && blocksArray.get(currentBlockRow - 1).get(currentBlockCol).getType() != 0)
        {
          currentBlock.moveUp();
        }
      }
    }
      
    if(keyCode == RIGHT)
    {
      currentBlockX = currentBlock.getX();
      currentBlockY = currentBlock.getY();
      currentBlockSize = currentBlock.getSize();
      
      currentBlockRow = currentBlockY/blockSize;
      currentBlockCol = currentBlockX/blockSize;
      
      if(currentBlockCol < gameWidth/blockSize - 1)
      {
        if(blocksArray.get(currentBlockRow).get(currentBlockCol + 1).getSize() == 0 && blocksArray.get(currentBlockRow).get(currentBlockCol + 1).getType() != 0)
        {
          currentBlock.moveRight();
        }
      }
    }
          
    if(keyCode == LEFT)
    {
      currentBlockX = currentBlock.getX();
      currentBlockY = currentBlock.getY();
      currentBlockSize = currentBlock.getSize();
      
      currentBlockRow = currentBlockY/blockSize;
      currentBlockCol = currentBlockX/blockSize;
      
      // To avoid ArrayOutOfBound Error
      if(currentBlockCol > 0)
      {
        if(blocksArray.get(currentBlockRow).get(currentBlockCol - 1).getSize() == 0 && blocksArray.get(currentBlockRow).get(currentBlockCol - 1).getType() != 0)
        {
          currentBlock.moveLeft();
        }
      }
    }
    
    if(keyCode == ENTER)
    {
      currentBlockX = currentBlock.getX();
      currentBlockY = currentBlock.getY();
      currentBlockSize = currentBlock.getSize();
      
      currentBlockRow = currentBlockY/blockSize;
      currentBlockCol = currentBlockX/blockSize;
      
      println(currentBlockRow, currentBlockCol);
      
      blocksArray.get(currentBlockRow).set(currentBlockCol, currentBlock);
      
      //Generating new moving block
      currentBlock = new Block(0, 0, blockSize);
    }
  }
}
