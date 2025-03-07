# c8051_ass_3

## Team
Ye Cheng A00923048
Jason Chung A00803304

## Controls
- Single Finger Pan will rotate the camera if not editing the enemy, otherwise it will rotate the enemy
- Two Finger Pan will translate the enemy if you are editing the enemy
- Long Press will move the camera forward
- Single Finger Double Tap will reset the camera position and rotation
- Two Finger Double Tap will toggle between minimap and camera view
- Three Finger Double Tap will toggle between editing the enemy and not editing the enemy
- Two Finger Pinch will scale the enemy if editing the enemy

## Buttons
- Toggle Lighting button will switch between morning and night
- Toggle Flashlight button will turn the flashlight on or off
- Toggle Fog button will turn fog on or off
- Fog Slider will adjust the fog distance

## Notes
a. OBJ Loading code is in Engine/Utility.m under the function loadMeshByFilename
b. Three finger double tap toggles between editing the enemy and normal game functions. When editing the enemy, you can single finger pan to rotate the enemy, double finger pan to translate the enemy, and pinch to scale the enemy. It is seen more easily in the minimap view.
c. Collision detection happens in ViewController.m's update function. I check every GameObject in the maze array to see if it collides with the enemy and if it does, it rotates the enemy. The enemy is just always moving in a direction.

The Golden Goose model was given freely to other students as an enemy.

## More Details
- Check report
