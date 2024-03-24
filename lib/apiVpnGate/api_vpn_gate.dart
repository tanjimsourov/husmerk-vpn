import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:husmerk_vpn/appPreferences/appPreferences.dart';
import 'package:husmerk_vpn/models/vpn_info.dart';
import 'package:http/http.dart' as http;

import '../models/ip_info.dart';
class ApiVpnGate{

  static Future<List<VpnInfo>> retrieveAllAvailableFreeVpnServers() async {

    final List<VpnInfo> vpnServerList = [];
    try{
     final responseFromApi =await http.get(Uri.parse("https://www.vpngate.net/api/iphone/"));
     final commaSeparatedValueString = responseFromApi.body.split("#")[1].replaceAll("*", "");
     List<List<dynamic>> listData =  const CsvToListConverter().convert(commaSeparatedValueString);
     final header = listData[0];
     for(int counter=1; counter<listData.length-1;counter++){

       Map<String,dynamic> jsonData = {};

       for(int innercounter=0; innercounter<header.length;innercounter++){
          jsonData.addAll({header[innercounter].toString(): listData[counter][innercounter]});
       }
       
       vpnServerList.add(VpnInfo.fromJson(jsonData));
     }
    }catch(error){
        Get.snackbar("Error Occured",
            error.toString(),
           colorText: Colors.white,
            backgroundColor: Colors.redAccent.withOpacity(.8)
        );
    }

    vpnServerList.shuffle();
    if(vpnServerList.isNotEmpty) appPreferences.vpnList = vpnServerList;
    return vpnServerList;

}

  static Future<void> retrieveIPDetails({required Rx<IPInfo> ipInformation}) async{

    try{
      final responseFromApi  =await http.get(Uri.parse('http://ip-api.com/json/'));
      final dataFromApi = jsonDecode(responseFromApi.body);
      ipInformation.value = IPInfo.fromJson(dataFromApi);

    }catch(error){
      Get.snackbar("Error Occured",
          error.toString(),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent.withOpacity(.8)
      );
    }

  }


}