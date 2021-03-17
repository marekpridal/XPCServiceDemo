//
//  ViewController.m
//  XPCServiceDemo
//
//  Created by Marek Přidal on 17.03.2021.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.firstButton setTitle:@"First button"];
    NSClickGestureRecognizer* firstButtonRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(firstButtonPressed)];
    [self.firstButton addGestureRecognizer:firstButtonRecognizer];

    [self.secondButton setTitle:@"Second button"];
    NSClickGestureRecognizer* secondButtonRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(secondButtonPressed)];
    [self.secondButton addGestureRecognizer:secondButtonRecognizer];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)firstButtonPressed {
    NSLog(@"firstButtonPressed");
}

- (void)secondButtonPressed {
    NSLog(@"secondButtonPressed");
}

@end
