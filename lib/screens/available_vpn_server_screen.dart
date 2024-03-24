import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:husmerk_vpn/allControllers/controller_vpn_location.dart';
import 'package:husmerk_vpn/models/vpn_location_card_widget.dart';
class AvailableVpnServersLocation extends StatelessWidget {
   AvailableVpnServersLocation({super.key});

  final vpnLocationController = ControllerVpnLocation();
   loadingUIWidget(){
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Gathering Free Vpn Locations....",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      );
   }
   noVpnServerFoundUIWidget(){
     return Center(
          child: Text(
            "No Vpn Found....try again",
            style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold
            ),
          ),
     );
   }

   vpnAvailableServerData(){
     return ListView.builder(
       itemCount: vpnLocationController.vpnServersList.length,
       physics: BouncingScrollPhysics(),
       padding: EdgeInsets.all(3),
       itemBuilder: (context, index){
        return VpnLocationCardWidget(vpnInfo: vpnLocationController.vpnServersList[index]);
       }

     );
   }
  @override
  Widget build(BuildContext context) {

    if(vpnLocationController.vpnServersList.isEmpty){
      vpnLocationController.retrieveVpnInformation();
    }
    return Obx(()=> Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          "VPN locations: "+ vpnLocationController.vpnServersList.length.toString(),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: (){
            vpnLocationController.retrieveVpnInformation();
          },
          child: Icon(
            CupertinoIcons.refresh_circled,
            size: 40,
          ),
        ),
      ),
      body: vpnLocationController.isLoadingNewLocations.value
          ? loadingUIWidget()
          : vpnLocationController.vpnServersList.isEmpty
          ? noVpnServerFoundUIWidget()
          : vpnAvailableServerData(),
    ));
  }
}
