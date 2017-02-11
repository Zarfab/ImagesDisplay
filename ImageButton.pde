class ImageButton {
  private PVector topLeft;
  private PVector size;
  
  private PImage released, mouseOver, clicked;


  public ImageButton() {
    topLeft = new PVector();
    size = new PVector();
  }
  
  public ImageButton(String[] imgPaths, float s) {
    topLeft = new PVector();
    size = new PVector();
    setImages(imgPaths);
    setSize(s);
  }
  
  public void setImages(String[] imgPaths) {
    switch(imgPaths.length) {
      case 1:
        released = loadImage(imgPaths[0]);
        mouseOver = loadImage(imgPaths[0]);
        clicked = loadImage(imgPaths[0]);
        break;
      case 2:
        released = loadImage(imgPaths[0]);
        mouseOver = loadImage(imgPaths[1]);
        clicked = loadImage(imgPaths[1]);
        break;
      case 3:
        released = loadImage(imgPaths[0]);
        mouseOver = loadImage(imgPaths[1]);
        clicked = loadImage(imgPaths[2]);
        break;
      default:
        break;
    }
  }
  
  public void setSize(float x, float y) {
    size.x = x;
    size.y = y;
  }
  
  public void setSize(float x) {
    size.x = x;
    size.y = x;
  }
  
  public PVector getSize() {
    return size;
  }
  
  public void drawAt(PVector position) {
    topLeft.x = position.x;
    topLeft.y = position.y;
    pushStyle();
    imageMode(CORNER);
    if(!mouseOver()) {
      image(released, topLeft.x, topLeft.y, size.x, size.y);
    }
    else {
      if(!mousePressed) {
        image(mouseOver, topLeft.x, topLeft.y, size.x, size.y);
      }
      else {
        image(clicked, topLeft.x, topLeft.y, size.x, size.y);
      }
    }
    popStyle();
  }
  
  public boolean mouseOver() {
    return mouseX >= topLeft.x && 
          mouseY >= topLeft.y && 
          mouseX <= topLeft.x + size.x && 
          mouseY <= topLeft.y + size.y;
  }
}