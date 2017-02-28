class ImageStructure extends MediaStructure {
  private PImage img;
  
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
    setThumbnailCenterPosition(posx, posy);
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
      
      mediaPath = path;
      aspectRatio = (float)img.width / (float)img.height;
      float screenAspectRatio = (float)width / (float)height;
      if(aspectRatio > screenAspectRatio) {
        img.resize(int(width*0.8), 0);
        mediaTopLeft = new PVector(width*0.1, (height - img.height) * 0.5);
        mediaBottomRight = new PVector(width*0.9, (height + img.height) * 0.5);
      } else {
        img.resize(0, int(height*0.8));
        mediaTopLeft = new PVector((width - img.width)*0.5, height * 0.1);
        mediaBottomRight = new PVector((width + img.width)*0.5, height * 0.9);
      }
      initialThumbnail = img.copy();
      thumbnail = initialThumbnail.copy();
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
  
  
  public void drawEnlarged() {   
    image(img, width/2, height/2);
  }
  
}