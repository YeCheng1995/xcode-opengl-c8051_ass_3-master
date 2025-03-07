//
//  Renderer.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Renderer.h"
#import "../Utility.h"

const GLKVector3 DEFAULT_CLEAR_COLOR = { 0.2f, 0.3f, 0.3f };

const NSString *KEY_PROGRAM_BASIC = @"basic";

@implementation Renderer

- (id)init {
	if (self == [super init]) {
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		
		if (!context) {
			NSLog(@"Failed to create GLES context.");
		}
		
		[EAGLContext setCurrentContext:context];
		
		glEnable(GL_DEPTH_TEST);
		glEnable(GL_TEXTURE_2D);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        cachedPrograms = [NSMutableDictionary dictionary];
        
        [self loadResources];
	}
	return self;
}

- (void)loadResources {
    NSMutableArray<Shader *> *shaders = [[NSMutableArray<Shader *> alloc] init];
    NSMutableArray<ShaderAttribute *> *attributes = [[NSMutableArray<ShaderAttribute *> alloc] init];
    
    Shader *vertexShader = [[Shader alloc] initWithFilename:[Utility getFilepath:@"basic.vsh" fileType:@"shaders"] shaderType:GL_VERTEX_SHADER];
    Shader *fragmentShader = [[Shader alloc] initWithFilename:[Utility getFilepath:@"basic.fsh" fileType:@"shaders"] shaderType:GL_FRAGMENT_SHADER];
    [shaders addObject:vertexShader];
    [shaders addObject:fragmentShader];
    ShaderAttribute *position = [[ShaderAttribute alloc] initWithName:@"aPos" attributeId:GLKVertexAttribPosition];
    ShaderAttribute *normal = [[ShaderAttribute alloc] initWithName:@"aNormal" attributeId:GLKVertexAttribNormal];
    ShaderAttribute *texcoord = [[ShaderAttribute alloc] initWithName:@"aTexCoords" attributeId:GLKVertexAttribTexCoord0];
    [attributes addObject:position];
    [attributes addObject:normal];
    [attributes addObject:texcoord];
    Program *program = [[Program alloc] initWithShaders:&shaders attributes:&attributes];
    [cachedPrograms setObject:program forKey:KEY_PROGRAM_BASIC];
}

- (void)setView:(GLKView *)view {
	view.context = context;
	view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
	
	glViewport(0, 0, view.bounds.size.width, view.bounds.size.height);
    aspectRatio = fabsf((float)(view.bounds.size.width / view.bounds.size.height));
}

- (Camera *)getCamera {
    return mainCamera;
}

- (void)setCamera:(Camera *)camera {
    mainCamera = camera;
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians([mainCamera getFieldOfView]), aspectRatio, [mainCamera getNearClippingPlane], [mainCamera getFarClippingPlane]);
}

- (void)setupRender:(CGRect)rect {
	[self setupRender:rect program:[self getCachedProgram:KEY_PROGRAM_BASIC]];
}

- (void)setupRender:(CGRect)rect program:(Program *)program {
	[program bind];
    
    viewMatrix = [mainCamera getViewMatrix];
	
	[program set3fv:[mainCamera getPosition].v uniformName:@"viewPos"];
	[program set4fvm:viewMatrix.m uniformName:@"view"];
	[program set4fvm:projectionMatrix.m uniformName:@"projection"];
}

- (void)clear {
    glClearColor(DEFAULT_CLEAR_COLOR.r, DEFAULT_CLEAR_COLOR.g, DEFAULT_CLEAR_COLOR.b, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT |  GL_DEPTH_BUFFER_BIT);
}

- (void)renderMesh:(Mesh *)mesh position:(GLKVector3)position rotation:(GLKVector3)rotation scale:(GLKVector3)scale {
    [self renderMesh:mesh program:[self getCachedProgram:KEY_PROGRAM_BASIC] position:position rotation:rotation scale:scale];
}

- (void)renderMesh:(Mesh *)mesh program:(Program *)program position:(GLKVector3)position rotation:(GLKVector3)rotation scale:(GLKVector3)scale {
    if (mesh == nil) return;

    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4TranslateWithVector3(modelMatrix, position);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.x, 1.0f, 0.0f, 0.0f);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.y, 0.0f, 1.0f, 0.0f);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.z, 0.0f, 0.0f, 1.0f);
    modelMatrix = GLKMatrix4ScaleWithVector3(modelMatrix, scale);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(GLKMatrix4Multiply(viewMatrix, modelMatrix)), NULL);
    [program set3fvm:normalMatrix.m uniformName:@"normalMatrix"];
    [program set4fvm:modelMatrix.m uniformName:@"model"];
    
    [mesh renderWithProgram:program];
}

- (void)renderLight:(Light *)light {
    [self renderLight:light program:[self getCachedProgram:KEY_PROGRAM_BASIC]];
}

- (void)renderLight:(Light *)light program:(Program *)program {
    [light renderWithProgram:program];
}

- (Program *)getCachedProgram:(NSString *)key {
    return [cachedPrograms objectForKey:key];
}
    
- (GLKMatrix4)getProjectionMatrix {
    return projectionMatrix;
}

@end
