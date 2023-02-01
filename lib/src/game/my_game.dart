import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/rendering.dart';
import 'package:my_flame_game/src/constants/asset_constants.dart';

class MyGame extends FlameGame with HasGameRef, HasTappables {
  bool running = true;
  SpriteComponent boy = SpriteComponent();
  SpriteAnimationComponent boyAnimation = SpriteAnimationComponent();
  SpriteAnimationComponent boyJumpAnimation = SpriteAnimationComponent();
  String direction = 'right';
  double speed = 4.0;
  static const double _yAxisHeight = 250;

  final boyStartPositionX = 100.0;
  final spriteSize = Vector2(102, 122);
  final arrowSize = Vector2(50, 100);
  final buttonSize = Vector2(100, 80);

  // final leftArrowPosition = Vector2(20, 250);
  // final rightArrowPosition = Vector2(740, 250);
  // final jumpButtonPosition = Vector2(350, 250); //center
  final jumpButtonPosition = Vector2(640, _yAxisHeight);
  final boyRunningVSize = Vector2(112.0, 130.0);
  final boyJumpVSize = Vector2(90.0, 120.0);

  Future<void> _addImageInCanvas(String path) async {
    SpriteComponent background = SpriteComponent()
      ..sprite = await loadSprite(path)
      ..size = size;
    add(background);
  }

  // _onLeftArrowPressed() {
  //   if (direction != 'left') {
  //     flipCharacter();
  //   }
  // }
  //
  // _onRightArrowPressed() {
  //   if (direction != 'right') {
  //     flipCharacter();
  //   }
  // }

  _onJumpButtonPressed() async {
    // var spriteSheet = await images.load(AssetConstants.boyJump);
    // SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
    //   amount: 6,
    //   stepTime: 0.1,
    //   textureSize: boyJumpVSize,
    // );
    // boyAnimation =
    // SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
    //   ..x = 250
    //   ..y = 350
    //   ..size = spriteSize;
    // boyAnimation
    var spriteSheet = await images.load(AssetConstants.boyJump);
    boy
      ..sprite = await loadSprite(AssetConstants.boyJump)
      ..size = boyJumpVSize
      ..x = 150
      ..y = 50;
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: boyJumpVSize,
    );
    boyJumpAnimation =
        SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
          ..x = 150
          ..y = 350
          ..size = spriteSize
          ..position = boyAnimation.position
          ..removeOnFinish = true;
    boyAnimation.removeFromParent();
    if (boyAnimation.isPrepared) {
      await add(boyJumpAnimation);
    }
    // add(boyAnimation);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // await _addImageInCanvas(AssetConstants.background);
    var spriteSheet = await images.load(AssetConstants.boyRunning);
    // List<ParallaxImageData> forestParallaxImages = [
    //   ParallaxImageData('parallax_forest/forest_front.png'),
    //   ParallaxImageData('parallax_forest/forest_middle.png'),
    //   ParallaxImageData('parallax_forest/forest_back.png'),
    //   ParallaxImageData('parallax_forest/grass_foreground.png'),
    // ];
    List<ParallaxData> forestParallaxImages = [
      ParallaxImageData('parallax_forest/forest_back.png'),
      ParallaxImageData('parallax_forest/forest_middle.png'),
      ParallaxImageData('parallax_forest/forest_front.png'),
      // ParallaxImageData('parallax_forest/grass_foreground.png'),
    ];
    List<ParallaxData> groundParallaxImages = [
      ParallaxImageData('parallax_forest/grass_foreground.png'),
      ParallaxImageData('parallax_forest/grass_foreground.png'),
    ];
    ParallaxComponent backgroundParallax = await ParallaxComponent.load(
      forestParallaxImages,
      repeat: ImageRepeat.repeatX,
      baseVelocity: Vector2(-2, 0),
      size: size,
      velocityMultiplierDelta: Vector2(-2.5, 0),
    );
    add(backgroundParallax);
    ParallaxComponent groundParallax = await ParallaxComponent.load(
      groundParallaxImages,
      repeat: ImageRepeat.repeatX,
      baseVelocity: Vector2(3, 20),
      size: size,
      velocityMultiplierDelta: Vector2(-3.5, 0),
    );
    add(groundParallax);

//character
    boy
      ..sprite = await loadSprite(AssetConstants.boyRunning)
      ..size = boyRunningVSize
      ..x = 150
      ..y = 50;
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: boyRunningVSize,
    );
    boyAnimation =
        SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
          ..x = 150
          ..y = 350
          ..size = spriteSize
          ..position = Vector2(boyStartPositionX, _yAxisHeight);
    add(boyAnimation);
    //arrows
    // Button leftArrow = Button(onPressed: _onLeftArrowPressed)
    //   ..sprite = await loadSprite(AssetConstants.leftArrow)
    //   ..size = arrowSize
    //   ..position = leftArrowPosition;
    // add(leftArrow);
    //
    // Button rightArrow = Button(onPressed: _onRightArrowPressed)
    //   ..sprite = await loadSprite(AssetConstants.rightArrow)
    //   ..size = arrowSize
    //   ..position = rightArrowPosition;
    // add(rightArrow);

    Button jumpArrow = Button(onPressed: _onJumpButtonPressed)
      ..sprite = await loadSprite(AssetConstants.buttonJump)
      ..size = buttonSize
      ..position = jumpButtonPosition;
    add(jumpArrow);
  }

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
  update(double dt) async{
    super.update(dt);
    _updateDirection(
      direction: direction,
      character: boyAnimation,
      speed: speed,
    );
    _updateDirection(
      direction: direction,
      character: boyJumpAnimation,
      speed: speed,
    );
    await _updateJumpAxisY();
    // final screenSize = gameRef.size;

    // boyAnimation.position = Vector2(700, 200.0);
  }
Future<void> _updateJumpAxisY() async{
  if(boyJumpAnimation.isPrepared){
    print('boyJumpAnimation.position.y ${boyJumpAnimation.position.y}');
    // -- upward
    // ++ downward
    if(boyJumpAnimation.position.y >= (_yAxisHeight + 50)) { // if down
      boyJumpAnimation.position.y -= 1.5;
    }else if(boyJumpAnimation.position.y == (_yAxisHeight + 50)){ // if up
      boyJumpAnimation.position.y += 1.5;
    }
  }
}
  _updateDirection({
    required String direction,
    required SpriteAnimationComponent character,
    required double speed,
  }) {
    // switch (direction) {
    //   case 'right':
    //     character.x += speed;
    //     break;
    //   case 'left':
    //     character.x -= speed;
    //     break;
    // }

    if (character.x > 800 || boyJumpAnimation.x > 800) {
      if (direction == 'right') {
        character.position = Vector2(-50, _yAxisHeight);
      }
      // direction = 'left';
    }
    if (character.x < 10 || boyJumpAnimation.x < 10) {
      if (direction == 'left') {
        character.position = Vector2(810, _yAxisHeight);
      }
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
