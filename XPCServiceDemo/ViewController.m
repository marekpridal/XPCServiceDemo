//
//  ViewController.m
//  XPCServiceDemo
//
//  Created by Marek Přidal on 17.03.2021.
//

#import "Constants.h"
#import "ViewController.h"
#import "XPCServiceDemoTitleLabelServiceProtocol.h"

@interface ViewController()

@property NSXPCConnection* connectionToService;
@property (weak) IBOutlet NSButton *firstButton;
@property (weak) IBOutlet NSButton *secondButton;
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
    [self secondButtonPressed];

    [self.firstButton setTitle:@"Action button"];
    NSClickGestureRecognizer* firstButtonRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(firstButtonPressed)];
    [self.firstButton addGestureRecognizer:firstButtonRecognizer];

    [self.secondButton setTitle:@"Clear button"];
    NSClickGestureRecognizer* secondButtonRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(secondButtonPressed)];
    [self.secondButton addGestureRecognizer:secondButtonRecognizer];
}

-(void)dealloc {
    [_connectionToService invalidate];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)firstButtonPressed {
    NSLog(@"firstButtonPressed");
    
    ViewController *__weak weakSelf = self;
    [[_connectionToService remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
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

- (void)secondButtonPressed {
    [self.label setStringValue:@""];
}

- (IBAction)establishConnectionButtonPressed:(NSButton *)sender {
    [self establishXPCConnection];
}

- (IBAction)invalidateConnectionButtonPressed:(NSButton *)sender {
    [self.connectionToService invalidate];
}

- (void)establishXPCConnection {
    _connectionToService = [[NSXPCConnection alloc] initWithServiceName:XPCServiceDemoTitleLabelServiceName];
    _connectionToService.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCServiceDemoTitleLabelServiceProtocol)];
    [_connectionToService resume];
    [self.connectionStatus setStringValue:[NSString stringWithFormat:@"Connected to service %@", self.connectionToService.serviceName]];
    
    ViewController *__weak weakSelf = self;
    [_connectionToService setInvalidationHandler:^{
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[weakSelf2 connectionStatus] setStringValue:@"Connection has been invalidated. Need to reestablish connection."];
        });
    }];
    [_connectionToService setInterruptionHandler:^{
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[weakSelf2 connectionStatus] setStringValue:@"Connection has been interrupted but still valid."];
        });
    }];
}

@end
