# Hacking With Swift - Pachinko project

This project features:
- Game development with SpriteKit
- Entities: SKNodes, SKScenes, SKSpriteNodes
- Physics: SKPhysicsBody, SKPhysicsContact
- Particle Effects: SKEmitterNodes
- Aspects of game development and how SpriteKit eases development flow

## The challenge
- Change the balls to be randomly colored
- Force Y value of new balls to be at the top of the scene
- Change the game rules:
  1. Start the game with 5 balls;
  2. Whenever balls land on obstacles, destroy them too;
  3. Increase score only if player reaches the end of the game with no obstacles left (NEW);
  4. Fails to score if player reaches the end of the game with obstacles on the scene and no balls left (NEW);
  5. Both win/loss displays an alert and resets the stage, but not the score (NEW);
  6. Player may only drop balls if they have placed at least 5 obstacles (NEW).
