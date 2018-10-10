Agent [] agents;
ArrayList<Sem> sems; 
CollectiveMind collectiveMind;

int numAgents = 2;

int rowNum = 3;
int colNum = 2; 

void setup() {
  size(800, 800);
  sems = new ArrayList();  
  collectiveMind = new CollectiveMind();
  agents = new Agent[numAgents];

  for (int i = 0; i < agents.length; i++) {
    agents[i] = new Agent(i);
  }

  for (int j = 0; j < rowNum; j++) {
    for (int i = 0; i < colNum; i++) {
      sems.add(new Sem((width / colNum) * i + ((width/colNum)/2) + random(-((width/colNum)/3), ((width/colNum)/3)), (height / rowNum) * j + ((height / rowNum)/2) + random(-((height/rowNum)/3), ((height/rowNum)/3)), int(random(5, 8)), collectiveMind));
    }
  }
  noStroke();
  noCursor();
  colorMode(HSB);
}

void draw() { 
  background(255);  
  for (int i = 0; i < sems.size(); i++) { 
    sems.get(i).display();
  }

  for (int i = 0; i < agents.length; i++) {
    agents[i].display();
  }
}
