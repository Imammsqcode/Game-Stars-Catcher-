class Star {
  float x, y, speed;
  PImage image;
  PApplet parent;

  Star(float x, float y, float speed, PImage image, PApplet parent) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.image = image;
    this.parent = parent;
  }

  void update() {
    y += speed;
  }

  void display() {
    parent.image(image, x, y, 40, 40);
  }
}
