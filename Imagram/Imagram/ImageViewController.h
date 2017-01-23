//
//  ImageViewController.h
//  Imagram
//
//  Created by  Alex Nevsky on 05.12.14.
//  Copyright (c) 2014 Alex Nevsky. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Single Image View Controller Interface
 *
 */
@interface ImageViewController : UIViewController

// Just image view for property configuration in Main.storyboard
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
// Just URL for image view
@property (weak, nonatomic) NSString *imageUrl;

@end
