public class Enemy {
  float x;
  float y;
  int health;
  float speed;
  public float movementCount;
  int nextX;
  int nextY;
  int nextMove;
  int previousMove;

  public Enemy(float x, float y, int health, float speed) {
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

  public void Show() {
    stroke(50);
    fill(200, 10, 10);
    ellipse(x, y, 35, 35);
    fill(0);
    rect(x - 25, y - 25, 50, 5);
    fill(0, 150, 0);
    rect(x - 25, y - 25, health/2, 5);
  }

  public int move(int playerHealth) {
    if (nextY < 14) {
      if (nextMove == 0) this.y += speed;
      else if (nextMove == 1) this.x += speed;
      else if (nextMove == -1) this.x -= speed;
      movementCount += speed;
    } else {
      playerHealth -= 1;
    }
    
    return playerHealth;
  }

  public void calculateNextMove(String[] lvl) {

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