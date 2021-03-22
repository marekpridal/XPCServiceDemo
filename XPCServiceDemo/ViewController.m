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
@property (weak) IBOutlet NSButton *dogButton;
@property (weak) IBOutlet NSButton *dogsButton;

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

    [self.dogButton setTitle:@"Dog button"];
    [self.dogsButton setTitle:@"Dogs button"];

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

- (IBAction)dogButtonPressed:(NSButton *)sender {
//    ViewController *__weak weakSelf = self;
//    [[self.connectionToService remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
//        ViewController *__weak weakSelf2 = weakSelf;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf2.label setStringValue:error.localizedDescription];
//        });
//    }] dogNameForDog:[[Dog alloc] initWithName:@"Mac"] withReply:^(NSString * _Nonnull aString) {
//        ViewController *__weak weakSelf2 = weakSelf;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf2.label setStringValue:aString];
//        });
//    }];
    
    ViewController *__weak weakSelf = self;
    [[self.connectionToService remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf2.label setStringValue:error.localizedDescription];
        });
    }] setDogAgeForDog:[[Dog alloc] initWithName:@"Mac"] withReply:^(Dog * _Nonnull response) {
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf2.label setStringValue:response.formattedNameWithAge];
        });
    }];
}
- (IBAction)dogsButtonPressed:(NSButton *)sender {
    ViewController *__weak weakSelf = self;
    NSArray *dogs = [NSArray arrayWithObjects:[[Dog alloc] initWithName:@"Mac"], [[Dog alloc] initWithName:@"Swift"], nil];
    
//    [[self.connectionToService remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
//        ViewController *__weak weakSelf2 = weakSelf;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf2.label setStringValue:error.localizedDescription];
//        });
//    }] dogNameForDog:[[Dog alloc] initWithName:@"Mac"] withReply:^(NSString * _Nonnull aString) {
//        ViewController *__weak weakSelf2 = weakSelf;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf2.label setStringValue:aString];
//        });
//    }];
    
//    [[self.connectionToService remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
//        ViewController *__weak weakSelf2 = weakSelf;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf2.label setStringValue:error.localizedDescription];
//        });
//    }] dogNamesForDogs:dogs withReply:^(NSArray<NSString*> * response) {
//        ViewController *__weak weakSelf2 = weakSelf;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSMutableString * names = [NSMutableString stringWithString:@""];
//            [response enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [names appendString:obj];
//                [names appendString:@"\n"];
//            }];
//            [weakSelf2.label setStringValue:names];
//        });
//    }];

    [[self.connectionToService remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf2.label setStringValue:error.localizedDescription];
        });
    }] setDogAgeForDogs:dogs withReply:^(NSArray<Dog*> * response) {
        ViewController *__weak weakSelf2 = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableString * names = [NSMutableString stringWithString:@""];
            [response enumerateObjectsUsingBlock:^(Dog * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [names appendString:obj.formattedNameWithAge];
                [names appendString:@"\n"];
            }];
            [weakSelf2.label setStringValue:names];
        });
    }];
}

- (void)establishXPCConnection {
    NSXPCConnection *connectionToService = [[NSXPCConnection alloc] initWithServiceName:XPCServiceDemoTitleLabelServiceName];
    
    NSXPCInterface * interface = [NSXPCInterface interfaceWithProtocol:@protocol(XPCServiceDemoTitleLabelServiceProtocol)];
    [interface setClasses:[self getParameterDataTypes] forSelector:@selector(dogNamesForDogs:withReply:) argumentIndex:0 ofReply:NO]; // Need to specify Dog.class because is used as member of collection used as parameter or return type of XCP interface method. For usage outside of collection conforming  to NSSecureCoding protocol is enough.
    [interface setClasses:[self getParameterDataTypes] forSelector:@selector(setDogAgeForDogs:withReply:) argumentIndex:0 ofReply:NO];
    [interface setClasses:[self getParameterDataTypes] forSelector:@selector(setDogAgeForDogs:withReply:) argumentIndex:0 ofReply:YES];
    
    connectionToService.remoteObjectInterface = interface;
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

- (NSSet<NSSecureCoding> *)getParameterDataTypes {
    return [NSSet setWithObjects:NSArray.class, Dog.class, nil];
}

@end
