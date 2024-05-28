import peasy.*;
PeasyCam cam;

PImage img;
boolean useOriginalColors = true;
int paletteIndex = 0;
color[] palette1, palette2;
int saveCounter = 0;


void setup() {
  size(840, 510, P3D);
  img = loadImage("../boiko.jpg");

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  
  palette1 = new color[] {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)};
  palette2 = new color[] {color(255, 255, 0), color(0, 255, 255), color(255, 0, 255)};
}

int LoopStep, StrokeWeight;
float rotation;
color bgColor;

// Part 2
void draw() {
  translate(-width / 2, -height / 2);

  LoopStep = 5; 
  StrokeWeight = 5; 
  float rotationSpeed = map(mouseX, 0, width, 0, 0.1); 

  bgColor = color(127 + 127 * sin(frameCount * 0.01), 127 + 127 * sin(frameCount * 0.01 + PI / 3), 127 + 127 * sin(frameCount * 0.01 + 2 * PI / 3));
  background(bgColor);

  for (int x = 0; x < width; x += LoopStep) {
    for (int y = 0; y < height; y += LoopStep) {
      color c = img.pixels[y * img.width + x];
      if (!useOriginalColors) {
        float mappedBrightness = map(brightness(c), 0, 255, 0, 1);
        c = lerpColor(palette1[paletteIndex % palette1.length], palette2[paletteIndex % palette2.length], mappedBrightness);
      }

      float b = brightness(c);
      float z = map(b, 0, 255, -100, 100);
      float shapeSize = map(b, 0, 255, 5, 20); 
      stroke(c);
      strokeWeight(StrokeWeight);

      pushMatrix();
      translate(x, y, z);
      rotateZ(rotation);
      rotateY(rotation * (x + y) * 0.0001); 

      fill(c);
      rectMode(CENTER);
      square(0, 0, shapeSize);
      noFill();

      popMatrix();

      rotation += rotationSpeed;
    }
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    useOriginalColors = !useOriginalColors;
  }
  if (key == 'p' || key == 'P') {
    paletteIndex++;
  }
  if (key == 't' || key == 'T') {
    saveFrame("output-######.png");
  }
}
