//
//  Geometry.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Geometry.h"

@implementation Geometry

+ (Mesh *)triangle {
    NSMutableData *vertices = [NSMutableData data];
    NSMutableData *indices = [NSMutableData data];
	
	Vertex verticesArray[] = {
		// top
		{
			{
				0, 0.5f, 0
			},
			{
				0, 0, 1
			},
			{
				0.5f, 1
			}
		},
		// bottom left
		{
			{
				-0.5f, -0.5f, 0
			},
			{
				0, 0, 1
			},
			{
				0, 0
			}
		},
		// bottom right
		{
			{
				0.5f, -0.5f, 0
			},
			{
				0, 0, 1
			},
			{
				1, 0
			}
		}
	};
	
	GLuint indicesArray[] = {
		0, 1, 2
	};
	
	for (int i = 0; i < sizeof(verticesArray) / sizeof(Vertex); i++) {
		[vertices appendBytes:&verticesArray[i] length:sizeof(Vertex)];
	}
	
	for (int i = 0; i < sizeof(indicesArray) / sizeof(GLuint); i++) {
		[indices appendBytes:&indicesArray[i] length:sizeof(GLuint)];
	}
	
	Mesh *mesh = [[Mesh alloc] initWithVertices:vertices indices:indices];
	
	[mesh setup];
	
    return mesh;
}

+ (Mesh *)square {
    NSMutableData *vertices = [NSMutableData data];
    NSMutableData *indices = [NSMutableData data];
	
	Vertex verticesArray[] = {
		// top left
		{
			{
				-0.5f, 0.5f, 0
			},
			{
				0, 0, 1
			},
			{
                0, 0
			}
		},
		// top right
		{
			{
				0.5f, 0.5f, 0
			},
			{
				0, 0, 1
			},
			{
                1, 0
			}
		},
		// bottom left
		{
			{
				-0.5f, -0.5f, 0
			},
			{
				0, 0, 1
			},
			{
                0, 1
			}
		},
		// bottom right
		{
			{
				0.5f, -0.5f, 0
			},
			{
				0, 0, 1
			},
			{
                1, 1
			}
		}
	};
	
	GLuint indicesArray[] = {
		0, 1, 2,
        3, 2, 1
	};
	
	for (int i = 0; i < sizeof(verticesArray) / sizeof(Vertex); i++) {
		[vertices appendBytes:&verticesArray[i] length:sizeof(Vertex)];
	}
	
	for (int i = 0; i < sizeof(indicesArray) / sizeof(GLuint); i++) {
		[indices appendBytes:&indicesArray[i] length:sizeof(GLuint)];
	}
	
	Mesh *mesh = [[Mesh alloc] initWithVertices:vertices indices:indices];
	
	[mesh setup];
	
    return mesh;
}

@end
