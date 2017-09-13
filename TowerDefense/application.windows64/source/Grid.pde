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