package com.hdlang.flutter.flibraryplugin

import android.content.Context
import android.content.pm.ApplicationInfo
import android.telephony.TelephonyManager
import com.hlibrary.util.Logger
import com.hlibrary.util.SIMCardInfo
import com.hlibrary.util.Utils
import com.hlibrary.util.file.SdUtil
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*


class FlibraryPlugin : MethodCallHandler {

    private val context: Context

    companion object {

        const val HAVE_EXTERNAL_STORAGE = "haveExternalStorage"

        const val PLATFORM_VERSION = "getPlatformVersion"

        const val SCREEN_WIDTH = "getScreenWidth"

        const val SCREEN_HEIGHT = "getScreenHeight"

        const val SCREEN_RATIO = "getScreenRatio"

        const val TEXT_RATIO = "getTextRatio"

        const val PHONE_TYPE = "getPhoneType"

        const val LANGUAGE = "getLanguage"

        const val NETWORK_TYPE = "getCurrentNetworkType"

        const val ROUTE_WIFI_MAC = "getRouteMacAddress"

        const val WIFI_MAC = "getMacAddress"

        const val IMEI = "getImei"

        const val ROOT = "isRoot"

        const val VPN = "isVpn"

        const val PROXY_HOST = "getProxyHost"

        const val PROXY_PORT = "getProxyPort"

        const val CHECK_RELEASE = "isRelease"


        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "flibrary_plugin")
            channel.setMethodCallHandler(FlibraryPlugin(registrar.context()))
        }
    }

    constructor(context: Context) : super() {
        this.context = context
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        when (call.method) {
            HAVE_EXTERNAL_STORAGE -> result.success(SdUtil.existSDCard())
            PLATFORM_VERSION -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            SCREEN_WIDTH -> result.success(context.resources.displayMetrics.widthPixels)
            SCREEN_HEIGHT -> result.success(context.resources.displayMetrics.heightPixels)
            SCREEN_RATIO -> result.success(context.resources.displayMetrics.density)
            TEXT_RATIO -> result.success(context.resources.displayMetrics.scaledDensity)
            PHONE_TYPE -> getPhoneType(result)
            LANGUAGE -> result.success(Locale.getDefault().language)
            NETWORK_TYPE -> result.success(SIMCardInfo(context).getCurrentNetworkType())
            ROUTE_WIFI_MAC -> getRouteWifiMac(result)
            WIFI_MAC -> getWifiMac(result)
            IMEI -> getImei(result)
            ROOT -> isRoot(result)
            VPN -> isVpn(result)
            PROXY_HOST -> getProxyHost(result)
            PROXY_PORT -> getProxyPort(result)
            CHECK_RELEASE -> checkRelease(result)
            else -> result.notImplemented()
        }
    }

    fun getPhoneType(result: Result) {
        var telephonyManager: TelephonyManager? = null
        val obj = context.getSystemService(Context.TELEPHONY_SERVICE)
        if (obj is TelephonyManager) {
            telephonyManager = obj
        }
        var phoneType: Int? = -1
        phoneType = telephonyManager?.phoneType
        result?.success(phoneType)
    }


    private fun getRouteWifiMac(result: Result) {
        Logger.instance.defaultTagI("getRouteWifiMac")
        var mac = ""
        try {
            mac = Utils.getConnectedWifiMacAddress(context)
        } catch (e: Exception) {
            e.printStackTrace()
            Logger.instance.defaultTagI(e.toString())
        }
        result.success(mac)
    }

    /**
     * 获得wifi mac
     */
    private fun getWifiMac(result: Result) {
        Logger.instance.defaultTagI("getWifiMac")
        var mac = ""
        try {
            mac = Utils.getMacAddress(context)
        } catch (e: Exception) {
            e.printStackTrace()
            Logger.instance.defaultTagI(e.toString())
        }
        result.success(mac)
    }

    /**
     * 获得imei
     */
    private fun getImei(result: Result) {
        val simCardInfo = SIMCardInfo(context)
        result.success(simCardInfo.imei)
    }

    /**
     * 判断是否root
     */
    private fun isRoot(result: Result) {
        result.success(Utils.isRoot())
    }

    /**
     * 判断是否使用vpn
     */
    private fun isVpn(result: Result) {
        if (Utils.isVpnConnected() || Utils.isWifiProxy(context)) {
            result.success(true)
        } else {
            result.success(false)
        }
    }

    private fun getProxyHost(result: Result) {
        val host = Utils.getProxyHost(context)
        result.success(host)
    }

    private fun getProxyPort(result: Result) {
        val port = Utils.getProxyPort(context)
        result.success(port)
    }

    /**
     * 判断是否为release版本
     */
    private fun checkRelease(result: Result) {
        val info: ApplicationInfo = context?.applicationInfo
        if (info?.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0) {
            result.success(false)
        } else {
            result.success(true)
        }

    }

}
