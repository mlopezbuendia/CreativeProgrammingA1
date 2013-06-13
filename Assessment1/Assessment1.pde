//Audio variables
Maxim  maxim;
AudioPlayer player;
AudioPlayer playerColission;

//Punctuation
long points = 0;

//Ellipse Position
int ellipseX = 300;
int ellipseY = 300;

void setup(){
  
  //Screen parameters
  size(640, 1024);
  background(0);  
  
  //Launch ellipse through the screen with a size of 100 x 100
  launchEllipse(100, 100);
  
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
  
  //Play music
  player.play();
  
  /* Change the background colour depending on the distance between auto-moving
   * and user ellipse. It also updates punctuation
   */
  updateBackgroundColour(mouseX, mouseY);
  
  //Draw the little ellipse sequence and the auto-moving ellipse
  launchEllipse();
  ellipse(mouseX, mouseY, 50, 50);
  
  //Check collision
  if(thereIsCollision(mouseX, mouseY)){
    playerCollision.play();
    //Decrease points
    points = points - 50.00;
  }
  else{
    playerCollision.stop();
  }
 
  /* Change the audio speed depending on the distance between auto-moving 
   * and user ellipse
   */
  updateBackgroundAudio(mouseX, mouseY);
 
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
 * both ellipses. It also updates punctuation
 */
void updateBackgroundColour(int posX, int posY){
  
  int distance = 0;
  int red = 0;
  long newPoints = 0.00;
  
  //Get the distance between both ellipses
  distance = dist(posX, posY, ellipseX, ellipseY);
  
  //Limit the top value of distance to avoid getting the diagonal length
  distance = constrain(distance, 0, height);
  
  //Map red colour
  red = map(distance, 0, height, 255, 0);
  
  background(red, 0, 0);
  
  //Update punctuation, max 10 point in each call
  if(distance < 200){
    if(distance < 100){
      newPoints = 10;
    }
    else if(distance < 125){
      newPoints = 0.30;
    }
    else if(distance < 150){
      newPoints = 0.20;
    }
    else if(distance < 175){
      newPoints = 0.10;
    }
  }
  //If distance is larger than half screen height we don give points

  points = points + newPoints;
  
}

/**
 * Upadte the background audio speed attending at the distancte between
 * both ellipses
 */
void updateBackgroundAudio(int posX, int posY){
  
  int distance = 0;
  int speed = 0;
  
  //Get the distance between both ellipses
  distance = dist(posX, posY, ellipseX, ellipseY);
  
  //Limit the top value of distance to avoid getting the diagonal lenght
  distance = constrain(distance, 0, height);
  
  //Map audio speed
  speed = map(distance, 0, height, 1.5, 0.75);
  
  player.speed(speed);
  
}

/**
 * Check if ellipses are in the same space
 */
boolean thereIsCollision(int posX, int posY){
  
  boolean result = false;
  int distance = 0;
  
  //Get the distance between both centers
  distance = dist(posX, posY, ellipseX, ellipseY);
  
  if(distance < 75){
    result = true;
  }
  
  return result;
  
}

