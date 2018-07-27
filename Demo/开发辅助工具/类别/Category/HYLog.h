//
//  HYLog.h
//  test
//
//  Created by sphere on 16/5/19.
//  Copyright © 2016年 sphere. All rights reserved.
//

#ifndef HYLog_h
#define HYLog_h

#ifdef DEBUG
#define HYLog(fmt,...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define HYLog(...)
#endif

#endif /* HYLog_h */
