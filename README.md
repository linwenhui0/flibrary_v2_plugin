# flibrary_plugin

整合常用的 Flutter plugin.
    
整合常用的插件
- path_provider
- shared_preferences
- dio
- cookie_jar
- sqflite
- connectivity
- package_info
- device_info
- flutter_permissions（https://github.com/linwenhui0/flutter_permissions.git）
   

# Android 配置

全局gradle(android/build.gradle)修改

    maven {
        url 'http://207.246.93.94:8081/nexus/content/groups/public/'
    }

    maven {
        url 'http://maven.aliyun.com/nexus/content/groups/public/'
    }
    
    maven {
        url 'https://dl.bintray.com/kotlin/kotlin-dev/'
    }
    
    maven {
        url 'https://google.bintray.com/exoplayer/'
    }

本地gradler(android/app/build.gradle)修改
    
    implementation 'com.hlibrary.util:utillibrary:0.0.11'
    implementation 'com.alibaba:fastjson:1.2.51'
