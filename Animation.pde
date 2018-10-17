class Animation {

  float t;
  float y1, y1c, y2, y2c;
  ArrayList<float[]> curves;
  boolean curveEnded;
  boolean animationEnded;
  int i; 
  float duration;
  boolean cyclic;

  Animation nextAnimation; 

  Animation(ArrayList<float[]> curves_) {
    curves = curves_;
    cyclic = true;
  }

  Animation(ArrayList<float[]> curves_, Animation nextAni) {
    curves = curves_;
    duration = curves.get(i)[5];
    cyclic = false;
  }

  Animation(float y1, float y1c, float y2, float y2c, int d, Animation nextAni) {
    float[] a = {y1, y1c, y2, y2c, d};
    curves = new ArrayList();
    curves.add(a);
    nextAnimation = nextAni;
    cyclic = false;
  }

  Animation(float y1, float y1c, float y2, float y2c, int d) {
    float[] a = {y1, y1c, y2, y2c, d};
    curves = new ArrayList();
    curves.add(a);
    cyclic = true;
  }

  boolean hasEnded() {
    return animationEnded;
  }

  boolean isCycling() {
    return cyclic;
  }

  Animation getNext() {
    return nextAnimation;
  }

  float animate() {
    float y = 0;

    t += (1 / duration);   
    //animationEnded = false;

    if (t > 1) {
      t = 0;
      animationEnded = true;

      if ( i < curves.size()-1) {
        i++;
      } else {
        i = 0;
      }
    } else {
      animationEnded = false;
    }

    y = bezierPoint(curves.get(i)[0], curves.get(i)[1], curves.get(i)[2], curves.get(i)[3], t);

    return y;
  }
}
