import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:openvpn/data/local/app_db.dart';
import 'package:openvpn/di/components/app_component.dart';
import 'package:openvpn/domain/model/history/history_model.dart';
import 'package:openvpn/presentations/bloc/app_cubit.dart';
import 'package:openvpn/presentations/bloc/app_state.dart';
import 'package:openvpn/presentations/widget/impl/app_body_text.dart';
import 'package:openvpn/presentations/widget/impl/app_title_text.dart';
import 'package:openvpn/resources/assets.gen.dart';
import 'package:openvpn/utils/extension/date_extension.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppCubit>().fetchHistoryList();
    });
  }

  void _refreshListView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isHistoryNotEmpty = false;
    return Scaffold(
      backgroundColor: Color(0xff1c1d21),
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AppTitleText(
          text: 'History',
          color: Colors.white,
        ),
        actions: [
          TextButton(
            child: isHistoryNotEmpty == true
                ? Assets.icons.icCrown.svg()
                : const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              if (isHistoryNotEmpty == true) {
                _deleteAllConfirmationDialog();
              } else {
                EasyLoading.showToast('History connection list is empty');
              }
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            if (state.histories.isNotEmpty) {
              isHistoryNotEmpty = true;
            } else {
              isHistoryNotEmpty = false;
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Visibility(
                  visible: state.histories.isEmpty,
                  child: const Column(
                    children: [
                      SizedBox(height: 150),
                      SizedBox(height: 16),
                      Align(
                        child: AppBodyText(
                          text: "Empty!",
                          size: 20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // SizedBox(
                      //     width: 80,
                      //     height: 80,
                      //     child: Cstmgradient(
                      //       color: AppColors.listgradient,
                      //       child: Icon(
                      //         Icons.hide_source,
                      //         size: 50,
                      //       ),
                      //     )),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                Visibility(
                  visible: state.histories.isNotEmpty,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final history = state.histories[index];
                      return _buildHistoryItem(history);
                    },
                    itemCount: state.histories.length,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _deleteAllConfirmationDialog() async {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(vertical: 320, horizontal: 40),
      
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            const Text(
              'Delete History',
            ),
           
            const Text(
              'Do you want delete all history?',
            ),
            const SizedBox(
              height: 4,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               
                                 Container(
                   padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 1, color: Colors.black),
                      color: Colors.transparent),
                  child: Container(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        )),
                  ),
                ),
                 SizedBox(
                  height: 10,
                ),
                Container(

                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30, vertical: 10),
                
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.red),
                  child: GestureDetector(
                      onTap: () {
                        getIt<AppDatabase>().deleteAllHistories(() {
                          _refreshListView();
                          if (!context.mounted) return;
                          // Navigator.of(context).popUntil((route) => route.isFirst);
                          EasyLoading.showToast(
                              'All History connection is deleted');
                          // Future.delayed(Duration(seconds: 2), () {
                          //   setState(() {
                          //     //return _refreshListView();
                          //   });
                          // });
                          context.read<AppCubit>().fetchHistoryList();
                          Navigator.pop(context);
                        });
                      },
                      child: Align(
                        child: const Text(
                          'Delete History',
                          style: TextStyle(fontSize: 14, color: Colors.white, ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
               

              ],
            ),
            SizedBox(
              height: 20,
            )
          ]),
        );
      },
    );
  }

  Widget _buildHistoryItem(HistoryModel history) {
    final server = history.vpnServerModel;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(width: 1, color: Colors.transparent),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                child: Container(
                  decoration: BoxDecoration(),
                  child: Image.asset(
                    fit: BoxFit.cover,
                    server.flag,
                    width: 50,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppBodyText(
                        color: Colors.white,
                        text: '${server.country}',
                      ),
                       Text(
                    ', City: ${server.region}',
                    style: TextStyle(color: Colors.white),
                  )
                    ],
                  ),
                  Text(
                    'day: ${history.createAt.toStringFormatted()}',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Spacer(),
              // AppBodyText(
              //   text: history.createAt.toStringFormatted(),
              //   size: 12,
              //   color: Colors.white,
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              GestureDetector(
                onTap: () {
                  getIt<AppDatabase>().deleteitems(() {
                    _refreshListView();
                    if (!context.mounted) return;
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                    EasyLoading.showToast('Deleted');
                    // Future.delayed(Duration(seconds: 2), () {
                    //   setState(() {
                    //     //return _refreshListView();
                    //   });
                    // });
                    context.read<AppCubit>().fetchHistoryList();
                  }, history.createAt.second.toString());
                },
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Dash(dashColor: Colors.white, length: MediaQuery.of(context).size.width/1.2,)
        ],
      ),
    );
  }
}
