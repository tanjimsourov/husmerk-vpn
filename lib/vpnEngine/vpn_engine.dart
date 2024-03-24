import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:husmerk_vpn/models/vpn_configuartion.dart';

import '../models/vpn_status.dart';

class VpnEngine{

  //native channel
  static final String eventChannelVpnStage ="vpnStage";
  static final String eventChannelVpnStatus ="vpnStatus";
  static final String methodChannelVpnControl ="vpnControl";


  //vpn connection stage snapshot
static Stream<String> snapshotVpnStage()=>
    EventChannel(eventChannelVpnStage).receiveBroadcastStream().cast();

  //vpn connection status snapshot
static Stream<VpnStatus?> snapshotVpnStatus()=>
    EventChannel(eventChannelVpnStatus).receiveBroadcastStream().map((eventStatus) =>
        VpnStatus.fromJson(jsonDecode(eventStatus))).cast();

  //
static Future<void> startVpnNow(VpnConfiguration vpnConfiguration) async{

  return MethodChannel(methodChannelVpnControl).invokeMethod(
    "start",
    {
      "config":vpnConfiguration.config,
      "country":vpnConfiguration.countryName,
      "username":vpnConfiguration.username,
      "password":vpnConfiguration.password
    },
  );

}
  static Future<void> stopVpnNow(){
  return MethodChannel(methodChannelVpnControl).invokeMethod("stop");
  }

  static Future<void> killSwitchOpenNow(){
    return MethodChannel(methodChannelVpnControl).invokeMethod("kill_switch");
  }
  static Future<void> refreshStageNow(){
    return MethodChannel(methodChannelVpnControl).invokeMethod("refresh");
  }
  static Future<String?> getStageNow(){
    return MethodChannel(methodChannelVpnControl).invokeMethod("stage");
  }


  static Future<bool> isConnectedNow(){
   return getStageNow().then((valueStage) => valueStage!.toLowerCase() =="connected");
  }

  //stages of vpn connection
static const String vpnConnectedNow = "connected";
static const String vpnDisconnectedNow = "disconnected";
static const String vpnWaitConnectionNow = "wait_connection";
static const String vpnAuthenticationNow = "authenticating";
static const String vpnReconnectNow = "reconnect";
static const String vpnNoConnectionNow = "no_connection";
static const String vpnConnectionNow = "connecting";
static const String vpnPrepareNow = "prepare";
static const String vpnDeniedNow = "denied";

}