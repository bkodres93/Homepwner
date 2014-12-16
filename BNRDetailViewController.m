//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Benjamin Kodres-O'Brien on 8/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRDateViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation BNRDetailViewController

#pragma mark - VIEW METHODS

//renamed so that it does not get called!
- (void)viewDidLoad3
{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    // content fit was ascpect fit in XIB
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // add the image view to this view
    [self.view addSubview:iv];
    // save it in a global variable
    self.imageView = iv;
    /*
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar" : self.toolbar};
    
    // imageView is 0 pts from super view on left and right
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:nameMap];
    
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dateLabel]-[imageView]-[toolbar]-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:nameMap];
     */
    
    /*
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
     */

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // prepare for different orientation right away
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    BNRItem *item = self.item;
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // You need an NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    // Do the image
    NSString *itemKey = self.item.itemKey;
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:itemKey];
    self.imageView.image = imageToDisplay;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
}


//right before it rotates
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}


// prepare the views
- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    // if we are an ipad do nothing
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return;
    }
    
    // otherwise we test for landscape
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    }
    else
    {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}


#pragma mark - UITextFieldDelegateMethods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - OTHER METHODS

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

#pragma mark - OTHER ACTIONS

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)changeDate:(id)sender
{
    BNRDateViewController *dateViewController = [[BNRDateViewController alloc] init];
    
    dateViewController.item = self.item;
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:dateViewController animated:YES];
}


#pragma mark - IMAGE METHODS

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePicker setAllowsEditing:YES];
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (IBAction)clearImage:(id)sender
{
    [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    self.imageView.image = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    if (picker.allowsEditing) {
        image = info[UIImagePickerControllerEditedImage];
    }
    
    // Store the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    
    self.imageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
