//
//  Image.h
//  Imagram
//
//  Created by  Alex Nevsky on 06.12.14.
//  Copyright (c) 2014 Alex Nevsky. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Data Transfer Object for the entity
 *
 * Represent the image meta data interface
 *
 */
@interface Image : NSObject

// Default constructor
- (id)initWithImageId:(NSNumber*)imageId andOwnerId:(NSNumber*)ownerId andUrl:(NSString*)url;

@property NSNumber *imageId;
@property NSNumber *ownerId;
@property NSString *url;

@end
