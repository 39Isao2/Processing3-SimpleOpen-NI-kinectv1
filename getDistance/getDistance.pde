import SimpleOpenNI.*;
SimpleOpenNI kinect;

// kinectからの距離
float distance;

void setup() {
  size(640, 480);
  kinect = new SimpleOpenNI(this);

  // RGB カメラon
  kinect.enableRGB();

  // 深度カメラon
  kinect.enableDepth();

  // 左右反転
  kinect.setMirror(true);

  // 赤外線カメラとRGBカメラの位置補正で人物の領域一致
  kinect.alternativeViewPointDepthToImage();

  // 人物認識機能on
  kinect.enableUser();

  // 人からkinectまでの距離
  distance = 0;

}

void draw() {

  // 背景白
  background(255);

  // kinect情報アップデート
  kinect.update();


  int[] userMap = null;
  int userCount = kinect.getNumberOfUsers();
  if (userCount > 0) {
    userMap = kinect.userMap();
  }

  loadPixels();
  for (int y=0; y<kinect.rgbHeight(); y++){
    for (int x=0; x<kinect.rgbWidth(); x++){
      int i = x + y * kinect.rgbWidth();

      // 人物検知領域の
      if (userMap != null && userMap[i] > 0){
        pixels[i]=kinect.rgbImage().pixels[i];

        // 実空間のx,y,zに変換
        PVector r_pos = kinect.depthMapRealWorld()[i];

        // 実空間のz座標取得（距離取得）
        distance = r_pos.z;
      }
    }

  }
  updatePixels();

  // 約何mmか出力
  println("約" + distance + "mmです。");


}



/*

for文で人物領域全体のピクセル情報見に行ってるので、
もっといい処理あると思う。
printlnしたらいい感じの値が返ってきたので取り急ぎよし。

*/
