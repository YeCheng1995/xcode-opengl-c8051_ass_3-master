//
//  Utility.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Utility.h"
#import "Log.h"

@implementation Utility

+ (NSString *)getFilepath:(NSString *)filename fileType:(NSString *)fileType {
    return [Utility getFilepath:filename fileType:fileType bundle:[NSBundle mainBundle]];
}

+ (NSString *)getFilepath:(NSString *)filename fileType:(NSString *)fileType bundle:(NSBundle *)bundle {
    return [bundle pathForResource:filename ofType:nil inDirectory:[NSString stringWithFormat:@"assets/%@/", fileType]];
}

+ (Mesh *)loadMeshByFilename:(NSString *)filename {
    NSString *contents = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:NULL];
    
    // The final buffers to pass to the Mesh
    NSMutableData *vertices = [NSMutableData data];
    NSMutableData *indices = [NSMutableData data];
    
    // The arrays of vertices with point, normals, and uvs matching to a single point
    NSMutableArray<NSValue *> *out_vertices = [NSMutableArray array];
    NSMutableArray<NSValue *> *out_uvs = [NSMutableArray array];
    NSMutableArray<NSValue *> *out_normals = [NSMutableArray array];
    
    // The array of indices in the OBJ file
    NSMutableArray<NSNumber *> *vertexIndices = [NSMutableArray array];
    NSMutableArray<NSNumber *> *uvIndices = [NSMutableArray array];
    NSMutableArray<NSNumber *> *normalIndices = [NSMutableArray array];
    
    // The points, uvs, and normals in the OBJ file
    NSMutableArray<NSValue *> *temp_vertices = [NSMutableArray array];
    NSMutableArray<NSValue *> *temp_uvs = [NSMutableArray array];
    NSMutableArray<NSValue *> *temp_normals = [NSMutableArray array];
    
    NSScanner *fileScanner = [NSScanner scannerWithString:contents];
    int lineNumber = 0;
    
    NSString *line;
    while ([fileScanner scanUpToString:@"\n" intoString:&line]) {
        lineNumber++;
        
        // remove comments
        line = [[line componentsSeparatedByString:@"#"] objectAtIndex:0];
        
        NSScanner *lineScanner = [NSScanner scannerWithString:line];
        
        NSString *directive;
        
        if (![lineScanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&directive]) {
            continue;
        }
        
        if ([directive isEqualToString:@"v"]) {
            GLKVector3 pt;
            BOOL xyzOK = ([lineScanner scanFloat:&pt.x] &&
                          [lineScanner scanFloat:&pt.y] &&
                          [lineScanner scanFloat:&pt.z]);
            
            // Ignore the 'w' component
            [lineScanner scanFloat:NULL];
            
            if (!xyzOK || ![lineScanner isAtEnd]) {
                [Log l:@"The 'v' directive should be followed by 3 numbers."];
                continue;
            }
            
            [temp_vertices addObject:[NSValue value:&pt withObjCType:@encode(GLKVector3)]];
        } else if ([directive isEqualToString:@"vt"]) {
            // Turn any potential texture coordinate into a 2-dimensional one
            GLKVector2 tc;
            if ([lineScanner scanFloat:&tc.x]) {
                if ([lineScanner scanFloat:&tc.y]) {
                    // OpenGL flips the UV coordinate, so we reverse it
                    tc.y = 1 - tc.y;
                    if ([lineScanner scanFloat:NULL]) {
                        [Log l:@"This OBJ file has a texture coordinate in 3-dimensions."];
                        [temp_uvs addObject:[NSValue value:&tc withObjCType:@encode(GLKVector2)]];
                    } else if ([lineScanner isAtEnd]) {
                        [temp_uvs addObject:[NSValue value:&tc withObjCType:@encode(GLKVector2)]];
                    } else {
                        [Log l:@"The 'vt' directive expects 2 numbers."];
                    }
                } else if ([lineScanner isAtEnd]) {
                    tc.y = 0;
                    [temp_uvs addObject:[NSValue value:&tc withObjCType:@encode(GLKVector2)]];
                } else {
                    [Log l:@"The 'vt' directive expects 2 numbers."];
                }
            } else {
                [Log l:@"The 'vt' directive expects 2 numbers."];
            }
        } else if ([directive isEqualToString:@"vn"]) {
            GLKVector3 n;
            if (![lineScanner scanFloat:&n.x] ||
                ![lineScanner scanFloat:&n.y] ||
                ![lineScanner scanFloat:&n.z] ||
                ![lineScanner isAtEnd]) {
                [Log l:@"The 'vn' directive expects 3 numbers."];
                continue;
            }
            [temp_normals addObject:[NSValue value:&n withObjCType:@encode(GLKVector3)]];
        } else if ([directive isEqualToString:@"f"]) {
            NSString *vertexStr;
            while ([lineScanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&vertexStr]) {
                NSScanner *vertexScanner = [NSScanner scannerWithString:vertexStr];
                GLint pointIndex, uvIndex, normalIndex;
                if ([vertexScanner scanInt:&pointIndex]) {
                    if ([vertexScanner scanString:@"/" intoString:NULL]) {
                        if ([vertexScanner scanInt:&uvIndex]) {
                            if ([vertexScanner scanString:@"/" intoString:NULL]) {
                                if (![vertexScanner scanInt:&normalIndex]) {
                                    // Unable to find the normal index
                                    [Log l:@"Parse error in vertex."];
                                    continue;
                                }
                            } else {
                                // Unable to find the normal index
                                [Log l:@"Parse error in vertex."];
                                continue;
                            }
                        } else {
                            // Unable to find the texture index
                            [Log l:@"Parse error in vertex."];
                            continue;
                        }
                    } else {
                        // There's only a point in this face, no other data
                        [Log l:@"Parse error in vertex."];
                        continue;
                    }
                } else {
                    // We were unable to find a point
                    [Log l:@"Parse error in vertex."];
                    continue;
                }
                
                if (![vertexScanner isAtEnd]) {
                    [Log l:@"Parse error in vertex."];
                    continue;
                }
                
                [vertexIndices addObject:[NSNumber numberWithUnsignedInt:pointIndex]];
                [uvIndices addObject:[NSNumber numberWithUnsignedInt:uvIndex]];
                [normalIndices addObject:[NSNumber numberWithUnsignedInt:normalIndex]];
            }
        }
    }
    
    for (GLuint i = 0; i < [vertexIndices count]; i++) {
        GLuint vertexIndex = [[vertexIndices objectAtIndex:i] unsignedIntValue];
        GLuint uvIndex = [[uvIndices objectAtIndex:i] unsignedIntValue];
        GLuint normalIndex = [[normalIndices objectAtIndex:i] unsignedIntValue];
        
        GLKVector3 vertex, normal;
        GLKVector2 uv;
        [[temp_vertices objectAtIndex:(vertexIndex - 1)] getValue:&vertex];
        [[temp_uvs objectAtIndex:(uvIndex - 1)] getValue:&uv];
        [[temp_normals objectAtIndex:(normalIndex - 1)] getValue:&normal];
        
        [out_vertices addObject:[NSValue value:&vertex withObjCType:@encode(GLKVector3)]];
        [out_uvs addObject:[NSValue value:&uv withObjCType:@encode(GLKVector2)]];
        [out_normals addObject:[NSValue value:&normal withObjCType:@encode(GLKVector3)]];
    }
    
    NSMutableDictionary<NSValue *, NSNumber *> *VertexToOutIndex = [NSMutableDictionary dictionary];
    for (GLuint i = 0; i < out_vertices.count; i++) {
        Vertex vertex;
        [out_vertices[i] getValue:&vertex.point];
        [out_uvs[i] getValue:&vertex.texcoord];
        [out_normals[i] getValue:&vertex.normal];
        
        bool found = false;
        NSNumber *indexNumber = [VertexToOutIndex objectForKey:[NSValue value:&vertex withObjCType:@encode(Vertex)]];
        if (indexNumber != nil) {
            found = true;
        }
        if (found) {
            GLuint index = [indexNumber unsignedIntValue];
            [indices appendBytes:&index length:sizeof(GLuint)];
        } else {
            [vertices appendBytes:&vertex length:sizeof(Vertex)];
            GLsizei numVertices = [vertices length] / sizeof(Vertex);
            GLuint index = (GLuint)numVertices - 1;
            [indices appendBytes:&index length:sizeof(GLuint)];
        }
    }
    
    return [[Mesh alloc] initWithVertices:vertices indices:indices];
}

@end
