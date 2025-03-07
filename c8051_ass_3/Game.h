//
//  Game.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Assets.h"
#import "Engine/Engine.h"

extern NSString *KEY_ASSETS_TEXTURE_DIFFUSE_GOLDEN_GOOSE;
extern NSString *KEY_ASSETS_TEXTURE_DIFFUSE_CRATE;
extern NSString *KEY_ASSETS_TEXTURE_DIFFUSE_NORTH_WALL;
extern NSString *KEY_ASSETS_TEXTURE_DIFFUSE_EAST_WALL;
extern NSString *KEY_ASSETS_TEXTURE_DIFFUSE_SOUTH_WALL;
extern NSString *KEY_ASSETS_TEXTURE_DIFFUSE_WEST_WALL;
extern NSString *KEY_ASSETS_TEXTURE_DIFFUSE_FLOOR;
extern NSString *KEY_ASSETS_TEXTURE_DIFFUSE_ARROW;

extern NSString *KEY_ASSETS_MESH_CUBE;
extern NSString *KEY_ASSETS_MESH_CUBE_DIRECTION;
extern NSString *KEY_ASSETS_MESH_GOLDEN_GOOSE;
extern NSString *KEY_ASSETS_MESH_NORTH_WALL;
extern NSString *KEY_ASSETS_MESH_EAST_WALL;
extern NSString *KEY_ASSETS_MESH_SOUTH_WALL;
extern NSString *KEY_ASSETS_MESH_WEST_WALL;
extern NSString *KEY_ASSETS_MESH_FLOOR;

@interface Game : NSObject {
    Engine *engine;
    Assets *assets;
}

+ (id)getInstance;

- (void)loadResources;

- (Engine *)getEngine;
- (Assets *)getAssets;

@end
