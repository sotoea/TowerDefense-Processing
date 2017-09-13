public class Tower {
  ArrayList<PVector> towers;

  public Tower() {
    towers = new ArrayList();
  }

  void newTower(PVector pos) {
    towers.add(pos);
  }

  void attackAndShow(Enemy[] enemies) {
    for (int i = 0; i < towers.size(); i++) {
      PVector g = towers.get(i);
      fill(255/(1+g.z));
      stroke(0);
      rect(g.x + 5, g.y + 5, 40, 40, 10);

      attack(enemies, g);
    }
  }

  void attack(Enemy[] enemies, PVector g) {
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