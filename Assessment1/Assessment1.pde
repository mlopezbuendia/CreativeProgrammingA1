//Audio variables
Maxim  maxim;
AudioPlayer player;
AudioPlayer playerCollision;

//Punctuation
float points = 0;

//Minimum distance at each moment
float minDist = 0;

//Ellipse Position
float[] ellipseX;
float[] ellipseY;
int numEllipse=16;

//Text box parameters
float textHeight = 28;
int textTopPadding = 10;
int textLeftPadding = 30;
int boxHeight = 48;

//Background colours
int textBox = 153;
int normal = 0;
int badEllipse = 255;

void setup(){
  
  //Screen parameters
  background(0); 
  
  //Text parameters
  textSize(textHeight);
  
  background(0);
  fill(badEllipse);
      
  //Set ellipse positions and draw them
  initEllipsePosition();
  
  //Load background music and enable loop
  maxim = new Maxim(this);
  player = maxim.loadFile("background.wav");
  player.setLooping(true);
  
  //Load collision sound
  playerCollision = maxim.loadFile("alarm.wav");
  playerCollision.volume(0.25);
  playerCollision.setLooping(true);
    
  //Define Text and print it
  fill(textBox);
  rect(0, 0, width, boxHeight);
  fill(normal);
  text("Points: 0.00", textTopPadding , textLeftPadding);
  
}

void draw(){

  float[] distances;

  if(mousePressed){
    //Play music
    player.play();
      
    /* Change the background colour depending on the distance between auto-moving
     * and user ellipse. It also checks collision and play alarm sound in that case
     */
    distances = updateBackgroundColour(mouseX, mouseY);
      
    //Draw the little ellipse sequence and the auto-moving ellipse
    launchEllipse(100,100);
    ellipse(mouseX, mouseY, 50, 50);
      
    /* Change the audio speed depending on the distance calculated 
     * within update background
     */
    updateBackgroundAudio();
   
    //Update punctuation, max 10 point in each call for each ellipse
    points = points + calculatePoints(distances);
    fill(textBox);
    rect(0, 0, width, boxHeight);
    fill(normal);
    text("Points: " + points, 10, 30);
   }
  
}

/**
 * Only react if settings are complete
 */
void mousePressed(){
  


}

void mouseReleased(){
  
  //Erase ellipse Tails
  updateBackgroundColour(mouseX, mouseY);
  //Draw user ellipse
  ellipse(mouseX, mouseY, 50, 50);
  //Draw the "bad" ellipses
  fill(badEllipse);
  for (int i=0; i<numEllipse; i++){
    ellipse(ellipseX[i], ellipseY[i], 100, 100);
  }
  fill(normal);
  
  //Stop music
  player.stop();
  
  //Show current punctuation 
  fill(textBox);
  rect(0, 0, width, boxHeight);
  fill(normal);
  text("Points: " + points, 10, 30);
  
  //Reset punctuation
  points = 0;
  
}

/**
 * Draw a ellipse moving through the screen
 */
void launchEllipse(int ancho, int largo){
  
  //Get a random difference
  float[] newX = new float[numEllipse];
  float[] newY = new float[numEllipse];
  
  for(int i=0; i<numEllipse;i++){
    newX[i] = random(-10, 10);
    newY[i] = random(-5, 5);
  }
  
  fill(badEllipse);
  //We are going to draw 10 ellipses each time to simulate a smooth movement
  for(int i=0; i<numEllipse;i++){
    
    newX[i] = newX[i]/10;
    newY[i] = newY[i]/10;
  
    for (int j=0; j<10; j++){
      ellipseX[i] = ellipseX[i] + newX[i];
      ellipseY[i] = ellipseY[i] + newY[i];
    
      //Limit values into screen limits
      ellipseX[i] = constrain(ellipseX[i], 50, width - 50);
      ellipseY[i] = constrain(ellipseY[i], boxHeight, height - 50);
  
      ellipse(ellipseX[i], ellipseY[i], ancho , largo);
    }
  }
  fill(normal);
}

/**
 * Upadte the background colour attending at the distancte between
 * both ellipses. It also updates punctuation
 *
 * @return array with distance between each ellipse and user ellipse
 */
float[] updateBackgroundColour(float posX, float posY){
  
  float[] distance;
  float red = 0.00;
  float green = 0.00;
  float blue = 0.00;
  float newPoints = 0.00;
  
  distance = new float[numEllipse];
  
  //Get the distance between every ellipse
  for (int i=0; i<numEllipse; i++){
    distance[i] = dist(posX, posY, ellipseX[i], ellipseY[i]);
  }
  
  //Get the minimum distance
  minDist = getMinDist(distance);
  
  //Limit the top value of distance to avoid getting the diagonal length
  minDist = constrain(minDist, 0, height);
  
  //Check collision
  if(minDist < 75){
    playerCollision.play();
    //Decrease points
    points = points - 50.00;
    //Paint background in yellow
    red = 255;
    green = 165;
    blue = 0;
  }
  //If no collision
  else{
    playerCollision.stop();
    
    //Map red colour
    red = map(minDist, 0, height, 255, 0);
    green = map(posX, 0, width, 0, 92);
    blue = map(posY, 0, height, 0, 92);
  }
  
  //Paint background
  background(red, green, blue);
    
  return distance;
  
}

/**
 * Upadte the background audio speed attending at the distancte between
 * both ellipses
 */
void updateBackgroundAudio(){
  
  float speed = 0;
  
  //Map audio speed
  speed = map(minDist, 0, height, 1.5, 0.75);
  
  player.speed(speed);
  
}

/*
 * Return le lowest value in an array
 */
float getMinDist(float[] distances){
  
  float result = height;
  
  for(int i=0; i<numEllipse; i++){
    if(distances[i] < result){
      result = distances[i];
    }
  }
  
  return result;
  
}

/**
 * Obtain the punctuation based on the position of all ellipses
 */

float calculatePoints(float[] distances){
  
  float result = 0.00;
  
  //Get points for each ellipse distance
  for(int i=0; i<numEllipse; i++){
    if(distances[i] < 200){
      if(distances[i] < 100){
        result += 10.00;
      }
      else if(distances[i] < 125){
        result += 0.30;
      }
      else if(distances[i] < 150){
        result += 0.20;
      }
      else if(distances[i] < 175){
        result += 0.10;
      }
    }
  
  //If distance is larger than 200
  }
  
  return result;
  
}

/**
 * Set the initial position for the bad ellipses and draw them
 */
void initEllipsePosition(){
  
  ellipseX = new float[numEllipse];
  ellipseY = new float[numEllipse];
    
  //Get random position for each ellipse
  for (int i=0; i<numEllipse; i++){
    ellipseX[i] = random(100, width-100);
    ellipseY[i] = random(100 + boxHeight, height-100);
  }
  
  //Draw initial ellipses
  for (int i=0; i < numEllipse; i++){
    ellipse(ellipseX[i], ellipseY[i], 100, 100);
  }
}


