import SimpleOpenNI.*;

// SimpleOpenNI
SimpleOpenNI kinect;

void setup(){ 
  size(640, 480);

  kinect = new SimpleOpenNI(this);

  kinect.enableDepth(); 

  kinect.enableUser();
}


void draw(){

  kinect.update();


  // 深度画像取得して表示
  PImage depth = kinect.depthImage();
  image(depth, 0, 0);


  // 検出した人たちをuserListにいれる
  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  // 一人以上検出してたら
  if(userList.size() > 0){

    // 一人目のID取得
    int userId = userList.get(0);

    //  一人目の骨格を見にいく
    if(kinect.isTrackingSkeleton(userId)) {

      //  頭の(x,y,z)座標取得 
      PVector headPos = new PVector();
      kinect.getJointPositionSkeleton( userId,SimpleOpenNI.SKEL_HEAD,headPos );



      // 顔の位置入れとくPVector用意
      PVector convertedHeadPos = new PVector();

        //丸書くために、現実世界の座標から、スクリーンの2次元のx,y座標に変換（多分）
        kinect.convertRealWorldToProjective( headPos, convertedHeadPos );

        // 青丸描画
        fill(255, 0, 0);
        ellipse(convertedHeadPos.x, convertedHeadPos.y,50,50 );
      }
    }
}



// 新しいuser検知した時
void onNewUser( SimpleOpenNI kinect, int userId ){
  println("Detection Start");
  kinect.startTrackingSkeleton(userId); 
}
