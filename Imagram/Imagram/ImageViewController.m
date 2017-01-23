//
//  ImageViewController.m
//  Imagram
//
//  Created by  Alex Nevsky on 05.12.14.
//  Copyright (c) 2014 Alex Nevsky. All rights reserved.
//

#import "ImageViewController.h"

#import "UIImageView+AFNetworking.h"

@interface ImageViewController ()

@end

/**
 * Single Image View Controller Implementation
 *
 */
@implementation ImageViewController

@synthesize imageView = _imageView; // Just image view
@synthesize imageUrl = _imageUrl;   // Just URL for image view

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // Load remote image asynchronously from a URL and use cache to improve loading performance using AFNetworking
    [_imageView setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
