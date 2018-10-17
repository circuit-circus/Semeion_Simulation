Agent [] agents;
ArrayList<Sem> sems; 
CollectiveMind collectiveMind;

int numAgents = 1;

int rowNum = 3;
int colNum = 2; 

//Predefined animations 
Animation aniDark;
Animation aniIdleHigh;
Animation aniAppearHigh;
Animation aniMirror;
Animation aniIdleLow; 
Animation aniClimax;
Animation aniDisappearFade;
Animation aniDisappearHide; 
Animation aniAppearLow;
Animation aniRandomPause;
Animation aniStimulation; 

void setup() {
  size(800, 800);
  sems = new ArrayList();  
  collectiveMind = new CollectiveMind();
  agents = new Agent[numAgents];
  initializeAnimations();

  for (int i = 0; i < agents.length; i++) {
    agents[i] = new Agent(i);
  }

  for (int j = 0; j < rowNum; j++) {
    for (int i = 0; i < colNum; i++) {
      sems.add(new Sem((width / colNum) * i + ((width/colNum)/2) + random(-((width/colNum)/3), ((width/colNum)/3)), (height / rowNum) * j + ((height / rowNum)/2) + random(-((height/rowNum)/3), ((height/rowNum)/3)), int(random(5, 8)), collectiveMind));
    }
  }
  strokeWeight(5);
  stroke(150);
  noCursor();
  //colorMode(HSB);
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

void initializeAnimations() {
  
  //Default animations 
  aniDark = new Animation(0,0,0,0,100);   
  aniIdleHigh = new Animation(8, 8, 12.3, 8, 70); 
  aniAppearHigh = new Animation(0, 8.5, 12.3, 8, 50, aniIdleHigh);
  aniIdleLow = new Animation(3, 3, 7, 3, 100);
  aniClimax = new Animation(8, 9, 13, 8, 20);
  aniDisappearFade = new Animation(10, 10, 0, 0, 100, aniDark);
  aniDisappearHide = new Animation(4, 4, 0, 0, 30, aniDark);
  aniAppearLow = new Animation(0, 3, 3, 3, 100, aniIdleLow);
  aniRandomPause = new Animation(0, 0, 0, 0, round(random(0,100)));
  //aniStimulation = new Animation();
  //aniMirror = new Animation();  
  
  //Initialize animation sequences and single curve animations here. 
  //First parameter of the Animation constructor is an ArrayList<float[]>. The float arrays should contain 5 parameters: x1, x1 control, y2 control, y2, duration.
}
