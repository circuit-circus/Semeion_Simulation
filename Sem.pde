class Sem {

  int radius = 50; 
  int npoints = 5;
  int posX;
  int posY;
  int angle;
  PVector[] lastAction;
  PVector[] action;
  int animationState = 0;
  float t = 0;
  float brightness = 0; 
  boolean animationEnded = false;
  final float vectorScale = 25.5;
  long lastInteraction = 0;
  int incomingAnimation;

  CollectiveMind mind; 

  Sem(int x_, int y_, int ang_, int n_, CollectiveMind m_) {
    posX = x_;
    posY = y_;
    npoints = n_;  //<>//
    angle = ang_; 
    lastAction = new PVector[2];
    action = new PVector[2];  
    lastAction[0] = new PVector(abs(posX - mouseX), abs(posY - mouseY));  
    action[0] = new PVector(abs(posX - mouseX), abs(posY - mouseY)); 
    lastAction[1] = new PVector(0, 0);
    action[1] = new PVector(0, 0);
    mind = m_;
    mind.subscribe(this);
  } 

  void display() {
    checkEnvironment(); //Check for recent actions in the environment and set the appearance variables.  

    //Draw the shape
    float angle = TWO_PI / npoints;
    fill(220, 150, brightness);
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
    lastAction = action;
    action[0] = new PVector(abs(posX - mouseX), abs(posY - mouseY)); //Distance between mouse and Sem
    //println(action[0].mag());
    //action[1] = action[0].sub(lastAction[0]);  // Movement between mouse and Sem

    if (action[0].mag() < 100) {
      if (animationState == 0) {
        setAnimation(1);
      }
      lastInteraction = millis();
    } else if (action[1].mag() > 200) {
      //Communicate to others and hide
    } else if (millis() - lastInteraction > 5000 && animationState == 2) {
      setAnimation(5);
    } else {
      //Default
      setAnimation(-1);
    }
    
    animate();
  }
  
  void setAnimation(int animationID){
    
    //Check if a new animation has been requested and queue it
    if (animationID != -1 && animationState != animationID) {
      incomingAnimation = animationID;
    }

  } //<>//

  void animate() {
    float b = 0;
    
    //When the current animation ends load the waiting animation
    if (incomingAnimation != animationState && animationEnded) { 
      animationState = incomingAnimation; 
    }

    switch(animationState) {
    case 0: 
      //No animation
      println("No animation");
      b = bezierPoint(0, 0, 0, 0, t);
      break; 
    case 1:  
      // Appear 
      println("Appearing");
      b = bezierPoint(0, 4.5, 0, 10, t); 
      if (animationEnded) {
        incomingAnimation = 2;
      }
      break;
    case 2: 
      // Looking around
      println("Looking around");
      b = bezierPoint(10, 10, 0, 10, t);
      break;
    case 3: 
      // Mirror
      break;
    case 4: 
      // Ecstasy
      break;
    case 5: 
      // Disappear, fade
      println("Disappearing, fading");
      b = bezierPoint(10, 10, 0, 0, t);
      if (animationEnded) {
        //println("Starting animation: No animation");
        incomingAnimation = 0;
      }
      break;
    case 6: 
      // Disappear, hide
      break;
    case 7: 
      // Enthusiasm
      break;
    default: 
      // No animation
      break;
    }

    t += 0.01;   
    animationEnded = false;

    if (t > 1) {
      t = 0;
      animationEnded = true;
    }

    brightness = b * vectorScale;

    //println("Animating: " + animationState);
  }

  void send() {
    //Send a message to the Collective Mind
    mind.send("Chock");
  }

  void receive(String str) {
    if (str == "Chock") {
      setAnimation(6);
    }
    //Receive a message from the Collective Mind
  }
}
