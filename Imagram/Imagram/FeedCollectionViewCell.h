//
//  FeedCollectionViewCell.h
//  Imagram
//
//  Created by Aliaksei Neuski on 12/2/14.
//  Copyright (c) 2014 Alex Nevsky. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Feed Collection View Cell
 *
 * Nothing special in interface but some configuration in Main.storyboard
 *
 */
@interface FeedCollectionViewCell : UICollectionViewCell

// ImageView inside cell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
