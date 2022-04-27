final int SIZE_WIDTH = 500;
final int SIZE_HEIGHT = 500;
final int PLAYER_XPOS_STARTING_POINT = 25; //starting point of player
final int PLAYER_TIP_OFFSET_X_POSITION = 50; //offset for tip of triangle xPos
final int PLAYER_TIP_OFFSET_Y_POSITION = 50; //offset for tip of triangle yPos
float personY; //person movement
final int SIZE_OF_MOON = 100; //moon size
final int STARTING_X_POS_OF_MOON = SIZE_WIDTH - SIZE_OF_MOON/2;
float [] moonXs; //moons x locations
float [] moonYs; //moons y locations
float [] moonSpeed; // varying moon speed
final float MIN_MOON_SPEED = 0.2;
final float MAX_MOON_SPEED = 1;
float projectileX; //projectile being shot
final float PROJECTILE_X_OFFSET = 70;
final float PROJECTILE_Y_OFFSET = 50;
float projectileY; //projectile movement with person
final int SIZE_OF_PROJECTILE = 10; //projectile size
boolean isFired = false; //DID I SHOOT YET?
int stageLevel = 3; //stage level of game //REMEMBER STARTS AT 3 ENDS AT 6
boolean [] isMoonDed; //IS MOON DINKED YET?
boolean isPlayerDed = false; //is player ded?
int numOfStars = 100; //number of stars in the background
float [] xPosStarArray; //stars x Locations
float [] yPosStarArray; //stars y Locations
float [] speedOfStarArray; //stars speed
final int MIN_STAR_SPEED = 1;
final int MAX_STAR_SPEED = 5;
float [] sizeOfStar; //stars size
final int MIN_STAR_SIZE = 1;
final int MAX_STAR_SIZE = 15;
float [] colourOfStar; //slight changes in star colour
final int MIN_COLOUR_RANGE = 150;
final int MAX_COLOUR_RANGE = 255;
int winConditionStage = 7; //when to end level

void setup() {
  size (500, 500);
  levelSetup();
  starBackgroundSetup();
}

void drawPlayer(float x, float y) {
  int yOffsetTopPoint = 25;
  int yOffsetBottomPoint = 75;
  noStroke();
  fill(255);
  triangle(x, yOffsetTopPoint + y, x, yOffsetBottomPoint + y, PLAYER_TIP_OFFSET_X_POSITION + x, PLAYER_TIP_OFFSET_Y_POSITION + y);
}

void drawMoon(float x, float y) {
  strokeWeight(3);
  stroke(255, 0, 0);
  fill(#D32222);
  circle(STARTING_X_POS_OF_MOON - x, y, SIZE_OF_MOON);
}

void drawProjectile(float x, float y) {
  noStroke();
  fill(#C95EE8); 
  circle(PLAYER_TIP_OFFSET_X_POSITION + x, PLAYER_TIP_OFFSET_Y_POSITION + y, SIZE_OF_PROJECTILE);
}

void movePlayer() {
  if (keyPressed) {
    if (key == 's' || key == 'S') {
      if (personY + 125 < SIZE_HEIGHT) {
        personY += 50;
      }
    } else if (key == 'w' || key =='W') {
      if (personY > 25) {
        personY -= 50;
      }
    }
  }
}

void shootProjectile() {
  if (keyPressed) {
    if (key == ' ') {
      isFired = true;
    }
  }
}

//projectile touches moon
void collisionProjectile() {
  for (int i = 0; i < stageLevel; i ++) {
    float x = PROJECTILE_X_OFFSET + projectileX;
    float y = PROJECTILE_Y_OFFSET + projectileY;
    float z = dist(x, y, (STARTING_X_POS_OF_MOON - moonXs[i]), moonYs[i]); //distance between projectile and moons
    if (z <= (SIZE_OF_PROJECTILE / 2 + SIZE_OF_MOON / 2) && isFired == true) {
      //YEET MOON OUTTA HERE AND MAKE IT DED
      isMoonDed[i] = true;
      moonXs[i] = -(SIZE_WIDTH * SIZE_WIDTH);
      //reset projectile
      isFired = false;
      projectileX = 0;
    }
  }
}

//moon touches player
void collisionPlayer() { 
  for (int i = 0; i < stageLevel; i ++) {
    float x = PLAYER_XPOS_STARTING_POINT + PLAYER_TIP_OFFSET_X_POSITION;
    float y = personY + PLAYER_TIP_OFFSET_Y_POSITION;
    float z = dist(x, y, (STARTING_X_POS_OF_MOON - moonXs[i]), moonYs[i]); //distance between player and moons
    if (z <= (SIZE_OF_PROJECTILE / 2 + SIZE_OF_MOON / 2)) {
      isPlayerDed = true;
    }
  }
}

void updateProjectile() {
  if (isFired == false) {
    projectileY = personY;
  }
  if (isFired == true) {
    projectileX += 5;
  }
  if ((PROJECTILE_X_OFFSET + projectileX) >= SIZE_WIDTH) { //reset projectile if it missed
    isFired = false;
    projectileX = 0;
    projectileY = personY;
  }
}

void levelSetup() {
  moonXs = new float[stageLevel];
  moonYs = new float[stageLevel];
  moonSpeed = new float[stageLevel];
  isMoonDed = new boolean[stageLevel];
  for (int i = 0; i < stageLevel; i ++) {
    moonSpeed[i] = random(MIN_MOON_SPEED, MAX_MOON_SPEED);
    moonYs[i] = random(SIZE_OF_MOON / 2, SIZE_HEIGHT - SIZE_OF_MOON / 2);
    isMoonDed[i] = false;
    moonXs[i] = 0;
  }
}

void drawMoons() {
  for (int i = 0; i < stageLevel; i ++) {
    if (isMoonDed[i] == false && isPlayerDed == false) {
      drawMoon(moonXs[i], moonYs[i]);
    }
  }
}

void moveMoons() {
  for (int i = 0; i < stageLevel; i ++) {
    if (moonXs[i] <= SIZE_WIDTH) {
      moonXs[i] += moonSpeed[i];
    }
  }
}

void starBackgroundSetup() {
  xPosStarArray = new float[numOfStars];
  yPosStarArray = new float[numOfStars];
  speedOfStarArray = new float[numOfStars];
  sizeOfStar = new float[numOfStars];
  colourOfStar = new float[numOfStars];
  for (int i = 0; i < numOfStars; i ++) {
    xPosStarArray[i] = random(0, SIZE_WIDTH);
    yPosStarArray[i] = random(0, SIZE_HEIGHT);
    speedOfStarArray[i] = random(MIN_STAR_SPEED, MAX_STAR_SPEED);
    sizeOfStar[i] = random(MIN_STAR_SIZE, MAX_STAR_SIZE);
    colourOfStar[i] = random(MIN_COLOUR_RANGE, MAX_COLOUR_RANGE);
  }
}

void drawStars() {
  for (int i = 0; i < numOfStars; i ++) {
    noStroke();
    fill(colourOfStar[i]);
    circle(xPosStarArray[i], yPosStarArray[i], sizeOfStar[i]);
  }
}

void moveStars() {
  for (int i = 0; i < numOfStars; i ++) {
    xPosStarArray[i] -= speedOfStarArray[i];
    if (xPosStarArray[i] <= 0) {
      xPosStarArray[i] = SIZE_WIDTH;
    }
  }
}

void winGame() {
  textSize(64);
  textAlign(CENTER, CENTER);
  fill(255);
  text("You Win!", width/2, height/2); 
  for (int i = 0; i < stageLevel; i ++) {
    moonXs[i] = -(SIZE_WIDTH * SIZE_WIDTH);
  }
}

void winGameConditions() {
  if (stageLevel == winConditionStage) {
    winGame();
  }
}

void printLoseGame() {
  textSize(64); 
  textAlign(CENTER, CENTER); 
  fill(255); 
  text("You Lose!", width/2, height/2);
}

void loseGameConditions() {
  if (isPlayerDed == true) {
    printLoseGame();
  }
  for (int i = 0; i < stageLevel; i ++) {
    if (moonXs[i] >= SIZE_WIDTH - SIZE_OF_MOON && isMoonDed[i] == false) {
      isPlayerDed = true;
    }
  }
}

void updateStage() {
  boolean stageFinished = true; //stage level completed
  for (int i = 0; i < stageLevel; i++) {
    if (isMoonDed[i] == false) {
      stageFinished = false;
    }
  }
  if (stageFinished == true) {
      stageLevel++;
      levelSetup();
    }
}

void draw() {
  background(0); 
  drawStars(); 
  moveStars(); 
  updateProjectile(); 
  shootProjectile(); 
  drawMoons();
  moveMoons(); 
  collisionProjectile(); 
  collisionPlayer(); 
  drawPlayer(PLAYER_XPOS_STARTING_POINT, personY); 
  drawProjectile(PLAYER_XPOS_STARTING_POINT + projectileX, projectileY); 
  updateStage();
  winGameConditions();
  loseGameConditions();
}

void keyPressed() {
  movePlayer();
}
