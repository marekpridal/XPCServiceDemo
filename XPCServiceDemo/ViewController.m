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
#import "XPCServiceDemoSwiftService.h"
#import "XPCServiceDemoSwiftServiceProtocol.h" // This works

@import XPCServiceDemo; // This works
@import XPCServiceDemoSwiftService; // This doesn't work!!
@import XPCTestFramework; // This works

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
    // Swift class from TestFrameworks successfully works and can be initialized
    TestClass *class = TestClass.new;
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
