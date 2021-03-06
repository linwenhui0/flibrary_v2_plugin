#import <Flutter/Flutter.h>

@interface FlibraryPlugin : NSObject<FlutterPlugin>

#define GET_SCREEN_WIDTH @"getScreenWidth"
#define GET_SCREEN_HEIGHT @"getScreenHeight"
#define GET_SCREEN_RATIO @"getScreenRatio"

#define IS_ROOT @"isRoot"
#define IS_VPN @"isVpn"
#define IDFA @"getIDFA"
#define IDFV @"getIDFV"
#define Mac @"getMacAddress"
#define BSSID @"getRouteMacAddress"
#define CHECK_RELEASE @"isRelease"

@end
