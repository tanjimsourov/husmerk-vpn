import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:husmerk_vpn/appPreferences/appPreferences.dart';
import 'package:husmerk_vpn/models/vpn_configuartion.dart';
import 'package:husmerk_vpn/vpnEngine/vpn_engine.dart';
import '../models/vpn_info.dart';
class ControllerHome extends GetxController{

    final Rx<VpnInfo> vpnInfo = appPreferences.vpnInfoObj.obs;
    final vpnConnectionState = VpnEngine.vpnDisconnectedNow.obs;

    void connectToVpnNow() async{

        if(vpnInfo.value.base64OpenVPNConfigurationData.isEmpty){
            Get.snackbar("Location", "Please select Location first!");
            return;
        }
        //disconnected
        if(vpnConnectionState.value == VpnEngine.vpnDisconnectedNow){
            final dataConfigVpn = Base64Decoder().convert(vpnInfo.value.base64OpenVPNConfigurationData);
            final configuration = Utf8Decoder().convert(dataConfigVpn);
            final vpnConfiguration = VpnConfiguration(
              username: "vpn",
              password: "vpn",
              countryName: vpnInfo.value.countryLongName,
              config: configuration
            );
            await VpnEngine.startVpnNow(vpnConfiguration);
        } else{
            await VpnEngine.stopVpnNow();
        }

    }

    Color get getRoundButtonColor{
        switch(vpnConnectionState.value){
            case VpnEngine.vpnDisconnectedNow:
                return Colors.redAccent;
            case VpnEngine.vpnConnectedNow:
                return Colors.green;

            default:
                return Colors.orangeAccent;

        }
    }

    String get getRoundButtonText{
        switch(vpnConnectionState.value){
            case VpnEngine.vpnDisconnectedNow:
                return "Tap To Connect";
            case VpnEngine.vpnConnectedNow:
                return "Disconnect";

            default:
                return "Connecting...";

        }
    }

}