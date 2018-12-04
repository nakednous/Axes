/**
 * Axes
 * by Cristian Ramirez
 */

import frames.primitives.Vector;
import frames.primitives.Quaternion;

import frames.processing.Scene;
import frames.processing.Shape;

Scene scene;

Axis[] axes;

Vector p1;
Vector p2;

void setup() {
  size(800, 600, P3D);
  scene = new Scene(this);
  
  axes = new Axis[20];
  
  for (int i = 0; i < axes.length; i++) {
    p1 = Vector.random();
    p1.setMagnitude(scene.radius() / 3);
    
    p2 = Vector.random();
    p2.setMagnitude(scene.radius() / 3);
    
    axes[i] = new Axis(scene, p1, p2);
  }
}

void pre() {
  background(0);
}


void draw() {
  background(0);
  scene.traverse();
  scene.beginHUD();
  pushStyle();
  textAlign(RIGHT, BOTTOM);
  text("Left Button: translate scene\nRight Button: rotate the scene\nWheel Button: scale the scene", width, height);
  popStyle();
  scene.endHUD();
}

class Axis {
  Scene _scene;
  
  Vector _p1;
  Vector _p2;
  
  Shape shape;
  
  public Axis(Scene scene, Vector p1, Vector p2) {
    _scene = scene;
    
    _p1 = p1;
    _p2 = p2;
    shape = new Shape(_scene) {
      @Override
      void setGraphics(PGraphics pGraphics) {
        // set shape's position, orientation and highlighting
        setPosition(_p1);
        setOrientation(new Quaternion(new Vector(1, 0, 0), Vector.subtract(_p2, _p1)));
        setHighlighting(Shape.Highlighting.NONE);
        
        // set color
        int red = 239;
        int green = 127;
        int blue = 26;
        
        float r = 1f;
        
        pGraphics.pushStyle();
        
        pGraphics.strokeWeight(3);
        
        pGraphics.pushStyle();
        
        pGraphics.stroke(color(isTracked() ? 255 - red : red,
                               isTracked() ? 255 - green : green,
                               isTracked() ? 255 - blue : blue));
        // line
        pGraphics.pushStyle();
        pGraphics.beginShape(LINES);
        vertex(0f, 0f, 0f);
        vertex(length(), 0f, 0f);
        pGraphics.endShape();
        pGraphics.popStyle();
        
        // bubble
        pGraphics.pushStyle();
        pGraphics.fill(color(isTracked() ? 255 - red : red,
                               isTracked() ? 255 - green : green,
                               isTracked() ? 255 - blue : blue), 
                               127);
        pGraphics.ellipse(-r, 0, 2*r, 2*r);
        pGraphics.popStyle();
        
        pGraphics.popStyle();
        
        pGraphics.popStyle();
      }
      float length() {
        return (float)Math.pow(Math.pow((double)(_p2.x() - _p1.x()), 2) +
                               Math.pow((double)(_p2.y() - _p1.x()), 2), 0.5);
      }
    };
  }
}

void mouseMoved() {
  scene.track();
}

void mouseDragged(MouseEvent event) {
  if (event.getButton() == RIGHT) {
    scene.rotateCAD(new Vector(0, 0, 1));
  }
  if (event.getButton() == LEFT) {
    scene.translate(scene.eye());
  }
}

void mouseWheel(MouseEvent event) {
  scene.scale(-100 * event.getCount(), scene.eye());
}
