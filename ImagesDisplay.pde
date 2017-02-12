import drop.*;

final int thumbnailSize = 256;
final int buttonSize = 32;
final color selectionColor = color(240, 240, 255);
final color backgroundColor = color(24, 12, 6);


SDrop drop;
long mouseReleasedT0;

ArrayList<ImageStructure> images;
boolean lastImageSelected = false;
boolean selectedEnlarged = false;
boolean selectedMoving = false;
PVector movingOffset = new PVector();

ImageButton closeButton, enlargeButton, reduceButton;

void setup() {
  fullScreen(2);
  cursor(CROSS);
  imageMode(CENTER);
  rectMode(CORNER);
  
  drop = new SDrop(this);
  
  images = new ArrayList<ImageStructure>();
  
  closeButton = new ImageButton(new String[]{"GUI/close0.png", "GUI/close1.png", "GUI/close2.png"}, buttonSize);
  enlargeButton = new ImageButton(new String[]{"GUI/enlarge0.png", "GUI/enlarge1.png", "GUI/enlarge2.png"}, buttonSize);
  reduceButton = new ImageButton(new String[]{"GUI/reduce0.png", "GUI/reduce1.png", "GUI/reduce2.png"}, buttonSize);
}

void draw() {
  background(backgroundColor);
  
  if(images.size() > 0) {
    for(int i = 0; i < images.size()-1; i++) {
      ImageStructure img = images.get(i);
      img.drawThumbnail();
    }
    ImageStructure lastImg = images.get(images.size()-1);
    if(!lastImageSelected) {
      lastImg.drawThumbnail();
    }
    else {
      if(selectedEnlarged) {
        lastImg.drawEnlarged();
        PVector reduceButtonPosition = lastImg.getBottomLeftCorner();
        reduceButtonPosition.y -= reduceButton.getSize().y;
        reduceButton.drawAt(reduceButtonPosition);
      }
      else {
        if(selectedMoving) {
          lastImg.setCenterPosition(mouseX + movingOffset.x, mouseY + movingOffset.y);
        }
        stroke(selectionColor);
        strokeWeight(7);
        noFill();
        float[] imgRect = lastImg.getRect();
        rect(imgRect[0], imgRect[1], imgRect[2], imgRect[3]);
        lastImg.drawThumbnail();
        // Draw thumbnail controls
        closeButton.drawAt(new PVector(imgRect[0] + imgRect[2] - closeButton.getSize().x, imgRect[1]));
        enlargeButton.drawAt(new PVector(imgRect[0], imgRect[1] + imgRect[3] - closeButton.getSize().y));
      }
    }
  }
}

void keyReleased() {
  switch(key) {
   case DELETE:
      closeSelected();
      break;
    case ' ':
      break;
    default:
      break;
  }
}

void mousePressed() {
  if(! selectedEnlarged) {
    for(int i = images.size() - 1; i >= 0; i--) {
      if(images.get(i).mouseOverThumbnail()) {
        ImageStructure selected = images.remove(i);
        PVector selectedCenter = selected.getCenter();
        movingOffset.x = selectedCenter.x - mouseX;
        movingOffset.y = selectedCenter.y - mouseY;
        images.add(selected);
        lastImageSelected = true;
        selectedMoving = true;
        return;
      }
    }
  }
}

void mouseReleased() {
  boolean doubleClick = millis() - mouseReleasedT0 < 500;
  mouseReleasedT0 = millis();
  
  if(selectedEnlarged) {
    // reduce image if click on reduce button or double click on enlarged image
    if(images.get(images.size()-1).mouseOverEnlarged() && doubleClick || reduceButton.mouseOver()) {
      selectedEnlarged = false;
      return;
    }
  }
  
  if(lastImageSelected) {
    selectedMoving = false;
    // deselect image if simple click anywhere else
    if(!images.get(images.size()-1).mouseOverThumbnail()) {
      lastImageSelected = false;
      return;
    }
    // from here, we are sure mouse is over selected image thumbnail
    if(closeButton.mouseOver()) {
      closeSelected();
      return;
    }
    // enlarge thumbnail if click on enlrage button or double click on thumbnail
    if(enlargeButton.mouseOver() || doubleClick) {
      selectedEnlarged = true;
      return;
    }
  }
}

void closeSelected() {
  if(lastImageSelected) {
    ImageStructure toRemove = images.remove(images.size() - 1);
    println("Image removed : "+toRemove);
    lastImageSelected = false;
    selectedEnlarged = false;
  }
}

void dropEvent(DropEvent dropEvent) {
  ImageStructure selected = null;
  if(lastImageSelected) {
    selected = images.remove(images.size() - 1);
  }
  if(dropEvent.isFile()) {
    File droppedFile = dropEvent.file();
    // if just one file has been dropped
    if(droppedFile.isFile()) {
      images.add(new ImageStructure(droppedFile.getPath(), dropEvent.x(), dropEvent.y()));
    }
    // if a directory has been dropped
    if(droppedFile.isDirectory()) {
      // list files in the directory
      for(File f : droppedFile.listFiles()) {
        images.add(new ImageStructure(f.getPath()));
      }
    }
  }
  if(selected != null) {
    images.add(selected);
  }
}