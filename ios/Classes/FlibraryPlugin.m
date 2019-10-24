#import "FlibraryPlugin.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>
#import <sys/stat.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <AdSupport/ASIdentifierManager.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

@implementation FlibraryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flibrary_plugin"
            binaryMessenger:[registrar messenger]];
  FlibraryPlugin* instance = [[FlibraryPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([GET_SCREEN_HEIGHT isEqualToString:call.method]) {
      CGRect rect = [[UIScreen mainScreen] bounds];
      CGSize size = rect.size;
      result([[NSNumber alloc] initWithInt:(int)(size.height*[UIScreen mainScreen].scale)]);
  } else if([GET_SCREEN_WIDTH isEqualToString:call.method]) {
      CGRect rect = [[UIScreen mainScreen] bounds];
      CGSize size = rect.size;
      result([[NSNumber alloc] initWithInt:(int)(size.width*[UIScreen mainScreen].scale)]);
  } else if([GET_SCREEN_RATIO isEqualToString:call.method]) {
      result([[NSNumber alloc] initWithDouble:[UIScreen mainScreen].scale]);
  } else if([IS_ROOT isEqualToString:call.method]){
      // 是否越狱
      BOOL r = [self isPrisonBreak];
      result([[NSNumber alloc] initWithBool:r]);
  } else if([IS_VPN isEqualToString:call.method]) {
      BOOL openProxy = [self isProxyOpened];
      BOOL vpnContact = [self isVPNConnected];
      result([[NSNumber alloc] initWithBool:openProxy || vpnContact]);
  } else if([IDFA isEqualToString:call.method]) {
      NSString* idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
      result(idfa);
  } else if([IDFV isEqualToString:call.method]) {
      NSString* idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
      result(idfv);
  } else if([Mac isEqualToString:call.method]) {
	  NSString* mac = [self get_macAddress];
	  result(mac);
  } else if([BSSID isEqualToString:call.method]) {
	  NSString* bssid = [self get_bssid];
	  result(bssid);
  } else if([CHECK_RELEASE isEqualToString:call.method]) {
      BOOL r = [self checkReleaes];
      result([[NSNumber alloc] initWithBool:r]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void) getWifiMac:(FlutterResult)result{
    NSString *macIp = @"";
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef) ifname);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info;
    macIp = [dic objectForKey:@"BSSID"];
    NSLog(@"getWifiMac %@",macIp);
    result(macIp);
}

// 检测设备是否越狱
- (BOOL)isPrisonBreak {
    BOOL b1 = NO, b2 = NO, b3 = NO, b4 = NO, b5 = NO;
    // 常见越狱文件
    NSArray*pathArray =@[@"/Applications/Cydia.app",
                         @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                         @"/bin/bash",
                         @"/usr/sbin/sshd",
                         @"/etc/apt"];
    NSUInteger len = pathArray.count;
    for(int i =0; i < len; i++) {
        NSString*path = pathArray[i];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            b1 =YES;
        }
    }
    // 读取系统所有的应用名称
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]){
        b2 =YES;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        b3 =YES;
    }
    struct stat stat_info;
    //使用stat系列函数检测Cydia等工具
    if(0==stat("/Applications/Cydia.app", &stat_info)) {
        b4 =YES;
    }
    // 读取环境变量
    char*checkInsertLib =getenv("DYLD_INSERT_LIBRARIES");
    if(checkInsertLib) {
        b5 =YES;
    }
    return(b1 && b2 && b3 && b4 && b5);
}

// 判断网络请求是否开启代理
- (BOOL)isProxyOpened {
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        return NO;
    }else{
        return YES;
    }
}

// 判断VPN的连接
- (BOOL)isVPNConnected {
    NSDictionary * proxySettings = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    NSArray * keys = [proxySettings[@"__SCOPED__"] allKeys];
    for (NSString * key in keys) {
        if ([key rangeOfString:@"tap"].location != NSNotFound ||
            [key rangeOfString:@"tun"].location != NSNotFound ||
            [key rangeOfString:@"ppp"].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

/// 获取BSSID
- (NSString *)get_bssid {
	
	static NSString *bssid = @"";
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
		id info = nil;
		for (NSString *ifnam in ifs) {
			info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
			if (info && [info count]) {
				NSDictionary *dic = (NSDictionary *)info;
				bssid = [dic valueForKey:@"BSSID"];
				break;
			}
		}
	});
	return bssid.length > 0 ? bssid : @"";
}

/// 获取Mac
- (NSString *)get_macAddress {
	
	static NSString *macAddress = @"";
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		int                    mib[6];
		size_t                len;
		char                *buf;
		unsigned char        *ptr;
		struct if_msghdr    *ifm;
		struct sockaddr_dl    *sdl;
		mib[0] = CTL_NET;
		mib[1] = AF_ROUTE;
		mib[2] = 0;
		mib[3] = AF_LINK;
		mib[4] = NET_RT_IFLIST;
		if ((mib[5] = if_nametoindex("en0")) == 0) {
			printf("Error: if_nametoindex error/n");
			return;
		}
		if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
			printf("Error: sysctl, take 1/n");
			return;
		}
		if ((buf = malloc(len)) == NULL) {
			printf("Could not allocate memory. error!/n");
			return;
		}
		if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
			printf("Error: sysctl, take 2");
			return;
		}
		ifm = (struct if_msghdr *)buf;
		sdl = (struct sockaddr_dl *)(ifm + 1);
		ptr = (unsigned char *)LLADDR(sdl);
		NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
		free(buf);
		
		macAddress = [outstring uppercaseString];
	});
	
	return macAddress.length > 0 ? macAddress : @"";
	
}

// 判断当前执行在release模式下
-(BOOL) checkReleaes {
    if(DEBUG!=1){
        return YES;
    }
    return NO;
}

@end
