class Sem {

  int radius = 50; 
  int npoints = 5;
  int posX;
  int posY;
  int angle;
  PVector[] lastAction;
  PVector[] action;
  int animationState = -1;
  float t = 0;
  float brightness; 
  boolean animationEnded = false;
  final float vectorScale = 25.5;

  Sem(int x_, int y_, int ang_, int n_) {
    posX = x_;
    posY = y_;
    npoints = n_;
    angle = ang_;
    lastAction = new PVector[2];
    action = new PVector[2];
 //<>//
    lastAction[0] = new PVector(abs(posX - mouseX), abs(posY - mouseY));  //<>// //<>//
    action[0] = new PVector(abs(posX - mouseX), abs(posY - mouseY)); 
    lastAction[1] = new PVector(0, 0);
    action[1] = new PVector(0, 0);
  } 

  void display() {
    checkEnvironment(); //Check for recent actions in the environment and set the appearance variables.  

    //Draw the shape
    float angle = TWO_PI / npoints;
    fill(179, 68.5, brightness);
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
      animate(1);
    } else {
      animate(-1);
    }
  }

  void animate(int animationID) {
    float b = 0;
    if (animationID != -1) {
      if (animationState != animationID) {
        animationState = animationID;
        t = 0;
      }
    }
 
    switch(animationState) {
    case 0: 
      b = bezierPoint(0, 0, 0, 0, t);
      //No animation
    case 1:
      // Appear
      b = bezierPoint(0, 4.5, 0, 10, t);
      if (animationEnded) {
        println("Starting animation: Looking Around");
        animationState = 2;
        animationEnded = false;
      }
    case 2: 
      b = bezierPoint(10, 10, 0, 10, t);
      // Looking around
    case 3: 
      // Mirror
    case 4: 
      // Ecstasy
    case 5: 
      // Disappear, fase
    case 6: 
      // Disappear, hide
    case 7: 
      // Enthusiasm
    default: 
      // No animation
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
}
