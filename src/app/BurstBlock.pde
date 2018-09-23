// BurstBlock
class BurstBlock extends Block
{
  // Speed
  int speedX;
  int speedY;
    
  BurstBlock(int x, int y, int size)
  {
    super(x, y, size);
    if((int)random(10)%5 == 0)
    {
      speedX = 2;
      speedY = 10;
    }
    else if((int)random(10)%5 == 1)
    {
      speedX = -2;
      speedY = 8;
    }
    else if((int)random(10)%5 == 2)
    {
      speedX = 3;
      speedY = 5;
    }
    else if((int)random(10)%5 == 3)
    {
      speedX = -3;
      speedY = 6;
    }
    else
    {
      speedX = 4;
      speedY = 9;
    }
  }
  
  void fall()
  {
    this.y += speedY;
    this.x += speedX;
  }
  
  void setType(int type)
  {
    this.type = type;
    if(this.type == 1)
    {
      this.image = loadImage("../assets/images/type1.png");
    }
    
    if(this.type == 2)
    {
      this.image = loadImage("../assets/images/type2.png");
    }
    
    if(this.type == 3)
    {
      this.image = loadImage("../assets/images/type3.png");
    }
  }
}
