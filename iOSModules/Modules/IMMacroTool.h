//
//  IMMacroTool.h
//  iOSModules
//
//  Created by 石城磊 on 28/12/2017.
//  Copyright © 2017 石城磊. All rights reserved.
//

#ifndef IMMacroTool_h
#define IMMacroTool_h

    #define IMDebugLog(fmt, ...)        {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
    #define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

    #define ScreenWidth                 [UIScreen mainScreen].bounds.size.width
    #define ScreenHeight                [UIScreen mainScreen].bounds.size.height
#endif /* IMMacroTool_h */
