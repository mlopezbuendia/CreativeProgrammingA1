//Audio variables
Maxim  maxim;
AudioPlayer player;
AudioPlayer playerColission;

//Punctuation
long points = 0;

//Minimum distance each moment
int minDist = 0;

//Ellipse Position
int[] ellipseX;
int[] ellipseY;
int numEllipse=4;

void setup(){
  
  //Screen parameters
  size(640, 1024);
  background(0);

  //Set ellipse positions
  ellipseX = new int[numEllipse];
  ellipseY = new int[numEllipse];
  int start=100;
  for (int i=0; i<numEllipse; i++){
    ellipseX[i] = start;
    ellipseY[i] = start;
    start = start + 100; 
  }
  
  //Draw initial ellipses
  for (int i=0; i < numEllipse; i++){
    ellipse(ellipseX[i], ellipseY[i], 100, 100);
  }

  
  //Load background music and enable loop
  maxim = new Maxim(this);
  player = maxim.loadFile("background.wav");
  player.setLooping(true);
  
  //Load collision sound
  playerCollision = maxim.loadFile("alarm.wav");
  playerCollision.volume(0.25);
  playerCollision.setLooping(true);
  
  //Define Text
  textSize(32);
  text("Points: 0.00", 10 , 30);
  
}

void draw(){
  
}

void mouseDragged(){
  
  int[] distances;
  
  //Play music
  player.play();
  
  /* Change the background colour depending on the distance between auto-moving
   * and user ellipse. It also updates punctuation
   */
  distances = updateBackgroundColour(mouseX, mouseY);
  
  //Draw the little ellipse sequence and the auto-moving ellipse
  launchEllipse(100,100);
  ellipse(mouseX, mouseY, 50, 50);
  
  //Check collision
  if(thereIsCollision(distances)){
    playerCollision.play();
    //Decrease points
    points = points - 50.00;
  }
  else{
    playerCollision.stop();
  }
 
  /* Change the audio speed depending on the distance calculated 
   * within update background
   */
  updateBackgroundAudio();
 
 //Update punctuation
  text("Points: " + points, 10, 30); 

}

void mouseReleased(){
  
  //Erase ellipse Tails
  updateBackgroundColour(mouseX, mouseY);
  //Draw ellipses
  ellipse(mouseX, mouseY, 50, 50);
  ellipse(ellipseX, ellipseY, 100, 100);
  
  //Stop music
  player.stop();
  
  //Show current punctuation
  text("Points: " + points, 10, 30);
  
}

/**
 * Draw a ellipse moving through the screen
 */
void launchEllipse(int ancho, int largo){
  
  //Get a random difference
  int[] newX = new int[numEllipse];
  int[] newY = new int[numEllipse];
  
  for(int i=0; i<numEllipse;i++){
    newX[i] = int(random(-10, 10));
    newY[i] = int(random(-5, 5));
  }
   
  //We are going to draw 10 ellipses each time to simulate a smooth movement
  for(int i=0; i<numEllipse;i++){
    
    newX[i] = newX[i]/10;
    newY[i] = newY[i]/10;
  
    for (int j=0; j<10; j++){
      ellipseX[i] = ellipseX[i] + newX[i];
      ellipseY[i] = ellipseY[i] + newY[i];
    
      //Limit values into screen limits
      ellipseX[i] = constrain(ellipseX[i], 0, width);
      ellipseY[i] = constrain(ellipseY[i], 0, height);
  
      ellipse(ellipseX[i], ellipseY[i], ancho , largo);
    }
  }
}

/**
 * Upadte the background colour attending at the distancte between
 * both ellipses. It also updates punctuation
 * @return minDist to update musicBackground
 */
int[] updateBackgroundColour(int posX, int posY){
  
  int[] distance;
  int red = 0;
  long newPoints = 0.00;
  
  distance = new int[numEllipse];
  
  //Get the distance between every ellipse
  for (int i=0; i<numEllipse; i++){
    distance[i] = dist(posX, posY, ellipseX[i], ellipseY[i]);
  }
  
  //Get the minimum distance
  minDist = getMinDist(distance);
  
  //Limit the top value of distance to avoid getting the diagonal length
  minDist = constrain(minDist, 0, height);
  
  //Map red colour
  red = map(minDist, 0, height, 255, 0);
  
  background(red, 0, 0);
  
  //Update punctuation, max 10 point in each call WE NEED TO TAKE INTO ACCOUNT PUNTS WITH ALL ELLIPSES
//  if(distance < 200){
//    if(distance < 100){
//      newPoints = 10;
//    }
//    else if(distance < 125){
//      newPoints = 0.30;
//    }
//    else if(distance < 150){
//      newPoints = 0.20;
//    }
//    else if(distance < 175){
//      newPoints = 0.10;
//    }
//  }
  //If distance is larger than half screen height we don give points

  //points = points + newPoints;
  
  return distance;
  
}

/**
 * Upadte the background audio speed attending at the distancte between
 * both ellipses
 */
void updateBackgroundAudio(){
  
  int speed = 0;
  
  //Map audio speed
  speed = map(minDist, 0, height, 1.5, 0.75);
  
  player.speed(speed);
  
}

/**
 * Check if ellipses are in the same space
 */
boolean thereIsCollision(int[] distances){
  
  boolean result = false;
  
  //Check collision for each ellipse
  for (int i=0; i<numEllipse; i++){  
    if(distances[i] < 75){
      result = true;
    }
  }
  
  return result;
  
}

/*
 * Return le lowest value in an array
 */
int getMinDist(int[] distances){
  
  int result = height;
  
  for(int i=0; i<numEllipse; i++){
    if(distances[i] < result){
      result = distances[i];
    }
  }
  
  return result;
  
}

