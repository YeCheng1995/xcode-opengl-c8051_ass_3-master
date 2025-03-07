//
//  Geometry.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Mesh.h"

@interface Geometry : NSObject

/*!
 * @brief Returns a Mesh object in the shape of a triangle.
 * @author Jason Chung
 *
 * @return The triangle Mesh.
 */
+ (Mesh *)triangle;
/*!
 * @brief Returns a Mesh object in the shape of a square.
 * @author Jason Chung
 *
 * @return The square Mesh.
 */
+ (Mesh *)square;

@end
