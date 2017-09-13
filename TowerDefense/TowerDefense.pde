PImage bg;
PImage path;
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

void setup() {
  frameRate(50);
  size(401, 801);
  initVars();
  towers = new Tower();
  towerType = -1;
}

void draw() {

  spawnEnemy();
  background(bg);
  placeLocation = grid.show(placing, level);
  showPath();
  nextEnemyMove();
  towers.show();

  stroke(255);
  fill(0, 200, 0);
  rect(275, 12.5, playerHealth/10, 25);
  textSize(25);
  fill(200);
  text("Level 1", 25, 35);
}
void mouseClicked() {
  if(!placing && mouseY > 700){
    placing = true;
    if(mouseX < 100) towerType = 0;
    else if(mouseX > 700) towerType = 3;
    else if(mouseX < 700 && mouseX > 500) towerType = 2;
    else towerType = 1;
  }else if(placing && placeLocation.x != 0) {
    towers.newTower(placeLocation);
    placing = false;
  }
}

void showPath() {
  for (int j = 0; j < 14; j++) {
    for (int i = 0; i < 8; i++) {
      if (level[j].charAt(i) == '1') {
        image(path, i*50, j*50);
      }
    }
  }
}

void nextEnemyMove() {
  for (int i = 0; i < enemies.length; i++) {
    enemies[i].Show();
    if (enemies[i].movementCount == 50 && enemies[i].y > 0) {
      enemies[i].movementCount = 0;

      enemies[i].calculateNextMove(level);
    }
    playerHealth = enemies[i].move(playerHealth);
  }
}

void spawnEnemy() {
  timer++;
  if (timer > 200) {
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

void initVars(){
  placeLocation = new PVector(0,0);
  playerHealth = 1000;
  bg = loadImage("background.png");
  path = loadImage("Path2.png");
  level = loadStrings("lvl.txt");
  ene = loadStrings("ene.txt");
  grid = new Grid();
  enemies = new Enemy[Integer.parseInt(ene[0])];
  for (int i = 0; i < enemies.length; i++) {
    print(i);
    enemies[i] = new Enemy(175, -25, 0, 0);
  }
  timer = 100;
  nextEnemy = 1;
  placing = false;
}