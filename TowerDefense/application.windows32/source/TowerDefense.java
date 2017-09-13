import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TowerDefense extends PApplet {

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

public void setup() {
  frameRate(50);
  
  initVars();
  towers = new Tower();
  towerType = -1;
  timerInc = 0;
  gold = 100;
  enemiesKilled = 0;
}

public void draw() {

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
  }else rect(275, 27.5f, playerHealth/10, 15);
  textSize(25);
  fill(200);
  text("Level 1", 25, 35);
  textSize(17.5f);
  fill(200, 200, 50);
  text("Gold:", 275, 20);
  text(gold, 345, 20);

  
  println(enemies.length);
}
public void mouseClicked() {
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

public void showPath() {
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

public void nextEnemyMove() {
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

public void spawnEnemy() {
  timer++;
  if (timer > 200 + timerInc) {
    if (timerInc > -150) timerInc -= 20;
    timer = 0;
    if (nextEnemy == 0) {
      float s = Integer.parseInt(ene[1]);
      if (s > 50) s = 3.125f;
      enemies[nextEnemy].speed = s;
      enemies[nextEnemy].health = Integer.parseInt(ene[2]);
      nextEnemy++;
    } else if (nextEnemy < enemies.length) {
      float s = Integer.parseInt(ene[nextEnemy*2]);
      if (s > 50) s = 3.125f;
      enemies[nextEnemy].speed = s;
      enemies[nextEnemy].health = Integer.parseInt(ene[nextEnemy*2 - 1]);
      nextEnemy++;
    }
  }
}

public void initVars() {
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

public class Enemy {
  float x;
  float y;
  float health;
  float speed;
  public float movementCount;
  int nextX;
  int nextY;
  int nextMove;
  int previousMove;

  public Enemy(float x, float y, float health, float speed) {
    this.x = x;
    this.y = y;
    this.health = health;
    this.speed = speed;
    movementCount = 0;
    nextX = 3;
    nextY = 0;
    nextMove = 0;
    previousMove = 0;
  }

  public int Show() {
    if (health > 0) {
      stroke(50);
      fill(200, 10, 10);
      ellipse(x, y, 35, 35);
      fill(0);
      rect(x - 25, y - 25, 50, 5);
      fill(0, 150, 0);
      rect(x - 25, y - 25, health/20, 5);
    }else if(health > - 100){
      x = -100;
      y = -100;
      health = -101;
      return 1;
    }
    return 0;
  }

  public int move(int playerHealth) {
    if (health > 0) {
      if (nextY < 14) {
        if (nextMove == 0) this.y += speed;
        else if (nextMove == 1) this.x += speed;
        else if (nextMove == -1) this.x -= speed;
        movementCount += speed;
      } else {
        playerHealth -= 3;
      }
    }
    return playerHealth;
  }

  public void calculateNextMove(String[] lvl) {
    if (health > 0) {
      for (int i = 0; i < 3; i++) {
        if (nextY < 16 && lvl[nextY+1].charAt(nextX) == '1') {
          nextMove = 0;
          nextY++;
          i = 3;
          previousMove = 0;
        } else if (previousMove != -1 && nextX!=0 && lvl[nextY].charAt(nextX-1) == '1') { 
          nextMove = -1;
          nextX--;
          i = 3;
          previousMove = 1;
        } else if (previousMove != 1 && lvl[nextY].charAt(nextX+1) == '1') { 
          nextMove = 1;
          nextX++;
          i = 3;
          previousMove = -1;
        }
      }
    }
  }
}
public class Grid {

  int[][] squares;

  public Grid() {
    squares = new int[8][16];
  }

  public PVector show(boolean placingTower, String[] lvl) {

    noFill();
    PVector ret = new PVector(0, 0);
    stroke(80, 75, 50);
    for (int i = 0; i < 8; i++) {
      for (int j = 1; j < 14; j++) {
        noFill();
        if (placingTower) {
          if (mouseX > i * 50 && mouseX < (i*50+50) && mouseY > j * 50 && mouseY < (j*50+50)) 
            if (lvl[j].charAt(i) == '0') { 
              fill(0, 155, 0);
              ret = new PVector(i*50,j*50);
            } else { 
              fill(155, 0, 0);
              
            }
          rect(i * 50, j * 50, 50, 50);
        }
      }
      
    }
    stroke(0);
    fill(255);
    rect(23, 727, 50, 50, 10);
    fill(200);
    rect(125, 727, 50, 50, 10);
    fill(100);
    rect(224, 727, 50, 50, 10);
    fill(20);
    rect(324, 727, 50, 50, 10);
    
    return ret;
    
  }
}
public class Tower {
  ArrayList<PVector> towers;

  public Tower() {
    towers = new ArrayList();
  }

  public void newTower(PVector pos) {
    towers.add(pos);
  }

  public void attackAndShow(Enemy[] enemies) {
    for (int i = 0; i < towers.size(); i++) {
      PVector g = towers.get(i);
      fill(255/(1+g.z));
      stroke(0);
      rect(g.x + 5, g.y + 5, 40, 40, 10);

      attack(enemies, g);
    }
  }

  public void attack(Enemy[] enemies, PVector g) {
    int enemy = -1;
    float dist = 0;
    if(g.z == 0) dist = 150;
    else if(g.z == 1) dist = 125;
    else if(g.z == 2) dist = 100;
    else dist = 80;
    
    for (int i = 0; i < enemies.length; i++) {
      float tDist = sqrt(pow((g.x+25) - enemies[i].x, 2) + pow((g.y+25) - enemies[i].y, 2));
      if (tDist < dist) enemy = i;
    }

    if (enemy != -1) {
      stroke(200, 30, 30);
      line(g.x+25, g.y+25, enemies[enemy].x, enemies[enemy].y);
      enemies[enemy].health -= (g.z + 1);
    }
  }
}
  public void settings() {  size(401, 801); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TowerDefense" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
