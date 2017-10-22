import drop.*;

final int thumbnailSizeIncrement = 16;
final int buttonSize = 32;
final color selectionColor = color(240, 240, 255);
final color backgroundColor = color(24, 12, 6);


SDrop drop;
boolean codedKeysDown[];

int thumbnailSize = 256;

ArrayList<MediaStructure> mediaContent;
boolean lastMediaSelected = false;
boolean selectedEnlarged = false;
boolean selectedMoving = false;
PVector movingOffset = new PVector();

ImageButton closeButton, enlargeButton, reduceButton;

void setup() {
  //fullScreen(2);
  size(800, 600);
  cursor(CROSS);
  imageMode(CENTER);
  rectMode(CORNER);
  
  drop = new SDrop(this);
  
  mediaContent = new ArrayList<MediaStructure>();
  codedKeysDown = new boolean[256];
  
  closeButton = new ImageButton(new String[]{"GUI/close0.png", "GUI/close1.png", "GUI/close2.png"}, buttonSize);
  enlargeButton = new ImageButton(new String[]{"GUI/enlarge0.png", "GUI/enlarge1.png", "GUI/enlarge2.png"}, buttonSize);
  reduceButton = new ImageButton(new String[]{"GUI/reduce0.png", "GUI/reduce1.png", "GUI/reduce2.png"}, buttonSize);
}

void draw() {
  background(backgroundColor);
  
  if(mediaContent.size() > 0) {
    for(int i = 0; i < mediaContent.size()-1; i++) {
      MediaStructure media = mediaContent.get(i);
      media.drawThumbnail();
    }
    MediaStructure lastMedia = mediaContent.get(mediaContent.size()-1);
    if(!lastMediaSelected) {
      lastMedia.drawThumbnail();
    }
    else {
      if(selectedEnlarged) {
        lastMedia.drawEnlarged();
        PVector reduceButtonPosition = lastMedia.getBottomLeftCorner();
        reduceButtonPosition.y -= reduceButton.getSize().y;
        reduceButton.drawAt(reduceButtonPosition);
      }
      else {
        if(selectedMoving) {
          lastMedia.setThumbnailCenterPosition(mouseX + movingOffset.x, mouseY + movingOffset.y);
        }
        stroke(selectionColor);
        strokeWeight(7);
        noFill();
        float[] imgRect = lastMedia.getThumbnailRect();
        rect(imgRect[0], imgRect[1], imgRect[2], imgRect[3]);
        lastMedia.drawThumbnail();
        // Draw thumbnail controls
        closeButton.drawAt(new PVector(imgRect[0] + imgRect[2] - closeButton.getSize().x, imgRect[1]));
        enlargeButton.drawAt(new PVector(imgRect[0], imgRect[1] + imgRect[3] - closeButton.getSize().y));
      }
    }
  }
}

void keyPressed() {
  if(key != CODED) {
    switch(key) {
     case DELETE:
          if(codedKeysDown[CONTROL])
            closeAll();
          else
            closeSelected();
        break;
      case ' ':
        break;
      default:
        break;
    }
  }
  else {
    codedKeysDown[keyCode] = true;
  }
}

void keyReleased() {
  if(key == CODED) {
    codedKeysDown[keyCode] = false;
  }
}

void mousePressed() {
  if(! selectedEnlarged) {
    for(int i = mediaContent.size() - 1; i >= 0; i--) {
      if(mediaContent.get(i).mouseOverThumbnail()) {
        MediaStructure selected = mediaContent.remove(i);
        PVector selectedCenter = selected.getCenter();
        movingOffset.x = selectedCenter.x - mouseX;
        movingOffset.y = selectedCenter.y - mouseY;
        mediaContent.add(selected);
        lastMediaSelected = true;
        selectedMoving = true;
        return;
      }
    }
  }
}

void mouseReleased(MouseEvent e) {
  boolean doubleClick = e.getCount() == 2;
  
  if(selectedEnlarged) {
    // reduce image if click on reduce button or double click on enlarged image
    if(mediaContent.get(mediaContent.size()-1).mouseOverEnlarged() && doubleClick || reduceButton.mouseOver()) {
      selectedEnlarged = false;
    }
    return;
  }
  
  if(lastMediaSelected) {
    selectedMoving = false;
    // deselect image if simple click anywhere else
    if(!mediaContent.get(mediaContent.size()-1).mouseOverThumbnail()) {
      lastMediaSelected = false;
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

void mouseWheel(MouseEvent event) {
  if(codedKeysDown[CONTROL]) {
    thumbnailSize += -1 * thumbnailSizeIncrement * event.getCount();
    if(thumbnailSize <= 2 * buttonSize) {
      thumbnailSize = 2 * buttonSize;
    }
    if(thumbnailSize >= height / 2) {
      thumbnailSize =  height / 2;
    }
    println("new thumbnail size = "+thumbnailSize);
    for(MediaStructure m : mediaContent) {
      m.updateThumbnailSize();
    }
  }
}

void closeAll() {
  mediaContent.clear();
  println("All media removed");
}

void closeSelected() {
  if(lastMediaSelected) {
    MediaStructure toRemove = mediaContent.remove(mediaContent.size() - 1);
    println("Image removed : "+toRemove);
    lastMediaSelected = false;
    selectedEnlarged = false;
  }
}

void dropEvent(DropEvent dropEvent) {
  MediaStructure selected = null;
  if(lastMediaSelected) {
    selected = mediaContent.remove(mediaContent.size() - 1);
  }
  if(dropEvent.isFile()) {
    File droppedFile = dropEvent.file();
    // if just one file has been dropped
    if(droppedFile.isFile()) {
      mediaContent.add(new ImageStructure(droppedFile.getPath(), dropEvent.x(), dropEvent.y()));
    }
    // if a directory has been dropped
    if(droppedFile.isDirectory()) {
      // list files in the directory
      for(File f : droppedFile.listFiles()) {
        mediaContent.add(new ImageStructure(f.getPath()));
      }
    }
  }
  if(selected != null) {
    mediaContent.add(selected);
  }
}