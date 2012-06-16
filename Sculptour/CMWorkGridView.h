//
//  CMWorkGridView.h
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@class Work;

@interface CMWorkGridView : AQGridViewCell
{
    UILabel *title;
}

@property (nonatomic, strong) Work *work;

@end
