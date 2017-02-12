class ImageStructure {
  private String imagePath;
  private PImage img;
  private PImage thumbnail;
  private float aspectRatio;
  
  private PVector thumbnailCenter;
  private PVector thumbnailTopLeft;
  private PVector thumbnailBottomRight;
  
  private PVector imageTopLeft;
  private PVector imageBottomRight;
  
  public ImageStructure() {
    init();
  }
  
  public ImageStructure(String path) {
    init();
    load(path);
  }
  
  public ImageStructure(String path, float posx, float posy) {
    init();
    load(path);
    setCenterPosition(posx, posy);
  }
  
  private void init() {
    imagePath = "";
    img = null;
    thumbnail = null;
  }
  
  public void load(String path) {
    if(path.toLowerCase().endsWith("png") || path.toLowerCase().endsWith("jpg") || path.toLowerCase().endsWith("jpeg")) {
      try {
        img = loadImage(path);
      }
      catch (Exception e){
        println(e);
      }
      println("Image loaded from "+path);
      
      imagePath = path;
      aspectRatio = (float)img.width / (float)img.height;
      float screenAspectRatio = (float)width / (float)height;
      if(aspectRatio > screenAspectRatio) {
        img.resize(int(width*0.8), 0);
        imageTopLeft = new PVector(width*0.1, (height - img.height) * 0.5);
        imageBottomRight = new PVector(width*0.9, (height + img.height) * 0.5);
      } else {
        img.resize(0, int(height*0.8));
        imageTopLeft = new PVector((width - img.width)*0.5, height * 0.1);
        imageBottomRight = new PVector((width + img.width)*0.5, height * 0.9);
      }
      thumbnail = img.copy();
      if(aspectRatio > 1) {
        thumbnail.resize(thumbnailSize, 0);
      } else {
        thumbnail.resize(0, thumbnailSize);
      }
      thumbnailCenter = new PVector(random(thumbnailSize/2, width-thumbnailSize), random(thumbnailSize/2, height-thumbnailSize));
      thumbnailTopLeft = new PVector(thumbnailCenter.x - thumbnail.width/2, thumbnailCenter.y - thumbnail.height/2);
      thumbnailBottomRight = new PVector(thumbnailCenter.x + thumbnail.width/2, thumbnailCenter.y + thumbnail.height/2);
    } else {
      println(path + " is not a jpg or png image");
    }
  }
  
  public void setCenterPosition(float x, float y) {
    thumbnailCenter.x = x;
    thumbnailCenter.y = y;
    thumbnailTopLeft.x = thumbnailCenter.x - thumbnail.width/2;
    thumbnailTopLeft.y = thumbnailCenter.y - thumbnail.height/2;
    thumbnailBottomRight.x = thumbnailCenter.x + thumbnail.width/2;
    thumbnailBottomRight.y = thumbnailCenter.y + thumbnail.height/2;
  }
  
  public PVector getCenter() {
    return thumbnailCenter;
  }
  
  public void drawThumbnail() {
    image(thumbnail, thumbnailCenter.x, thumbnailCenter.y);
  }
  
  public void drawEnlarged() {   
    image(img, width/2, height/2);
  }
  
  public boolean mouseOverThumbnail() {
    return mouseX >= thumbnailTopLeft.x && 
          mouseY >= thumbnailTopLeft.y && 
          mouseX <= thumbnailBottomRight.x && 
          mouseY <= thumbnailBottomRight.y;
  }
  
  public boolean mouseOverEnlarged() {
    return mouseX >= imageTopLeft.x && 
          mouseY >= imageTopLeft.y && 
          mouseX <= imageBottomRight.x && 
          mouseY <= imageBottomRight.y;
  }
  
  public float[] getRect() {
    float rect[] = {thumbnailTopLeft.x, 
                    thumbnailTopLeft.y, 
                    thumbnailBottomRight.x - thumbnailTopLeft.x,
                    thumbnailBottomRight.y - thumbnailTopLeft.y};
    return rect;
  }
  
  public PVector getBottomLeftCorner() {
    return new PVector(imageTopLeft.x, imageBottomRight.y);
  }
  
  public String toString() {
    return imagePath;
  }
}