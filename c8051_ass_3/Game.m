//
//  Game.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Game.h"
#import "Engine/Utility.h"
#import "Engine/Log.h"
#import "Engine/Renderer/Geometry.h"

NSString *KEY_ASSETS_TEXTURE_DIFFUSE_GOLDEN_GOOSE = @"diffuse_golden_goose";
NSString *KEY_ASSETS_TEXTURE_DIFFUSE_CRATE = @"diffuse_crate";
NSString *KEY_ASSETS_TEXTURE_DIFFUSE_NORTH_WALL = @"diffuse_north_wall";
NSString *KEY_ASSETS_TEXTURE_DIFFUSE_EAST_WALL = @"diffuse_east_wall";
NSString *KEY_ASSETS_TEXTURE_DIFFUSE_SOUTH_WALL = @"diffuse_south_wall";
NSString *KEY_ASSETS_TEXTURE_DIFFUSE_WEST_WALL = @"diffuse_west_wall";
NSString *KEY_ASSETS_TEXTURE_DIFFUSE_FLOOR = @"diffuse_floor";
NSString *KEY_ASSETS_TEXTURE_DIFFUSE_ARROW = @"arrow";

NSString *KEY_ASSETS_MESH_CUBE = @"cube";
NSString *KEY_ASSETS_MESH_CUBE_DIRECTION= @"cube_direction";
NSString *KEY_ASSETS_MESH_GOLDEN_GOOSE = @"golden_goose";
NSString *KEY_ASSETS_MESH_NORTH_WALL = @"north_wall";
NSString *KEY_ASSETS_MESH_EAST_WALL = @"east_wall";
NSString *KEY_ASSETS_MESH_SOUTH_WALL = @"south_wall";
NSString *KEY_ASSETS_MESH_WEST_WALL = @"west_wall";
NSString *KEY_ASSETS_MESH_FLOOR = @"floor";

static Game *INSTANCE = nil;

@implementation Game

+ (id)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INSTANCE = [[self alloc] init];
    });
    return INSTANCE;
}

- (id)init {
    if (self == [super init]) {
        engine = [[Engine alloc] init];
        assets = [[Assets alloc] init];
    }
    return self;
}

- (void)loadResources {
    [self loadTextures];
    [self loadMeshes];
}

- (void)loadTextures {
    Texture *texture = [[Texture alloc] initWithFilename:[Utility getFilepath:@"golden_goose.png" fileType:@"textures"]];
    [assets setTexture:texture forKey:KEY_ASSETS_TEXTURE_DIFFUSE_GOLDEN_GOOSE];
    texture = [[Texture alloc] initWithFilename:[Utility getFilepath:@"crate.jpg" fileType:@"textures"]];
    [assets setTexture:texture forKey:KEY_ASSETS_TEXTURE_DIFFUSE_CRATE];
    texture = [[Texture alloc] initWithFilename:[Utility getFilepath:@"north.jpg" fileType:@"textures"]];
    [assets setTexture:texture forKey:KEY_ASSETS_TEXTURE_DIFFUSE_NORTH_WALL];
    texture = [[Texture alloc] initWithFilename:[Utility getFilepath:@"east.jpg" fileType:@"textures"]];
    [assets setTexture:texture forKey:KEY_ASSETS_TEXTURE_DIFFUSE_EAST_WALL];
    texture = [[Texture alloc] initWithFilename:[Utility getFilepath:@"south.jpg" fileType:@"textures"]];
    [assets setTexture:texture forKey:KEY_ASSETS_TEXTURE_DIFFUSE_SOUTH_WALL];
    texture = [[Texture alloc] initWithFilename:[Utility getFilepath:@"west.jpg" fileType:@"textures"]];
    [assets setTexture:texture forKey:KEY_ASSETS_TEXTURE_DIFFUSE_WEST_WALL];
    texture = [[Texture alloc] initWithFilename:[Utility getFilepath:@"floor.jpg" fileType:@"textures"]];
    [assets setTexture:texture forKey:KEY_ASSETS_TEXTURE_DIFFUSE_FLOOR];
    texture = [[Texture alloc] initWithFilename:[Utility getFilepath:@"arrow-256.jpg" fileType:@"textures"]];
    [assets setTexture:texture forKey:KEY_ASSETS_TEXTURE_DIFFUSE_ARROW];
}

- (void)loadMeshes {
    Mesh *mesh = [Utility loadMeshByFilename:[Utility getFilepath:@"cube.obj" fileType:@"models"]];
    [mesh addTexture:[assets getTextureByKey:KEY_ASSETS_TEXTURE_DIFFUSE_CRATE]];
    [assets setMesh:mesh forKey:KEY_ASSETS_MESH_CUBE];
    mesh = [Utility loadMeshByFilename:[Utility getFilepath:@"cube.obj" fileType:@"models"]];
    [mesh addTexture:[assets getTextureByKey:KEY_ASSETS_TEXTURE_DIFFUSE_ARROW]];
    [assets setMesh:mesh forKey:KEY_ASSETS_MESH_CUBE_DIRECTION];
    mesh = [Utility loadMeshByFilename:[Utility getFilepath:@"golden_goose.obj" fileType:@"models"]];
    [mesh addTexture:[assets getTextureByKey:KEY_ASSETS_TEXTURE_DIFFUSE_GOLDEN_GOOSE]];
    [assets setMesh:mesh forKey:KEY_ASSETS_MESH_GOLDEN_GOOSE];
	mesh = [Geometry square];
	[mesh addTexture:[assets getTextureByKey:KEY_ASSETS_TEXTURE_DIFFUSE_NORTH_WALL]];
	[assets setMesh:mesh forKey:KEY_ASSETS_MESH_NORTH_WALL];
	mesh = [Geometry square];
	[mesh addTexture:[assets getTextureByKey:KEY_ASSETS_TEXTURE_DIFFUSE_EAST_WALL]];
	[assets setMesh:mesh forKey:KEY_ASSETS_MESH_EAST_WALL];
	mesh = [Geometry square];
	[mesh addTexture:[assets getTextureByKey:KEY_ASSETS_TEXTURE_DIFFUSE_SOUTH_WALL]];
	[assets setMesh:mesh forKey:KEY_ASSETS_MESH_SOUTH_WALL];
	mesh = [Geometry square];
	[mesh addTexture:[assets getTextureByKey:KEY_ASSETS_TEXTURE_DIFFUSE_WEST_WALL]];
	[assets setMesh:mesh forKey:KEY_ASSETS_MESH_WEST_WALL];
	mesh = [Geometry square];
	[mesh addTexture:[assets getTextureByKey:KEY_ASSETS_TEXTURE_DIFFUSE_FLOOR]];
	[assets setMesh:mesh forKey:KEY_ASSETS_MESH_FLOOR];
}

- (Engine *)getEngine {
    return engine;
}

- (Assets *)getAssets {
    return assets;
}

@end
