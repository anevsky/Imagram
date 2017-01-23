//
//  FeedCollectionCollectionViewController.m
//  Imagram
//
//  Created by Aliaksei Neuski on 12/2/14.
//  Copyright (c) 2014 Alex Nevsky. All rights reserved.
//

#import "FeedCollectionViewController.h"

#import "FeedCollectionViewCell.h"
#import "ImageViewController.h"
#import "Image.h"

#import "Reachability.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"

@interface FeedCollectionViewController ()

- (void)reachabilityChanged:(NSNotification*)note;

@end

/**
 * Feed Controller Implementation
 *
 *  Main app controller based on Collection View Controller
 *
 */
@implementation FeedCollectionViewController {
    UIAlertView *networkAlert;  // Reachability alert view
    BOOL isGrid;                // Show images as grid or not
    CGRect screenRect;          // Device screen bounds
    CGFloat screenWidth;        // Device screen width
    NSMutableArray *feedImages; // Array for Images Data Transfer Object
    long userId;                // Current user id. Could be changed in Info.plist -> CustomUserId
}

// ID for reusable collection view cell
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    isGrid = YES;
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    feedImages = [[NSMutableArray alloc] init];
    
    NSNumberFormatter * numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *customUserId = [numFormatter numberFromString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CustomUserId"]];
    userId = [customUserId longValue];
    
    // Bar button for add new image action
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showSavedMediaBrowser:)];
    self.navigationItem.rightBarButtonItems = @[addItem];
    
    // Bar button for grid view
    UIBarButtonItem *changeSquareItem = [[UIBarButtonItem alloc] initWithTitle:@"∷" style:UIBarButtonItemStylePlain target:self action:@selector(showSquareGrid:)];
    // Bar button for linear view
    UIBarButtonItem *changeLineItem = [[UIBarButtonItem alloc] initWithTitle:@"≡" style:UIBarButtonItemStylePlain target:self action:@selector(showByLine:)];
    self.navigationItem.leftBarButtonItems = @[changeSquareItem, changeLineItem];
    
    // Initialize feed images array
    [self getImagesForUser:userId fromServer:[NSString stringWithFormat:@"%@/owner/%ld", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WebgramREST"], userId]];
    
    networkAlert = [[UIAlertView alloc] initWithTitle:@"Network connection" message:@"You should be connected to the Internet to get more experience from app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    // Is user device connected to Internet?
    [self testReachability];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
// Prepare for view single image action when user select it
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewSingleImageSeque"]) {
        // Get the new view controller
        ImageViewController *destViewController = segue.destinationViewController;
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        // Pass the selected object to the new view controller
        Image *image = (Image*)[feedImages objectAtIndex:indexPath.row];
        destViewController.imageUrl = image.url;
    }
}

#pragma mark <UICollectionViewDataSource>

// Show all images in one section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// Count total images to show in collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return feedImages.count;
}

// Configure the reusable cell, set image for cell with placeholder and photo-frame
//
// Load remote images asynchronously from a URL and use cache to improve loading performance using AFNetworking
//
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeedCollectionViewCell *cell = (FeedCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Image *image = (Image*)[feedImages objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];

    return cell;
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Collection View Options
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// Action for grid tap
- (void)showSquareGrid:(id)sender {
    if (!isGrid) {
        isGrid = YES;
        [self changeFeedView];
    }
}

// Action for linear tap
- (void)showByLine:(id)sender {
    if (isGrid) {
        isGrid = NO;
        [self changeFeedView];
    }
}

// Reload collection view items after grid/linear tap
- (void)changeFeedView {
    NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
    for (int i = 0; i < feedImages.count; ++i) {
        [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self.collectionView reloadItemsAtIndexPaths:arrayWithIndexPaths];
    [UIView setAnimationsEnabled:animationsEnabled];
}

// Change cell size depending on isGrid or not selected
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (isGrid) {
        return CGSizeMake(screenWidth / 3 - 5, screenWidth / 3 - 5);
    } else {
        return CGSizeMake(screenWidth, screenWidth);
    }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Image Picker
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// Action for add new image tap
- (void)showSavedMediaBrowser:(id)sender {
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

// Show controller for select image from Camera Roll
- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] != NO) && (delegate != nil) && (controller != nil)) {
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        // Displays saved pictures, if they are available, from the Camera Roll album.
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        // Shows the controls for moving & scaling pictures.
        mediaUI.allowsEditing = YES;
        mediaUI.delegate = delegate;
        
        [controller presentViewController:mediaUI animated:YES completion:nil];
        
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error access to Photo Library"
                                                        message:@"Your device is not support Photo Library"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
}

// Process selected image from Camera Roll
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToUse = editedImage;
    } else {
        imageToUse = originalImage;
    }
    
    // Do something with imageToUse
    long imageId = (long)[[NSDate date] timeIntervalSince1970];
    [self postImage:imageToUse
                    forUser:userId
                    withImageId:imageId
                   toServer:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WebgramREST"]]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// What to do when user cancelled the pick operation
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Images Utils
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// Receive and obtain Images DTO from server using AFNetworking
//
// When working on local system, http or file protocol url could be configured in code below
//
- (void)getImagesForUser:(long)ownerId fromServer:(NSString *)url {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"ownerId":[NSString stringWithFormat:@"%ld", ownerId]};
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [feedImages removeAllObjects];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *responseArray = responseObject;
            for (NSDictionary *dict in responseArray) {
                NSNumber *imageId = [dict objectForKey:@"imageId"];
                NSNumber *ownerId = [dict objectForKey:@"ownerId"];
                NSString *url = [dict objectForKey:@"url"];
                
                // TODO : UNCOMMENT THIS CODE LINE FOR LOCAL SYSTEM
                // url = [NSString stringWithFormat:@"file://%@", url];
                
                [feedImages addObject:[[Image alloc] initWithImageId:imageId andOwnerId:ownerId andUrl:url]];
            }
        }
        
        // Reload feed images
        [self.collectionView reloadData];
        
        NSLog(@"### ---getImagesForUser. Success: \n%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"### ---getImagesForUser. Failure: \n%@", error);
    }];
}

// Loads image to server using AFNetworking
//
// Only JPEG for now
//
- (void)postImage:(UIImage *)image forUser:(long)ownerId withImageId:(long)imageId toServer:(NSString *)url {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"ownerId":[NSString stringWithFormat:@"%ld", ownerId],
                                 @"imageId":[NSString stringWithFormat:@"%ld", imageId]};
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%ld.jpg", imageId] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"### ---postImage. Success: \n%@", responseObject);
        
        // Update feed images
        [self getImagesForUser:userId fromServer:[NSString stringWithFormat:@"%@/owner/%ld", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WebgramREST"], userId]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"### ---postImage. Failure: \n%@", error);
    }];
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Utils
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// Reachability NSNotification observer
- (void)testReachability {
    // Here we set up a NSNotification observer
    // The Reachability that caused the notification is passed in the object parameter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    // Allocate a reachability object
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
}

// NSNotifications to tell you when the interface has changed
// They will be delivered on the MAIN THREAD so we can do UI updates from within the function
- (void)reachabilityChanged:(NSNotification*)note {
    Reachability *reach = [note object];
    
    if ([reach isReachable]) {
        [networkAlert dismissWithClickedButtonIndex:0 animated:YES];
    } else {
        [networkAlert show];
    }
}

@end
