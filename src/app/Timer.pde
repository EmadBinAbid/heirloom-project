// Timer
class Timer
{
  float time;
  
  Timer(float time)
  {
    this.time = time;
  }
  
  void setTime(float time)
  {
    this.time = time;
  }
  
  float getTime()
  {
    return this.time;
  }
  
  void countUp()
  {
    this.time += 0.007;
  }
  
  void countDown()
  {
    this.time -= 0.007;
  }
}
