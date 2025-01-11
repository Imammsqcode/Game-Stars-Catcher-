class GameController {
  PApplet parent;

  PImage BG_MENU, BG_MAIN, BG_SETELAH_MAIN, BG_OPTIONS, BG_Credit;
  PImage Button_Play, Button_Restart, Button_Menu, Button_Options, Button_Credit, Button_back;
  PImage Button_ON, Button_OFF;
  PImage Object, Stars;

  SoundFile bgMusic, buttonSound, starSound;

  int screen = 0; // 0: Menu, 1: Game, 2: Setelah Main, 3: Options, 4: Credit
  float objectX, objectY;
  boolean isMusicOn = true;

  ArrayList<Star> stars = new ArrayList<>();
  int score = 0;
  float spawnInterval = 60;
  float spawnTimer = 0;
  
  int difficultyTimer = 0;
  float starSpeedIncrement = 0.1;
  float minSpawnInterval = 20;
  
  GameController(PApplet parent) {
    this.parent = parent;
  }

  void init() {
    BG_MENU = parent.loadImage("BG_MENU.png");
    BG_MAIN = parent.loadImage("BG_MAIN.png");
    BG_SETELAH_MAIN = parent.loadImage("BG_SETELAH_MAIN.png");
    BG_OPTIONS = parent.loadImage("BG_Options.png");
    BG_Credit = parent.loadImage("BG_Credit.png");

    Button_Play = parent.loadImage("Button_Play.png");
    Button_Restart = parent.loadImage("Button_Restart.png");
    Button_Menu = parent.loadImage("Button_Menu.png");
    Button_Options = parent.loadImage("Button_Options.png");
    Button_Credit = parent.loadImage("Button_Credit.png");
    Button_back = parent.loadImage("Button_back.png");
    Button_ON = parent.loadImage("ON.png");
    Button_OFF = parent.loadImage("OFF.png");

    Object = parent.loadImage("Object.png");
    Stars = parent.loadImage("Stars.png");

    bgMusic = new SoundFile(parent, "Bright Whistle.mp3");
    buttonSound = new SoundFile(parent, "Blip_Select2.wav");
    starSound = new SoundFile(parent, "Pickup_Coin.wav");

    objectX = parent.width / 2 - 50;
    objectY = parent.height - 100;

    bgMusic.loop();
  }


  void update() {
    if (screen == 1) {
      spawnTimer++;
      difficultyTimer++;
  
      if (difficultyTimer >= 600) {
        difficultyTimer = 0;
        if (spawnInterval > minSpawnInterval) {
          spawnInterval -= 5;
        }
        for (Star star : stars) {
          star.speed += starSpeedIncrement;
        }
      }
  
      if (spawnTimer >= spawnInterval) {
        spawnTimer = 0;
        stars.add(new Star(parent.random(25, parent.width - 25), -25, 2 + score * 0.05, Stars, parent));
      }
  
      for (int i = stars.size() - 1; i >= 0; i--) {
        Star star = stars.get(i);
        star.update();
  
        if (parent.dist(objectX + 40, objectY + 44, star.x + 20, star.y + 20) < 40) {
          score++;
          stars.remove(i);
          starSound.play();
        } else if (star.y > parent.height) {
          screen = 2;
          bgMusic.stop();
        }
      }
    }
  }

  void render() {
    parent.background(0);

    switch (screen) {
      case 0: renderMenu(); break;
      case 1: renderGame(); break;
      case 2: renderGameOver(); break;
      case 3: renderOptions(); break;
      case 4: renderCredits(); break;
    }
  }

  void handleMousePressed() {
    if (screen == 0) {
      if (isButtonClicked(parent.width / 2 - 75, parent.height / 2 - 100, 150, 50)) {
        startGame();
      } else if (isButtonClicked(parent.width / 2 - 75, parent.height / 2 - 25, 150, 50)) {
        screen = 3;
        buttonSound.play();
      } else if (isButtonClicked(parent.width / 2 - 75, parent.height / 2 + 50, 150, 50)) {
        screen = 4;
        buttonSound.play();
      }
    } else if (screen == 2) {
      if (isButtonClicked(parent.width / 2 - 150, parent.height / 2 + 50, 100, 50)) {
        screen = 0;
        bgMusic.loop();
        buttonSound.play();
      } else if (isButtonClicked(parent.width / 2 + 50, parent.height / 2 + 50, 100, 50)) {
        startGame();
      }
    } else if (screen == 3) {
      if (isButtonClicked(20, 20, 100, 50)) {
        screen = 0;
        buttonSound.play();
      } else if (isButtonClicked(parent.width / 2 - 75, parent.height / 2, 50, 50)) {
        toggleMusic(true);
      } else if (isButtonClicked(parent.width / 2 + 25, parent.height / 2, 50, 50)) {
        toggleMusic(false);
      }
    } else if (screen == 4) {
      if (isButtonClicked(20, 20, 100, 50)) {
        screen = 0;
        buttonSound.play();
      }
    }
  }

  void renderMenu() {
    parent.background(BG_MENU);
    parent.image(Button_Play, parent.width / 2 - 75, parent.height / 2 - 100, 150, 50);
    parent.image(Button_Options, parent.width / 2 - 75, parent.height / 2 - 25, 150, 50);
    parent.image(Button_Credit, parent.width / 2 - 75, parent.height / 2 + 50, 150, 50);
  }

  void renderGame() {
    parent.background(BG_MAIN);
    parent.textSize(24);
    parent.fill(255);
    parent.text("Score: " + score, 20, 40);

    parent.image(Object, objectX, objectY, 80, 88);
    objectX = parent.constrain(parent.mouseX - 40, 0, parent.width - 80);

    for (Star star : stars) {
      star.display();
    }
  }

  void renderGameOver() {
    parent.background(BG_SETELAH_MAIN);
    parent.textSize(32);
    parent.fill(255);
    parent.text("Game Over!", parent.width / 2 - 100, parent.height / 2 - 150);
    parent.textSize(24);
    parent.text("Score: " + score, parent.width / 2 - 50, parent.height / 2 - 100);

    parent.image(Button_Menu, parent.width / 2 - 150, parent.height / 2 + 50, 100, 50);
    parent.image(Button_Restart, parent.width / 2 + 50, parent.height / 2 + 50, 100, 50);
  }

  void renderOptions() {
    parent.background(BG_OPTIONS);
    parent.image(Button_back, 20, 20, 100, 50);

    parent.textSize(24);
    parent.fill(255);
    parent.text("Music", parent.width / 2 - 30, parent.height / 2 - 50);

    parent.image(Button_ON, parent.width / 2 - 75, parent.height / 2, 50, 50);
    parent.image(Button_OFF, parent.width / 2 + 25, parent.height / 2, 50, 50);
  }

  void renderCredits() {
    parent.background(BG_Credit);
    parent.image(Button_back, 20, 20, 100, 50);
  }

  boolean isButtonClicked(float x, float y, float w, float h) {
    return parent.mouseX > x && parent.mouseX < x + w && parent.mouseY > y && parent.mouseY < y + h;
  }

  void startGame() {
    screen = 1;
    score = 0;
    stars.clear();
    bgMusic.loop();
    buttonSound.play();
  }

  void toggleMusic(boolean status) {
    isMusicOn = status;
    if (isMusicOn) {
      if (!bgMusic.isPlaying()) {
        bgMusic.loop();
      }
    } else {
      bgMusic.stop();
    }
    buttonSound.play();
  }
}
