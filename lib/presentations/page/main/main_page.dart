import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn/presentations/bloc/app_cubit.dart';
import 'package:openvpn/presentations/bloc/app_state.dart';
import 'package:openvpn/presentations/page/billing/premium_page.dart';
import 'package:openvpn/presentations/page/main/history_page.dart';
import 'package:openvpn/presentations/page/main/settingpage.dart';
import 'package:openvpn/presentations/page/main/vpn_page.dart';
import 'package:openvpn/presentations/widget/impl/backround.dart';
import 'package:openvpn/resources/assets.gen.dart';
import 'package:openvpn/utils/config.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return  SafeArea(
            bottom: false,
            child: Custombackground(
              child: Scaffold(
                
                appBar: AppBar(
                  actions: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumPage()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.amber),
                          borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: const Text('Go pro', style: TextStyle(color: Colors.white),),),
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingPage()));
                    } ,child: const Icon(Icons.settings_rounded, color: Colors.white,),),
                    const SizedBox(width: 10,), 
                  ],
                  backgroundColor: const Color(0xff7000e1),
                  leading: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>const HistoryPage()));
                      },
                      child: const Icon(Icons.access_time_outlined, color: Colors.white),
                    ),
                  centerTitle: true,
                  title:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Assets.images.lo.image(height: 40),
                       const SizedBox(width: 3,),
                      Text('${ Config.appName.split('S').last}'  ,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                    
                  // BlocBuilder<AppCubit, AppState>(
                  //   builder: (context, state) {
                  //     return Container(
                  //       decoration: const BoxDecoration(
                  //         boxShadow: <BoxShadow>[
                  //           BoxShadow(
                  //             color: Colors.white12,
                  //             blurRadius: 10,
                  //           ),
                  //         ],
                  //         borderRadius: BorderRadius.all(Radius.circular(100)),
                  //       ),
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       child: CachedNetworkImage(
                  //         imageUrl: state.currentServer?.flag ?? 'assets/images/Frame.png',
                  //         height: 32,
                  //       ),
                  //     );
                  //   },
                  // )
                ),
                body: 
                          const VpnPage(),

                      
                    
              ),
            ));
      },
    );
  }
}
