import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn/presentations/bloc/app_cubit.dart';
import 'package:openvpn/presentations/bloc/app_state.dart';
import 'package:openvpn/presentations/page/main/server_page/server_page.dart';
import 'package:openvpn/presentations/route/app_router.gr.dart';
import 'package:openvpn/presentations/widget/impl/Customprenium.dart';
import 'package:openvpn/presentations/widget/impl/app_thapgiac_text.dart';
import 'package:openvpn/presentations/widget/impl/backround.dart';
import 'package:openvpn/presentations/widget/index.dart';
import 'package:openvpn/resources/assets.gen.dart';
import 'package:openvpn/resources/colors.dart';
import 'package:openvpn/resources/strings.dart';
import 'package:upgrader/upgrader.dart';

class VpnPage extends StatefulWidget {
  const VpnPage({
    super.key,
  });

  @override
  State<VpnPage> createState() => _VpnPageState();
}

class _VpnPageState extends State<VpnPage> {
  late Timer? _timer = null;
  bool _dialogShown = false;
  Timer? _connectingTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppCubit>().startBilling();
      _maintenancePopup();
    });
    setState(() {});
  }

  Future<void> _maintenancePopup() async {
    await Future.delayed(const Duration(seconds: 7));
    if (!this.mounted) {
      return;
    }
    if (context.read<AppCubit>().state.currentServer?.flag.isEmpty ??
        true && !_dialogShown) {
      Future.microtask(() {
        _showMaintenanceDialog();
      });
    }
    _timer = Timer.periodic(const Duration(seconds: 60), (Timer timer) {
      context.read<AppCubit>().fetchServerList();
      if (context.read<AppCubit>().state.servers.isEmpty && !_dialogShown) {
        Future.microtask(() {
          _showMaintenanceDialog();
        });
      }
    });
  }

  void _showMaintenanceDialog() {
    if (!this.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _dialogShown = true;
        return AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Network Error'),
            ],
          ),
          content: const Text(
              textAlign: TextAlign.center,
              'We are maintaining the system to upgrade the server. Please try again later'),
          actions: <Widget>[
            AppButtons(
                textColor: AppColors.primary,
                text: "Close",
                backgroundColor: AppColors.colorRed,
                onPressed: () {
                  Navigator.pop(context);
                  _dialogShown = false;
                }),
          ],
        );
      },
    );
  }

  void _showDisconnectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _dialogShown = true;
        return AlertDialog(
          title: const Text('Sorry :(('),
          content: const Text(
              'This server is experiencing issues, please disconnect and select a different server!'),
          actions: <Widget>[
            AppButtons(
                textColor: AppColors.primary,
                text: "Disconnected",
                backgroundColor: AppColors.colorYellow,
                onPressed: () {
                  context..read<AppCubit>().openVPN.disconnect();
                  //  Navigator.of(context).pop();
                  _handleConnectButtonPressed();
                  Navigator.of(context).pop();
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  _dialogShown = false;
                }),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double halfScreenHeight = screenHeight / 2.5;

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state.isConnecting) {
          _connectingTimer ??= Timer(const Duration(seconds: 15), () {
            _showDisconnectDialog();
          });
        } else {
          _connectingTimer?.cancel();
          _connectingTimer = null;
        }
        return UpgradeAlert(
          child: Custombackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 10),
                  //   height: halfScreenHeight,
                  //   decoration: BoxDecoration(
                  //     borderRadius: const BorderRadius.all(Radius.circular(10)),
                  //     color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.25),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       const SizedBox(
                  //         height: 10,
                  //       ),
                  //       const Text(
                  //         'VPN connection',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //       const SizedBox(height: 20),
                  //       Expanded(
                  //           child: Padding(
                  //         padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                  //         child: GridView.builder(
                  //           gridDelegate:
                  //               const SliverGridDelegateWithMaxCrossAxisExtent(
                  //                   maxCrossAxisExtent: 30,
                  //                   mainAxisSpacing: 1,
                  //                   childAspectRatio: 1,
                  //                   crossAxisSpacing: 1),
                  //           itemBuilder: (context, index) =>
                  //               Center(child: BuildList(state.duration[index])),
                  //           itemCount: state.duration.length,
                  //         ),
                  //       )),
                  //       state.titleStatus == 'Not connected'
                  //           ? const Text(
                  //               'Your IP exposed to danger!',
                  //               style: TextStyle(color: Color(0xffD62828)),
                  //             )
                  //           : state.isConnecting
                  //               ? const Text(
                  //                   'Your IP exposed to danger!',
                  //                   style: TextStyle(color: Color(0xffD62828)),
                  //                 )
                  //               : const Text(
                  //                   'Your IP is hidden, you are now very secure!',
                  //                   style: TextStyle(color: Color(0xff119822)),
                  //                 ),
                  //       const SizedBox(
                  //         height: 10,
                  //       ),
                  //       const Dash(
                  //           dashThickness: 2,
                  //           dashLength: 10,
                  //           dashGap: 6,
                  //           length: 320,
                  //           direction: Axis.horizontal,
                  //           dashColor: Color(0xff2F2F2F)),
                  //       const SizedBox(height: 10),
                  //       Row(
                  //         children: [
                  //           const SizedBox(width: 8),
                  //           const SizedBox(
                  //             width: 8,
                  //           ),
                  //           Expanded(
                  //             child: ClipRRect(
                  //               borderRadius:
                  //                   const BorderRadius.all(Radius.circular(16)),
                  //               child: Column(
                  //                 children: [
                  //                   Padding(
                  //                     padding: const EdgeInsets.symmetric(
                  //                         horizontal: 40),
                  //                     child: AppLabelText(
                  //                       icon: Appicon.upload,
                  //                       text: Strings.download,
                  //                       coloricon: const Color(0xff08A045),
                  //                       size: 10,
                  //                       color: AppColors.textSecondary,
                  //                     ),
                  //                   ),
                  //                   const SizedBox(height: 8),
                  //                   AppTitleText(
                  //                       text: state.byteOut,
                  //                       size: 28,
                  //                       color: Colors.white)
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           const Dash(
                  //               dashThickness: 2,
                  //               dashLength: 10,
                  //               length: 70,
                  //               dashGap: 6,
                  //               direction: Axis.vertical,
                  //               dashColor: Color(0xff2F2F2F)),
                  //           const SizedBox(width: 8),
                  //           Expanded(
                  //             child: ClipRRect(
                  //               borderRadius:
                  //                   const BorderRadius.all(Radius.circular(16)),
                  //               child: Container(
                  //                 child: Column(
                  //                   children: [
                  //                     Padding(
                  //                       padding: const EdgeInsets.symmetric(
                  //                           horizontal: 40),
                  //                       child: AppLabelText(
                  //                         icon: Appicon.download,
                  //                         coloricon: const Color(0xffF6AA1C),
                  //                         text: Strings.upload,
                  //                         size: 10,
                  //                         color: AppColors.textSecondary,
                  //                       ),
                  //                     ),
                  //                     const SizedBox(height: 8),
                  //                     AppTitleText(
                  //                       text: state.byteIn,
                  //                       size: 28,
                  //                       color: Colors.white,
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(width: 8),
                  //         ],
                  //       ),
                  //       const Spacer(),
                  //       const Spacer(),
                  //       const SizedBox(height: 32),
                  //     ],
                  //   ),
                  // ),
            
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
            
                  const SizedBox(
                    height: 10,
                  ),
                  LoadingButtons(
                    isDisconnect: state.titleStatus == 'Not connected',
                    isLoading: state.isConnecting,
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Icon(Icons.play_arrow_rounded,
                          size: 50, color: Colors.white),
                    ),
                    text: 'connecting',
                    onPressed: state.isConnecting
                        ? () {
                            context.read<AppCubit>().openVPN.disconnect();
                          }
                        : () async {
                            await context.read<AppCubit>().toggle();
                          },
                    changeUI: state.titleStatus == 'Not connected',
                    duaration: state.duration,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      state.titleStatus == 'Connected'
                          ? Assets.images.checked.image(height: 35)
                          : Assets.images.uncheck.image(height: 30),
                      Text(
                        ' ${state.titleStatus}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: state.colorStatus,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
            
                  const SizedBox(
                    height: 20,
                  ),
                  data(state.byteOut, state.byteIn),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Connecting time', style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                  ),),
                  Text(state.duration, style: TextStyle(
                      color: Colors.black,
                    fontSize: 20
                  ),),
                  SizedBox(height: 10,),
            
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: const Color(0xff7000e1),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border:
                            Border.all(width: 1, color: const Color(0xffffff00))),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ServerPage()));
                          
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 60),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Image.asset(
                                state.currentServer?.flag ??
                                    Assets.images.logo.path,
                                height: 32,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.currentServer?.country ??
                                          'Fastest Server',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      ' City: (${state.currentServer?.region})',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5)),
                                    )
                                  ],
                                ),
                                Text('IP: ${state.currentServer?.ip}',style: TextStyle(
                                          color: Colors.white),)
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 25,
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
            
                  // const Custompretimum(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget data(String upload, String dowload) {
    return Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                Text(
                  Strings.download,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.4), fontSize: 20),
                ),
                const SizedBox(
                  width: 2,
                ),
                Column(
                  children: [
                    Text(' ${dowload}',
                        style: const TextStyle(color: Colors.black)),
                    Assets.images.chartdown.image(height: 50),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                Text(
                  Strings.upload,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.4), fontSize: 20),
                ),
                const SizedBox(
                  width: 2,
                ),
                Column(
                  children: [
                    Text(' ${upload}',
                        style: const TextStyle(color: Colors.black)),
                    Assets.images.chartup.image(height: 50),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildList(String d) {
    bool flag = false;
    if (d == ':') {
      flag = true;
    }
    return Row(
      children: [
        CustomPaint(painter: MyPainter()),
        const SizedBox(),
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: flag ? Colors.transparent : Colors.black,
          ),
          child: Text(
            d,
            style: const TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _navigateToSelectLocation() {
    AutoRouter.of(context).push(const ServerRoute());
  }

  void _handleConnectButtonPressed() {
    context.read<AppCubit>().toggle();
  }
}
