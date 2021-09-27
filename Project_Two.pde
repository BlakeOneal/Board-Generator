import controlP5.*;
import java.util.Iterator;
import java.util.Map;

ControlP5 cp5;
Button start;
boolean started = false;
ScrollableList shapes;
boolean squareSelect = true;
boolean hexSelect = false;
boolean stepsConstrained = false;
boolean terrainSimulated = false;
boolean strokeUsed = false;
boolean randomSeedUsed = false;
Slider maxSteps;
Slider stepRate;
Slider stepSize;
Slider stepScale;
Toggle constrainSteps;
Toggle simulateTerrain;
Toggle useStroke;
Toggle useRandomSeed;
Textfield randomSeed;
Textlabel labelOne;
Textlabel labelTwo;
Textlabel labelThree;
Textlabel labelFour;
int maxStepNum = 100;
int stepRateNum = 1;
int stepSizeNum = 10;
String seedString;
float stepScaleNum = 1.0;

void setup() {
  size(1200, 800);
  fill(97, 94, 93);
  rect(0, 0, 200, 800);
  cp5 = new ControlP5(this);
  // Start Button Initialization
  start = cp5.addButton("Start").setPosition(10, 10).setWidth(100).setHeight(30);
  // Dropdown (Scrollable) list Initialization
  shapes = cp5.addScrollableList("Shapes").setPosition(10, 50).setBarHeight(30);
  // Two options, squares = 0, hexagons = 1
  shapes.addItem("Squares", squareSelect);
  shapes.addItem("Hexagons", hexSelect);
  shapes.setValue(0).setItemHeight(30);
  // Maximum Step Slider Initialization
  maxSteps = cp5.addSlider("maxStepNum", 100, 50000).setLabel("").setPosition(10, 160).setHeight(20).setWidth(150);
  labelOne = cp5.addLabel("Maximum Steps").setPosition(8, 150);
  // Step Rate Slider Initialization
  stepRate = cp5.addSlider("stepRateNum", 1, 1000).setLabel("").setPosition(10, 200).setHeight(20).setWidth(150);
  labelTwo = cp5.addLabel("Step Rate").setPosition(8, 190);
  // Step Size Slider Initialization
  stepSize = cp5.addSlider("stepSizeNum", 10, 30).setLabel("").setHeight(20).setWidth(75).setPosition(10, 250);
  labelThree = cp5.addLabel("Step Size").setPosition(8, 240);
  // Step Scale Slider Initialization
  stepScale = cp5.addSlider("stepScaleNum", 1.00, 1.50).setLabel("").setHeight(20).setWidth(75).setPosition(10, 300);
  labelFour = cp5.addLabel("Step Scale").setPosition(8, 290);
  // Toggle Step Constraint Initialization
  constrainSteps = cp5.addToggle("stepsConstrained").setLabel("Constrain Steps").setPosition(10, 330).setWidth(20).setHeight(20);
  // Toggle Terrain Simulation Initialization
  simulateTerrain = cp5.addToggle("terrainSimulated").setLabel("Simulate Terrain").setWidth(20).setHeight(20).setPosition(10, 370);
  // Toggle Use Stroke Initialization
  useStroke = cp5.addToggle("strokeUsed").setLabel("Use Stroke").setWidth(20).setHeight(20).setPosition(10, 410);
  // Toggle Use Random Seed Initialization
  useRandomSeed = cp5.addToggle("randomSeedUsed").setLabel("Use Random Seed").setWidth(20).setHeight(20).setPosition(10, 450);
  // Text Field Random Seed Initialization
  randomSeed = cp5.addTextfield("seedNumber").setLabel("Seed Value").setWidth(50).setHeight(20).setPosition(100, 450).setInputFilter(ControlP5.INTEGER);
}

float xPos = 600;
float yPos = 400;
int numDrawn = 0;

class basicShape {
  boolean useStroke = strokeUsed;
  boolean useColor = terrainSimulated;
  boolean clampVal = stepsConstrained;
  boolean useSeed = randomSeedUsed;
  int sideLength = stepSizeNum;
  float spacing = stepScaleNum;
  int stepRate = stepRateNum;
  int maximumSteps = maxStepNum;
  float maxXVal = 1199 - (spacing * sideLength);
  float minXVal = 201 + (spacing * sideLength);
  float maxYVal = 799 - (spacing * sideLength);
  float minYVal = 1 + (spacing * sideLength);
  float maxXValHex = 1199 - (spacing * sqrt(3) * sideLength);
  float minXValHex = 201 + (spacing * sqrt(3) * sideLength);
  float maxYValHex = 799 - (spacing * sqrt(3) * sideLength);
  float minYValHex = 1 + (spacing * sqrt(3) * sideLength);
  HashMap<PVector, Integer> locationMap = new HashMap<PVector, Integer>();

  void prelim() {
    if (useStroke) {
      stroke(10);
    }
    if (!useStroke) {
      noStroke();
    }
  }
}
class squareShape extends basicShape {
  void randomGen() {
    int randomNum = int(random(1, 5));
    float prevXPos = xPos;
    float prevYPos = yPos;
    switch(randomNum) {
    case 1:
      yPos = (yPos - (sideLength * spacing));
      break;
    case 2:
      yPos = (yPos + (sideLength * spacing));
      break;
    case 3:
      xPos = (xPos - (sideLength * spacing));
      break;
    case 4:
      xPos = (xPos + (sideLength * spacing));
      break;
    }
    if (clampVal) {
      if (xPos > maxXVal) {
        xPos = prevXPos;
        randomGen();
      }
      if (xPos < minXVal) {
        xPos = prevXPos;
        randomGen();
      }
      if (yPos > maxYVal) {
        yPos = prevYPos;
        randomGen();
      }
      if (yPos < minYVal) {
        yPos = prevYPos;
        randomGen();
      }
    }
  }
  void prelim() {
    super.prelim();
  }
  void drawSquare() {
    square(xPos, yPos, sideLength);
  }
}

class hexagonShape extends basicShape { //<>//
  void randomGen() {
    int randomNum = int(random(1, 7));
    float prevXPos = xPos;
    float prevYPos = yPos;
    switch(randomNum) {
    case 1:
      xPos = prevXPos + (sqrt(3.0f) * (float)sideLength * cos(radians(30))) * spacing;
      yPos = prevYPos + (sqrt(3.0f) * (float)sideLength * sin(radians(30))) * spacing;
      break;
    case 2:
      xPos = prevXPos + (sqrt(3.0f) * (float)sideLength * cos(radians(90))) * spacing;
      yPos = prevYPos + (sqrt(3.0f) * (float)sideLength * sin(radians(90))) * spacing;
      break;
    case 3:
      xPos = prevXPos + (sqrt(3.0f) * (float)sideLength * cos(radians(150))) * spacing;
      yPos = prevYPos + (sqrt(3.0f) * (float)sideLength * sin(radians(150))) * spacing;
      break;
    case 4:
      xPos = prevXPos + (sqrt(3.0f) * (float)sideLength * cos(radians(210))) * spacing;
      yPos = prevYPos + (sqrt(3.0f) * (float)sideLength * sin(radians(210))) * spacing;
      break;
    case 5:
      xPos = prevXPos + (sqrt(3.0f) * (float)sideLength * cos(radians(270))) * spacing;
      yPos = prevYPos + (sqrt(3.0f) * (float)sideLength * sin(radians(270))) * spacing;
      break;
    case 6:
      xPos = prevXPos + (sqrt(3.0f) * (float)sideLength * cos(radians(330))) * spacing;
      yPos = prevYPos + (sqrt(3.0f) * (float)sideLength * sin(radians(330))) * spacing;
      break;
    }
    if (clampVal) {
      if (xPos > maxXVal) {
        xPos = prevXPos;
        yPos = prevYPos;
        randomGen();
      }
      if (xPos < minXVal) {
        xPos = prevXPos;
        yPos = prevYPos;
        randomGen();
      }
      if (yPos > maxYVal) {
        xPos = prevXPos;
        yPos = prevYPos;
        randomGen();
      }
      if (yPos < minYVal) {
        xPos = prevXPos;
        yPos = prevYPos;
        randomGen();
      }
    }
  }
  void drawHex() {
    beginShape();
    rectMode(CENTER);
    for (int i = 0; i <= 6; i++) {
      float xPosition = (float)sideLength * cos(radians(60*i));
      float yPosition = (float)sideLength * sin(radians(60*i));
      vertex((float)(xPosition + xPos), (float)(yPosition + yPos));
    }
    endShape();
  }
}

basicShape shapeToDrawOne;
basicShape shapeToDrawTwo;
HashMap<PVector, Integer> locationMasterMap = new HashMap<PVector, Integer>();




void draw() {
  if (started && (numDrawn != maxStepNum)) {
    int choice = Shapes(int(shapes.getValue()));
    if (choice == 0) {
      rectMode(CENTER);
      squareShape squareToDraw = (squareShape)shapeToDrawOne;
      if (numDrawn != 0 && squareToDraw.useColor) {
        squareToDraw.locationMap.putAll(shapeToDrawOne.locationMap);
      }
      if (numDrawn == 0) {
        PVector currLocation = new PVector();
        squareToDraw.prelim();
        if (squareToDraw.useColor) {
          currLocation.x = xPos;
          currLocation.y = yPos;
          squareToDraw.locationMap.put(currLocation, 1);
          shapeToDrawOne.locationMap.put(currLocation, 1);
          fill(160, 126, 84);
        }
        if (!squareToDraw.useColor) {
          fill(110, 28, 150);
        }
        squareToDraw.drawSquare();
        numDrawn++;
      }
      squareToDraw.prelim();
      for (int i = 0; i < stepRateNum; i++) {
        squareToDraw.randomGen();
        if (squareToDraw.useColor) {
          PVector currLocation = new PVector();
          currLocation.x = xPos;
          currLocation.y = yPos;
          Integer valToCheck = squareToDraw.locationMap.get(currLocation);
          if (valToCheck == null) {
            squareToDraw.locationMap.put(currLocation, 1);
            shapeToDrawOne.locationMap.put(currLocation, 1);
            valToCheck = 1;
          } else {
            squareToDraw.locationMap.put(currLocation, valToCheck + 1);
            shapeToDrawOne.locationMap.put(currLocation, valToCheck + 1);
          }
          if (valToCheck + 1 < 4) {
            fill(160, 126, 84);
          } else if (valToCheck + 1 < 7) {
            fill(143, 170, 64);
          } else if (valToCheck + 1 < 10) {
            fill(135, 135, 135);
          } else {
            fill((valToCheck + 1) * 20, (valToCheck + 1) * 20, (valToCheck + 1) * 20);
          }
        }
        if (!squareToDraw.useColor) {
          fill(110, 28, 150);
        }
        squareToDraw.drawSquare();
        numDrawn++;
        if (numDrawn == maxStepNum)
        {
          started = false;
          break;
        }
      }
    } else if (choice == 1) {
      hexagonShape hexToDraw = (hexagonShape)shapeToDrawTwo;
      if(numDrawn != 0 && hexToDraw.useColor) {
        hexToDraw.locationMap.putAll(shapeToDrawTwo.locationMap);
      }
      if(numDrawn == 0) {
        PVector currLocation;
        hexToDraw.prelim();
        if(hexToDraw.useColor) {
          fill(160, 126, 84);
          currLocation = CartesianToHex(xPos, yPos, hexToDraw.sideLength, hexToDraw.spacing, 600, 400);
          hexToDraw.locationMap.put(currLocation, 1);
          shapeToDrawTwo.locationMap.put(currLocation, 1);
        }
        if(!hexToDraw.useColor) {
             fill(110, 28, 150);
        }
        hexToDraw.drawHex();
        numDrawn++;
      }
      hexToDraw.prelim();
      for(int i = 0; i < stepRateNum; i++) {
        hexToDraw.randomGen();
        if(hexToDraw.useColor) {
          PVector currLocation;
          currLocation = CartesianToHex(xPos, yPos, hexToDraw.sideLength, hexToDraw.spacing, 600, 400);
          Integer valToCheck = hexToDraw.locationMap.get(currLocation);
          if(valToCheck == null) {
            hexToDraw.locationMap.put(currLocation, 1);
            shapeToDrawTwo.locationMap.put(currLocation, 1);
            valToCheck = 1;
          }
          else{
            hexToDraw.locationMap.put(currLocation, valToCheck + 1);
            shapeToDrawTwo.locationMap.put(currLocation, valToCheck + 1);
          }
          if (valToCheck + 1 < 4) {
            fill(160, 126, 84);
          } else if (valToCheck + 1 < 7) {
            fill(143, 170, 64);
          } else if (valToCheck + 1 < 10) {
            fill(135, 135, 135);
          } else {
            fill((valToCheck + 1) * 20, (valToCheck + 1) * 20, (valToCheck + 1) * 20);
          }
        }
          if(!hexToDraw.useColor) {
             fill(110, 28, 150);
        }
        hexToDraw.drawHex();
        numDrawn++;
        if (numDrawn == maxStepNum)
        {
          started = false;
          break;
        }
      }
    }
  }
}


int Shapes(int shapeChosen) {
  rectMode(CORNER);
  fill(97, 94, 93);
  rect(0, 0, 200, 800);
  if (shapeChosen == 0) {
    return 0;
  } else if (shapeChosen == 1) {
    return 1;
  }
  return 0;
}

void Start() {
  int choice = Shapes(int(shapes.getValue()));
  started = true;
  background(205, 205, 205);
  fill(97, 94, 93);
  rectMode(CORNER);
  rect(0, 0, 200, 800);
  xPos = 600;
  yPos = 400;
  numDrawn = 0;
  if (choice == 0) {
    shapeToDrawOne = new squareShape();
  } else if (choice == 1) {
    shapeToDrawTwo = new hexagonShape();
  }
  if (randomSeedUsed) {
    seedString = randomSeed.getText();
    randomSeed(parseInt(seedString));
  }
}

PVector CartesianToHex(float xPos, float yPos, float hexRadius, float stepScale, float xOrigin, float yOrigin)
{
  float startX = xPos - xOrigin;
  float startY = yPos - yOrigin;

  float col = (2.0/3.0f * startX) / (hexRadius * stepScale);
  float row = (-1.0f/3.0f * startX + 1/sqrt(3.0f) * startY) / (hexRadius * stepScale);

  /*===== Convert to Cube Coordinates =====*/
  float x = col;
  float z = row;
  float y = -x - z; // x + y + z = 0 in this system

  float roundX = round(x);
  float roundY = round(y);
  float roundZ = round(z);

  float xDiff = abs(roundX - x);
  float yDiff = abs(roundY - y);
  float zDiff = abs(roundZ - z);

  if (xDiff > yDiff && xDiff > zDiff)
    roundX = -roundY - roundZ;
  else if (yDiff > zDiff)
    roundY = -roundX - roundZ;
  else
    roundZ = -roundX - roundY;

  /*===== Convert Cube to Axial Coordinates =====*/
  PVector result = new PVector(roundX, roundZ);

  return result;
}
