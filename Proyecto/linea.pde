class linea{
  punto A;
  punto B;
  
  linea(punto A,punto B){
    this.A=A;
    this.B=B;
  }
  
  void dibuja(){
    stroke(random(255),random(255),random(255));
    line(A.x,A.y,B.x,B.y);
  }
}
