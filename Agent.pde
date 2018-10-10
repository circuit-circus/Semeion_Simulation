class Agent {
  float x, y, size, n1, n2, t1, t2;
  int id, offset = 50;
  boolean userAgent;
  color c;

  Agent(int _id) {
    id = _id;
    if (id == 0) {
      userAgent = true;
      c = color(255,255,0);
    } else {
      userAgent = false;
      c = color(0,0,255);
      x = random(offset, width-offset);
      y = random(offset, height-offset);
    }
    t1 = random(1, 1000);
    t2 = random(1, 1000);
    size = 25;
  }

  void display() {

    if (userAgent) {
      x = mouseX;
      y = mouseY;
    
    } else {
      t1 += 0.001;
      t2 += 0.001;
      x = map(noise(t1), 0, 1, 0, width);
      y = map(noise(t2), 0, 1, 0, height);
      
    }
    fill(c);
    ellipse(x, y, size, size);
  }
}
