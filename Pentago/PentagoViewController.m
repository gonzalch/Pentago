//
//  PentagoViewController.m
//  Pentago
//
//  Created by Ali Kooshesh on 2/5/13.
//  Copyright (c) 2013 SSU. All rights reserved.
//

#import "PentagoViewController.h"

@interface PentagoViewController ()

@property (nonatomic, strong) NSMutableArray *subViewControllers;
@property (nonatomic, strong) UILabel *gameLabel;

@end

@implementation PentagoViewController
@synthesize subViewControllers = _subViewControllers;
@synthesize gameLabel = _gameLabel;

-(NSMutableArray *) subViewControllers
{
    if( ! _subViewControllers )
        _subViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    return _subViewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];

    // This is our root view-controller. Each of the quadrants of the game is
    // represented by a different view-controller. We create them here and add their views to the
    // view of the root view-controller.
    for (int i = 0; i < 4; i++) {
        PentagoSubboardViewController *p = [[PentagoSubboardViewController alloc] initWithSubsquare:i];
        [p.view setBackgroundColor:[UIColor blackColor]];
        [self.subViewControllers addObject: p];
        [self.view addSubview: p.view];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:@"theChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(winAlert) name:@"winAlert" object:nil];

    // label telling player what to do
    self.gameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 830, 768, 100)];
    self.gameLabel.backgroundColor = [UIColor clearColor];
    self.gameLabel.text = @"Red place a marble";
    self.gameLabel.textAlignment = UITextAlignmentCenter;
    self.gameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.gameLabel];

}

-(void)winAlert
{
    //NSLog(@"winner found");
    
    if ([[[self.subViewControllers objectAtIndex:0] getPBrain] getDraw] == YES) {
        //NSLog(@"draw");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                        message:@"Draw! Play again?"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"No thanks", nil];
        [alert show];
    }
    
    else if ([[[self.subViewControllers objectAtIndex:0] getPBrain] getRedWin] == YES) {
        //NSLog(@"red win");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                        message:@"Red wins! Play again?"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"No thanks", nil];
        [alert show];
    }
    
    else if ([[[self.subViewControllers objectAtIndex:0] getPBrain] getGreenWin] == YES) {
        //NSLog(@"green win");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                        message:@"Green wins! Play again?"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"No thanks", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //NSLog(@"OK was pressed");
        [self viewDidUnload];
        [self viewDidLoad];
    }
    if (buttonIndex == 1)
    {
        //NSLog(@"No thanks was pressed");
        exit(0);
    }
}


- (void)updateLabel
{
    if ([[[self.subViewControllers objectAtIndex:0] getPBrain] getPlayerTurn] == YES && [[[self.subViewControllers objectAtIndex:0] getPBrain] getPlayerRotate] == NO) {
        self.gameLabel.text = @"Red place a marble";
    }
    
    if ([[[self.subViewControllers objectAtIndex:0] getPBrain] getPlayerTurn] == NO && [[[self.subViewControllers objectAtIndex:0] getPBrain] getPlayerRotate] == NO) {
        self.gameLabel.text = @"Green place a marble";
    }
    
    if ([[[self.subViewControllers objectAtIndex:0] getPBrain] getPlayerTurn] == YES && [[[self.subViewControllers objectAtIndex:0] getPBrain] getPlayerRotate] == YES) {
        self.gameLabel.text = @"Red rotate a board";
    }
    
    if ([[[self.subViewControllers objectAtIndex:0] getPBrain] getPlayerTurn] == NO && [[[self.subViewControllers objectAtIndex:0] getPBrain] getPlayerRotate] == YES) {
        self.gameLabel.text = @"Green rotate a board";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"theChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"winAlert" object:nil];
    // Release any retained subviews of the main view.
    //[self.subViewControllers makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //[[self.subViewControllers objectAtIndex:1] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //[[self.subViewControllers objectAtIndex:2] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //[[self.subViewControllers objectAtIndex:3] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[[self.subViewControllers objectAtIndex:0] getPBrain] init];
    [self.subViewControllers removeAllObjects];
    for (UIView *i in self.view.subviews)
        [i removeFromSuperview];
    //[self.gameLabel removeFromSuperview];
    //self.subViewControllers = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
