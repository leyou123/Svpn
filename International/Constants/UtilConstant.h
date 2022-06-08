

#ifndef UtilConstant_h
#define UtilConstant_h

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 打印日志

#ifdef DEBUG
#define LOG(fmt,...)  DDLogInfo((@"%s[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LOG_STRING(s) DDLogInfo((@"%s[Line %d] %@"), __PRETTY_FUNCTION__, __LINE__, s)
#define LOG_INT(i)    DDLogInfo((@"%s[Line %d] %d"), __PRETTY_FUNCTION__, __LINE__, i)
#define LOG_FLOAT(f)  DDLogInfo((@"%s[Line %d] %f"), __PRETTY_FUNCTION__, __LINE__, f)
#define LOG_POINT(p)  DDLogInfo((@"%s[Line %d] x=%f, y=%f"), __PRETTY_FUNCTION__, __LINE__, p.x, p.y)
#define LOG_SIZE(s)   DDLogInfo((@"%s[Line %d] w=%f, h=%f"), __PRETTY_FUNCTION__, __LINE__, s.width, s.height)
#define LOG_RECT(r)   DDLogInfo((@"%s[Line %d] x=%f, y=%f, w=%f, h=%f"), \
                      __PRETTY_FUNCTION__, __LINE__, r.origin.x, r.origin.y, r.size.width, r.size.height)
#else
#define LOG(fmt,...)
#define LOG_STRING(s)
#define LOG_INT(i)
#define LOG_FLOAT(f)
#define LOG_POINT(p)
#define LOG_SIZE(s)
#define LOG_RECT(r)
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 颜色处理

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.f \
                                     green:(g)/255.f \
                                      blue:(b)/255.f \
                                     alpha:1.f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.f \
                                         green:(g)/255.f \
                                          blue:(b)/255.f \
                                         alpha:a]
#define RGB_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.f \
                                          green:((float)((hexValue & 0xFF00) >> 8))/255.f \
                                           blue:((float)(hexValue & 0xFF))/255.f \
                                          alpha:1.f]
#define RGBA_HEX(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.f \
                                              green:((float)((hexValue & 0xFF00) >> 8))/255.f \
                                               blue:((float)(hexValue & 0xFF))/255.f \
                                              alpha:a]

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 资源加载

#define IMAGE_NAME(name)      [UIImage imageNamed:name]
#define IMAGE_LOAD(file, ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(file) ofType:(ext)]

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 计算、换算

#define DEGREES_TO_RADIANS(degrees) (M_PI * (x) / 180.f)
#define RADIANS_TO_DEGREES(radians) (radian * 180.f / M_PI)

#define INT_2_STRING(i) [NSString stringWithFormat:@"%d", i]
#define STRING_2_INT(s) [s intValue]

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 缩写

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self

#define SCREEN_W MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define SCREEN_H MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

#define GCD_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_MAIN(block) dispatch_async(dispatch_get_main_queue(), block)

//字体
#define kFont(A) [UIFont systemFontOfSize:A]
//加粗字体
#define kBoldFont(A) [UIFont boldSystemFontOfSize:A]

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 常量

static const CGFloat kTableViewHeaderFooterHeightZero = 0.00001f;

////////////////////////////////////////////////////////////////////////////////////////////////////

#endif
