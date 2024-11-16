class punto{
  float x;
  float y;
  
  punto(float x,float y){
    this.x=x;
    this.y=y;
  }
  
  void dibuja(){
    fill(255);
    circle(x,y,10);
  }
}
