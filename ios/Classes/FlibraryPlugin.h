#import <Flutter/Flutter.h>

@interface FlibraryPlugin : NSObject<FlutterPlugin>

#define PLATFORM_VERSION @"getPlatformVersion"
#define HAVE_EXTERNAL_STORAGE @"haveExternalStorage"
#define GET_SCREEN_WIDTH @"getScreenWidth"
#define GET_SCREEN_HEIGHT @"getScreenHeight"
#define GET_SCREEN_RATIO @"getScreenRatio"
#define GET_PHONE_TYPE @"getPhoneType"
#define GET_LANGUAGE @"getLanguage"
#define GET_CURRENT_NETWORK_TYPE @"getCurrentNetworkType"
#define IS_ROOT @"isRoot"
#define IS_VPN @"isVpn"
#define IDFA @"getIDFA"
#define IDFV @"getIDFV"
#define Mac @"getMacAddress"
#define BSSID @"getRouteMacAddress"
#define CHECK_RELEASE @"isRelease"

@end
