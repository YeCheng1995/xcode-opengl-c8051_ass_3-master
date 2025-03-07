//
//  Mesh.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "Program.h"
#import "Texture.h"

typedef struct {
	GLKVector3 point;
	GLKVector3 normal;
	GLKVector2 texcoord;
} Vertex;

@interface Mesh : NSObject {
	NSMutableData *vertices;
	NSMutableData *indices;
    
    NSMutableArray<Texture *> *textures;
    
    GLuint indicesCount;
	
	GLuint vao;
	GLuint vbo;
	GLuint ebo;
    
    GLfloat shininess;
	GLKVector3 specular;
}

/*!
 * @brief Initializes a Mesh instance with vertices and indices.
 * @author Jason Chung
 *
 * @param verticesData The vertices to copy.
 * @param indicesData the indices to copy.
 *
 * @return The new Mesh.
 */
- (id)initWithVertices:(NSMutableData *)verticesData indices:(NSMutableData *)indicesData;
/*!
 * @brief Initializes a Mesh instance and copies another Meshes values.
 * @author Jason Chung
 *
 * @param mesh The mesh to copy.
 *
 * @return The new Mesh.
 */
- (id)initWithMesh:(Mesh *)mesh;
/*!
 * @brief Initializes a Mesh instance and copies this instances values.
 * @author Jason Chung
 *
 * @return The new Mesh.
 */
- (id)copy;
/*!
 * Sets up the OpenGL buffers for this Mesh.
 * @author Jason Chung
 */
- (void)setup;
/*!
 * @brief Renders the Mesh.
 * @author Jason Chung
 *
 * @param program A pointer to the program to set uniforms
 */
- (void)renderWithProgram:(Program *)program;

/*!
 * Returns the vertices of the Mesh.
 * @author Jason Chung
 *
 * @return The vertices of the Mesh.
 */
- (NSMutableData *)getVertices;
/*!
 * Returns the indices of the Mesh.
 * @author Jason Chung
 *
 * @return The indices of the Mesh.
 */
- (NSMutableData *)getIndices;
/*!
 * Returns the textures of the Mesh.
 * @author Jason Chung
 *
 * @return The textures of the Mesh.
 */
- (NSMutableArray<Texture *> *)getTextures;
/*!
 * Returns the texture at the index of the Mesh.
 * @author Jason Chung
 *
 * @param index The index of the textures array
 *
 * @return The texture at the index of the Mesh.
 */
- (Texture *)getTextureByIndex:(GLint)index;
/*!
 * Adds a texture to the array of textures.
 * @author Jason Chung
 *
 * @param texture The texture to add
 */
- (void)addTexture:(Texture *)texture;
/*!
 * Sets the shininess of the Mesh.
 * @author Jason Chung
 *
 * @param SHININESS The new shininess of the Mesh.
 */
- (void)setShininess:(GLfloat)SHININESS;

@end
