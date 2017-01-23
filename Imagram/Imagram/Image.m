//
//  Image.m
//  Imagram
//
//  Created by  Alex Nevsky on 06.12.14.
//  Copyright (c) 2014 Alex Nevsky. All rights reserved.
//

#import "Image.h"

/**
 * Data Transfer Object for the entity
 *
 * Represent the image meta data implementation
 *
 */
@implementation Image

@synthesize imageId = _imageId;
@synthesize ownerId = _ownerId;
@synthesize url = _url;

// Default constructor
- (id)initWithImageId:(NSNumber*)imageId andOwnerId:(NSNumber*)ownerId andUrl:(NSString*)url
{
    self = [super init];
    
    if (self) {
        _imageId = imageId;
        _ownerId = ownerId;
        _url = url;
    }
    
    return self;
}

@end

