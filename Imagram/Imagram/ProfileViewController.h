//
//  SecondViewController.h
//  Imagram
//
//  Created by  Alex Nevsky on 01.12.14.
//  Copyright (c) 2014 Alex Nevsky. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Profile View Controller Skeleton
 *
 * Just say hello to user right now but receive username from server depending on Info.plist -> CustomUserId
 *
 */
@interface ProfileViewController : UIViewController

// Message
@property (weak, nonatomic) IBOutlet UILabel *greetingContent;
// Greeting count
@property (weak, nonatomic) IBOutlet UILabel *greetingId;

// Fetch greeting action
- (IBAction)fetchGreeting:(id)sender;

@end

