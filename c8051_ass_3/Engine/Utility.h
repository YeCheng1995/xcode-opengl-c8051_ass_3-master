//
//  Utility.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Renderer/Mesh.h"

@interface Utility : NSObject

+ (NSString *)getFilepath:(NSString *)filename fileType:(NSString *)fileType;
+ (NSString *)getFilepath:(NSString *)filename fileType:(NSString *)fileType bundle:(NSBundle *)bundle;

+ (Mesh *)loadMeshByFilename:(NSString *)filename;

@end
