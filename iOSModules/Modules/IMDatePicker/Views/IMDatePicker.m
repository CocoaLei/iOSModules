//
//  IMDatePicker.m
//  iOSModules
//
//  Created by 石城磊 on 29/01/2018.
//  Copyright © 2018 石城磊. All rights reserved.
//

#import "IMDatePicker.h"
#import "IMYearModel.h"
#import "IMMonthModel.h"

@interface IMDatePicker ()
<
    UIPickerViewDelegate,
    UIPickerViewDataSource
>

@property (nonatomic, strong)   UIView       *imDatePickerContainerView;
@property (nonatomic, strong)   UIPickerView *imDatePickerView;
@property (nonatomic, strong)   UIButton     *cancelButton;
@property (nonatomic, strong)   UIButton     *confirmButton;

@property (nonatomic, strong)   NSMutableArray *imYearsMutArray;
@property (nonatomic, strong)   NSMutableArray *imMonthsMutArray;
@property (nonatomic, strong)   NSMutableArray *imDaysMutArray;
@property (nonatomic, strong)   NSMutableArray *imHoursMutArray;
@property (nonatomic, strong)   NSMutableArray *imSecondsMuArray;

@end

@implementation IMDatePicker


- (instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        [self setUpDateSource];
    }
    return self;
}

- (void)layoutSubviews {
    [self setUpIMDatePicker];
}

- (void)setUpDateSource {
    NSCalendar *dateCalendar            =   [NSCalendar currentCalendar];
    NSCalendarUnit formatUnit           =   (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitSecond);
    NSDateComponents *dateComponents    =   [dateCalendar components:formatUnit fromDate:[NSDate date]];
    
    //
    NSInteger currentYear               =   [dateComponents year];
    self.imYearsMutArray    =   [NSMutableArray arrayWithCapacity:100];
    for (NSInteger index = 0; index < 100; index++) {
        IMYearModel *yearModel  =   [[IMYearModel alloc] init];
        NSInteger aYear         =   currentYear + index;
        yearModel.im_Year       =   @(aYear);
        NSMutableArray *monthMutArr =   [NSMutableArray arrayWithCapacity:12];
        for (NSInteger mIndex = 1 ; mIndex <= 12; mIndex++) {
            BOOL isLeapYear =   ((aYear%4==0 && aYear%100!=0) || aYear%400==0);
            IMMonthModel *monthModel    =   [[IMMonthModel alloc] init];
            NSInteger daysInMonth       =   0;
            switch (mIndex) {
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    daysInMonth =   31;
                    break;
                case 4:
                case 6:
                case 9:
                case 11:
                    daysInMonth =   30;
                    break;
                case 2:
                    daysInMonth =   isLeapYear?29:28;
                    break;
                default:
                    break;
            }
            NSMutableArray *dayMutArr   =   [NSMutableArray arrayWithCapacity:daysInMonth];
            for (NSInteger dayIndex = 1; dayIndex <= daysInMonth; dayIndex++) {
                [dayMutArr addObject:@(dayIndex)];
            }
            monthModel.im_Month_Days    =   [NSArray arrayWithArray:dayMutArr];
            [monthMutArr addObject:monthModel];
        }
        yearModel.im_Year_Months    =   [NSArray arrayWithArray:monthMutArr];
    }
}

- (void)setUpIMDatePicker {
    UIView *buttonsView =   [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds),  CGRectGetHeight(self.bounds)/5)];
    [buttonsView setBackgroundColor:[UIColor blueColor]];
    [self addSubview:buttonsView];
    //
    self.cancelButton   =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setFrame:CGRectMake(8.0f, 0.0f, CGRectGetWidth(buttonsView.bounds)/4, CGRectGetHeight(buttonsView.bounds))];
    [buttonsView addSubview:self.cancelButton];
    //
    self.confirmButton  =   [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton setFrame:CGRectMake(CGRectGetMaxX(buttonsView.frame)-CGRectGetWidth(buttonsView.bounds)/4-8.0f, 0.0f, CGRectGetWidth(buttonsView.bounds)/4, CGRectGetHeight(buttonsView.bounds))];
    [buttonsView addSubview:self.confirmButton];
    //
    [self.imDatePickerView setFrame:CGRectMake(0.0f, CGRectGetHeight(self.bounds)/5, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/5*4)];
    [self addSubview:self.imDatePickerView];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.imYearsMutArray.count;
            break;
        case 1:
            return 12;
            break;
        case 2:
            return 31;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            IMYearModel *yModel =   self.imYearsMutArray[row];
            return [NSString stringWithFormat:@"%ld年",[yModel.im_Year integerValue]];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark - UIPIckerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 0.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 0.0f;
}

#pragma mark - Initializations
- (UIPickerView *)imDatePickerView {
    if (!_imDatePickerView) {
        _imDatePickerView           =   [[UIPickerView alloc] init];
        _imDatePickerView.delegate  =   self;
        _imDatePickerView.dataSource=   self;
    }
    return _imDatePickerView;
}

@end
