//Audio variables
Maxim  maxim;
AudioPlayer player;
AudioPlayer playerColission;

//Punctuation
long points = 0;

//Minimum distance at each moment
int minDist = 0;

//Ellipse Position
int[] ellipseX;
int[] ellipseY;
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

//Check when to start drawing
boolean settingsComplete = false;
boolean initial = true;

//String for user interaction
PFont f;
String typing = "";
String saved = "";

void setup(){
  
  //Screen parameters
  size(800, 800);
  background(0); 
  
  //Text parameters
  textSize(textHeight);
  f = createFont("Arial",16,true);
  
}

void draw(){
  
  //Before starting we need to get user info
  if(!settingsComplete){
    
    // Set the font and fill for text
    textFont(f);
    fill(badEllipse);
  
    // Display everything
    text("Click in the screen and type how many enemies you want (0-25): ", 25, 40);
    text(typing, 25, 90);
    text(saved, 25, 130);
    
    fill(normal);
    
    //Wait for user input in "key pressed" where we change settingsComplete value
  }
  //If user have already inserted info...
  else{
    //The very first time setting are complete, we need to initialize screen with ellipses
    if (initial){
      
      background(0);
      fill(badEllipse);
      
      //Set ellipse positions and draw them
      initEllipsePosition();
  
      //Load background music and enable loop
      maxim = new Maxim(this);
      player = maxim.loadFile("background.wav");
      player.setLooping(true);
  
      //Load collision sound
      playerColission = maxim.loadFile("alarm.wav");
      playerColission.volume(0.25);
      playerColission.setLooping(true);
    
      //Define Text and print it
      fill(textBox);
      rect(0, 0, width, boxHeight);
      fill(normal);
      text("Points: 0.00", textTopPadding , textLeftPadding);
      
      //Skip this step next time
      initial = false;
      
    }
  }
}

/**
 * Only react if settings are complete
 */
void mouseDragged(){
  
  int[] distances;
  
  if(settingsComplete){
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

void mouseReleased(){
  
  if(settingsComplete){
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
int[] updateBackgroundColour(int posX, int posY){
  
  int[] distance;
  int red = 0;
  int green = 0;
  int blue = 0;
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
  
  //Check collision
  if(minDist < 75){
    playerColission.play();
    //Decrease points
    points = points - 50.00;
    //Paint background in yellow
    red = 255;
    green = 165;
    blue = 0;
  }
  //If no collision
  else{
    playerColission.stop();
    
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
  
  int speed = 0;
  
  //Map audio speed
  speed = map(minDist, 0, height, 1.5, 0.75);
  
  player.speed(speed);
  
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

/**
 * Obtain the punctuation based on the position of all ellipses
 */

long calculatePoints(int[] distances){
  
  long result = 0.00;
  
  //Get points for each ellipse distance
  for(int i=0; i<numEllipse; i++){
    if(distances[i] < 200){
      if(distances[i] < 100){
        result += 10;
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
  
  ellipseX = new int[numEllipse];
  ellipseY = new int[numEllipse];
    
  //Get random position for each ellipse
  for (int i=0; i<numEllipse; i++){
    ellipseX[i] = int(random(100, width-100));
    ellipseY[i] = int(random(100 + boxHeight, height-100));
  }
  
  //Draw initial ellipses
  for (int i=0; i < numEllipse; i++){
    ellipse(ellipseX[i], ellipseY[i], 100, 100);
  }
}

/**
 * Process key user input
 */
void keyPressed() {
  
  //Used to transform input char into string
  String keyStr;
  String numbers = "0123456789";
  
  // If the return key is pressed, save the String and clear it
  if (key == '\n' ) {
    saved = typing;
    // A String can be cleared by setting it equal to ""
    typing = ""; 
    settingsComplete = true;
    
    //Convert string into integer
    numEllipse = int(saved);
    
    //The maximum numbre of ellipses is 25
    if(numEllipse > 25){
      numEllipse=25; 
    }
    
  } else {
    // Otherwise, concatenate the String only if the current input is a number
    if(numbers.indexOf(key) != -1){
      keyStr = new String(key);
      typing += keyStr;
    }
  }
}

