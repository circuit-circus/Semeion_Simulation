class Sem { //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

  float radius = random(35, 65); 
  int npoints = 5;
  float posX;
  float posY;
  float angle = random(0, TWO_PI); 
  String lastSent;
  PVector[] lastAction;
  PVector[] action;
  int animationState = 0;
  float t = 0;
  float animationTime = 100; // Default number of frames per animation
  float brightness = 0; 
  boolean animationEnded = false;
  final float vectorScale = 22.5; //Scaled to less than 255 to allow for overshooting. Bezier curves are drawn with factor 10. 
  long lastInteraction = 0;
  int incomingAnimation;
  float b = 0;

  CollectiveMind mind; 

  Sem(float x_, float y_, int n_, CollectiveMind m_) {
    posX = x_; //<>//
    posY = y_; 
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
  } 

  void display() {
    checkEnvironment(); //Check for recent actions in the environment and set the appearance variables.  

    //Draw the shape
    float angle = TWO_PI / npoints;
    fill(100, 200, brightness);
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
      if (animationState == 0 || animationState == 7) {
        changeAnimation(1); //Appear to nearby agent
      } else if (animationState == 2 && action[1].mag() > 0) {
        queueAnimation(3);
      }  
      if (action[0].mag() < radius-2 && animationState == 3) {
        changeAnimation(4);
      } else if (animationState == 4 && action[0].mag() > radius-2 ) {
        queueAnimation(3);
      }
      if (action[1].mag() > 30 && animationState != 0) {
        send("Chock"); //Communicate to others and hide
      }
      lastInteraction = millis();
    } else if (millis() - lastInteraction > 5000 && animationState == 2 ) {
      queueAnimation(5); //Fade out
    } else {
      //Default
      queueAnimation(-1); //Continue current animation
    }

    animate();

    //Save last recorded actions
    lastAction[0] = action[0].copy(); 
    lastAction[1] = action[1].copy();
  }

  void queueAnimation(int animationID) { //Check if a new animation has been requested and queue it 
    if (animationID != -1 && animationState != animationID) {
      incomingAnimation = animationID;
    }
  }

  void changeAnimation(int animationID) { //Change animation with immediate effect. May cause choppyness in the animation (add lerping here).
    if (animationID != -1) {
      animationState = animationID;
      incomingAnimation = animationID;
      t = 0;
    }
  }

  void animate() {


    t += (1 / animationTime);   
    //animationEnded = false;

    if (t > 1) {
      t = 0;
      animationEnded = true;
    } else {
      animationEnded = false;
    }

    switch(animationState) { //All bezier curves are drawn in a 10x10 unit grid. 

    case 0: //No animation
      animationTime = 100;
      b = bezierPoint(0, 0, 0, 0, t);
      break; 

    case 1: // Appear  
      animationTime = 50;
      if (animationEnded) {
        incomingAnimation = 2;
      } else {
        b = bezierPoint(0, 8.5, 12.3, 8, t);
        send("Greet");
      }
      break;

    case 2: // Idle, high
      println("Idle high");
      animationTime = 70; 
      b = bezierPoint(8, 8, 12.3, 8, t);
      break;

    case 3: // Mirror
      animationTime = 100; 
      b = 10 - (action[0].mag() / 20); //Not defined by a bezier, but follows the movement of the agent
      break;

    case 4: // Ecstasy
      animationTime = 20; 
      b = bezierPoint(8, 9, 13, 8, t);
      break;

    case 5: // Disappear, fade
      //println("Disappearing, fading");
      animationTime = 100;
      if (animationEnded) {
        incomingAnimation = 0;
      } else {
        b = bezierPoint(10, 10, 0, 0, t);
      }
      break;
    case 6: // Disappear, hide       
      animationTime = 30;
      if (animationEnded) {
        incomingAnimation = 0;
      } else {
        b = bezierPoint(4, 4, 0, 0, t);
      }
      break;

    case 7: // Idle, low 
      animationTime = 100; 
      b = bezierPoint(3, 3, 7, 3, t);
      break;

    case 8: //Appear, low  
      animationTime = 100; 
      if (animationEnded) {
        incomingAnimation = 7;
      } else {
        b = bezierPoint(0, 3, 3, 3, t);
      }
      break;

    case 9: //Random pause before appear low
      animationTime = round(random(0, 100)); 
      if (animationEnded) {
        incomingAnimation = 8;
      } else {
        b = bezierPoint(0, 0, 0, 0, t);
      }
      break;

    default: 
      // No animation
      break;
    }



    //When the current animation ends load the waiting animation
    if (incomingAnimation != animationState && animationEnded) { 
      animationState = incomingAnimation;
      //animationEnded = false;
    }

    brightness = b * vectorScale;

    //println("Animating: " + animationState);
  }

  void send(String str) { //Send a message to the Collective Mind
    if (lastSent != str) {
      mind.send(str);
      println("Sent: " + str);
    }
    lastSent = str;
  }

  void receive(String str) { //Receive a message from the Collective Mind
    if (str == "Chock" && animationState != 0) {
      changeAnimation(6);
    } else if (str == "Greet") {
      if (animationState == 0) {
        if (0.5 < random(0, 1)) {
          queueAnimation(9);
        }
      }
    }
  }
}
