// Block
class Block
{
  int x;
  int y;
  int size;
  PImage image;
  int type;
  
  Block(int x, int y, int size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
    
    if((int)random(3)%3 == 0)
    {
      this.image = loadImage("../assets/images/type1.png");
      this.type = 1;
    }
    else if((int)random(3)%3 == 1)
    {
      this.image = loadImage("../assets/images/type2.png");
      this.type = 2;
    }
    else
    {
      this.image = loadImage("../assets/images/type3.png");
      this.type = 3;
    }
  }
  
  void setType(int type)
  {
    this.type = type;
    if(this.type == 0)
    {
      this.image = loadImage("../assets/images/conquered_block.png");
    }
  }
  
  int getType()
  {
    return this.type;
  }
  
  int getSize()
  {
    return this.size;
  }
  
  int getX()
  {
    return this.x;
  }
  
  int getY()
  {
    return this.y;
  }
  
  void show()
  {
    if(this.getSize() !=  0)
    {
      image(this.image, this.x, this.y);
    }
  }
  
  void moveRight()
  {
    if(x + this.size < gameWidth)
    {
      x += this.size;
    }
  }
  
  void moveLeft()
  {
    if(x > 0)
    {
      x -= this.size;
    }
  }
  
  void moveUp()
  {
    if(y > 0)
    {
      y -= this.size;
    }
  }
  
  void moveDown()
  {
    if(y + this.size < gameHeight)
    {
      y += this.size;
    }
  }
}
