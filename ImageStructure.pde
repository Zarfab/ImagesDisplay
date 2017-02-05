class ImageStructure {
  private String imagePath;
  private PImage img;
  private PImage thumbnail;
  private float aspectRatio;
  
  private PVector thumbnailCenter;
  private PVector thumbnailTopLeft;
  private PVector thumbnailBottomRight;
  private boolean selected;
  
  
  public ImageStructure(String path) {
    load(path);
  }
  
  public ImageStructure() {
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
    }
    imagePath = path;
    aspectRatio = (float)img.width / (float)img.height;
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
  
  public void draw() {
    
  }
  
  public boolean mouseOverThumbnail() {
    return mouseX >= thumbnailTopLeft.x && 
          mouseY >= thumbnailTopLeft.y && 
          mouseX <= thumbnailBottomRight.x && 
          mouseY <= thumbnailBottomRight.y;
  }
  
  public void update() {
    
  }
  
  public boolean selected() {
    return selected;
  }
  
  public void select() {
    selected = true;
  }
  
  public void deselect() {
    selected = false;
  }
  
  public String toString() {
    return imagePath;
  }
}