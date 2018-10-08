ArrayList<Sem> sems; 
int numSems = 10; 

void setup() {
  size(800, 800);
  sems = new ArrayList();  //<>// //<>//
  for (int i = 0; i < numSems; i++) {
    sems.add(new Sem(int(random(0, 800)), int(random(0, 800)), int(random(0, TWO_PI)), int(random(3, 8))));  //<>// //<>//
  }
  noStroke();
  colorMode(HSB);
}
 //<>//
void draw() { 
  background(255);  //<>// //<>//
  for (int i = 0; i < sems.size(); i++) { 
    sems.get(i).display(); 
  }
}
