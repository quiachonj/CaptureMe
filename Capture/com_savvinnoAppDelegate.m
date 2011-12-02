//
//  com_savvinnoAppDelegate.m
//  Capture
//
//  Created by Josh Quiachon on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "com_savvinnoAppDelegate.h"

@implementation com_savvinnoAppDelegate

@synthesize window = _window;
@synthesize session = _session;

#define BUFFERSIZE 10
static uint8_t buffer[BUFFERSIZE];

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    EAAccessoryManager *p;
    p=[EAAccessoryManager sharedAccessoryManager];
    
    // accessory manager information
    NSLog(@"%@",p);
    NSLog(@"%@",[p description]);
    
    NSArray *accessories;
    accessories = [p connectedAccessories];
    
    // connected accessories count; expected 2 emulated 
    // accessories only as per emulator documentation
    NSLog(@"count: %u", [accessories count]); 
    
    for(EAAccessory *accessory in accessories)
    {
        NSLog(@"+---------------------------------+");        
        NSLog(@"%@", accessory.name);        
        NSLog(@"%@", accessory.manufacturer);
        NSLog(@"%@", accessory.modelNumber);
        NSLog(@"%@", accessory.serialNumber);
        NSLog(@"%@", accessory.firmwareRevision);
        NSLog(@"%@", accessory.hardwareRevision);
        NSLog(@"Protocol strings: %d", [accessory.protocolStrings count]);
        NSLog(@"+---------------------------------+");
        accessory.delegate = self;
        
        // A94207C9-1167-4BE9-97CD-EBACAFAAADE1 -- manufacturer unique uuid; for the lack of manufacturer name..
        // 314EE24D-D288-450E-89F9-F24AA41C63CF -- name unique uuid; for the lack of name...
        if([accessory.name isEqualToString:@"A94207C9-1167-4BE9-97CD-EBACAFAAADE1"]&& 
           [accessory.manufacturer isEqualToString:@"314EE24D-D288-450E-89F9-F24AA41C63CF"])
        {
            NSLog(@"Found: %@ %@", accessory.manufacturer, accessory.name);
            
            // get the protocol at index 0. Protocols... no docs... frustrating...
            NSString *protocol = [accessory.protocolStrings objectAtIndex:0];
            
            // No sessions created when run on simulator
            // Attempt to to create one
            _session = [[EASession alloc]initWithAccessory:accessory forProtocol:protocol];
            NSLog(@"%@",_session);
            NSLog(@"%@",_session.inputStream);
            NSLog(@"%@",_session.outputStream);
        }
    }
    
    // output stream simulation
    NSOutputStream *os = [NSOutputStream outputStreamToBuffer:buffer capacity:BUFFERSIZE];
    
    // setting up delegate
    [os setDelegate:self];
    
    // schedule output on run
    [os scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
     
    // open output pandora's box
    [os open];
    
    // input stream simulation
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:BUFFERSIZE];
    
    NSInputStream *is=[NSInputStream inputStreamWithData:data];
    
    // setting up delegate
    [is setDelegate:self];
    
    [is scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    // open input pandora's box
    [is open];
    
    [_window makeKeyAndVisible];
    return YES;
}
//
//- (void)dealloc{
//    [_window release];
//    [super dealloc];
//}

- (void)accessoryDidDisconnect:(EAAccessory *)accessory
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@", accessory.manufacturer);
    NSLog(@"%@", accessory.name);
    NSLog(@"%@", accessory.modelNumber);
    NSLog(@"%@", accessory.serialNumber);
}

- (void)stream:(NSStream *)stream
   handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone:
        {
            NSLog(@"NSStreamEventNone");
            break;
        }
        case NSStreamEventOpenCompleted:
        {
            NSLog(@"NSStreamEventOpenCompleted: %@", stream);
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            // if there is bytes available to be read, emulate a read from input stream
            // writing an accessory event name for click...

            NSLog(@"NSStreamEventHasBytesAvailable");
            uint8_t readBuffer[BUFFERSIZE];
            memset(readBuffer, 0, sizeof(readBuffer));
            
            // read
            NSInteger numberRead = [(NSInputStream*)stream
                                    read:readBuffer maxLength:sizeof(readBuffer)];
            if(numberRead==-1)
            {
                // NSError
                NSError *error = [(NSInputStream*)stream streamError];
                NSLog(@"%@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"numberRead: %d", numberRead);
                NSLog(@"readBuffer: %s", readBuffer);
                
                // CAMCLICK -- launch camera

            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            // if there is space available, emulate a write to output stream
            // writing an accessory event name for click...
            NSLog(@"NSStreamEventHasSpaceAvailable");
            
            // write to the output stream
            const uint8_t writeBuffer[] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
            NSInteger numberWrite = [(NSOutputStream*)stream
                                     write:writeBuffer maxLength:sizeof(writeBuffer)];
            
            if(numberWrite==-1)
            {
                NSError *error = [(NSOutputStream*)stream streamError];
                NSLog(@"%@", [error localizedDescription]);
            }
            else
            {
                NSLog(@"numberWrite: %d", numberWrite);
                NSLog(@"writeBuffer: %s", writeBuffer);
            }
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"NSStreamEventErrorOccurred");
            break;
        }
        case NSStreamEventEndEncountered:
        {
            NSLog(@"NSStreamEventEndEncountered");
            break;
        }
        default:
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
