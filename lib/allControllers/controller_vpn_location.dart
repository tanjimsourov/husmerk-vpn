import 'package:get/get.dart';
import 'package:husmerk_vpn/apiVpnGate/api_vpn_gate.dart';
import 'package:husmerk_vpn/appPreferences/appPreferences.dart';

import '../models/vpn_info.dart';

class ControllerVpnLocation extends GetxController{

    List<VpnInfo> vpnServersList = appPreferences.vpnList;

    final RxBool isLoadingNewLocations = false.obs;

    Future<void> retrieveVpnInformation() async{

      isLoadingNewLocations.value = true;
      vpnServersList.clear();

      vpnServersList =await ApiVpnGate.retrieveAllAvailableFreeVpnServers();
      isLoadingNewLocations.value = false;

    }


}