//
//  com_savvinnoViewController.m
//  Capture
//
//  Created by Josh Quiachon on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "com_savvinnoViewController.h"

@implementation com_savvinnoViewController
//@synthesize picker = _picker;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // check for camera because...
    // emulation has NO CAMERA!!!
    BOOL result = false;
    result = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]; 
    NSLog(@"Source Camera: %d", result);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // SIGABRT!!!
    //if (_picker == nil) 
    //{
    //    _picker = [[UIImagePickerController alloc] init];
    //    _picker.delegate = self;
    //    _picker.sourceType = UIImagePickerControllerSourceTypeCamera; 
    //    [self presentModalViewController:_picker animated:YES];
    //}
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [self presentModalViewController:imagePicker animated:YES];
    //[imagePicker release];

}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
