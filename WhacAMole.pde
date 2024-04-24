ArrayList<Holes> holes = new ArrayList<Holes>(); ArrayList<HorrorCharacters> horrorCharacters = new ArrayList<HorrorCharacters>();
PImage backImage, selectionCursor, hammerCursor, cloud;
int totalScore = 0, x_value = 0, difficultyLevel;
float camX = 0, camY = 0, rotX = 0, rotY = 0, lastX, distX, lastY, distY, startingTime, remainingTime, gameDuration;
boolean inMotion = false, gameStart = false, hoverEffect = false, switchAnimation = false;

void setup() {
  fullScreen(P3D);
  frameRate(144);
  backImage = loadImage("Images/Background/Background.png");
  selectionCursor = loadImage("Images/Cursor/SelectionCursor.png");
  hammerCursor = loadImage("Images/Cursor/HammerCursor.png");
  cloud = loadImage("Images/Animation/Cloud.png");
  noStroke();
  textureMode(NORMAL);
  assignHoles();
}

void draw() {
  if(!gameStart) setGameDifficulty(); else startGame();
}

void assignHoles() {
  holes.add(new Holes(displayWidth / 3.62264, displayHeight / 1.51571, 1, true));
  holes.add(new Holes(displayWidth / 1.93939, displayHeight / 1.51571, 2, true));
  holes.add(new Holes(displayWidth / 1.32413, displayHeight / 1.51571, 3, true));
  holes.add(new Holes(displayWidth / 3.84, displayHeight / 1.07171, 4, true));
  holes.add(new Holes(displayWidth / 1.92, displayHeight / 1.06633, 5, true));
  holes.add(new Holes(displayWidth / 1.28, displayHeight / 1.07171, 6, true));
  holes.add(new Holes(displayWidth / 3.84, displayHeight / 0.81615, 7, true));
  holes.add(new Holes(displayWidth / 1.92, displayHeight / 0.81615, 8, true));
  holes.add(new Holes(displayWidth / 1.28, displayHeight / 0.81615, 9, true));
}

void assignHorrorCharacters(int difficultyLevel) {
  String[] horrorCharactersNames = new String[9];
  for(int i = 0; i < 9; i++) horrorCharactersNames[i] = "Images/HorrorCharacters/Character" + "0" + str(i + 1) + ".png";
  switch(difficultyLevel) {
  case 1:
    for(int i = 0; i < 9; i++) horrorCharacters.add(new HorrorCharacters(holes.get(i).xPos, holes.get(i).yPos, 0, 250, 75, 40, 9, 0, random(1, 3), i + 1, loadImage(horrorCharactersNames[i]), true, true, false));
    break;
  case 2:
    for(int i = 0; i < 9; i++) horrorCharacters.add(new HorrorCharacters(holes.get(i).xPos, holes.get(i).yPos, 0, 250, 75, 40, 9, 0, random(3, 5), i + 1, loadImage(horrorCharactersNames[i]), true, true, false));
    break;
  case 3:
    for(int i = 0; i < 9; i++) horrorCharacters.add(new HorrorCharacters(holes.get(i).xPos, holes.get(i).yPos, 0, 250, 75, 40, 9, 0, random(5, 6.5), i + 1, loadImage(horrorCharactersNames[i]), true, true, false));
    break;
  }
}

void setGameDifficulty() {
  background(lerpColor(color(135, 206, 235), color(255), 0.5));
  cursor(selectionCursor);
  textAlign(CENTER);
  showMenu();
}

void showMenu() {
  cloudAnimation();
  mouseControl();
}

void cloudAnimation() {
  int cloudX = 20;
  pushMatrix();
  if(x_value <= displayWidth / 6 && !switchAnimation) { translate(x_value, 0); x_value++; }
  else { switchAnimation = true; translate(x_value, 0); x_value--; if(x_value < displayWidth / 100) switchAnimation = false; }
  for(int i = 0; i < 4; i++) { for(int j = 0; j < 2; j++) { image(cloud, cloudX, j * 100 + 20, 100, 100); cloudX += 100; } cloudX += 100; }
  popMatrix();
}

void mouseControl() {
  mouseOver();
  mouseOut();
}

void startGame() {
  camera(width / 2 + camX, 2 * height + camY, (height / 2) / tan((PI * 60) / 360), width / 2, height / 2, 0, 0, 1, 0);
  background(lerpColor(color(135, 206, 235), color(255), 0.5));
  cursor(hammerCursor);
  rotationControls();
  image(backImage, -1 * displayWidth / 76.8, -1 * displayHeight / 106.1, 1.04 * displayWidth, 1.5 * displayHeight);
  remainingTimeUpdate();
  printText();
  if(!inMotion) { drawImage(); availabilityReset(); randomEffect(); } else characterAnimation();
  inMotionCheck();
}

void rotationControls() {
  if(keyPressed) { if(keyCode == UP) camY += 4; else if(keyCode == DOWN) camY -= 4; else if(keyCode == LEFT) camX += 4; else if(keyCode == RIGHT) camX -= 4; }
  if (mousePressed && (mouseButton == RIGHT)) { rotateX(rotX + distY); rotateY(rotY + distX); }
}

void drawImage() {
    for(int i = 0; i < (int)random(1, horrorCharacters.size()); i++) {
    int random = (int)random(9);
    if(horrorCharacters.get(random).available && holes.get(random).available && horrorCharacters.get(random).isAlive) {
    drawHorrorCharacter(random);
    inMotion = true;
    horrorCharacters.get(random).inMotion = true;
    horrorCharacters.get(random).available = false;
    for(int j = 0; j < horrorCharacters.size(); j++) if(horrorCharacters.get(random).xPos == holes.get(random).xPos && horrorCharacters.get(random).yPos == holes.get(random).yPos) holes.get(random).available = false;
    }
  }
}

void drawHorrorCharacter(int random) {
  pushMatrix();
  translate(horrorCharacters.get(random).xPos, horrorCharacters.get(random).yPos, horrorCharacters.get(random).zPos);
  rotateX(radians(270));
  rotateY(HALF_PI);
  beginShape(QUADS);
  texture(horrorCharacters.get(random).horrorCharactersImage);
  for (int i = ((int)horrorCharacters.get(random).fragments) - 1; i >= 0; i--) {
    vertex(horrorCharacters.get(random).cylinderRadius * cos(radians((i + 1) * horrorCharacters.get(random).angle)), 0, horrorCharacters.get(random).cylinderRadius * sin(radians((i + 1) * horrorCharacters.get(random).angle)), horrorCharacters.get(random).beginCor, 0);
    vertex(horrorCharacters.get(random).cylinderRadius * cos(radians(i * horrorCharacters.get(random).angle)), 0, horrorCharacters.get(random).cylinderRadius * sin(radians(i * horrorCharacters.get(random).angle)), horrorCharacters.get(random).beginCor + (1 / horrorCharacters.get(random).fragments), 0);
    vertex(horrorCharacters.get(random).cylinderRadius * cos(radians(i * horrorCharacters.get(random).angle)), horrorCharacters.get(random).cylinderHeight, horrorCharacters.get(random).cylinderRadius * sin(radians(i * horrorCharacters.get(random).angle)), horrorCharacters.get(random).beginCor + (1 / horrorCharacters.get(random).fragments), 1);
    vertex(horrorCharacters.get(random).cylinderRadius * cos(radians((i + 1) * horrorCharacters.get(random).angle)), horrorCharacters.get(random).cylinderHeight, horrorCharacters.get(random).cylinderRadius * sin(radians((i + 1) * horrorCharacters.get(random).angle)), horrorCharacters.get(random).beginCor, 1);
    horrorCharacters.get(random).beginCor += (1 / horrorCharacters.get(random).fragments);
   }
  horrorCharacters.get(random).beginCor = 0;
  endShape();
  popMatrix();
}

void characterAnimation() {
  for(int i = 0; i < horrorCharacters.size(); i++) {
    if(horrorCharacters.get(i).inMotion && horrorCharacters.get(i).isAlive) {
      horrorCharacters.get(i).zPos += horrorCharacters.get(i).animationSpeed;
      drawHorrorCharacter(i);
      if(horrorCharacters.get(i).zPos >= 250) horrorCharacters.get(i).animationSpeed *= -1;
      else if(horrorCharacters.get(i).zPos <= 0) horrorCharacters.get(i).inMotion = false;
      }
   }
}

void randomEffect() {
  for(int i = 0; i < horrorCharacters.size(); i++) {
    int random = (int)random(9);
    while(!holes.get(random).available) random = (int)random(9);
    horrorCharacters.get(i).xPos = holes.get(random).xPos;
    horrorCharacters.get(i).yPos = holes.get(random).yPos;
    holes.get(random).available = false;
  }
  availabilityReset();
}    

void availabilityReset() {
  for(int i = 0; i < horrorCharacters.size(); i++) {
    horrorCharacters.get(i).available = true;
    holes.get(i).available = true;
  }
}

void inMotionCheck() {
  int counter = 0;
  for(int i = 0; i < horrorCharacters.size(); i++) if(horrorCharacters.get(i).inMotion == false) counter++;
  if(counter == horrorCharacters.size()) { inMotion = false; randomAnimationSpeed(); }
}

void randomAnimationSpeed() {
  if(difficultyLevel == 1) for(int i = 0; i < horrorCharacters.size(); i++) horrorCharacters.get(i).animationSpeed = random(1, 3);
  if(difficultyLevel == 2) for(int i = 0; i < horrorCharacters.size(); i++) horrorCharacters.get(i).animationSpeed = random(3, 5);
  if(difficultyLevel == 3) for(int i = 0; i < horrorCharacters.size(); i++) horrorCharacters.get(i).animationSpeed = random(5, 6.5);
}

void killCharacters() {
  setHoleID();
  for(int i = 0; i < horrorCharacters.size(); i++) {
    if(horrorCharacters.get(i).inMotion) {
      switch(horrorCharacters.get(i).holeID) {
  case 1: 
    if(mouseX >= displayWidth * 0.3374816983 && mouseX <= displayWidth * 0.3945827232 && mouseY <= displayHeight * 0.5527369826 && mouseY >= displayHeight * 0.4112149532) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(0).available = true; totalScore++; }
    break;
  case 2: 
    if(mouseX >= displayWidth * 0.4765739385 && mouseX <= displayWidth * 0.5307467057 && mouseY <= displayHeight * 0.5527369826 && mouseY >= displayHeight * 0.4112149532) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(1).available = true; totalScore++; }
    break;
  case 3: 
    if(mouseX >= displayWidth * 0.6156661786 && mouseX <= displayWidth * 0.6756954612 && mouseY <= displayHeight * 0.5527369826 && mouseY >= displayHeight * 0.4112149532) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(2).available = true; totalScore++; }
    break;
  case 4: 
    if(mouseX >= displayWidth * 0.3060029282 && mouseX <= displayWidth * 0.3784773060 && mouseY <= displayHeight * 0.6568758344 && mouseY >= displayHeight * 0.5153538050) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(3).available = true; totalScore++; }
    break;
  case 5: 
    if(mouseX >= displayWidth * 0.4692532942 && mouseX <= displayWidth * 0.5461200585 && mouseY <= displayHeight * 0.6568758344 && mouseY >= displayHeight * 0.5153538050) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(4).available = true; totalScore++; }
    break;
  case 6: 
    if(mouseX >= displayWidth * 0.6442166910 && mouseX <= displayWidth * 0.7159590043 && mouseY <= displayHeight * 0.6568758344 && mouseY >= displayHeight * 0.5153538050) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(5).available = true; totalScore++; }
    break;
  case 7: 
    if(mouseX >= displayWidth * 0.2532942898 && mouseX <= displayWidth * 0.3448023426 && mouseY <= displayHeight * 0.8210947930 && mouseY >= displayHeight * 0.6795727636) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(6).available = true; totalScore++; }
    break;
  case 8: 
    if(mouseX >= displayWidth * 0.4685212298 && mouseX <= displayWidth * 0.5571010248 && mouseY <= displayHeight * 0.8210947930 && mouseY >= displayHeight * 0.6795727636) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(7).available = true; totalScore++; }
    break;
  case 9: 
    if(mouseX >= displayWidth * 0.6837481698 && mouseX <= displayWidth * 0.7715959004 && mouseY <= displayHeight * 0.8210947930 && mouseY >= displayHeight * 0.6795727636) { horrorCharacters.get(i).isAlive = false; horrorCharacters.get(i).inMotion = false; holes.get(8).available = true; totalScore++; }
    break;
  }
    }
  }
}

void setHoleID() {
  for(int i = 0; i < horrorCharacters.size(); i++) {
    if(horrorCharacters.get(i).inMotion) {
      for(int j = 0; j < horrorCharacters.size(); j++) if(horrorCharacters.get(i).xPos == holes.get(j).xPos && horrorCharacters.get(i).yPos == holes.get(j).yPos) horrorCharacters.get(i).holeID = holes.get(j).holeID;
    }
  }
}

void printText() {
  fill(0, 0, 255);
  textSize(54);
  text("Total Score: " + totalScore + "/" + 9 , displayWidth / 5.1, displayHeight, 340);
  text("Remaining Time: " + remainingTime, displayWidth / 1.9, displayHeight, 340);
    if (totalScore == 9) {
      fill(0, 125, 0);
      textSize(200);
      text("Well Done!", displayWidth / 3.5, displayHeight, 70);
      noLoop();
    }
    if (millis() >= (gameDuration + startingTime) * 1000) {
      fill(255, 0, 0);
      textSize(200);
      text("Game Over", displayWidth / 3.3, displayHeight, 55);
      noLoop();
    }
}

void mouseClicked() {
  if(gameStart && mouseButton == LEFT) killCharacters();
}

void remainingTimeUpdate() {
  remainingTime = (gameDuration + startingTime) - millis() / 1000;
}

void mousePressed() {
  if(!gameStart) {
    if(mouseX > displayWidth * 0.45095 && mouseX < displayWidth * 0.55197 && mouseY > displayHeight * 0.34178 && mouseY < displayHeight * 0.43257) { difficultyLevel = 1; assignHorrorCharacters(difficultyLevel); gameStart = true; gameDuration = 60;  startingTime = millis() / 1000; textAlign(BASELINE); }
    if(mouseX > displayWidth * 0.40995 && mouseX < displayWidth * 0.58931 && mouseY > displayHeight * 0.43925 && mouseY < displayHeight * 0.51401) { difficultyLevel = 2; assignHorrorCharacters(difficultyLevel); gameStart = true; gameDuration = 30;  startingTime = millis() / 1000; textAlign(BASELINE); }
    if(mouseX > displayWidth * 0.44729 && mouseX < displayWidth * 0.55270 && mouseY > displayHeight * 0.54072 && mouseY < displayHeight * 0.61548) { difficultyLevel = 3; assignHorrorCharacters(difficultyLevel); gameStart = true; gameDuration = 15;  startingTime = millis() / 1000; textAlign(BASELINE); }
  }
  else { lastX = mouseX; lastY = mouseY; }
}

void mouseDragged() {
  if(gameStart) { distX = radians(mouseX - lastX); distY = radians(lastY - mouseY); }
}

void mouseReleased() {
  if(gameStart) { rotX += distY; rotY += distX; distX = distY = 0; }
}

void mouseOver() {
   if(mouseX > displayWidth * 0.45095 && mouseX < displayWidth * 0.55197 && mouseY > displayHeight * 0.34178 && mouseY < displayHeight * 0.43257) {
    hoverEffect = true;
    textSize(displayHeight / 8);
    fill(0, 225, 0);
    text("Easy", displayWidth / 2, displayHeight / 2 - displayHeight / 10);
   }
   if(mouseX > displayWidth * 0.40995 && mouseX < displayWidth * 0.58931 && mouseY > displayHeight * 0.43925 && mouseY < displayHeight * 0.51401) {
    hoverEffect = true;
    textSize(displayHeight / 8);
    fill(0, 225, 0);
    text("Medium", displayWidth / 2, displayHeight / 2);
  }
  if(mouseX > displayWidth * 0.44729 && mouseX < displayWidth * 0.55270 && mouseY > displayHeight * 0.54072 && mouseY < displayHeight * 0.61548) {
    hoverEffect = true;
    textSize(displayHeight / 8);
    fill(0, 225, 0);
    text("Hard", displayWidth / 2, displayHeight / 2 + displayHeight / 10);
  }
}

void mouseOut() { 
  if(!hoverEffect) {
   if(mouseX <= displayWidth * 0.45095 || mouseX >= displayWidth * 0.55197 || mouseY <= displayHeight * 0.34178 || mouseY >= displayHeight * 0.43257) {
    textSize(displayHeight / 10);
    fill(0);
    text("Easy", displayWidth / 2, displayHeight / 2 - displayHeight / 10);
  }
   if(mouseX <= displayWidth * 0.40995 || mouseX >= 0.58931 || mouseY <= displayHeight * 0.43925 || mouseY >= 385) {
    textSize(displayHeight / 10);
    fill(0);
    text("Medium", displayWidth / 2, displayHeight / 2);
  }
   if (mouseX <= displayWidth * 0.44729 || mouseX >= displayWidth * 0.55270 || mouseY <= displayHeight * 0.54072 || mouseY >= displayHeight * 0.61548) {
    textSize(displayHeight / 10);
    fill(0);
    text("Hard", displayWidth / 2, displayHeight / 2 + displayHeight / 10);
    }
  }
  if(hoverEffect) {
    if (mouseX <= displayWidth * 0.40629 || mouseX >= displayWidth * 0.59663 || mouseY <= displayHeight * 0.26702 || mouseY >= displayHeight * 0.43524) {
     hoverEffect = false;
     textSize(displayHeight / 10);
     fill(0);
     text("Easy", displayWidth / 2, displayHeight / 2 - displayHeight / 10);
  }
   if(mouseX <= displayWidth * 0.36530 || mouseX >= displayWidth * 0.63396 || mouseY <= displayHeight * 0.43925 || mouseY >= displayHeight * 0.53671) {
     hoverEffect = false;
     textSize(displayHeight / 10);
     fill(0);
     text("Medium", displayWidth / 2, displayHeight / 2);
  }
   if (mouseX <= displayWidth * 0.41361 || mouseX >= displayWidth * 0.59736 || mouseY <= displayHeight * 0.54072 || mouseY >= displayHeight * 0.69292) {
     hoverEffect = false;
     textSize(displayHeight / 10);
     fill(0);
     text("Hard", displayWidth / 2, displayHeight / 2 + displayHeight / 10);
    }
  }
}

void keyReleased() {
  if(gameStart) { camX = camY = 0; }
}
