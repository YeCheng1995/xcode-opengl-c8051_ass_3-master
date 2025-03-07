//
//  ViewController.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController

@property (weak, nonatomic) IBOutlet UIButton *lightingButton;
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;
@property (weak, nonatomic) IBOutlet UIButton *fogButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *sliderMin;
@property (weak, nonatomic) IBOutlet UILabel *sliderMax;

@end

