//
//  SecondViewController.m
//  Imagram
//
//  Created by  Alex Nevsky on 01.12.14.
//  Copyright (c) 2014 Alex Nevsky. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

/**
 * Profile View Controller Skeleton Implementation
 *
 * Just say hello to user right now but receive username from server depending on Info.plist -> CustomUserId
 *
 */
@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self fetchGreeting:self];
}

// Fetch greeting action from server depending on Info.plist -> CustomUserId and how many times you do action
- (IBAction)fetchGreeting:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",
                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WebgramREST"],
                                       @"greeting",
                                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CustomUserId"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data.length > 0 && connectionError == nil) {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             self.greetingId.text = [[greeting objectForKey:@"id"] stringValue];
             self.greetingContent.text = [greeting objectForKey:@"content"];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
