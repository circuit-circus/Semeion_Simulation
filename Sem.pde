class Sem {  //<>// //<>// //<>//
  
  float radius = random(35, 65); 
  int npoints = 5;
  float posX;
  float posY;
  float angle = random(0, TWO_PI); 
  String lastSent;
  PVector[] lastAction;
  PVector[] action;
  float t = 0;
  float animationTime = 100; // Default number of frames per animation
  float brightness = 0; 
  boolean animationEnded = false;
  final float vectorScale = 22.5; //Scaled to less than 255 to allow for overshooting. Bezier curves are drawn with factor 10. 
  long lastInteraction = 0;
  Animation incomingAnimation;
  Animation currentAnimation;

  CollectiveMind mind; 

  Sem(float x_, float y_, int n_, CollectiveMind m_) {
    posX = x_; 
    posY = y_;  //<>//
    npoints = n_;  
    lastAction = new PVector[2];
    action = new PVector[2];  
    for (int i = 0; i < agents.length; i++) {
      lastAction[0] = new PVector(abs(posX - agents[i].x), abs(posY - agents[i].y));  
      action[0] = new PVector(abs(posX -agents[i].x), abs(posY - agents[i].y));
    }
    lastAction[1] = new PVector(0, 0);
    action[1] = new PVector(0, 0);
    mind = m_;
    mind.subscribe(this);
    currentAnimation = aniDark;
  } 

  void display() {
    checkEnvironment(); //Check for recent actions in the environment and set the appearance variables.  

    //Draw the shape
    float angle = TWO_PI / npoints;
    fill(0, 255, 200, brightness);
    //println(brightness);
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = posX + cos(a) * radius;
      float sy = posY + sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }

  void checkEnvironment() {
    for (int i = 0; i < agents.length; i++) {
      action[0] = new PVector(abs(posX - agents[i].x), abs(posY - agents[i].y)); //Distance between mouse and Sem
    }
    //println(action[0].mag());
    action[1] = PVector.sub(lastAction[0], action[0]);  // Movement between mouse and Sem
    //println(action[0] + " - " + lastAction[0] + " = " + action[1]);
    //println(action[1].mag());

    if (action[0].mag() < 100) {
      println("close");
      println(currentAnimation + " " + aniDark);
      if (currentAnimation == aniDark || currentAnimation == aniIdleLow) {
        changeAnimation(aniAppearHigh); //Appear to nearby agent
        println("hej");
      } else if (currentAnimation == aniIdleHigh && action[1].mag() > 0) {
        queueAnimation(aniMirror);
      }  
      if (action[0].mag() < radius-2 && currentAnimation == aniMirror) {
        changeAnimation(aniClimax);
      } else if (currentAnimation == aniClimax && action[0].mag() > radius-2 ) {
        queueAnimation(aniMirror);
      }
      if (action[1].mag() > 30 && currentAnimation != aniDark) {
        send("Chock"); //Communicate to others and hide
      }
      lastInteraction = millis();
    } else if (millis() - lastInteraction > 5000 && currentAnimation == aniIdleHigh ) {
      queueAnimation(aniDisappearFade); //Fade out
    } else {
      //Default
    }
    
    brightness = animate();

    //Save last recorded actions
    lastAction[0] = action[0].copy(); 
    lastAction[1] = action[1].copy();
  }

  void queueAnimation(Animation ani) { //Check if a new animation has been requested and queue it 
    if (currentAnimation != ani) {
      incomingAnimation = ani;
    }
  }

  void changeAnimation(Animation ani) { //Change animation with immediate effect. May cause choppyness in the animation (add lerping here).
      currentAnimation = ani;
      incomingAnimation = ani;
      t = 0;
  }
  
    void send(String str) { //Send a message to the Collective Mind
    if (lastSent != str) {
      mind.send(str);
      println("Sent: " + str);
    }
    lastSent = str;
  }

  void receive(String str) { //Receive a message from the Collective Mind
    if (str == "Chock" && currentAnimation != aniDark) {
      changeAnimation(aniDisappearHide);
    } else if (str == "Greet") {
      if (currentAnimation == aniDark) {
        if (0.5 < random(0, 1)) {
          queueAnimation(aniRandomPause);
        }
      }
    }
  }

  float animate() {
    float b;
    
    if (currentAnimation.hasEnded()) {
      if(!currentAnimation.isCycling()){
        currentAnimation = currentAnimation.getNext();
      }
    }
    
    b = currentAnimation.animate() * vectorScale; //<>//
    
    return b;
  }

}
