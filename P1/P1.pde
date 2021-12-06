PImage img0, img1;
PrintWriter output;
int textsize = 30;
int stop;
int mode;
int finish;
int directL,directR;
int stageL,stageR;
int time;
int hardness;
int target;
int num1,num2,num3;
int found;
int search=0;
int instruct=1;
int[][]  results = new int[1000][2];
float mousex, mousey;
float radius;
float change;
float[][] sounds;
Color[] clr ={new Color(0,0,255),new Color(255,255,0)};
ArrayList<Fist> fistsL;
ArrayList<Fist> fistsR;
ArrayList<HitSound> hitsoundsL;
ArrayList<HitSound> hitsoundsR;
int hitL,hitR,round=0 ;
float battleLine;
void setup(){
  size(1000, 600);
  img0 = loadImage("fist_L.jpg");
  img1 = loadImage("fist_R.jpg");
  
  sounds = new float[1000][2];
  fistsL = new ArrayList<Fist>();
  fistsR = new ArrayList<Fist>();
  hitsoundsL = new ArrayList<HitSound>();
  hitsoundsR = new ArrayList<HitSound>();
  
  stop=1;
  mode=1;
  time=100;
  hardness=1;
  finish=0;
  radius=20;
  hitL=hitR=0;
  stageL=stageR = 0;
  directL=directR=-1;
  change=0;
  num1=num2=num3;
  found=0;
  num1=num2=num3=0;
  output = createWriter("sounds.txt");
}

void draw(){
  Player playerR = new Player(1,directR);
  if(mode<0&&finish==0&&stop>0){
    if(time==100){
   fistsR.add(new Fist(random(textsize+height*0.4,height), 1));
    hitsoundsR.add(new HitSound(random(battleLine, width-206), random(textsize+height*0.35, textsize+height*0.4), 1));
    hitR++;
    directR*=-1;
    if(directR==1)
    change=(height*0.6-textsize)/40;
    if(directR==-1)
    change=(height*0.6-textsize)*9/40;
    }
    time-=hardness;
    if(time<0)
    time=100;
  }
  if(stop > 0){
  background(255);
  radius=20;
  for(int i = fistsR.size()-1;i>=0;i--){
    Fist fist = fistsR.get(i);
    if(fist.x>battleLine){
      fist.move();
      fist.display(); 
      stageR=1;
    }
    else{
      fist.disappear();
      fist.display();
    }
    if(fist.finished()){
      stageR=0;
    fistsR.remove(i);
    }
  }
  for(int i = hitsoundsR.size()-1;i>=0;i--){
    HitSound hitsound = hitsoundsR.get(i);
      hitsound.display();
      
      hitsound.disappear();
      hitsound.display();
    if(hitsound.finished())
    hitsoundsR.remove(i);
    }
  }
  else{
    stopTime();
  }
  textAlign(LEFT);
  fill(0, 0, 255);
  textSize(textsize);
  text("HIT:", 0, textsize);
  text(hitL,70,textsize);
  fill(255,0,0);
  text(round, width*0.5, textsize);
  textAlign(RIGHT);
  text("ROUND: ", width*0.5, textsize);
  fill(255,255,0);
  text("HIT:", width-100, textsize);
  text(hitR,width-25,textsize);
  battleLine = width*0.5;
  battleLine=battleLine + (hitL-hitR)*(width/20);
  BloodBoard bloodboard = new BloodBoard(battleLine, height);
  Player playerL = new Player(0,directL);
  
  for(int i = fistsL.size()-1;i>=0;i--){
    Fist fist = fistsL.get(i);
    if(fist.x<battleLine-100){
      fist.move();
      fist.display(); 
      stageL=1;
    }
    else{
      fist.disappear();
      fist.display();
    }
    if(fist.finished()){
    stageL=0;
    fistsL.remove(i);
    }
  }
  for(int i = hitsoundsL.size()-1;i>=0;i--){
    HitSound hitsound = hitsoundsL.get(i);
      hitsound.display();
      hitsound.disappear();
      hitsound.display();
      if(hitsound.finished()){
        hitsound.record();
        hitsoundsL.remove(i);
    }
  }
  bloodboard.display();
  if (battleLine==0||battleLine==width){
    if(battleLine==0){
    stageL=stageR=2;
    fill(255,0,0);
    textSize(height*0.26);
    textAlign(RIGHT);
    text("WIN", width, height*0.4+textsize);
    }
    else{
    stageL=stageR=3;
    fill(255,0,0);
    textSize(height*0.26);  
    textAlign(LEFT);  
    text("WIN", 0, height*0.4+textsize);
    }
    results[round][0]=hitL;
    results[round][1]=hitR;
    restart();
  }
   playerL.display(stageL);
   playerR.display(stageR);
   if(mode<0){
     textSize(textsize);
     fill(0);
     textAlign(LEFT);
     text("Hardness(PVC): "+(hardness+1)/2, width*5/8, height*0.1+textsize);
   }
   
   if(search>0){
     search();
   }
   if(instruct>0)
   instruction();
}

void search(){
  rectMode(CENTER);
  strokeWeight(5);
  fill(255);
  rect(width/2,height/2, width, height/2);
  switch(search){
    case 1:
    textAlign(CENTER);
    textSize(textsize);
    fill(0);
    text("Please type an integer less than 1000, \nthen type N/n again", width/2, height/2);
    break;
    case 2:
    textAlign(CENTER);
    textSize(textsize);
    fill(0);
    text(num1,width/2,height/2);
    println(num1);
    target = num1;
    break;
    case 3:
    textAlign(CENTER);
    textSize(textsize);
    fill(0);
    text(num1*10+num2, width/2,height/2);
        println(num1,num2);
    target = num1*10+num2;
    break;
    case 4:
    textAlign(CENTER);
    textSize(textsize);
    fill(0);
    text(num1*100+num2*10+num3, width/2,height/2);
        println(num1,num2,num3);
    target=num1*100+num2*10+num3;
    break;
    case 5:
    for(int i=0; i<round; i++){
      for(int j=0;j<2;j++){
        if(results[i][j]==target)
        found=i+1;
      }
    }
    textAlign(CENTER);
    textSize(textsize);
    fill(0);
    if(found>0){
      text("Found!The round is "+found, width/2, height/2);
    }
    else{
      text("Sorry!Cannot find it", width/2, height/2);
    }
    break;
    default:
    break;
  }
}

interface Objects{
  void display();
}

abstract class Object{
  float x,y;
  int side, red, green,blue;
}


class Player extends Object{
  int stage;
  int direct;
  float  h=height*0.6-textsize;
  float r=h/6;
  float w=r;
  Player(int s, int d){
   side=s;
   direct = d;
   red=clr[side].getRed();
   blue = clr[side].getBlue();
   green = clr[side].getGreen();
  };
  void display(int s){
    stage = s;
    //LEFT PLAYER
    if(side==0&&stage==0){
      pushMatrix();
      translate(0, textsize+height*0.4);
      strokeWeight(10);
      stroke(0);
      ellipseMode(CENTER);
      fill(255);
      ellipse(width/4, h/12, r,r);
      rectMode(CENTER);
      fill(red, green, blue);
      rect(width/4, h/3, r,h/3);
      line(width/4-r/4, h/2, width/4-r/4, h);//left leg
      line(width/4+r/4, h/2, width/4+r/4, h);//right leg
      line(width/4-r/2, h/6, width/4-r/2-h/6, h/3);//left arm1
      line(width/4-r/2-h/6, h/3, width/4-r/2, h/3);//left arm2
      line(width/4+r/2, h/6, width/4+r/2+h/4, h/2);//right arm
      strokeWeight(1);
      fill(255);
      ellipse(width/4-r/2, h/3, 20,20);
      ellipse(width/4+r/2+h/4, h/2, 20,20);
      popMatrix();
    }
    if(side==0&&stage==1){
      pushMatrix();
      translate(0, textsize+height*0.4);
      strokeWeight(10);
      stroke(0);
      ellipseMode(CENTER);
      fill(255);
      ellipse(width/4, h/12, r,r);//head
      line(width/4-r*3/2+change, h/3, width/4+change, h/3);//left arm
      strokeWeight(1);
      fill(255);
      ellipse(width/4+change, h/3, 20,20);
      rectMode(CENTER);
      strokeWeight(10);
      fill(red, green, blue);
      rect(width/4, h/3, r,h/3);//body
      line(width/4-r/4, h/2, width/4-r/2-h/6, h);//left leg
      line(width/4+r/4, h/2, width/4+r/2+h/4, h*3/4);//right leg1
      line(width/4+r/2+h/4, h*3/4, width/4+r/2+h/4, h);//right leg2
      line(width/4-change, h/3, width/4+r*3/2-change, h/3);//right arm
      strokeWeight(1);
      fill(255);
      ellipse(width/4+r*3/2-change, h/3, 20,20);
      if(change>0&&change<r*3/2){
        change+=(r*(3/20)*direct);
      }
      popMatrix();
    }
    if(side==0&&stage==2){
      pushMatrix();
      translate(0, textsize+height*0.4);
      strokeWeight(10);
      stroke(0);
      ellipseMode(CENTER);
      fill(255);
      ellipse(width/4+h/6+r/2, h-r/2, r,r);
      rectMode(CENTER);
      fill(red, green, blue);
      rect(width/4, h-r/2, h/3,r);
      line(width/4-h*2/3, h-r/2, width/4-h/6, h-r/2);//legs
      line(width/4-h/12, h-r/2, width/4+h/6, h-r/2);//arms
      strokeWeight(1);
      stroke(0);
      fill(255);
      ellipse(width/4-h/12, h-r/2, 20,20);
      popMatrix();
    }
    if(side==0&&stage==3){
      pushMatrix();
      translate(0, textsize+height*0.4);
      strokeWeight(10);
      stroke(0);
      ellipseMode(CENTER);
      fill(255);
      ellipse(width/4, h/12, r,r);
      rectMode(CENTER);
      fill(red, green, blue);
      rect(width/4, h/3, r,h/3);
      line(width/4-r/4, h/2, width/4-r/4, h);//left leg
      line(width/4+r/4, h/2, width/4+r/4, h);//right leg
      line(width/4-r/2, h/6, width/4-r/2-h/4, 0);//left arm
      line(width/4+r/2, h/6, width/4+r/2+h/4, 0);//right arm
      strokeWeight(1);
      fill(255);
      ellipse(width/4-r/2-h/4, 0, 20,20);
      ellipse(width/4+r/2+h/4, 0, 20,20);
      popMatrix();
    }
    //RIGHT PLAYER
    if(side==1&&stage==0){
      pushMatrix();
      translate(width*0.5, textsize+height*0.4);
      strokeWeight(10);
      stroke(0);
      ellipseMode(CENTER);
      fill(255);
      ellipse(width/4, h/12, r,r);
      rectMode(CENTER);
      fill(red, green, blue);
      rect(width/4, h/3, r,h/3);
      line(width/4-r/4, h/2, width/4-r/4, h);//left leg
      line(width/4+r/4, h/2, width/4+r/4, h);//right leg
      line(width/4+r/2, h/6, width/4+r/2+h/6, h/3);//left arm1
      line(width/4+r/2+h/6, h/3, width/4+r/2, h/3);//left arm2
      line(width/4-r/2, h/6, width/4-r/2-h/4, h/2);//right arm
      strokeWeight(1);
      fill(255);
      ellipse(width/4+r/2, h/3, 20,20);
      ellipse(width/4-r/2-h/4, h/2, 20,20);
      popMatrix();
    }
    if(side==1&&stage==1){
      pushMatrix();
      translate(width*0.5, textsize+height*0.4);
      strokeWeight(10);
      stroke(0);
      ellipseMode(CENTER);
      fill(255);
      ellipse(width/4, h/12, r,r);//head
      line(width/4+r*3/2-change, h/3, width/4-change, h/3);//right arm
      strokeWeight(1);
      fill(255);
      ellipse(width/4-change, h/3, 20,20);
      rectMode(CENTER);
      strokeWeight(10);
      fill(red, green, blue);
      rect(width/4, h/3, r,h/3);//body
      line(width/4+r/4, h/2, width/4+r/2+h/6, h);//right leg
      line(width/4-r/4, h/2, width/4-r/2-h/4, h*3/4);//left leg1
      line(width/4-r/2-h/4, h*3/4, width/4-r/2-h/4, h);//left leg2
      line(width/4+change, h/3, width/4-r*3/2+change, h/3);//right arm
      strokeWeight(1);
      fill(255);
      ellipse(width/4-r*3/2+change, h/3, 20,20);
      if(change>0&&change<r*3/2){
        change+=(r*(3/20)*direct);
      }
      popMatrix();
    }
    if(side==1&&stage==3){
      pushMatrix();
      translate(width*0.5, textsize+height*0.4);
      strokeWeight(10);
      stroke(0);
      ellipseMode(CENTER);
      fill(255);
      ellipse(width/4-h/6-r/2, h-r/2, r,r);
      rectMode(CENTER);
      fill(red, green, blue);
      rect(width/4, h-r/2, h/3,r);
      line(width/4+h*2/3, h-r/2, width/4+h/6, h-r/2);//legs
      line(width/4+h/12, h-r/2, width/4-h/6, h-r/2);//arms
      strokeWeight(1);
      stroke(0);
      fill(255);
      ellipse(width/4+h/12, h-r/2, 20,20);
      popMatrix();
    }
    if(side==1&&stage==2){
      pushMatrix();
      translate(width*0.5, textsize+height*0.4);
      strokeWeight(10);
      stroke(0);
      ellipseMode(CENTER);
      fill(255);
      ellipse(width/4, h/12, r,r);
      rectMode(CENTER);
      fill(red, green, blue);
      rect(width/4, h/3, r,h/3);
      line(width/4-r/4, h/2, width/4-r/4, h);//left leg
      line(width/4+r/4, h/2, width/4+r/4, h);//right leg
      line(width/4-r/2, h/6, width/4-r/2-h/4, 0);//left arm
      line(width/4+r/2, h/6, width/4+r/2+h/4, 0);//right arm
      strokeWeight(1);
      fill(255);
      ellipse(width/4-r/2-h/4, 0, 20,20);
      ellipse(width/4+r/2+h/4, 0, 20,20);
      popMatrix();
    }
  }
}

class Fist  extends Object implements Objects{
  float[] fistxs = {0,width-100};
  Fist(){};
  Fist(float y, int s){
    this.y=y;
    side=s;
    this.x=fistxs[side];
    red=clr[side].getRed();
    blue = clr[side].getBlue();
    green = clr[side].getGreen();
  }
  
  void move(){
      if (side == 0){
        x+=25;
      }
      else{
        x-=25;
      }
  }
  
  void display(){
    noStroke();
    fill(red,green,blue);
    rectMode(CORNERS);
    rect(x, y, x+100,y+75);
    tint(255,126);
    if (side==0)
    image(img0, x, y, 109, 75);
    else
    image(img1,x,y,109,75);
  }
  
  void disappear(){
    if (side == 0){
      red += 15;
      green +=15;
    }
    else{
      blue +=15;
    }
  }
  
  boolean finished(){
    if(red==255&&blue==255&&green==255){
      return true;
    }
    else
    return false;
  }
}

class Color{
  int r,b,g;
  Color(int red, int green, int blue){
    r=red;
    b=blue;
    g=green;
  }
  int getRed(){
  return r;
  }
  int getBlue(){
  return b;
  }
  int getGreen(){
  return g;
  }
}

class BloodBoard implements Objects{
  float bloodw,bloodh;
  BloodBoard(float w, float h){
    bloodw=w;
    bloodh=h*0.2;
  }
  void display(){
    stroke(0);
    strokeWeight(1);
    fill(0,0,255);
    rectMode(CORNER);
    rect(0, textsize, bloodw, bloodh);
    pushMatrix();
    translate(bloodw, 0);
    fill(255,255,0);
    rect(0, textsize,width-bloodw,bloodh);
    popMatrix();
    line(bloodw, textsize,bloodw,height);
  }
}

class HitSound extends Fist implements Objects{
  float temp;
  int i;
  HitSound(float x, float y, int s){
    this.x = x;
    this.y = y;
    side = s;
    red=clr[side].getRed();
    blue = clr[side].getBlue();
    green = clr[side].getGreen();
  }
  void display(){
    textSize(height*0.15);
    textAlign(LEFT);
    fill(red, green, blue);
    if (side == 0){
    text("Ola", x, y);
    }
    else{
    text("Muda", x, y);
    }
  }
  void record(){
    sounds[hitL-1][0]=x;
    sounds[hitL-1][1]=y;
    for(int i=hitL-1; i>0;i--){
      for(int j=0;j<2;j++){
        if(sounds[i][j]<sounds[i-1][j]){
        temp=sounds[i-1][j];
        sounds[i-1][j]=sounds[i][j];
        sounds[i][j]=temp;
        }
      }
    }
  }
}

void output(){
  for(int i =0;i<hitL;i++){
      output.println(i+":"+sounds[i][0]+"   "+sounds[i][1]);
      }  
}



void restart(){
    fill(255);
    ellipse(width*0.5, height*0.3, width*0.35, height*0.2);
    textSize(textsize);
    fill(0);
    textAlign(CENTER);
    text("Press R to restart", width*0.5, height*0.3);
    finish=1;
    round++;
    noLoop();
}

void stopTime(){
    fill(140,4);
    noStroke();
    ellipse(mousex,mousey,radius,radius);
    magnify();
    if(radius>2000)
    stop*=-1;
}

void magnify(){
  radius+=30;
  if(radius<100)
  magnify();
}

void instruction(){
  rectMode(CENTER);
  strokeWeight(5);
  fill(255);
  rect(width/2,height/2, width*7/8, height);
  textAlign(LEFT);
  textSize(textsize);
  fill(0);
  text("INSTRUCTIONS:\nA&S/K&L: panch\nP: switch mode(PVP/C)\nF: harder in PVC\nG: easier in PVC\nM: open or close search\nN: enter number\nC: output a sorted list of coordinations of sounds \nand close the program\nmouseCLICK: ???(CHEAT!!!)\nI: open and close instructions",width/6.5,height/6);
}

void mouseClicked(){
  stop*=-1;
  mousex=mouseX;
  mousey=mouseY;
}

void keyPressed(){
  if (finish==0&&(key == 65||key == 97||key == 83||key == 115)) {//hitL
    fistsL.add(new Fist(random(textsize+height*0.4,height), 0));
    hitsoundsL.add(new HitSound(random(battleLine-100),random(textsize+height*0.35, textsize+height*0.4), 0));
   hitL++;
   directL*=-1;
    if(directL==1)
    change=(height*0.6-textsize)/40;
    if(directL==-1)
    change=(height*0.6-textsize)*9/40;
  }
  if (finish==0&&stop > 0&&mode>0&&(key == 75||key == 76||key == 107||key == 108)) {
    fistsR.add(new Fist(random(textsize+height*0.4,height), 1));
    hitsoundsR.add(new HitSound(random(battleLine, width-206), random(textsize+height*0.35, textsize+height*0.4), 1));
    hitR++;
    directR*=-1;
    if(directR==1)
    change=(height*0.6-textsize)/40;
    if(directR==-1)
    change=(height*0.6-textsize)*9/40;
  }
  if (finish==0&&(key==80||key==112)){//mode change
    mode*=-1;
  }
  if (finish==0&&mode<0&&(key==70||key==102)){//harder
    hardness+=2;
  }
  if (finish==0&&mode<0&&(key==71||key==103)){//easier
    if(hardness>0)
    hardness-=2;
  }
  if (key == 82||key==114){//restart
    finish=0;
    setup();
    loop();
  }
  if(key==67||key==99){
  output();
  output.flush();
  output.close();
  exit();
  }
  if(finish==0&&(key==77||key==109)){    
    if(search>0)
    search=0;
    else
    search=1;
  }
   if(search==3&&key>47&&key<58){
    num3=key-48;
    search=4;
  }
  if(search==2&&key>47&&key<58){
    num2=key-48;
    search=3;
  }
  if(search==1&&key>47&&key<58){
    num1=key-48;
    search=2;
  }
  if(key==78||key==110)
  search=5;
  if(key==73||key==105)
  instruct*=-1;
}
