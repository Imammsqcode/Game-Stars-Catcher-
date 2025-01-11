import processing.sound.*;

GameController gameController;

void setup() {
  size(600, 800);
  gameController = new GameController(this);
  gameController.init();
}

void draw() {
  gameController.update();
  gameController.render();
}

void mousePressed() {
  gameController.handleMousePressed();
}
