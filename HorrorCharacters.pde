class HorrorCharacters {
  float xPos, yPos, zPos, cylinderHeight, cylinderRadius, fragments, angle, beginCor, animationSpeed;
  int holeID;
  PImage horrorCharactersImage;
  boolean available, isAlive, inMotion;
  
  HorrorCharacters(float xPos, float yPos, float zPos, float cylinderHeight, float cylinderRadius, float fragments, float angle, float beginCor,  float animationSpeed, int holeID, PImage horrorCharactersImage, boolean available, boolean isAlive, boolean inMotion) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.zPos = zPos;
    this.cylinderHeight = cylinderHeight;
    this.cylinderRadius = cylinderRadius;
    this.fragments = fragments;
    this.angle = angle;
    this.beginCor = beginCor;
    this.animationSpeed = animationSpeed;
    this.holeID = holeID;
    this.horrorCharactersImage = horrorCharactersImage;
    this.available = available;
    this.isAlive = isAlive;
    this.inMotion = inMotion;
  }
}
