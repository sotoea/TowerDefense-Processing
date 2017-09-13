PImage bg;
PImage path;
PImage rock;
String[] level;
String[] ene;
Enemy[] enemies;
Grid grid;
int timer;
int nextEnemy;
int playerHealth;
boolean placing;
PVector placeLocation;
Tower towers;
int towerType;
int timerInc;
int gold;
int enemiesKilled;

void setup() {
  frameRate(50);
  size(401, 801);
  initVars();
  towers = new Tower();
  towerType = -1;
  timerInc = 0;
  gold = 100;
  enemiesKilled = 0;
}

void draw() {

  spawnEnemy();
  background(bg);
  placeLocation = grid.show(placing, level);
  showPath();
  nextEnemyMove();
  towers.attackAndShow(enemies);

  stroke(255);
  fill(0, 200, 0);
  if (playerHealth < 0) {
    textSize(75);
    fill(200, 50, 50);
    text("YOU LOSE!", 10, 300);
  } else if (enemiesKilled == enemies.length - 1) {
    textSize(75);
    fill(0, 200, 0);
    text("YOU WIN!", 30, 300);
  }else rect(275, 27.5, playerHealth/10, 15);
  textSize(25);
  fill(200);
  text("Level 1", 25, 35);
  textSize(17.5);
  fill(200, 200, 50);
  text("Gold:", 275, 20);
  text(gold, 345, 20);

  
  println(enemies.length);
}
void mouseClicked() {
  if (!placing && mouseY > 700) {
    placing = true;
    if (mouseX < 100 && gold >= 5) { 
      towerType = 0;
      gold -= 5;
    } else if (mouseX > 300 && gold >= 20) {
      towerType = 3;
      gold -= 20;
    } else if (mouseX < 300 && mouseX > 200 && gold >= 15) {
      towerType = 2;
      gold -= 15;
    } else if (mouseX < 200 && mouseX > 100 && gold >= 10) {
      towerType = 1;
      gold -= 10;
    } else placing = false;
  } else if (placing && placeLocation.x != 0) {
    PVector towerParams = new PVector(placeLocation.x, placeLocation.y, towerType);
    towers.newTower(towerParams);
    towerType = -1;
    placing = false;
  }
}

void showPath() {
  for (int j = 0; j < 14; j++) {
    for (int i = 0; i < 8; i++) {
      if (level[j].charAt(i) == '1') {
        image(path, i*50, j*50);
      } else if (level[j].charAt(i) == '2') {
        image(rock, i*50, j*50);
      }
    }
  }
}

void nextEnemyMove() {
  for (int i = 0; i < enemies.length; i++) {
    int killed = enemies[i].Show();
    enemiesKilled += killed;
    gold += 5 * killed;
    if (enemies[i].movementCount == 50 && enemies[i].y > 0) {
      enemies[i].movementCount = 0;

      enemies[i].calculateNextMove(level);
    }
    playerHealth = enemies[i].move(playerHealth);
  }
}

void spawnEnemy() {
  timer++;
  if (timer > 200 + timerInc) {
    if (timerInc > -150) timerInc -= 20;
    timer = 0;
    if (nextEnemy == 0) {
      float s = Integer.parseInt(ene[1]);
      if (s > 50) s = 3.125;
      enemies[nextEnemy].speed = s;
      enemies[nextEnemy].health = Integer.parseInt(ene[2]);
      nextEnemy++;
    } else if (nextEnemy < enemies.length) {
      float s = Integer.parseInt(ene[nextEnemy*2]);
      if (s > 50) s = 3.125;
      enemies[nextEnemy].speed = s;
      enemies[nextEnemy].health = Integer.parseInt(ene[nextEnemy*2 - 1]);
      nextEnemy++;
    }
  }
}

void initVars() {
  placeLocation = new PVector(0, 0);
  playerHealth = 1000;
  bg = loadImage("background.png");
  path = loadImage("Path2.png");
  rock = loadImage("Rock.png");
  level = loadStrings("lvl2.txt");
  ene = loadStrings("ene.txt");
  grid = new Grid();
  enemies = new Enemy[Integer.parseInt(ene[0])];
  for (int i = 0; i < enemies.length; i++) {
    print(i);
    enemies[i] = new Enemy(175, -25, 1, 0);
  }
  timer = -400;
  nextEnemy = 1;
  placing = false;
}