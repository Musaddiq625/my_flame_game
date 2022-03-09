import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:my_flame_game/src/constants/asset_constants.dart';

class MyGame extends FlameGame with HasGameRef, HasTappables {
  bool running = true;
  SpriteComponent boy = SpriteComponent();
  SpriteAnimationComponent boyAnimation = SpriteAnimationComponent();
  String direction = 'right';
  double speed = 4.0;
  final double _yAxisHeight = 230;

  final spriteSize = Vector2(102, 122);
  final arrowSize = Vector2(50, 100);
  final buttonSize = Vector2(100, 80);
  final leftArrowPosition = Vector2(20, 250);
  final rightArrowPosition = Vector2(740, 250);
  final jumpButtonPosition = Vector2(350, 250);
  Future<void> _addImageInCanvas(String path) async {
    SpriteComponent background = SpriteComponent()
      ..sprite = await loadSprite(path)
      ..size = size;
    add(background);
  }

  _onLeftArrowPressed() {
    if (direction != 'left') {
      flipCharacter();
    }
  }

  _onRightArrowPressed() {
    if (direction != 'right') {
      flipCharacter();
    }
  }

  _onJumpButtonPressed() async {
    var spriteSheet = await images.load(AssetConstants.boyJump);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2(112.0, 130.0),
    );
    boyAnimation =
    SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
      ..x = 150
      ..y = 350
      ..size = spriteSize;
    // boyAnimation
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _addImageInCanvas(AssetConstants.background);
    var spriteSheet = await images.load(AssetConstants.boyRunning);

//character
    boy
      ..sprite = await loadSprite(AssetConstants.boyRunning)
      ..size = Vector2(20.0, 200.0)
      ..x = 150
      ..y = 50;
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2(112.0, 130.0),
    );
    boyAnimation =
        SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
          ..x = 150
          ..y = 350
          ..size = spriteSize
          ..position = Vector2(-50, _yAxisHeight);
    add(boyAnimation);
    //arrows
    Button leftArrow = Button(onPressed: _onLeftArrowPressed)
      ..sprite = await loadSprite(AssetConstants.leftArrow)
      ..size = arrowSize
      ..position = leftArrowPosition;
    add(leftArrow);

    Button rightArrow = Button(onPressed: _onRightArrowPressed)
      ..sprite = await loadSprite(AssetConstants.rightArrow)
      ..size = arrowSize
      ..position = rightArrowPosition;
    add(rightArrow);

    // Button jumpArrow = Button(onPressed: _onJumpButtonPressed)
    //   ..sprite = await loadSprite(AssetConstants.buttonJump)
    //   ..size = buttonSize
    //   ..position = jumpButtonPosition;
    // add(jumpArrow);
  }

  @override
  void onDoubleTap() {
    flipCharacter();
  }

  void flipCharacter() {
    switch (direction) {
      case 'right':
        direction = 'left';
        break;
      case 'left':
        direction = 'right';
        break;
    }
    boyAnimation.flipHorizontally();
  }

  // @override
  // void onTapUp(TapUpInfo info) {
  //   // TODO: implement onTapUp
  //   super.onTapUp(info);
  // }

  @override
  update(double dt) {
    super.update(dt);

    switch (direction) {
      case 'right':
        boyAnimation.x += speed;
        break;
      case 'left':
        boyAnimation.x -= speed;
        break;
    }
    // final screenSize = gameRef.size;
    if (boyAnimation.x > 800) {
      if (direction == 'right') {
        boyAnimation.position = Vector2(-50, _yAxisHeight);
      }
      // direction = 'left';
    }
    if (boyAnimation.x < 10) {
      if (direction == 'left') {
        boyAnimation.position = Vector2(810, _yAxisHeight);
      }
      // boyAnimation.position = Vector2(700, 200.0);
    }
  }
}

// class _Square extends PositionComponent {
//   static const speed = 0.25;
//   static const squareSize = 128.0;
//
//   static Paint white = BasicPalette.white.paint();
//   static Paint red = BasicPalette.red.paint();
//   static Paint blue = BasicPalette.blue.paint();
//
//   @override
//   void render(Canvas c) {
//     c.drawRect(size.toRect(), white);
//     c.drawRect(const Rect.fromLTWH(0, 0, 3, 3), red);
//     c.drawRect(Rect.fromLTWH(width / 2, height / 2, 3, 3), blue);
//   }
//
//   // @override
//   // void update(double dt) {
//   //   super.update(dt);
//   //   angle += speed * dt;
//   //   angle %= 2 * math.pi;
//   // }
//
//
//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     size.setValues(squareSize, squareSize);
//     anchor = Anchor.center;
//   }
// }
class Button extends SpriteComponent with Tappable {
  final Function() onPressed;

  Button({required this.onPressed});

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      onPressed();
      return true;
    } catch (error) {
      print('ArrowButton error $error');
      return false;
    }
    return super.onTapDown(info);
  }
}
