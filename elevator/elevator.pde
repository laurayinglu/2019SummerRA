
//2)Degrees-of-freedom: Elevator with and without springs for the cables

//Modifications needed: Add springs, perhaps make one of the videos (the one without the springs) shorter in height than the other one.



int initial = 0;
float elapsedTime = 0f;
ArrayList<double[]> dataList = new ArrayList<double[]>();
PImage wheel;
PImage bc;
PImage spring;

int w = 640;
int h = 640;

void setup() {
  size(640, 640, P3D);
  background(255);
  selectInput("Select the data file to be used: ", "fileSelected");
  wheel = loadImage(dataPath("wheel.png"));
  bc = loadImage(dataPath("elevator_background.png"));
  spring = loadImage(dataPath("largeSpring.png"));
  wheel.resize(60, 60);
  bc.resize(60, 520);
  spring.resize(15, 70);
}

void fileSelected(File selection) {
  if (selection == null) {
    println("No file selected");
  }
  else {
    println("User selected : " + selection.getAbsolutePath());
    loadFile(selection.getAbsolutePath());
  }
}

void draw() {
  scale(w/640f);
  float width = 640f;
  float height = 640f;
  noSmooth();
  while (initial < dataList.size() && dataList.get(initial)[0] < elapsedTime) {
    initial++;
  }

  if (initial >= dataList.size()) {
    initial = 0;
    elapsedTime = 0;
    return;
  }
  elapsedTime += 1/frameRate;
  background(255);
  // add spring right
  image(bc, width/2 - bc.width/2, height/2 - bc.height/2);

  float leftDiff = -(float)dataList.get(initial)[2];
  float rightDiff = (float)dataList.get(initial)[1];
  float l = (float)(height/2 + bc.height/2 - wheel.height - (height/2 - bc.height/2 + wheel.height + 40));
  //float he = rightDiff + leftDiff + l - (height/2 - bc.height/2 + wheel.height/3 + 30) - 150;
  float he = rightDiff/2 + leftDiff/2 + l - 130 - 67 - 107;
  //float he = rightDiff + leftDiff + l - 130 - 67 - (height/2 - bc.height/2 + wheel.height/3 + 30 - 1);

  noStroke();
  fill(255);
  //fill(0);
  rect(width/2 - bc.width/2 + bc.width - 6, height/2 - bc.height/2 + wheel.height/3 + 31, 10, he);


  // draw spring
  beginShape();
  texture(spring);
  vertex(width/2 - bc.width/2 + bc.width - 7, height/2 - bc.height/2 + wheel.height/3 + 30 - 1, 0, 0); // top left
  vertex(width/2 - bc.width/2 + bc.width - 7 + spring.width, height/2 - bc.height/2 + wheel.height/3 + 30 - 1, spring.width, 0); // top right
  vertex(width/2 - bc.width/2 + bc.width - 7 + spring.width, rightDiff + leftDiff + l - 130, spring.width, spring.height + 67); // bottom right
  vertex(width/2 - bc.width/2 + bc.width - 7, rightDiff + leftDiff + l - 130, 0, spring.height + 67); // bottom left
  endShape();
  

  //image(wheel, width/2 - wheel.width/2, height/2 - bc.height/2);
  //image(wheel, width/2 - wheel.width/2, height/2 + bc.height/2 - wheel.height);
  stroke(0);
  fill(255);
  strokeWeight(5);
  line(width/2 + wheel.width/2 + 20, height/2 - bc.height/2 + wheel.height + 52, width/2 + wheel.width/2 + 40, height/2 - bc.height/2 + wheel.height + 52);
  line(width/2 + wheel.width/2 + 20, height/2 + bc.height/2 - wheel.height, width/2 + wheel.width/2 + 40, height/2 + bc.height/2 - wheel.height);
  
  strokeWeight(2);
  // draw the left rect
  rect(width/2 - wheel.width/2 - 10, height/2 - bc.height/2 + wheel.height - leftDiff, 20, 40);
  for (float i = height/2 - bc.height/2 + wheel.height - leftDiff ;i < height/2 - bc.height/2 + wheel.height - leftDiff + 40; i += 5) {
    line(width/2 - wheel.width/2 - 10, i, width/2 - wheel.width/2 - 10 + 20, i); // line(x1, y1, x2, y2)
  }
  
  //line(width/2 + wheel.width/2, rightDiff + leftDiff + l, width/2 + wheel.width/2, height/2 + bc.height/2 - wheel.height - 40 - rightDiff);
  
  // draw the right rect
  rect(width/2 + wheel.width/2 - 7.5, height/2 + bc.height/2 - wheel.height - 40 - rightDiff + 20, 15, 20);
  line(width/2 + wheel.width/2 , height/2 + bc.height/2 - wheel.height - rightDiff, width/2 + wheel.width/2, height/2 + bc.height/2 - wheel.height - 40 - rightDiff + 20);
  rect(width/2 + wheel.width/2 - 20, height/2 + bc.height/2 - wheel.height - 40 - rightDiff, 40, 40);
  pushMatrix();
  translate(width/2, height/2 - bc.height/2 + wheel.height/2);
  rotate((float)(leftDiff/30));
  translate(-wheel.width/2, -wheel.height/2);
  image(wheel, 0, 0);
  popMatrix();
  pushMatrix();
  translate(width/2, height/2 + bc.height/2 - wheel.height/2);
  rotate((float)(-rightDiff/30));
  translate(-wheel.width/2, -wheel.height/2);
  image(wheel, 0, 0);
  popMatrix();
     
}

void keyPressed() {
  if (key == 'l') {
    selectInput("Select the data file to be used: ", "fileSelected");
  }
  if(key == 'r') {
    initial = 0;
    elapsedTime = 0;
  }
  if (key == '+') {
    w += 40;
    h += 40;
    surface.setSize(w, h);
  }
  if (key == '-') {
    w -= 40;
    h -= 40;
    surface.setSize(w, h);
  }
}

void loadFile(String path) {
  dataList.clear();
  initial = 0;
  elapsedTime = 0;
  try {
    BufferedReader br = createReader(path);
    String line;
    while ((line = br.readLine()) != null) {
      double[] lineData;
      String[] lineStr = line.split(",");
      lineData = new double[] {Double.parseDouble(lineStr[0]), Double.parseDouble(lineStr[1]), Double.parseDouble(lineStr[2])};
      dataList.add(lineData);
    }
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}
