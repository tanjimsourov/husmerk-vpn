import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:husmerk_vpn/allControllers/controller_home.dart';
import 'package:husmerk_vpn/allWidget/customWidget.dart';
import 'package:husmerk_vpn/allWidget/timer_widget.dart';
import 'package:husmerk_vpn/appPreferences/appPreferences.dart';
import 'package:husmerk_vpn/main.dart';
import 'package:husmerk_vpn/models/vpn_status.dart';
import 'package:husmerk_vpn/screens/available_vpn_server_screen.dart';
import 'package:husmerk_vpn/screens/connected_network_ip_infoScreen.dart';
import 'package:husmerk_vpn/vpnEngine/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final homeController = Get.put(ControllerHome());

  locationSelectionBottomNavigation(BuildContext context){
    return SafeArea(child: Semantics(
      button: true,
      child: InkWell(
        onTap: (){
              Get.to(()=>AvailableVpnServersLocation());
        },
        child: Container(
          color: Colors.cyan,
          padding: EdgeInsets.symmetric(horizontal: sizeScreen.width * .041),
          height: 62,
          child: const Row(
            children: [
              Icon(
                CupertinoIcons.flag_circle,
                color: Colors.white,
                size: 36,
              ),
              SizedBox(
                width: 12,
              ),
              Text("Select Country/Location",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400

                ),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.cyan,
                  size: 26,
                ),
              )
            ],
          ),

        ),
      ),
    ));
  }
  Widget vpnRoundButton(){

    return Column(
        children: [

          //vpn button
          Semantics(
           button: true,
            child: InkWell(
              onTap: (){
                    homeController.connectToVpnNow();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homeController.getRoundButtonColor.withOpacity(.1),
                ),

                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: homeController.getRoundButtonColor.withOpacity(.3),
                  ),
                  child: Container(
                    height: sizeScreen.height * .14,
                    width: sizeScreen.height * .14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: homeController.getRoundButtonColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          size: 30,
                        color: Colors.white,),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                        homeController.getRoundButtonText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white
                        ),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //status of connection
          Container(
            margin: EdgeInsets.only(top: sizeScreen.height * .015,bottom: sizeScreen.height * .02),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              homeController.vpnConnectionState.value == VpnEngine.vpnDisconnectedNow
                  ? "Not Connected"
                  : homeController.vpnConnectionState.replaceAll("_", " ").toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),

          //timer
          Obx(()=>TimerWidget(

              initTimerNow: homeController.vpnConnectionState.value == VpnEngine.vpnConnectedNow, //true
          ))

        ],
    );
  }
  @override
  Widget build(BuildContext context) {
    VpnEngine.snapshotVpnStage().listen((event) {
      homeController.vpnConnectionState.value = event;
    });
    sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            title: const Text("Husmerk VPN",
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black

            ),),
            leading: IconButton(
               onPressed: (){
                  Get.to(()=>ConnectedNetworkIPInfoScreen());
               },
              icon: Icon(Icons.perm_device_info),
            ),
            actions: [
              IconButton(
                onPressed: (){
                    Get.changeThemeMode(
                      appPreferences.isModeDark ? ThemeMode.light : ThemeMode.dark
                    );

                    appPreferences.isModeDark = !appPreferences.isModeDark;
                },
                icon: const Icon(Icons.brightness_2_outlined),
              ),
            ],
          ),
          bottomNavigationBar: locationSelectionBottomNavigation(context),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              //2 round widget
              //location + ping
              Obx(()=>Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget(

                      titleText: homeController.vpnInfo.value.countryLongName.isEmpty ?'Location'
                          : homeController.vpnInfo.value.countryLongName,
                      subTitleText: 'FREE',
                      roundWidgetWithIcon: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.redAccent,
                        child: homeController.vpnInfo.value.countryLongName.isEmpty ?Icon(Icons.flag_circle,
                          size: 30,
                          color: Colors.white,) : null,
                        backgroundImage: homeController.vpnInfo.value.countryLongName.isEmpty ? null
                            : AssetImage('countryFlags/${homeController.vpnInfo.value.countryShortName.toLowerCase()}.png'),

                      )
                  ),
                  CustomWidget(
                      titleText: homeController.vpnInfo.value.countryLongName.isEmpty ? '60ms'
                          : homeController.vpnInfo.value.ping +" ms",
                      subTitleText: 'PING',
                      roundWidgetWithIcon: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.graphic_eq,
                          size: 30,
                          color: Colors.white,),

                      )
                  ),
                ],
              ),),
              //button for vpn

              Obx(() => vpnRoundButton()),

              //2 round widget
              //download + ping
              StreamBuilder<VpnStatus?>(
                initialData: VpnStatus(),
                stream: VpnEngine.snapshotVpnStatus(),
                builder: (context, dataSnapshot){
                 return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomWidget(

                          titleText: "${dataSnapshot.data?.byteIn ?? '0 kbps'}",
                          subTitleText: 'DOWNLOAD',
                          roundWidgetWithIcon: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.arrow_circle_down,
                              size: 30,
                              color: Colors.white,),

                          )
                      ),
                      CustomWidget(titleText: "${dataSnapshot.data?.byteOut ?? '0 kbps'}",
                          subTitleText: 'UPLOAD',
                          roundWidgetWithIcon: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.purpleAccent,
                            child: Icon(Icons.arrow_circle_up_rounded,
                              size: 30,
                              color: Colors.white,),

                          )
                      ),
                    ],
                  );
                },
              ),

            ],

          ),

    );
  }
}
