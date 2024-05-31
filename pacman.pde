//マップの座標変数たち
int a1,a2,a3,a4,a5,a6,a7,a8,a9,a10;
int b1,b2,b3,b4,b5,b6,b7,b8,b9,b10;
//線の太さ(px)
int w = 10;

//パックマンの初期座標と大きさ
int x = 130; 
int y = 305;
int s = 36;

//敵の初期座標と大きさ、最初の動く方向
int ex1 = 250;
int ey1 = 180;
int ex2 = 250;
int ey2 = 540;
int es = 28;
int random_move1 = 0;
int random_move2 = 1;
float count = 3000;


//

float kx1 = random(25,475),kx2 = random(25,475),kx3 = random(25,475),kx4 = random(25,475);
float kx5 = random(25,475),kx6 = random(25,475),kx7 = random(25,475),kx8 = random(25,475);
float kx9 = random(25,475),kx10 = random(25,475),kx11 = random(25,475),kx12 = random(25,475);
float kx13 = random(25,475),kx14 = random(25,475),kx15 = random(25,475),kx16 = random(25,475);
float ky1 = 50, ky2 = 180, ky3 = 430, ky4 = 540;
int kh = 5, kw  = 10;

//パックマンと壁の最短距離
int r = (w+s)/2 + 2;
//衝突時の座標
int r2 = r + 2;
//敵とパックマンの距離
float dist1,dist2 ;
int rest = 16;


void setup(){
  size(500,650);
  frameRate(100);
  //座標の設定
  a1 = 10;
  a2 = 70;
  a3 = 100;
  a4 = 160;
  a5 =220;
  a6 = 280;
  a7 = 340;
  a8 = 400;
  a9 = 430;
  a10 = 490;

  b1 = 20;
  b2 = 80;
  b3 = 150;
  b4 = 210;
  b5 = 270;
  b6 = 340;
  b7 = 400;
  b8 = 460;
  b9 = 510;
  b10 = 570;
  key_create();
}
 
void draw(){
  if (pac_enemy() || count/100 == 0){
    background(255);
    fill(#FF0000);
    textSize(40);
    text("GAME OVER", width/3, height/2);
    count = 0;
    x = ex1 = ex2 = 250;
    y = ey1 = ey2 = 400;
    
  }else if (rest == 0){
    background(255);
    fill(#0868FF);
    textSize(40);
    text("CLEAR", width/3, height/2);
    count = 0;
    x = ex1 = ex2 = 250;
    y = 400;
    ey1 = ey2 = 250;
  }else
    background(0);
    if (keyPressed){
      //もし→が押されたれたら
      if (keyCode == RIGHT){
        x += 2;
      }
      //もし←が押されたれたら
      else if (keyCode == LEFT){
        x -= 2;
      }
      //もし↑が押されたれたら
      else if (keyCode == UP){
        y -= 2;
      }
      //もし↓が押されたれたら
      else if(keyCode == DOWN){
        y += 2;
      }
    }
    //マップ作成
    cage();
    //
    textSize(30);
    text("rest:" + rest,60,610);
    text("time left:" + count/100,300,610);
    
    //パックマン接触判定
    undo(x,y);
    
    //敵1・2の接触判定
    enemy1_undo(ex1,ey1);
    enemy2_undo(ex2,ey2);
    
    key_create();
      
    //パックマン描写
    fill(#FFF939);
    noStroke();
    arc(x,y,s,s,QUARTER_PI,7*QUARTER_PI);
    
    //敵1の描写
    enemy_move1();
    rectMode(CENTER);
    fill(#FF29F1);
    rect(ex1,ey1,es,es);
    //敵2の描写
    enemy_move2();
    rectMode(CENTER);
    fill(#FF29F1);
    rect(ex2,ey2,es,es);
    count -= 1;
}

//壁との接触判定のための関数
boolean collision(int k,int l,int m,int n,int o,int p){
  PVector start_to_center = new PVector(o-k,p-l);
  PVector end_to_center = new PVector(o-m,p-n);
  PVector start_to_end = new PVector(m-k,n-l);
  PVector normal_start_to_end = new PVector();
  start_to_end.normalize(normal_start_to_end);
  
  float cross_distance = start_to_center.x*normal_start_to_end.y - start_to_center.y*normal_start_to_end.x;
  float dot_start =  start_to_center.x * start_to_end.x + start_to_center.y * start_to_end.y;
  float dot_end =  end_to_center.x * start_to_end.x + end_to_center.y * start_to_end.y;
  
  if (abs(cross_distance) < r){
    if (dot_start*dot_end <= 0){
      return true;
    }else if(mag(start_to_center.x,start_to_center.y) < r || mag(end_to_center.x,end_to_center.y) < r){
      return true;
    }else return false;
  }else return false;
}

//敵の方向転換のための接触判定関数
boolean collision2(int k,int l,int m,int n,int o,int p){
  PVector start_to_center = new PVector(o-k,p-l);
  PVector end_to_center = new PVector(o-m,p-n);
  PVector start_to_end = new PVector(m-k,n-l);
  PVector normal_start_to_end = new PVector();
  start_to_end.normalize(normal_start_to_end);
  
  float cross_distance = start_to_center.x*normal_start_to_end.y - start_to_center.y*normal_start_to_end.x;
  float dot_start =  start_to_center.x * start_to_end.x + start_to_center.y * start_to_end.y;
  float dot_end =  end_to_center.x * start_to_end.x + end_to_center.y * start_to_end.y;
  
  if (abs(cross_distance) < r + 1){
    if (dot_start*dot_end <= 0){
      return true;
    }else if(mag(start_to_center.x,start_to_center.y) <= r + 2 || mag(end_to_center.x,end_to_center.y) <= r + 2){
      return true;
    }else return false;
  }else return false;
}


//パックマンの接触判定と座標変換の関数
void undo(int q,int r){
  //中央の連絡通路
  if (x <= 10  && (b5 <= y && y <= b6)){
    x = 500;
  }else if (x >= 500  && (b5 <= y && y <= b6)){
    x = 10;
  }
  //外枠
  //上半分
  if (collision(a1,b1,a1,b4,q,r)){
    x = a1 +r2;
  }if (collision(a1,b1,a10,b1,q,r)){
    y = b1 + r2;
  }if (collision(a10,b1,a10,b4,q,r)){
    x = a10 - r2;
  }if (collision(a1,b4,a3,b4,q,r)){
    y = b4 - r2;
  }if (collision(a8,b4,a10,b4,q,r)){
    y = b4 - r2;
  }if (collision(a3,b4,a3,b5,q,r)){
    x = a3 + r2;
  }if (collision(a8,b4,a8,b5,q,r)){
    x = a8 - r2;
  }if (collision(a1,b5,a3,b5,q,r)){
    y = b5 + r2;
  }if (collision(a8,b5,a10,b5,q,r)){
    y = b5 + r2;
  }
  //下半分
  if (collision(a1,b6,a3,b6,q,r)){
    y = b6 - r2;
  }if (collision(a8,b6,a10,b6,q,r)){
    y = b6 - r2;
  }if (collision(a3,b6,a3,b7,q,r)){
    x = a3 + r2;
  }if (collision(a8,b6,a8,b7,q,r)){
    x = a8 - r2;
  }if (collision(a1,b7,a3,b7,q,r)){
    y = b7 + r2;
  }if (collision(a8,b7,a10,b7,q,r)){
    y = b7 + r2;
  }if (collision(a1,b7,a1,b10,q,r)){
    x= a1 + r2;
  }if (collision(a10,b7,a10,b10,q,r)){
    x = a10 - r2;
  }if (collision(a1,b10,a10,b10,q,r)){
    y = b10 - r2;
  }
  //中身中央
  if (collision(a4,b4,a4,b7,q,r)){
    x = a4 - r2;
  }if (collision(a4,b4,a7,b4,q,r)){
    y = b4 - r2;
  }if (collision(a7,b4,a7,b7,q,r)){
    x = a7 + r2;
  }if (collision(a4,b7,a7,b7,q,r)){
    y = b7 + r2;
  }
  //中身上
  if (collision(a2,b2,a5,b2,q,r)){
    y = b2 - r2;
  }if (collision(a2,b2,a2,b3,q,r)){
    x = a2 - r2;
  }if (collision(a2,b3,a5,b3,q,r)){
    y = b3 + r2;
  }if (collision(a5,b2,a5,b3,q,r)){
    x = a5 + r2;
  }if (collision(a6,b2,a9,b2,q,r)){
    y = b2 - r2;
  }if (collision(a6,b2,a6,b3,q,r)){
    x = a6 - r2;
  }if (collision(a6,b3,a9,b3,q,r)){
    y = b3 + r2;
  }if (collision(a9,b2,a9,b3,q,r)){
    x = a9 + r2;
  }
  //中身下
  if (collision(a2,b8,a5,b8,q,r)){
    y = b8 - r2;
  }if (collision(a2,b8,a2,b9,q,r)){
    x = a2 - r2;
  }if (collision(a2,b9,a5,b9,q,r)){
    y = b9 + r2;
  }if (collision(a5,b8,a5,b9,q,r)){
    x = a5 + r2;
  }if (collision(a6,b8,a9,b8,q,r)){
    y = b8 - r2;
  }if (collision(a6,b8,a6,b9,q,r)){
    x = a6 - r2;
  }if (collision(a6,b9,a9,b9,q,r)){
    y = b9 + r2;
  }if (collision(a9,b8,a9,b9,q,r)){
    x = a9 + r2;
  }
}


//敵1の接触判定と座標変換の関数;
void enemy1_undo(int q,int r){
  //中央の連絡通路
  if (ex1 <= 10  && (b5 <= ey1 && ey1 <= b6)){
    ex1 = 500;
  }else if (ex1 >= 500  && (b5 <= ey1 && ey1 <= b6)){
    ex1 = 10;
  }
  //外枠
  //上半分
  if (collision(a1,b1,a1,b4,q,r)){
    ex1 = a1 + r2;
  }if (collision(a1,b1,a10,b1,q,r)){
    ey1 = b1 + r2;
  }if (collision(a10,b1,a10,b4,q,r)){
    ex1 = a10 - r2;
  }if (collision(a1,b4,a3,b4,q,r)){
    ey1 = b4 - r2;
  }if (collision(a8,b4,a10,b4,q,r)){
    ey1 = b4 - r2;
  }if (collision(a3,b4,a3,b5,q,r)){
    ex1 = a3 + r2;
  }if (collision(a8,b4,a8,b5,q,r)){
    ex1 = a8 - r2;
  }if (collision(a1,b5,a3,b5,q,r)){
    ey1 = b5 + r2;
  }if (collision(a8,b5,a10,b5,q,r)){
    ey1 = b5 + r2;
  }
  //下半分
  if (collision(a1,b6,a3,b6,q,r)){
    ey1 = b6 - r2;
  }if (collision(a8,b6,a10,b6,q,r)){
    ey1 = b6 - r2;
  }if (collision(a3,b6,a3,b7,q,r)){
    ex1 = a3 + r2;
  }if (collision(a8,b6,a8,b7,q,r)){
    ex1 = a8 - r2;
  }if (collision(a1,b7,a3,b7,q,r)){
    ey1 = b7 + r2;
  }if (collision(a8,b7,a10,b7,q,r)){
    ey1 = b7 + r2;
  }if (collision(a1,b7,a1,b10,q,r)){
    ex1= a1 + r2;
  }if (collision(a10,b7,a10,b10,q,r)){
    ex1 = a10 - r2;
  }if (collision(a1,b10,a10,b10,q,r)){
    ey1 = b10 - r2;
  }
  //中身中央
  if (collision(a4,b4,a4,b7,q,r)){
    ex1 = a4 - r2;
  }if (collision(a4,b4,a7,b4,q,r)){
    ey1 = b4 - r2;
  }if (collision(a7,b4,a7,b7,q,r)){
    ex1 = a7 + r2;
  }if (collision(a4,b7,a7,b7,q,r)){
    ey1 = b7 + r2;
  }
  //中身上
  if (collision(a2,b2,a5,b2,q,r)){
    ey1 = b2 - r2;
  }if (collision(a2,b2,a2,b3,q,r)){
    ex1 = a2 - r2;
  }if (collision(a2,b3,a5,b3,q,r)){
    ey1 = b3 + r2;
  }if (collision(a5,b2,a5,b3,q,r)){
    ex1 = a5 + r2;
  }if (collision(a6,b2,a9,b2,q,r)){
    ey1 = b2 - r2;
  }if (collision(a6,b2,a6,b3,q,r)){
    ex1 = a6 - r2;
  }if (collision(a6,b3,a9,b3,q,r)){
    ey1 = b3 + r2;
  }if (collision(a9,b2,a9,b3,q,r)){
    ex1 = a9 + r2;
  }
  //中身下
  if (collision(a2,b8,a5,b8,q,r)){
    ey1 = b8 - r2;
  }if (collision(a2,b8,a2,b9,q,r)){
    ex1 = a2 - r2;
  }if (collision(a2,b9,a5,b9,q,r)){
    ey1 = b9 + r2;
  }if (collision(a5,b8,a5,b9,q,r)){
    ex1 = a5 + r2;
  }if (collision(a6,b8,a9,b8,q,r)){
    ey1 = b8 - r2;
  }if (collision(a6,b8,a6,b9,q,r)){
    ex1 = a6 - r2;
  }if (collision(a6,b9,a9,b9,q,r)){
    ey1 = b9 + r2;
  }if (collision(a9,b8,a9,b9,q,r)){
    ex1 = a9 + r2;
  }
}

//敵2の接触判定と座標変換の関数;
void enemy2_undo(int q,int r){
  //中央の連絡通路
  if (ex1 <= 10  && (b5 <= ey1 && ey1 <= b6)){
    ex2 = 500;
  }else if (ex1 >= 500  && (b5 <= ey1 && ey1 <= b6)){
    ex2 = 10;
  }
  //外枠
  //上半分
  if (collision(a1,b1,a1,b4,q,r)){
    ex2 = a1 + r2;
  }if (collision(a1,b1,a10,b1,q,r)){
    ey2 = b1 + r2;
  }if (collision(a10,b1,a10,b4,q,r)){
    ex2 = a10 - r2;
  }if (collision(a1,b4,a3,b4,q,r)){
    ey2 = b4 - r2;
  }if (collision(a8,b4,a10,b4,q,r)){
    ey2 = b4 - r2;
  }if (collision(a3,b4,a3,b5,q,r)){
    ex2 = a3 + r2;
  }if (collision(a8,b4,a8,b5,q,r)){
    ex2 = a8 - r2;
  }if (collision(a1,b5,a3,b5,q,r)){
    ey2 = b5 + r2;
  }if (collision(a8,b5,a10,b5,q,r)){
    ey2 = b5 + r2;
  }
  //下2分
  if (collision(a1,b6,a3,b6,q,r)){
    ey2 = b6 - r2;
  }if (collision(a8,b6,a10,b6,q,r)){
    ey2 = b6 - r2;
  }if (collision(a3,b6,a3,b7,q,r)){
    ex2 = a3 + r2;
  }if (collision(a8,b6,a8,b7,q,r)){
    ex2 = a8 - r2;
  }if (collision(a1,b7,a3,b7,q,r)){
    ey2 = b7 + r2;
  }if (collision(a8,b7,a10,b7,q,r)){
    ey2 = b7 + r2;
  }if (collision(a1,b7,a1,b10,q,r)){
    ex2= a1 + r2;
  }if (collision(a10,b7,a10,b10,q,r)){
    ex2 = a10 - r2;
  }if (collision(a1,b10,a10,b10,q,r)){
    ey2 = b10 - r2;
  }
  //中身中央
  if (collision(a4,b4,a4,b7,q,r)){
    ex2 = a4 - r2;
  }if (collision(a4,b4,a7,b4,q,r)){
    ey2 = b4 - r2;
  }if (collision(a7,b4,a7,b7,q,r)){
    ex2 = a7 + r2;
  }if (collision(a4,b7,a7,b7,q,r)){
    ey2 = b7 + r2;
  }
  //中身上
  if (collision(a2,b2,a5,b2,q,r)){
    ey2 = b2 - r2;
  }if (collision(a2,b2,a2,b3,q,r)){
    ex2 = a2 - r2;
  }if (collision(a2,b3,a5,b3,q,r)){
    ey2 = b3 + r2;
  }if (collision(a5,b2,a5,b3,q,r)){
    ex2 = a5 + r2;
  }if (collision(a6,b2,a9,b2,q,r)){
    ey2 = b2 - r2;
  }if (collision(a6,b2,a6,b3,q,r)){
    ex2 = a6 - r2;
  }if (collision(a6,b3,a9,b3,q,r)){
    ey2 = b3 + r2;
  }if (collision(a9,b2,a9,b3,q,r)){
    ex2 = a9 + r2;
  }
  //中身下
  if (collision(a2,b8,a5,b8,q,r)){
    ey2 = b8 - r2;
  }if (collision(a2,b8,a2,b9,q,r)){
    ex2 = a2 - r2;
  }if (collision(a2,b9,a5,b9,q,r)){
    ey2 = b9 + r2;
  }if (collision(a5,b8,a5,b9,q,r)){
    ex2 = a5 + r2;
  }if (collision(a6,b8,a9,b8,q,r)){
    ey2 = b8 - r2;
  }if (collision(a6,b8,a6,b9,q,r)){
    ex2 = a6 - r2;
  }if (collision(a6,b9,a9,b9,q,r)){
    ey2 = b9 + r2;
  }if (collision(a9,b8,a9,b9,q,r)){
    ex2 = a9 + r2;
  }
}

//どこかに当たっているかの判定,敵の動きを変えるため。
boolean enemy_contact(int q, int r){
  //外枠
  //上半分
  if (collision2(a1,b1,a1,b4,q,r)){
    return true;
  }else if (collision2(a1,b1,a10,b1,q,r)){
    return true;
  }else if (collision2(a10,b1,a10,b4,q,r)){
    return true;
  }else if (collision2(a1,b4,a3,b4,q,r)){
    return true;
  }else if (collision2(a8,b4,a10,b4,q,r)){
    return true;
  }else if (collision2(a3,b4,a3,b5,q,r)){
    return true;
  }else if (collision2(a8,b4,a8,b5,q,r)){
    return true;
  }else if (collision2(a1,b5,a3,b5,q,r)){
    return true;
  }else if (collision2(a8,b5,a10,b5,q,r)){
    return true;
  }else if (collision2(a1,b6,a3,b6,q,r)){ //下半分
    return true;
  }else if (collision2(a8,b6,a10,b6,q,r)){
    return true;
  }else if (collision2(a3,b6,a3,b7,q,r)){
    return true;
  }else if (collision2(a8,b6,a8,b7,q,r)){
    return true;
  }else if (collision2(a1,b7,a3,b7,q,r)){
    return true;
  }else if (collision2(a8,b7,a10,b7,q,r)){
    return true;
  }else if (collision2(a1,b7,a1,b10,q,r)){
    return true;
  }else if (collision2(a10,b7,a10,b10,q,r)){
    return true;
  }else if (collision2(a1,b10,a10,b10,q,r)){
    return true;
  }else if (collision2(a4,b4,a4,b7,q,r)){ //中身中央
    return true;
  }else if (collision2(a4,b4,a7,b4,q,r)){
    return true;
  }else if (collision2(a7,b4,a7,b7,q,r)){
    return true;
  }else if (collision2(a4,b7,a7,b7,q,r)){
    return true;
  }else if (collision2(a2,b2,a5,b2,q,r)){ //中身上
    return true;
  }else if (collision2(a2,b2,a2,b3,q,r)){
    return true;
  }else if (collision2(a2,b3,a5,b3,q,r)){
    return true;
  }else if (collision2(a5,b2,a5,b3,q,r)){
    return true;
  }else if (collision2(a6,b2,a9,b2,q,r)){
    return true;
  }else if (collision2(a6,b2,a6,b3,q,r)){
    return true;
  }else if (collision2(a6,b3,a9,b3,q,r)){
    return true;
  }else if (collision2(a9,b2,a9,b3,q,r)){
    return true;
  }else if (collision2(a2,b8,a5,b8,q,r)){ //中身下
    return true;
  }else if (collision2(a2,b8,a2,b9,q,r)){
    return true;
  }else if (collision2(a2,b9,a5,b9,q,r)){
    return true;
  }else if (collision2(a5,b8,a5,b9,q,r)){
    return true;
  }else if (collision2(a6,b8,a9,b8,q,r)){
    return true;
  }else if (collision2(a6,b8,a6,b9,q,r)){
    return true;
  }else if (collision2(a6,b9,a9,b9,q,r)){
    return true;
  }else if (collision2(a9,b8,a9,b9,q,r)){
    return true;
  }else return false;
}

//敵1の移動関数、壁に接触したらランダムに方向転換する。それ以外は等速直線運動
void enemy_move1(){
  if (enemy_contact(ex1,ey1)){
    random_move1 = floor(random(4));
    if (random_move1 == 0 ){
      ex1 += 2;
    }else if (random_move1 == 1){
      ex1 -= 2;
    } else if (random_move1 == 2){
      ey1 += 2;
    } else if (random_move1 == 3){
      ey1 -= 2;
    }
  }else{
    if (random_move1 == 0 ){
      ex1 += 2;
    }else if (random_move1 == 1){
      ex1 -= 2;
    } else if (random_move1 == 2){
      ey1 += 2;
    } else if (random_move1 == 3){
      ey1 -= 2;
    }
  }
}

//敵2の移動関数、壁に接触したらランダムに方向転換する。それ以外は等速直線運動
void enemy_move2(){
  if (enemy_contact(ex2,ey2)){
    random_move2 = floor(random(4));
    if (random_move2 == 0 ){
      ex2 += 2;
    }else if (random_move2 == 1){
      ex2 -= 2;
    } else if (random_move2 == 2){
      ey2 += 2;
    } else if (random_move2 == 3){
      ey2 -= 2;
    }
  }else{
    if (random_move2 == 0 ){
      ex2 += 2;
    }else if (random_move2 == 1){
      ex2 -= 2;
    } else if (random_move2 == 2){
      ey2 += 2;
    } else if (random_move2 == 3){
      ey2 -= 2;
    }
  }
}


//マップの青い線の関数
void cage(){
  strokeWeight(w);
  stroke(#294EFF);
  
  //外枠
  //上半分
  line(a1,b1,a10,b1);
  line(a1,b1,a1,b4);
  line(a10,b1,a10,b4);
  line(a1,b4,a3,b4);
  line(a8,b4,a10,b4);
  line(a3,b4,a3,b5);
  line(a8,b4,a8,b5);
  line(a1,b5,a3,b5);
  line(a8,b5,a10,b5);
  //下半分
  line(a1,b6,a3,b6);
  line(a8,b6,a10,b6);
  line(a3,b6,a3,b7);
  line(a8,b6,a8,b7);
  line(a1,b7,a3,b7);
  line(a8,b7,a10,b7);
  line(a1,b7,a1,b10);
  line(a10,b7,a10,b10);
  line(a1,b10,a10,b10);
  
  //中身中央
  line(a4,b4,a4,b7);
  line(a4,b4,a7,b4);
  line(a7,b4,a7,b7);
  line(a4,b7,a7,b7);
  //中身上
  line(a2,b2,a5,b2);
  line(a2,b2,a2,b3);
  line(a2,b3,a5,b3);
  line(a5,b2,a5,b3);
  line(a6,b2,a9,b2);
  line(a6,b2,a6,b3);
  line(a6,b3,a9,b3);
  line(a9,b2,a9,b3);
  //中身下
  line(a2,b8,a5,b8);
  line(a2,b8,a2,b9);
  line(a2,b9,a5,b9);
  line(a5,b8,a5,b9);
  line(a6,b8,a9,b8);
  line(a6,b8,a6,b9);
  line(a6,b9,a9,b9);
  line(a9,b8,a9,b9);
}

boolean pac_enemy(){
  dist1 = dist(x,y,ex1,ey1);
  dist2 = dist(x,y,ex2,ey2);
  if (dist1 <= 32 || dist2 <= 32){
    return true;
  }else return false;
}

//パックマンと鍵の接触判定
boolean key_contact(float s,float t){
  if (dist(x,y,s,t) <= 18){
    return true;
  }else return false;
}
  
  
  
//鍵の配置
void key_create(){
    noStroke();
    fill(#FF9429);
    if (key_contact(kx1,ky1)){
      kx1 = 1000;
      rest -= 1;
    }else if (key_contact(kx2,ky2)){
      kx2 = 1000;
      rest -= 1;
    }else if (key_contact(kx3,ky3)){
      kx3 = 1000;
      rest -= 1;
    }else if (key_contact(kx4,ky4)){
      kx4 = 1000;
      rest -= 1;
    }else if (key_contact(kx5,ky1)){
      kx5 = 1000;
      rest -= 1;
    }else if (key_contact(kx6,ky2)){
      kx6 = 1000;
      rest -= 1;
    }else if (key_contact(kx7,ky3)){
      kx7 = 1000;
      rest -= 1;
    }else if (key_contact(kx8,ky4)){
      kx8 = 1000;
      rest -= 1;
    }else if (key_contact(kx9,ky1)){
      kx9 = 1000;
      rest -= 1;
    }else if (key_contact(kx10,ky2)){
      kx10 = 1000;
      rest -= 1;
    }else if (key_contact(kx11,ky3)){
      kx11 = 1000;
      rest -= 1;
    }else if (key_contact(kx12,ky4)){
      kx12 = 1000;
      rest -= 1;
    }else if (key_contact(kx13,ky1)){
      kx13 = 1000;
      rest -= 1;
    }else if (key_contact(kx14,ky2)){
      kx14 = 1000;
      rest -= 1;
    }else if (key_contact(kx15,ky3)){
      kx15 = 1000;
      rest -= 1;
    }else if (key_contact(kx16,ky4)){
      kx16 = 1000;
      rest -= 1;
    }
    ellipse(kx1,ky1,kh,kw);
    ellipse(kx2,ky2,kh,kw);
    ellipse(kx3,ky3,kh,kw);
    ellipse(kx4,ky4,kh,kw);
    ellipse(kx5,ky1,kh,kw);
    ellipse(kx6,ky2,kh,kw);
    ellipse(kx7,ky3,kh,kw);
    ellipse(kx8,ky4,kh,kw);
    ellipse(kx9,ky1,kh,kw);
    ellipse(kx10,ky2,kh,kw);
    ellipse(kx11,ky3,kh,kw);
    ellipse(kx12,ky4,kh,kw);
    ellipse(kx13,ky1,kh,kw);
    ellipse(kx14,ky2,kh,kw);
    ellipse(kx15,ky3,kh,kw);
    ellipse(kx16,ky4,kh,kw);
}








  
