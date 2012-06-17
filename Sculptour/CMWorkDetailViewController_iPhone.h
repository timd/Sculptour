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
@class CMWorkViewController_iPhone;

@interface CMWorkDetailViewController_iPhone : UIViewController <UIWebViewDelegate, FBRequestDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Work *work;
@property (nonatomic, strong) CMWorkViewController_iPhone *parentController;

- (IBAction)didTapFacebookButton:(id)sender;

@end
