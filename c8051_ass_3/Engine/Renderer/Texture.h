//
//  Texture.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface Texture : NSObject {
	GLuint textureId;
	NSString *type;
	
	size_t width;
	size_t height;
}

/*!
 * @brief Initializes the texture with a filename with the default texture_diffuse type
 * @author Jason Chung
 *
 * @param filename The filename of the texture
 *
 * @return An id to the created instance
 */
- (id)initWithFilename:(NSString *)filename;

/*!
 * @brief Initializes the texture with a filename with the default texture_diffuse type
 * @author Jason Chung
 *
 * @param filename The filename of the texture
 * @param TYPE The type of the texture (diffuse, specular, etc)
 *
 * @return An id to the created instance
 */
- (id)initWithFilename:(NSString *)filename TYPE:(NSString *)TYPE;
/*!
 * Returns the id of the Texture.
 * @author Jason Chung
 *
 * @return The id of the Texture.
 */
- (GLuint)getId;
/*!
 * Returns the type of the Texture.
 * @author Jason Chung
 *
 * @return The type of the Texture.
 */
- (NSString *)getType;
/*!
 * Returns the width of the Texture.
 * @author Jason Chung
 *
 * @return The width of the Texture.
 */
- (size_t)getWidth;
/*!
 * Returns the height of the Texture.
 * @author Jason Chung
 *
 * @return The height of the Texture.
 */
- (size_t)getHeight;

@end
