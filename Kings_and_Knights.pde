//desktop
int n = 50;
color[][] frameNow;
color[][] frameNext;
float manSize;
float padding = 30;
int blinksPerSecond = 6;
//set color values
color blue = color(0, 0, 255);
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color baseB = color(255, 255, 255);
color baseR = color(255, 255, 255);
color kingB = color(0, 255, 255);
color kingR = color(255, 255, 0);
color knightB = color(0,120,255);
color knightR = color(255,120,0);
int pointsB = 0;
int pointsR = 0;
boolean end = false;  //boolean to end program
int iB;
int iR;
float jB;
float jR;
boolean k;
color winner;
String mode = "organized";  //"organized"(checkerboard) or "random"
boolean knights = true;  //spawn a knight for each team
void setup() {
  frameNow = new color[n][n];
  frameNext = new color[n][n];
  noStroke();
  if (mode == "organized"){  //starting positions for organized pattern
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        if ((i%2 == 0 && j%2==0) || (i%2 == 1 && j%2==1)) {  //creates the checherboard pattern
          if (5<=j && j<(n/3))  //left side is blue
            frameNow[i][j] = blue;
          else if ((n-(n/3))<=j && j<(n-5))  //right side is red
            frameNow[i][j] = red;
          else  //rest is green
            frameNow[i][j] = green;
        } 
        else {
          frameNow[i][j] = green;
        }
        //white base for both teams on either side
        if (j<4)
          frameNow[i][j] = baseB;
        else if (j>=(n-4))
          frameNow[i][j] = baseR;
      }
    }
  }
  else if (mode == "random"){ //starting position for randomly placed soldiers
    for (int i=0; i<n; i++) {
      for (int j=0; j<n; j++) {
        int r = int(random(0,2));
        if (r == 0) {
          if (5<=j && j<(n/3))
            frameNow[i][j] = blue;
          else if ((n-(n/3))<=j && j<(n-5))
            frameNow[i][j] = red;
          else
            frameNow[i][j] = green;
        }
        else {
          frameNow[i][j] = green;
        }
        if (j<4)
          frameNow[i][j] = baseB;
        else if (j>=(n-4))
          frameNow[i][j] = baseR;
      }
    }
  }
  //array values for the kings
  iB = int(random(1,n-1));
  iR = int(random(1,n-1));
  jB = 6;
  jR = n-7;
  //kings are 3x3 in size
  for(int s=-1; s<=1; s++){
    for(int t=-1; t<=1; t++){
      frameNow[iB+s][int(jB)+t] = kingB;
      frameNow[iR+s][int(jR)+t] = kingR;
    }
  }
  //array values for the knights
  int a = iB;
  int b = iR;
  while(a == iB-1 || a == iB || a == iB+1){  //gets values that don't overlap with the king
    a = int(random(0,n));
  }
  while(b == iR-1 || b == iR || b == iR+1){
    b = int(random(0,n));
  }
  if(knights){
    frameNow[a][4] = knightB;
    frameNow[b][n-5] = knightR;
  }
  size(800, 800);
  manSize = (width-2*padding)/n;
  frameRate( blinksPerSecond );
}

void draw() {
  background(0, 0, 255);
  float y = padding;
  //draws all the cells
  for (int i=0; i<n; i++) {
    for (int j=0; j<n; j++) {
      float x = padding + j*manSize;
      if (frameNow[i][j] == red)
        fill(red);
      else if (frameNow[i][j] == blue)
        fill(blue);
      else if (frameNow[i][j] == baseB)
        fill(baseB);
      else if (frameNow[i][j] == baseR)
        fill(baseR);
      else if (frameNow[i][j] == kingB)
        fill(kingB);
      else if (frameNow[i][j] == kingR)
        fill(kingR);
      else if (frameNow[i][j] == knightB)
        fill(knightB);
      else if (frameNow[i][j] == knightR)
        fill(knightR);
      else
        fill(green);
      rect(x, y, manSize, manSize);
    }
    y += manSize;
  }
  computeValues();
  overwritecellsNow();
}


void computeValues() {
  for (int i = 0; i<n; i++) {
    for (int j = 0; j<n; j++) {
      try {
        //for blue cells
        if (frameNow[i][j] == blue) {
          //moves blue cells forward
          if (frameNow[i][j+1] == green || frameNow[i][j+1] == blue ||frameNext[i][j+1] == red ||frameNext[i][j] == red) {
            if(frameNext[i][j+1] == red ||frameNext[i][j] == red){
              int winner = round(random(0,1));  //random int value 0 or 1
              if (winner == 1){  //blue wins when int value is 0
                frameNext[i][j+1] = blue;
                if (frameNext[i][j] != kingB)
                  frameNext[i][j] = green;
              }
            //when the value is 1, red wins
              else{
                if(mode=="random"){
                  if(frameNext[i][j] == red && frameNext[i][j-1] != kingB)
                    frameNext[i][j-1] = red;
                  else
                    frameNext[i][j] = blue;
              }
                else{
                  if(frameNext[i][j] != kingB)
                    frameNext[i][j] = green;
              }
            }
          }
            else
              frameNext[i][j+1] = blue;
            if (frameNow[i][j-1] != kingB && frameNext[i][j] != knightB && frameNow[i][j-1] != blue)
              frameNext[i][j] = green;
          }
          //when blue cells hit other team's base
          else if (frameNow[i][j+1] == baseR){ 
            if(frameNext[i][j] != kingB)
              frameNext[i][j] = green;
            pointsB++;
          }
          //blue cells hit the red king
          else if (frameNow[i][j+1] == kingR){
            frameNext[i][j] = green;
          }
        }
        //for red cells
        else if (frameNow[i][j] == red) {
          //when the red cells hit the blue king
          if (frameNext[i][j-1] == kingB && frameNext[i][j] != kingB){
            frameNext[i][j] = green;
          }
          //when a red cell hits a blue cell
          else if (frameNext[i][j] == blue || frameNext[i][j-1] == blue) {
            int winner = round(random(0,1));  //random int value 0 or 1
            if (winner == 0){  //red wins when int value is 0
                frameNext[i][j-1] = red;
                frameNext[i][j] = green;
            }
            //when the value is 1, blue wins
            else{
              if(mode=="random"){
                if(frameNext[i][j] == blue)
                  frameNext[i][j+1] = blue;
                else
                  frameNext[i][j] = blue;
              }
              else
                frameNext[i][j] = green;
            }
          }
          //moves red cells forward in other cases
          else if((frameNow[i][j-1] == green || frameNow[i][j-1] == red) && frameNext[i][j-1] != kingB){
            frameNext[i][j-1] = red;
            if(frameNext[i][j] != knightR)
              frameNext[i][j] = green;
          }
          //when a red cell hits blue base
          else if (frameNow[i][j-1] == baseB){
            frameNext[i][j] = green;
            pointsR++;
          }
        }
        //code for stationary areas
        else if (frameNow[i][j] == baseB || frameNow[i][j] == baseR)
          frameNext[i][j] = frameNow[i][j];
        //green cells stay green except in these cases
        else if (frameNow[i][j] == green && frameNow[i][j-1] != blue && frameNow[i][j-1] != kingB && 
        frameNext[i][j] != knightB && frameNext[i][j] != knightR && frameNext[i][j] != red) 
          frameNext[i][j] = green;
        //code for blue king
        else if (frameNow[i][j] == kingB){
          frameNext[i][j+1] = kingB;
          if (frameNow[i][j-1] != kingB)
            frameNext[i][j] = green;
          if(frameNow[i][j-1] == kingR){  //when blue king hits red king
            //determine the winner and end simulation
            if(end == false){
              getWinner();
              noLoop();
            }
          }
          //the "xCord" of blue king is increased by 1/9 since a king is 9 cells and this would run 9 times
          jB += 1.0/9;
        }
        //code for red king
        else if (frameNow[i][j] == kingR){
          if(frameNow[i][j-1] != baseB && frameNow[i][j-1] != kingB){
            frameNext[i][j-1] = kingR;
            frameNext[i][j] = green;
          }
          //when king reaches the base(not coded in blue king since they reach at the same time)
          else if(frameNow[i][j-1] == baseB){ 
            frameNext[i][j] = green;
            if(end == false){  //end simulation
              getWinner();
              noLoop();
            }
          }
          else if(frameNow[i][j-1] == kingB){  //when red king hits blue king
            if(end == false){  //end simulation
              getWinner();
              noLoop();
            }
          }
          jR-=1.0/9;  //"xCord" of red king
        }
        //Code for both knights
        //This giant block of code basically gets the knight to move to a position where 
        //it can go directly diagonal to where the other team's king is.
        //I did this by getting delta x between knight and the other team's 
        //king to be double the delta y since the king will be moving in the x direction.
        else if (frameNow[i][j] == knightB){
          if(i>iR){
            if((2*(i-iR)) == (round(jR)-j)){
              if(frameNext[i-1][j+1] == kingR){
                noLoop();
                blueWins();
                
              }
              else if(frameNext[i-1][j+1] == red){
                println("blue knight has died");
              }
              else
                frameNext[i-1][j+1] = knightB;
            }
            else if((2*(i-iR)) > (round(jR)-j)){
              if(frameNext[i-1][j] == kingR){
                noLoop();
                blueWins();
              }
              else if(frameNext[i-1][j] == red){
                println("blue knight has died");
              }
              else
                frameNext[i-1][j] = knightB;
            }
            else if((2*(i-iR)) < (round(jR)-j)){
              if(frameNext[i][j+1] == kingR){
                noLoop();
                blueWins();
              }
              else if(frameNext[i][j+1] == red){
                println("blue knight has died");
              }
              else
                frameNext[i][j+1] = knightB;
            }
          }
          else if(i<iR){
            if((2*(iR-i)) == (int(jR)-j)){
              if(frameNext[i+1][j+1] == kingR){
                noLoop();
                blueWins();
              }
              else if(frameNext[i+1][j+1] == red){
                println("blue knight has died");
              }
              else
                frameNext[i+1][j+1] = knightB;
            }
            else if((2*(iR-i))>(int(jR)-j)){
              if(frameNext[i+1][j] == kingR){
                noLoop();
                blueWins();
              }
              else if (frameNext[i+1][j] == red){
                println("blue knight has died");
              }
              else
                frameNext[i+1][j] = knightB;
            }
            else if((2*(iR-i))<(int(jR)-j)){
              if(frameNext[i][j+1] == kingR){
                noLoop();
                blueWins();
              }
              else if(frameNext[i][j+1] == red){
                println("blue knight has died");
              }
              else
                frameNext[i][j+1] = knightB;
            }
          }
          else{
            if(frameNext[i][j+1] == kingR){
              blueWins();
              noLoop();
            }
            else if(frameNext[i][j+1] == red){
              println("blue knight has died");
            }
            else
              frameNext[i][j+1] = knightB;
          }
          frameNext[i][j] = green;
        }
        else if (frameNow[i][j] == knightR){
          if(i>iB){
            if((2*(i-iB)) == (j-round(jB))){
              if(frameNext[i-1][j-1] == kingB){
                noLoop();
                redWins();
              }
              else if(frameNext[i-1][j-1] == blue)
                println("red knight has died");
              else
                frameNext[i-1][j-1] = knightR;
            }
            else if((2*(i-iB)) > (j-round(jB))){
              if(frameNext[i-1][j] == kingB){
                noLoop();
                redWins();
              }
              else if(frameNext[i-1][j] == blue)
                println("red knight has died");
              else
                frameNext[i-1][j] = knightR;
            }
            else if((2*(i-iB)) < (j-round(jB))){
              if(frameNext[i][j-1] == kingB){
                noLoop();
                redWins();
              }
              else if(frameNext[i][j-1] == blue)
                println("red knight has died");
              else
                frameNext[i][j-1] = knightR;
            }
          }
          else if(i<iB){
            if((2*(iB-i)) == (j-round(jB))){
              if (frameNext[i+1][j-1] == kingB){
                noLoop();
                redWins();
              }
              else if (frameNext[i+1][j-1] == blue)
                println("red knight has died");
              else
                frameNext[i+1][j-1] = knightR;
            }
            else if((2*(iB-i))<(j-round(jB))){
              if(frameNext[i][j-1] == kingB){
                noLoop();
                redWins();
              }
              else if(frameNext[i][j-1] == blue)
                println("red knight has died");
              else
                frameNext[i][j-1] = knightR;
            }
            else if((2*(iB-i))>(j-round(jB))){
              if(frameNext[i+1][j] == kingB){
                noLoop();
                redWins();
              }
              else if(frameNext[i+1][j] == blue)
                println("red knight has died");
              else
                frameNext[i+1][j] = knightR;
            }
          }
          else{
            if(frameNext[i][j-1] == kingB){
              noLoop();
              redWins();
            }
            else if(frameNext[i][j-1] == blue)
              println("red knight has died");
            else
              frameNext[i][j-1] = knightR;
          }
          frameNext[i][j] = green;
        }
      }
      catch(Exception e) {
      }
    }
  }
}

void getWinner(){  //determines winner
  int locB = pointsB;  //I just didn't want to mess with the pointsB and pointsR because they are global
  int locR = pointsR;
  //gets the number of alive soldiers for red and blue team
  for (int i = 0; i<n; i++) {
    for (int j = 0; j<n; j++) {
      if (frameNow[i][j] == blue || frameNow[i][j] == knightB)
        locB ++;
      else if (frameNow[i][j] == red || frameNow[i][j] == knightR)
        locR ++;
    }
  }
  //print ending statements
  println("blue alive: " + locB);
  println("red alive: " + locR);
  if (locB<locR)
    println("red wins by " + (locR-locB) + " points");
  else if (locB>locR)
    println("blue wins by " + (locB-locR) + " points");
  else
    println("draw");
  end = true;
}

void redWins(){  //when knight kills a king
  if (winner == blue)
    println("TIE, both kings have been eliminated");
  else{
  println("red knight has killed the blue king");
  println("RED WINS");
  }
  winner = red;
}

void blueWins(){  //when knight kills a king
  if (winner == red)
    println("TIE, both kings have been eliminated");
  else{
    println("blue knight has killed the red king");
    println("BLUE WINS");
  }
  winner = blue;
}

void overwritecellsNow() {
  for (int i = 0; i<n; i++) {
    for (int j = 0; j<n; j++) {
      frameNow[i][j] = frameNext[i][j];
    }
  }
}
