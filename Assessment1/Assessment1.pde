//Ellipse Position
int ellipseX = 100;
int ellipseY = 100;

void setup(){
  
  /* 
   * Set initial settings
   */
  //Num ellipses in the screen
  int numEllipses = 1;
  
  //Screen parameters
  size(640, 1024);
  background(0);  
  
  //Launch ellipse through the screen with a size of 100 x 100
  launchEllipse(100, 100);
    
}

void draw(){
  
}

void mouseDragged(){
  
  /* Change the background colour depending on the distance between auto-moving
   * and user ellipse
   */
  updateBackgroundColour(mouseX, mouseY);
  
  //Draw the little ellipse sequence and the auto-moving ellipse
  launchEllipse();
  ellipse(mouseX, mouseY, 50, 50);
 
  /* Change the audio speed depending on the distance between auto-moving 
   * and user ellipse
   */
   

}

void mouseReleased(){
  //Erase ellipse Tails
  updateBackgroundColour(mouseX, mouseY);
  //Draw ellipses
  ellipse(mouseX, mouseY, 50, 50);
  ellipse(ellipseX, ellipseY, 100, 100);
}

/**
 * Draw a ellipse moving through the screen
 */
void launchEllipse(){
  
  //Get a random difference
  int newX = int(random(-10, 10));
  int newY = int(random(-5, 5));
  
  //We are going to draw 10 ellipses each time to simulate a smooth movement
  newX = newX/10;
  newY = newY/10;
  
  for (int i=0; i<10; i++){
    ellipseX = ellipseX + newX;
    ellipseY = ellipseY + newY;
    
    //Limit values into screen limits
    ellipseX = constrain(ellipseX, 0, width);
    ellipseY = constrain(ellipseY, 0, height);
  
    ellipse(ellipseX, ellipseY, 100 , 100);
  }
    
}

/**
 * Upadte the background colour attending at the distancte between
 * both ellipses
 */
void updateBackgroundColour(int posX, int posY){
  
  int distance = 0;
  int red = 0;
  
  //Get the distance between both ellipses
  distance = dist(posX, posY, ellipseX, ellipseY);
  
  //Limit the top value of distance to avoid getting the diagonal length
  distance = constrain(distance, 0, height);
  
  //Map red colour
  red = map(distance, 0, height, 255, 0);
  
  background(red, 0, 0);
  
}

