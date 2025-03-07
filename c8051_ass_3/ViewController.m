//
//  ViewController.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "ViewController.h"
#import "Game.h"
#import "Engine/Engine.h"
#import "Engine/Utility.h"
#import "Engine/GameObject.h"
#import "Engine/Renderer/Camera.h"
#import "Engine/Renderer/DirectionalLight.h"
#import "Engine/Renderer/SpotLight.h"
#import "Engine/Renderer/Geometry.h"
#import "Engine/Renderer/FrameBuffer.h"
#import "MyMaze.h"

@interface ViewController () {
    // The time for the previous frame
    NSDate *lastTime;
    // The time between each frame in seconds
    NSTimeInterval deltaTime;
    
    Camera *camera;
    Camera *minimapCamera;
    DirectionalLight *directionalLight;
    SpotLight *spotLight;
    
    MyMaze *mazeWrapper;
    
	GameObject *player;
    GameObject *enemy;
    GameObject *cube;
    NSMutableArray<GameObject *> *maze;
    
    GLKVector3 enemyVelocity;
    GLKVector3 oldVelocity;
    GLfloat enemySpeed;
    
    UIPanGestureRecognizer *singleFingerPan;
    UIPanGestureRecognizer *twoFingerPan;
    UILongPressGestureRecognizer *longPress;
    UITapGestureRecognizer *singleFingerDoubleTap;
    UITapGestureRecognizer *twoFingerDoubleTap;
    UITapGestureRecognizer *threeFingerDoubleTap;
    UIPinchGestureRecognizer *twoFingerPinch;
    
    bool isMoving;
    bool isFogEnabled;
    GLfloat fogStart;
    GLfloat fogEnd;
    GLfloat FOG_MIN;
    GLfloat FOG_MAX;
    
    bool isEditingEnemy;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lastTime = [NSDate date];
	
	maze = [NSMutableArray array];
    
    GLKView *view = (GLKView *)self.view;
    [[[Game getInstance] getEngine] initView:view];
	
	player = [[GameObject alloc] init];
    [player setScale:GLKVector3Make(0.1f, 0.1f, 0.1f)];
	[player addMesh:[[[Game getInstance] getAssets] getMeshByKey:KEY_ASSETS_MESH_CUBE_DIRECTION]];
    
    camera = [[Camera alloc] init];
    [[[[Game getInstance] getEngine] getRenderer] setCamera:camera];
    minimapCamera = [[Camera alloc] init];
    
    directionalLight = [[DirectionalLight alloc] init];
    spotLight = [[SpotLight alloc] initWithDirection:[camera getFront]];
    
    singleFingerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerPan:)];
    [self.view addGestureRecognizer:singleFingerPan];
    twoFingerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerPan:)];
    twoFingerPan.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer:twoFingerPan];
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longPress];
    singleFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerDoubleTap:)];
    singleFingerDoubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:singleFingerDoubleTap];
    twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerDoubleTap:)];
    twoFingerDoubleTap.numberOfTapsRequired = 2;
    twoFingerDoubleTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    threeFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreeFingerDoubleTap:)];
    threeFingerDoubleTap.numberOfTapsRequired = 2;
    threeFingerDoubleTap.numberOfTouchesRequired = 3;
    [self.view addGestureRecognizer:threeFingerDoubleTap];
    twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerPinch:)];
    [self.view addGestureRecognizer:twoFingerPinch];
	
	mazeWrapper = [[MyMaze alloc] init];
    
    GLfloat cellSize = 1.0f;
    [camera setPosition:GLKVector3Make(0, 0, -2)];
    
    [minimapCamera setPosition:GLKVector3Make((cellSize * [mazeWrapper numCols]) * 0.5f, 15, (cellSize * [mazeWrapper numRows]) * 0.5f)];
    [minimapCamera setPitch:270.0f];
    [minimapCamera setYaw:270.0f];
    
    cube = [[GameObject alloc] init];
    [cube setScale:GLKVector3Make(0.1f, 0.1f, 0.1f)];
    [cube addMesh:[[[Game getInstance] getAssets] getMeshByKey:KEY_ASSETS_MESH_CUBE]];
    
    enemy = [[GameObject alloc] init];
    [enemy setScale:GLKVector3Make(0.1f, 0.1f, 0.1f)];
    [enemy setPosition:GLKVector3Make(3 * cellSize, 0, 3 * cellSize)];
    [enemy setRotation:GLKVector3Make(0, M_PI, 0)];
    [enemy addMesh:[[[Game getInstance] getAssets] getMeshByKey:KEY_ASSETS_MESH_GOLDEN_GOOSE]];
    [[enemy getBoundingBox] setSize:GLKVector2Make(0.1f, 0.1f)];
    enemySpeed = 0.5f;
    enemyVelocity = GLKVector3Make(0, 0, enemySpeed);
    
    // Add an start wall
    GameObject *startWall = [[GameObject alloc] init];
    [startWall setPosition:GLKVector3Make(-0.5f, 0, -0.5f)];
	[[startWall getBoundingBox] setPosition:GLKVector2Make([startWall getPosition].x, [startWall getPosition].z)];
    [[startWall getBoundingBox] setSize:GLKVector2Make(1, 0.1f)];
    [maze addObject:startWall];
	
    for (int row = 0; row < [mazeWrapper numRows]; row++) {
        for (int col = 0; col < [mazeWrapper numCols]; col++) {
            // floor
            // Always create a floor
			GameObject *floorObj = [[GameObject alloc] init];
            [floorObj setPosition:GLKVector3Make(col * cellSize, -0.5f, row * cellSize)];
            [floorObj setRotation:GLKVector3Make(M_PI / 2, M_PI, M_PI)];
			[floorObj addMesh:[[[Game getInstance] getAssets] getMeshByKey:KEY_ASSETS_MESH_FLOOR]];
            [[floorObj getBoundingBox] setEnabled:GL_FALSE];
			[maze addObject:floorObj];
            
            // north wall
            if ([mazeWrapper hasNorthWall:row col:col]) {
                GameObject *northObj = [[GameObject alloc] init];
                [northObj setPosition:GLKVector3Make(col * cellSize, 0.0f, row * cellSize - 0.49f)];
                [northObj setRotation:GLKVector3Make(0, 0, 0)];
				[[northObj getBoundingBox] setPosition:GLKVector2Make(col * cellSize - 0.5f, row * cellSize - 0.5f)];
                [[northObj getBoundingBox] setSize:GLKVector2Make(1, 0.1f)];
                [northObj addMesh:[[[Game getInstance] getAssets] getMeshByKey:KEY_ASSETS_MESH_NORTH_WALL]];
                [maze addObject:northObj];
            }
            
            // east wall
            if ([mazeWrapper hasEastWall:row col:col]) {
                GameObject *eastObj = [[GameObject alloc] init];
                [eastObj setPosition:GLKVector3Make(col * cellSize + 0.49f, 0.0f, row * cellSize)];
                [eastObj setRotation:GLKVector3Make(0, M_PI * 0.5f, 0)];
                [eastObj setScale:GLKVector3Make(-1, 1, 1)];
				[[eastObj getBoundingBox] setPosition:GLKVector2Make(col * cellSize + 0.5f, row * cellSize - 0.5f)];
                [[eastObj getBoundingBox] setSize:GLKVector2Make(0.1f, 1)];
                [eastObj addMesh:[[[Game getInstance] getAssets] getMeshByKey:KEY_ASSETS_MESH_EAST_WALL]];
                [maze addObject:eastObj];
            }
            
            // south wall
            if ([mazeWrapper hasSouthWall:row col:col]) {
                GameObject *southObj = [[GameObject alloc] init];
                [southObj setPosition:GLKVector3Make(col * cellSize, 0.0f, row * cellSize + 0.49f)];
                [southObj setRotation:GLKVector3Make(0, M_PI, 0)];
				[[southObj getBoundingBox] setPosition:GLKVector2Make(col * cellSize - 0.5f, row * cellSize + 0.5f)];
                [[southObj getBoundingBox] setSize:GLKVector2Make(1, 0.1f)];
                [southObj addMesh:[[[Game getInstance] getAssets] getMeshByKey:KEY_ASSETS_MESH_SOUTH_WALL]];
                [maze addObject:southObj];
            }
            
            // west wall
            if ([mazeWrapper hasWestWall:row col:col]) {
                GameObject *westObj = [[GameObject alloc] init];
                [westObj setPosition:GLKVector3Make(col * cellSize - 0.49f, 0.0f, row * cellSize)];
                [westObj setRotation:GLKVector3Make(0, M_PI / 2, 0)];
				[[westObj getBoundingBox] setPosition:GLKVector2Make(col * cellSize - 0.5f, row * cellSize - 0.5f)];
                [[westObj getBoundingBox] setSize:GLKVector2Make(0.1f, 1)];
                [westObj addMesh:[[[Game getInstance] getAssets] getMeshByKey:KEY_ASSETS_MESH_WEST_WALL]];
                [maze addObject:westObj];
            }
        }
    }
    
    // Add an exit wall
    GameObject *exitWall = [[GameObject alloc] init];
    [exitWall setPosition:GLKVector3Make([mazeWrapper numCols] - 1 - 0.5f, 0, [mazeWrapper numRows] - 1 + 0.5f)];
    [[exitWall getBoundingBox] setSize:GLKVector2Make(1, 0.1f)];
    [maze addObject:exitWall];
    
    fogStart = 25.0f;
    fogEnd = 30.0f;
    FOG_MIN = 1.0f;
    FOG_MAX = 2.5f;
    
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] bind];
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] set1f:fogStart uniformName:@"fogStart"];
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] set1f:fogEnd uniformName:@"fogEnd"];
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] unbind];
}

- (void)update {
    deltaTime = [lastTime timeIntervalSinceNow];
    lastTime = [NSDate date];
    
    [spotLight setPosition:[camera getPosition]];
    [spotLight setDirection:[camera getFront]];
    
    if (isMoving) {
        [camera processMove:2.0f deltaTime:deltaTime];
    }
    
    [cube setRotation:GLKVector3AddScalar([cube getRotation], deltaTime)];
	
	[player setPosition:[camera getPosition]];
    [player setRotation:GLKVector3Make(0, -GLKMathDegreesToRadians([camera getYaw]), 0)];
    
    if (!isEditingEnemy) {
        for (GameObject *wall in maze) {
            if ([enemy collidesWithGameObject:wall]) {
                [enemy setPosition:GLKVector3Subtract([enemy getPosition], GLKVector3MultiplyScalar(GLKVector3MultiplyScalar(enemyVelocity, 2.0f), deltaTime))];
                if (enemyVelocity.z < 0) {
                    enemyVelocity = GLKVector3Make(-enemySpeed, 0, 0);
                } else if (enemyVelocity.x > 0) {
                    enemyVelocity = GLKVector3Make(0, 0, -enemySpeed);
                } else if (enemyVelocity.z > 0) {
                    enemyVelocity = GLKVector3Make(enemySpeed, 0, 0);
                } else if (enemyVelocity.x < 0) {
                    enemyVelocity = GLKVector3Make(0, 0, enemySpeed);
                }
                break;
            }
        }
    }
    
    [enemy setPosition:GLKVector3Add([enemy getPosition], GLKVector3MultiplyScalar(enemyVelocity, deltaTime))];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [[[[Game getInstance] getEngine] getRenderer] setupRender:rect];
    [[[[Game getInstance] getEngine] getRenderer] clear];
    
    [[[[Game getInstance] getEngine] getRenderer] renderLight:directionalLight];
    [[[[Game getInstance] getEngine] getRenderer] renderLight:spotLight];
    
    [[[Game getInstance] getEngine] renderGameObject:enemy];
    [[[Game getInstance] getEngine] renderGameObject:cube];
    
    for (GameObject *wall in maze) {
        [[[Game getInstance] getEngine] renderGameObject:wall];
    }
    
    if ([[[[Game getInstance] getEngine] getRenderer] getCamera] == minimapCamera) {
        [[[Game getInstance] getEngine] renderGameObject:player];
    }
}

- (void)handleSingleFingerPan:(UIPanGestureRecognizer *)recognizer {
    static CGPoint singleFingerPanPosition;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        singleFingerPanPosition = [recognizer locationInView:self.view];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint newPosition = [recognizer locationInView:self.view];
        CGPoint offset = CGPointMake(newPosition.x - singleFingerPanPosition.x, newPosition.y - singleFingerPanPosition.y);
        
        if (!isEditingEnemy) {
            [camera processLook:offset];
        } else {
            [enemy setRotation:GLKVector3Make([enemy getRotation].x + offset.x, 0, [enemy getRotation].z + offset.y)];
        }
        
        singleFingerPanPosition = newPosition;
    }
}

- (void)handleTwoFingerPan:(UIPanGestureRecognizer *)recognizer {
    if (isEditingEnemy) {
        static CGPoint twoFingerPanPosition;
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            twoFingerPanPosition = [recognizer locationInView:self.view];
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint newPosition = [recognizer locationInView:self.view];
            CGPoint offset = CGPointMake(newPosition.x - twoFingerPanPosition.x, newPosition.y - twoFingerPanPosition.y);
            
            if (!isEditingEnemy) {
                [camera processLook:offset];
            } else {
                [enemy setPosition:GLKVector3Add([enemy getPosition], GLKVector3Make(offset.x * 0.05f, 0, offset.y * 0.05f))];
            }
            
            twoFingerPanPosition = newPosition;
        }
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        isMoving = true;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        isMoving = false;
    }
}

- (void)handleSingleFingerDoubleTap:(UITapGestureRecognizer *)tapRecognizer {
    [camera setPosition:GLKVector3Make(0, 0, -2)];
    [camera setYaw:DEFAULT_YAW];
}

- (void)handleTwoFingerDoubleTap:(UITapGestureRecognizer *)tapRecognizer {
    if ([[[[Game getInstance] getEngine] getRenderer] getCamera] == camera) {
        [[[[Game getInstance] getEngine] getRenderer] setCamera:minimapCamera];
    } else {
        [[[[Game getInstance] getEngine] getRenderer] setCamera:camera];
    }
}

- (void)handleThreeFingerDoubleTap:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint tap1 = [tapRecognizer locationOfTouch:0 inView:self.view];
    CGPoint tap2 = [tapRecognizer locationOfTouch:1 inView:self.view];
    CGPoint tap3 = [tapRecognizer locationOfTouch:2 inView:self.view];
    CGPoint tapPosition = CGPointMake(tap1.x + tap2.x + tap3.x, tap1.y + tap2.y + tap3.y);
    GLKVector3 ray_origin;
    GLKVector3 ray_direction;
    
    GLint screenWidth = self.view.bounds.size.width;
    GLint screenHeight = self.view.bounds.size.height;
    
    [self screenPosToWorldRay:(screenWidth / 2) mouseY:(screenHeight / 2) screenWidth:screenWidth screenHeight:screenHeight viewMatrix:[camera getViewMatrix] projectionMatrix:[[[[Game getInstance] getEngine] getRenderer] getProjectionMatrix] outOrigin:&ray_origin outDirection:&ray_direction];
    
    
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4TranslateWithVector3(modelMatrix, [enemy getPosition]);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, [enemy getRotation].x, 1.0f, 0.0f, 0.0f);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, [enemy getRotation].y, 0.0f, 1.0f, 0.0f);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, [enemy getRotation].z, 0.0f, 0.0f, 1.0f);
    modelMatrix = GLKMatrix4ScaleWithVector3(modelMatrix, [enemy getScale]);
    
    for (int i = 0; i < 100; i++) {
        float intersection_distance;
        GLKVector3 aabbMin = GLKVector3Make(-1.0f, -1.0f, -1.0f);
        GLKVector3 aabbMax = GLKVector3Make(1.0f, 1.0f, 1.0f);
        
        if ([self testRayOBBIntersection:ray_origin rayDirection:ray_direction aabbMin:aabbMin aabbMax:aabbMax modelMatrix:modelMatrix intersectionDistance:intersection_distance]) {
            isEditingEnemy = !isEditingEnemy;
            break;
        }
    }
    
    
     if (!isEditingEnemy) {
         oldVelocity = enemyVelocity;
         enemyVelocity = GLKVector3Make(0, 0, 0);
     } else {
         enemyVelocity = oldVelocity;
     }
}

- (void)handleTwoFingerPinch:(UIPinchGestureRecognizer *)recognizer {
    if (isEditingEnemy) {
        if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
            [enemy setScale:GLKVector3Make(recognizer.scale, recognizer.scale, recognizer.scale)];
        }
    }
}

- (IBAction)lightingButtonClicked:(id)sender {
    if (GLKVector3AllEqualToVector3([directionalLight getAmbient], DIRECTIONALLIGHT_MORNING)) {
        [directionalLight setAmbient:DIRECTIONALLIGHT_NIGHT];
    } else {
        [directionalLight setAmbient:DIRECTIONALLIGHT_MORNING];
    }
}

- (IBAction)flashlightButtonClicked:(id)sender {
    if (GLKVector3AllEqualToVector3([spotLight getDiffuse], SPOTLIGHT_ON_DIFFUSE)) {
        [spotLight setAmbient:SPOTLIGHT_OFF_DIFFUSE];
        [spotLight setDiffuse:SPOTLIGHT_OFF_DIFFUSE];
        [spotLight setSpecular:SPOTLIGHT_OFF_DIFFUSE];
    } else {
        [spotLight setAmbient:SPOTLIGHT_ON_AMBIENT];
        [spotLight setDiffuse:SPOTLIGHT_ON_DIFFUSE];
        [spotLight setSpecular:SPOTLIGHT_ON_SPECULAR];
    }
}

- (IBAction)fogButtonClicked:(id)sender {
    isFogEnabled = !isFogEnabled;
    
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] bind];
    if (isFogEnabled) {
        [_slider setHidden:FALSE];
        [_sliderMin setHidden:FALSE];
        [_sliderMax setHidden:FALSE];
        fogStart = FOG_MIN;
        fogEnd = FOG_MAX;
    } else {
        [_slider setHidden:TRUE];
        [_sliderMin setHidden:TRUE];
        [_sliderMax setHidden:TRUE];
        fogStart = 25.0f;
        fogEnd = 30.0f;
    }
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] set1f:fogStart uniformName:@"fogStart"];
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] set1f:fogEnd uniformName:@"fogEnd"];
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] unbind];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    fogStart = sender.value;
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] bind];
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] set1f:fogStart uniformName:@"fogStart"];
    [[[[[Game getInstance] getEngine] getRenderer] getCachedProgram:KEY_PROGRAM_BASIC] unbind];
}

- (BOOL)isInSameCell:(GameObject *)left otherObject:(GameObject *)right {
    CGPoint leftCell = [self getCellforGameObject:left];
    CGPoint rightCell = [self getCellforGameObject:right];
    if (leftCell.x == rightCell.x && leftCell.y == rightCell.y)
        return TRUE;
    return FALSE;
}

- (CGPoint)getCellforGameObject:(GameObject *)gameObject {
    CGPoint point;
    
    point.x = round([gameObject getPosition].x);
    point.y = round([gameObject getPosition].z);
    
    return point;
}
    
/*
 * Adapated from https://github.com/opengl-tutorials/ogl/blob/master/misc05_picking/misc05_picking_custom.cpp
 *
 * @param mouseX Mouse position in pixels from bottom-left corner of the window
 * @param mouseY Mouse position in pixels from bottom-left corner of the window
 * @param screenWidth Window size in pixels
 * @param screenHeight Window size in pixels
 * @param viewMatrix Camera position and orientation
 * @param projectionMatrix Camera parameters (ratio, field of view, near and far planes)
 * @param outOrigin Origin of the ray
 * @param outDirection Direction, in world space, of the ray that goes through the mouse
 */
- (void)screenPosToWorldRay:(GLfloat)mouseX mouseY:(GLfloat)mouseY screenWidth:(GLint)screenWidth screenHeight:(GLint)screenHeight viewMatrix:(GLKMatrix4)viewMatrix projectionMatrix:(GLKMatrix4)projectionMatrix outOrigin:(GLKVector3 *)outOrigin outDirection:(GLKVector3 *)outDirection {
    
    GLKVector4 lRayStart_NDC = GLKVector4Make(((float)mouseX / (float)screenWidth - 0.5f) * 2.0f, ((float)mouseY / (float)screenHeight - 0.5f) * 2.0f, -1.0, 1.0f);
    GLKVector4 lRayEnd_NDC = GLKVector4Make(((float)mouseX / (float)screenWidth - 0.5f) * 2.0f, ((float)mouseY / (float)screenHeight - 0.5f) * 2.0f, 0.0, 1.0f);
    
    GLKMatrix4 InverseProjectionMatrix = GLKMatrix4Invert(projectionMatrix, NULL);
    GLKMatrix4 InverseViewMatrix = GLKMatrix4Invert(viewMatrix, NULL);
    
    GLKVector4 lRayStart_camera = GLKMatrix4MultiplyVector4(InverseProjectionMatrix, lRayStart_NDC);
    lRayStart_camera = GLKVector4DivideScalar(lRayStart_camera, lRayStart_camera.w);
    GLKVector4 lRayStart_world = GLKMatrix4MultiplyVector4(InverseViewMatrix, lRayStart_camera);
    lRayStart_world = GLKVector4DivideScalar(lRayStart_world, lRayStart_world.w);
    GLKVector4 lRayEnd_camera = GLKMatrix4MultiplyVector4(InverseProjectionMatrix, lRayEnd_NDC);
    lRayEnd_camera = GLKVector4DivideScalar(lRayEnd_camera, lRayEnd_camera.w);
    GLKVector4 lRayEnd_world = GLKMatrix4MultiplyVector4(InverseViewMatrix, lRayEnd_camera);
    lRayEnd_world = GLKVector4DivideScalar(lRayEnd_world, lRayEnd_world.w);
    
    GLKVector4 lRayDir_world4 = GLKVector4Subtract(lRayEnd_world, lRayStart_world);
    GLKVector3 lRayDir_world = GLKVector3Make(lRayDir_world4.x, lRayDir_world4.y, lRayDir_world4.z);
    lRayDir_world = GLKVector3Normalize(lRayDir_world);
    
    *outOrigin = GLKVector3Make(lRayStart_world.x, lRayStart_world.y, lRayStart_world.z);
    *outDirection = GLKVector3Normalize(lRayDir_world);
}

/*
 * Adapated from https://github.com/opengl-tutorials/ogl/blob/master/misc05_picking/misc05_picking_custom.cpp
 */
- (bool)testRayOBBIntersection:(GLKVector3)rayOrigin rayDirection:(GLKVector3)rayDirection aabbMin:(GLKVector3)aabbMin aabbMax:(GLKVector3)aabbMax modelMatrix:(GLKMatrix4)modelMatrix intersectionDistance:(GLfloat)intersectionDistance {
    float tMin = 0.0f;
    float tMax = 100000.0f;

    GLKVector3 OBBposition_worldspace = GLKVector3Make(modelMatrix.m30, modelMatrix.m31, modelMatrix.m32);
    GLKVector3 delta = GLKVector3Subtract(OBBposition_worldspace, rayOrigin);
    
    // Test intersection with the 2 planes perpendicular to the OBB's X axis
    {
        GLKVector3 xaxis = GLKVector3Make(modelMatrix.m01, modelMatrix.m02, modelMatrix.m03);
        float e = GLKVector3DotProduct(xaxis, delta);
        float f = GLKVector3DotProduct(rayDirection, xaxis);
        
        if (fabsf(f) > 0.001f) {
            float t1 = (e+aabbMin.x) / f; // intersection with the left plane
            float t2 = (e+aabbMax.x) / f; // intersection with the right plane
            // t1 and t2 now contain distances between ray origin and ray-plane intersections
            
            // we want t1 to represent the nearest intersection,
            // so if it's not the case, invert t1 and t2
            if (t1 > t2) {
                float w = t1; t1 = t2; t2 = w; // swap t1 and t2;
            }
            
            // tMax is the nearest "far" intersection (amongst the X, Y, and Z planes pairs)
            if (t2 < tMax)
                tMax = t2;
            // tMin is the farthest "near" intersection (amongst the X, Y, and Z planes pairs)
            if (t1 > tMin)
                tMin = t1;
            
            // if far is close than near, then there is NO intersection
            if (tMax < tMin)
                return false;
        } else { // rare case : the ray is almost paralell to the planes, so they don't have any "intersection"
            if (-e + aabbMin.x > 0.0f || -e + aabbMax.x < 0.0f)
                return false;
        }
    }
    
    intersectionDistance = tMin;
    
    return true;
}

@end
