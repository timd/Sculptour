//
//  CMWorkDetailViewController_iPhone.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class Work;

@interface CMWorkDetailViewController_iPhone : UIViewController <UIWebViewDelegate, FBRequestDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Work *work;

- (IBAction)didTapFacebookButton:(id)sender;

@end
