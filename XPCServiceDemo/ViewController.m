//
//  ViewController.m
//  XPCServiceDemo
//
//  Created by Marek Přidal on 17.03.2021.
//

#import "Constants.h"
#import "ViewController.h"
#import "XPCServiceDemoTitleLabelServiceProtocol.h"
#import "XPCServiceDemo-Swift.h"

@interface ViewController()

@property NSXPCConnection* connectionToService;
@property (weak) IBOutlet NSButton *firstButton;
@property (weak) IBOutlet NSButton *clearButton;
@property (weak) IBOutlet NSTextField *label;
@property (weak) IBOutlet NSTextField *connectionStatus;
@property (weak) IBOutlet NSButton *establishConnectionButton;
@property (weak) IBOutlet NSButton *invalidateConnectionButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.establishConnectionButton setTitle:@"Establish connection"];
    [self.invalidateConnectionButton setTitle:@"Invalidate Connection"];
    [self.connectionStatus setStringValue:@""];
    [self clearButtonPressed];

    [self.firstButton setTitle:@"Action button"];
    NSClickGestureRecognizer* firstButtonRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(firstButtonPressed)];
    [self.firstButton addGestureRecognizer:firstButtonRecognizer];

    [self.clearButton setTitle:@"Clear button"];
    NSClickGestureRecognizer* clearButtonRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(clearButtonPressed)];
    [self.clearButton addGestureRecognizer:clearButtonRecognizer];

    [self showSwiftWindowViewController];
}

-(void)dealloc {
    [self.connectionToService invalidate];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)firstButtonPressed {
    NSLog(@"firstButtonPressed");
    
    ViewController *__weak weakSelf = self;
    [[self.connectionToService remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf2.label setStringValue:error.localizedDescription];
        });
    }] upperCaseString:@"hello" withReply:^(NSString *aString) {
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf2.label setStringValue:aString];
        });
    }];
}

- (void)clearButtonPressed {
    [self.label setStringValue:@""];
}

- (IBAction)establishConnectionButtonPressed:(NSButton *)sender {
    [self establishXPCConnection];
}

- (IBAction)invalidateConnectionButtonPressed:(NSButton *)sender {
    [self.connectionToService invalidate];
}

- (IBAction)swiftButtonPressed:(NSButton *)sender {
    
}

- (void)establishXPCConnection {
    NSXPCConnection *connectionToService = [[NSXPCConnection alloc] initWithServiceName:XPCServiceDemoTitleLabelServiceName];
    connectionToService.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCServiceDemoTitleLabelServiceProtocol)];
    [connectionToService resume];
    [self.connectionStatus setStringValue:[NSString stringWithFormat:@"Connected to service %@", connectionToService.serviceName]];
    
    ViewController *__weak weakSelf = self;
    [connectionToService setInvalidationHandler:^{
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[weakSelf2 connectionStatus] setStringValue:@"Connection has been invalidated. Need to reestablish connection."];
        });
    }];
    [connectionToService setInterruptionHandler:^{
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[weakSelf2 connectionStatus] setStringValue:@"Connection has been interrupted but still valid."];
        });
    }];
    
    self.connectionToService = connectionToService;
}

- (void)showSwiftWindowViewController {
    NSWindowController *windowController = [self.storyboard instantiateControllerWithIdentifier:@"SwiftWindowController"];
    [windowController.window makeKeyAndOrderFront:self];
}

@end
