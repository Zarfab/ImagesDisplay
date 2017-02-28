abstract class MediaStructure {
  protected String mediaPath;
  protected PImage thumbnail;
  protected PImage initialThumbnail;
  protected float aspectRatio;
  
  protected PVector thumbnailCenter;
  protected PVector thumbnailTopLeft;
  protected PVector thumbnailBottomRight;
  
  protected PVector mediaTopLeft;
  protected PVector mediaBottomRight;
  
  public abstract void drawEnlarged();
  public abstract void load(String path);
  
  protected void init() {
    mediaPath = "";
    thumbnail = null;
  }
  
  public void setThumbnailCenterPosition(float x, float y) {
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
  
  public void updateThumbnailSize() {
    thumbnail = initialThumbnail.copy();
    if(aspectRatio > 1) {
      thumbnail.resize(thumbnailSize, 0);
    } else {
      thumbnail.resize(0, thumbnailSize);
    }
    thumbnailTopLeft.x = thumbnailCenter.x - thumbnail.width/2;
    thumbnailTopLeft.y = thumbnailCenter.y - thumbnail.height/2;
    thumbnailBottomRight.x = thumbnailCenter.x + thumbnail.width/2;
    thumbnailBottomRight.y = thumbnailCenter.y + thumbnail.height/2;
  }
  
  public boolean mouseOverThumbnail() {
    return mouseX >= thumbnailTopLeft.x && 
          mouseY >= thumbnailTopLeft.y && 
          mouseX <= thumbnailBottomRight.x && 
          mouseY <= thumbnailBottomRight.y;
  }
  
  public boolean mouseOverEnlarged() {
    return mouseX >= mediaTopLeft.x && 
          mouseY >= mediaTopLeft.y && 
          mouseX <= mediaBottomRight.x && 
          mouseY <= mediaBottomRight.y;
  }
  
  public float[] getThumbnailRect() {
    float rect[] = {thumbnailTopLeft.x, 
                    thumbnailTopLeft.y, 
                    thumbnailBottomRight.x - thumbnailTopLeft.x,
                    thumbnailBottomRight.y - thumbnailTopLeft.y};
    return rect;
  }
  
  public PVector getBottomLeftCorner() {
    return new PVector(mediaTopLeft.x, mediaBottomRight.y);
  }
  
  public PVector getTopLeftCorner() {
    return mediaTopLeft;
  }
  
  public PVector getBottomRightCorner() {
    return mediaBottomRight;
  }
  
  public PVector getTopRightCorner() {
    return new PVector(mediaBottomRight.x, mediaTopLeft.y);
  }
  
  public String toString() {
    return mediaPath;
  }
  

  
}