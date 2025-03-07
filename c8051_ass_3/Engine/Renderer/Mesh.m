//
//  Mesh.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Mesh.h"
#import <OpenGLES/ES2/glext.h>

@implementation Mesh

- (id)initWithVertices:(NSMutableData *)verticesData indices:(NSMutableData *)indicesData {
	if (self == [super init]) {
		vertices = [NSMutableData dataWithData:verticesData];
		indices = [NSMutableData dataWithData:indicesData];
        
        indicesCount = (GLuint)[indices length] / sizeof(GLuint);
        
        textures = [NSMutableArray array];
        
        shininess = 32.0f;
		specular = GLKVector3Make(1, 1, 1);
	}
	return self;
}

- (id)initWithMesh:(Mesh *)mesh {
	if (self == [super init]) {
		vertices = [NSMutableData dataWithData:[mesh getVertices]];
		indices = [NSMutableData dataWithData:[mesh getIndices]];
        
        indicesCount = (GLuint)[indices length] / sizeof(GLuint);
        
        textures = [NSMutableArray arrayWithArray:[mesh getTextures]];
        
        shininess = 32.0f;
		specular = GLKVector3Make(1, 1, 1);
        
        [self setup];
	}
	return self;
}

- (id)copy {
	return [[Mesh alloc] initWithMesh:self];
}

- (void)dealloc {
	if (vao) {
		glDeleteVertexArraysOES(1, &vao);
		vao = 0;
	}
	
	if (vbo) {
		glDeleteBuffers(1, &vbo);
		vbo = 0;
	}
	
	if (ebo) {
		glDeleteBuffers(1, &ebo);
		ebo = 0;
	}
}

- (void)setup {
	glGenVertexArraysOES(1, &vao);
	glGenBuffers(1, &vbo);
	glGenBuffers(1, &ebo);
	
    glBindVertexArrayOES(vao);
	glBindBuffer(GL_ARRAY_BUFFER, vbo);
	
	glBufferData(GL_ARRAY_BUFFER, [vertices length], [vertices bytes], GL_STATIC_DRAW);
	
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, [indices length], [indices bytes], GL_STATIC_DRAW);
	
	// Vertex positions
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)0);
	// Vertex normals
	glEnableVertexAttribArray(GLKVertexAttribNormal);
	glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)offsetof(Vertex, normal));
	// Vertex texture coords
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)offsetof(Vertex, texcoord));
	
	glBindVertexArrayOES(0);
}

- (void)renderWithProgram:(Program *)program {
	GLuint diffuseNr = 1;
	
	for (GLuint i = 0; i < [textures count]; i++) {
		glActiveTexture(GL_TEXTURE0 + i);
		GLuint number = 0;
		NSString *name = [textures[i] getType];
		if ([name isEqualToString:@"texture_diffuse"]) {
			number = diffuseNr++;
		}
		[program set1i:i uniformName:[NSString stringWithFormat:@"%@%u", name, number]];
		glBindTexture(GL_TEXTURE_2D, [textures[i] getId]);
	}
    
	[program set3fv:specular.v uniformName:@"material.specular"];
    [program set1f:shininess uniformName:@"material.shininess"];

    glBindVertexArrayOES(vao);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glDrawElements(GL_TRIANGLES, indicesCount, GL_UNSIGNED_INT, 0);
    glBindVertexArrayOES(0);
    glActiveTexture(GL_TEXTURE0);
}

- (NSMutableData *)getVertices {
	return vertices;
}

- (NSMutableData *)getIndices {
	return indices;
}

- (NSMutableArray<Texture *> *)getTextures {
    return textures;
}

- (Texture *)getTextureByIndex:(GLint)index {
    if (index >= textures.count) return nil;
    return [textures objectAtIndex:index];
}

- (void)addTexture:(Texture *)texture {
    [textures addObject:texture];
}

- (void)setShininess:(GLfloat)SHININESS {
    shininess = SHININESS;
}

@end
