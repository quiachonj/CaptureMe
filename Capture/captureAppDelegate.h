//
//  com_savvinnoAppDelegate.h
//  Capture
//
//  Created by Josh Quiachon on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ExternalAccessory/ExternalAccessory.h>

@interface captureAppDelegate : UIResponder <UIApplicationDelegate, EAAccessoryDelegate, NSStreamDelegate>
{
    EASession *session;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) EASession *session;
@end
