import peasy.*;
import damkjer.ocd.*;
PeasyCam cam;

Camera cam1;

PShape s;
PImage road;
PImage g;
float cx;
float cy;
float ladd;
int w = 640;
int h = 480;
boolean draw_minimap = false;
float minx;
float miny;
float maxx;
float maxy;

ArrayList<double[]> roadList = new ArrayList<double[]>();
ArrayList<double[]> dataList = new ArrayList<double[]>();

int initial = 0;
float elapsedTime = 0f;

void setup() {

  size(640, 480, P3D);
  background(255);


  loadFile("carMotion.txt");
  loadRoad("roaddata.txt");

  setCenter();

  cam1 = new Camera(this, -cy, -ladd, -cx, -cy, 0, -cx, 50, 5000000);

  //cam = new PeasyCam(this, cx, 0, cy, 300);
  //cam.rotateX(90);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(1000);
  s = loadShape("Smallcar.obj");
  road = loadImage("road.jpg");
  g = loadImage("grass.png");
  road.resize(100,100);

}

// find the min/max of the column 1, 2
void setCenter() {
  println(dataList.size());
  maxx = (float) dataList.get(0)[1];
  maxy = (float) dataList.get(0)[2];
  minx = (float) dataList.get(0)[1];
  miny = (float) dataList.get(0)[2];
  for (double[] lined : dataList) {
    float curx = (float) lined[1];
    float cury = (float) lined[2];
    if (curx < minx) {
      minx = curx;
    }
    if (curx > maxx) {
      maxx = curx;
    }

    if (cury < miny) {
      miny = cury;
    }

    if (cury > maxy) {
      maxy = cury;
    }
  }
  cy = maxx - (maxx - minx) / 2;
  cx = maxy - (maxy - miny) / 2;
  if ((maxx - minx) < (maxy - miny)){
    ladd = maxy - miny;
  }
  else {
    ladd = maxx - minx;
  }
}


void draw() {  
  scale(w/640f);
  while (initial < dataList.size() && (float)dataList.get(initial)[0] < elapsedTime) {
    initial ++;
  }

  if (initial >= dataList.size()) {
    initial = 0;
    elapsedTime = 0;
    return;
  }
  //lights();
  elapsedTime += 1/frameRate;

  background(180);
  //lights();
  cam1.feed();
  cam1.arc(0);
  cam1.circle(0);
  //renderCar();
  
  //fix the view
  //float an = (float)dataList.get(initial)[3];
  //camera((float)dataList.get(initial)[1] - 80*cos(an), -40, -(float)dataList.get(initial)[2] + 80*sin(an), (float)dataList.get(initial)[1], 0, -(float)dataList.get(initial)[2], 0, 1, 0);

  
  //camera((float)dataList.get(initial)[1] - 80*cos(an), -40, -(float)dataList.get(initial)[2] + 80*sin(an), (float)dataList.get(initial)[1], 0, -(float)dataList.get(initial)[2], 0, 1, 0);
  

  fill(160);
  noStroke();
  
  // set the grass 
  int sideL = 250;
  for (float x = minx-cx-2*sideL-1500; x <= maxx+cx+ 4*sideL; x+=sideL) {
    for (float y = -miny+cy+2*sideL; y >= -maxy-cy-2*sideL; y-= sideL) {
      beginShape();
      texture(g);
      vertex(x, 2, y, 0, 0);
      vertex(x+sideL, 2, y, 1024, 0);
      vertex(x+sideL, 2, y-sideL, 1024, 1024);
      vertex(x, 2, y-sideL, 0, 1024);
      endShape();
    }
  }
  
  
  
  
  pushMatrix();
  rotateY(PI/2);
  renderRoad();
  pushMatrix();
  translate((float)dataList.get(initial)[1], -7, -(float)dataList.get(initial)[2]);
  rotateY((float)dataList.get(initial)[3]);
  rotateX(2*(float)dataList.get(initial)[4]);
  rotateZ(PI);

  pushMatrix();
  scale(0.07);
  rotateY(PI/2);
  shape(s, 0, 0);
  popMatrix();

  popMatrix();
  popMatrix();
  //drawCylinder(30, 50, 20);
  
  camera();
  noLights();
  hint(DISABLE_DEPTH_TEST);
  if (draw_minimap) {
    renderMinimap();
  }
  textMode(MODEL);
  text(frameRate, 10, 10 + textAscent());
  hint(ENABLE_DEPTH_TEST);

}

void renderCar() {
  float si = 20;
  strokeWeight(2.0/si);

  pushMatrix();
  scale(si, si, si);
  float wid = -2;
  fill(0, 0, 120);
  stroke(160);

  beginShape();
  vertex(0, 0, 0);
  vertex(0, 0, wid);
  vertex(1.2, 0.45, wid);
  vertex(1.2, 0.45, 0);
  endShape();

  beginShape();
  vertex(1.2, 0.45, 0);
  vertex(1.2, 0.45, wid);
  vertex(1.35, 1.25, wid);
  vertex(1.35, 1.25, 0);
  endShape();

  beginShape();
  vertex(1.35, 1.25, 0);
  vertex(1.35, 1.25, wid);
  vertex(2.85, 1.25, wid);
  vertex(2.85, 1.25, 0);
  endShape();

  beginShape();
  vertex(2.85, 1.25, 0);
  vertex(2.85, 1.25, wid);
  vertex(3.3, 0.45, wid);
  vertex(3.3, 0.45, 0);
  endShape();

  beginShape();
  vertex(3.3, 0.45, 0);
  vertex(3.3, 0.45, wid);
  vertex(4.9, 0.15, wid);
  vertex(4.9, 0.15, 0);
  endShape();

  beginShape();
  vertex(4.9, 0.15, 0);
  vertex(4.9, 0.12, wid);
  vertex(4.9, -0.55, wid);
  vertex(4.9, -0.55, 0);
  endShape();

  beginShape();
  vertex(4.9, -0.55, 0);
  vertex(4.9, -0.55, wid);
  vertex(0, -0.55, wid);
  vertex(0, -0.55, 0);
  endShape();

  beginShape();
  vertex(0, -0.55, 0);
  vertex(0, -0.55, wid);
  vertex(0, 0, wid);
  vertex(0, 0, 0);
  endShape();

  beginShape();
  vertex(0, 0, 0);
  vertex(1.2, 0.45, 0);
  vertex(1.35, 1.25, 0);
  vertex(2.85, 1.25, 0);
  vertex(3.3, 0.45, 0);
  vertex(4.9, 0.15, 0);
  vertex(4.9, -0.55, 0);
  vertex(0, -0.55, 0);
  vertex(0, 0, 0);
  endShape();

  beginShape();
  vertex(0, 0, wid);
  vertex(1.2, 0.45, wid);
  vertex(1.35, 1.25, wid);
  vertex(2.85, 1.25, wid);
  vertex(3.3, 0.45, wid);
  vertex(4.9, 0.15, wid);
  vertex(4.9, -0.55, wid);
  vertex(0, -0.55, wid);
  vertex(0, 0, wid);
  endShape();

  pushMatrix();
  translate(1, -0.5, -0.1);
  drawCylinder(10, 0.5, 0.2);
  popMatrix();

  pushMatrix();
  translate(1, -0.5, wid + 0.1);
  drawCylinder(10, 0.5, 0.2);
  popMatrix();

  pushMatrix();
  translate(3, -0.5, wid + 0.1);
  drawCylinder(10, 0.5, 0.2);
  popMatrix();

  pushMatrix();
  translate(3, -0.5, -0.1);
  drawCylinder(10, 0.5, 0.2);
  popMatrix();


  popMatrix();

}

void drawCylinder(int sides, float r, float h) {
  float angle = 360/sides;
  float hHeight = h/2;

  beginShape();
  for (int i = 0; i < sides + 1; i++) {
    float x = cos(radians(i*angle)) * r;
    float y = sin(radians(i*angle)) * r;
    vertex(x, y, -hHeight);
  }
  endShape(); 
  
  beginShape();
  for (int i = 0; i < sides + 1; i++) {
    float x = cos(radians(i*angle)) * r;
    float y = sin(radians(i*angle)) * r;
    vertex(x, y, hHeight);
  }
  endShape();


  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < sides + 1; i++) {
    float x = cos(radians(i*angle)) * r;
    float y = sin(radians(i*angle)) * r;
    vertex(x, y, hHeight);
    vertex(x, y, -hHeight);
  }
  endShape();  
}


// render the road using the road data (need car data??)
void renderRoad() {
  int dent = 200;
  float wid = 10;
  noStroke();
  for(int x = 0; x < dataList.size() - dent; x += dent) {
    //line((float)dataList.get(x)[1], 0, -(float)dataList.get(x)[2], (float)dataList.get(x+dent)[1], 0, -(float)dataList.get(x+dent)[2]);

    line((float)dataList.get(x)[1] - wid*sin((float)dataList.get(x)[3]), 0, -(float)dataList.get(x)[2] - wid*cos((float)dataList.get(x)[3]), (float)dataList.get(x+dent)[1] - wid*sin((float)dataList.get(x+dent)[3]), 0, -(float)dataList.get(x+dent)[2] - wid*cos((float)dataList.get(x+dent)[3]));

    line((float)dataList.get(x)[1] + wid*sin((float)dataList.get(x)[3]), 0, -(float)dataList.get(x)[2] + wid*cos((float)dataList.get(x)[3]), (float)dataList.get(x+dent)[1] + wid*sin((float)dataList.get(x+dent)[3]), 0, -(float)dataList.get(x+dent)[2] + wid*cos((float)dataList.get(x+dent)[3]));

    beginShape();
    texture(road);
    vertex((float)dataList.get(x)[1] - wid*sin((float)dataList.get(x)[3]), 0, -(float)dataList.get(x)[2] - wid*cos((float)dataList.get(x)[3]), 0, 0);
    vertex((float)dataList.get(x)[1] + wid*sin((float)dataList.get(x)[3]), 0, -(float)dataList.get(x)[2] + wid*cos((float)dataList.get(x)[3]), 0, 100);

    vertex((float)dataList.get(x+dent)[1] + wid*sin((float)dataList.get(x+dent)[3]), 0, -(float)dataList.get(x+dent)[2] + wid*cos((float)dataList.get(x+dent)[3]), 100, 100);
    vertex((float)dataList.get(x+dent)[1] - wid*sin((float)dataList.get(x+dent)[3]), 0, -(float)dataList.get(x+dent)[2] - wid*cos((float)dataList.get(x+dent)[3]), 100, 0);

    endShape();
  }
}

// show right-corner minimal map
void renderMinimap() {
  float sc = 200/ladd;
  int dent = 200;
  fill(20, 100);
  stroke(0);
  rect(w-350,0,300,240);
  fill(255);
  stroke(255);
  // show the road
  for(int x = 0; x < dataList.size() - dent; x += dent) {
    line(w-300 + (200 - (sc * (float)dataList.get(x)[2] - minx)), 20 + 200 - (sc * (float)dataList.get(x)[1] - miny), w-300 + (200 - (sc * (float)dataList.get(x+dent)[2] - minx)), 20 + 200 - (sc * (float)dataList.get(x+dent)[1] - miny));
  }
  
  // show the car
  pushMatrix();
  translate(w-300 + (200 - (sc * (float)dataList.get(initial)[2] - minx)), 20 + 200 - (sc * (float)dataList.get(initial)[1] - miny));
  ellipse(0,0,10,10);
  popMatrix();

}



void clearData() {
  dataList.clear();
  initial = 0;
  elapsedTime = 0f;
}


// read the car motion data
void loadFile(String path) {
  clearData();
  try {
    BufferedReader br = createReader(path);
    String line;
    while ((line = br.readLine()) != null) {
      double[] lineData;
      String[] lineStr = line.split(",");
      lineData = new double[] {Double.parseDouble(lineStr[0]), Double.parseDouble(lineStr[1]), Double.parseDouble(lineStr[2]), Double.parseDouble(lineStr[3]), Double.parseDouble(lineStr[4])};
      dataList.add(lineData);
    }
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}


// read the road data
void loadRoad(String path) {
  try {
    BufferedReader br = createReader(path);
    String line;
    while ((line = br.readLine()) != null) {
      double[] lineData;
      String[] lineStr = line.split(",");
      lineData = new double[] {Double.parseDouble(lineStr[0]), Double.parseDouble(lineStr[1]), Double.parseDouble(lineStr[2]), Double.parseDouble(lineStr[3])};
      roadList.add(lineData);
    }
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}


void mouseDragged() {
  if (mouseButton == LEFT) {
    // http://www.airtightinteractive.com/demos/processing/bezier_ribbon_p3d/BezierRibbons.pde
    cam1.arc(radians(-(mouseY - pmouseY))/4);
    cam1.circle(radians(-(mouseX - pmouseX))/4);
  } else if (mouseButton == RIGHT) {
    cam1.zoom(radians(mouseY - pmouseY) / 2.0);
  } else if (mouseButton == CENTER) {
    // peasycam calls this .pan(); damkjer.ocd calls it .track()
    cam1.track(-(mouseX - pmouseX), -(mouseY - pmouseY));
  }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  cam1.zoom(e/40);
}


void keyPressed() {
  if (key == 'm') {
    draw_minimap = !draw_minimap;
  }
  
  if (key == 'l') {
    selectInput("Selected the data file to be used: ", "fileSelected");
  }

  if (key == 'r') {
    initial = 0;
    elapsedTime = 0f;
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
  
  if (key == 'v') {
    float an = (float)dataList.get(initial)[3];
    camera((float)dataList.get(initial)[1] - 80*cos(an), -40, -(float)dataList.get(initial)[2] + 80*sin(an), (float)dataList.get(initial)[1], 0, -(float)dataList.get(initial)[2], 0, 1, 0);
  
  }
}
