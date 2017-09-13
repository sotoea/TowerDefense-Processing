public class Tower{
  ArrayList<PVector> towers;
  
  public Tower(){
    towers = new ArrayList();
  }
  
  void newTower(PVector pos){
    towers.add(pos);
  }
  
  void show(){
    fill(200);
    for(int i = 0; i < towers.size(); i++){
      PVector g = towers.get(i);
      rect(g.x + 5, g.y + 5, 40, 40, 10);
    }
  }
}

class TowerType{
  
}