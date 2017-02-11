class ImageStructure {
  private String imagePath;
  private PImage img;
  private PImage thumbnail;
  private float aspectRatio;
  
  private PVector thumbnailCenter;
  private PVector thumbnailTopLeft;
  private PVector thumbnailBottomRight;
  
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
    try {
      img = loadImage(path);
    }
    catch (Exception e){
      println(e);
      return;
    }
    println("Image loaded from "+path);
    
    imagePath = path;
    aspectRatio = (float)img.width / (float)img.height;
    float screenAspectRatio = (float)width / (float)height;
    if(aspectRatio > screenAspectRatio) {
      img.resize(int(width*0.8), 0);
    } else {
      img.resize(0, int(height*0.8));
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
  
  public void update() {
    
  }
  
  public float[] getRect() {
    float rect[] = {thumbnailTopLeft.x, 
                    thumbnailTopLeft.y, 
                    thumbnailBottomRight.x - thumbnailTopLeft.x,
                    thumbnailBottomRight.y - thumbnailTopLeft.y};
    return rect;
  }
  
  public String toString() {
    return imagePath;
  }
}