//
//  CMWorkGridView.m
//  Sculptour
//
//  Created by Michael Dales on 16/06/2012.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CMWorkGridView.h"
#import "Work.h"

@implementation CMWorkGridView

@synthesize work=_work;



///////////////////////////////////////////////////////////////////////////////
//
- (void)setWork: (Work*)work
{
    _work = work;
    
    title.text = work.title;
}
                  


///////////////////////////////////////////////////////////////////////////////
//
- (id)initWithFrame: (CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame: frame
                reuseIdentifier: reuseIdentifier];
    if (self) 
    {
        title = [[UILabel alloc] initWithFrame: CGRectMake(0.0, 0.0, self.bounds.size.width, 25.0)];
        [self.contentView addSubview: title];        
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////
//
- (void)drawRect:(CGRect)rect
{
    // just prove it works
    UIBezierPath *path = [UIBezierPath bezierPathWithRect: self.bounds];
    [UIColor redColor];
    [path fill];
}

@end
