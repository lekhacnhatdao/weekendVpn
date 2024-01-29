import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:openvpn/resources/colors.dart';

class LoadingButtons extends StatefulWidget {
  const LoadingButtons({
    super.key,
    required this.isLoading,
    required this.icon,
    required this.text,
    this.backgroundColor = AppColors.accent,
    this.height = 52,
    this.onPressed,
    this.margin,
    required this.changeUI,
    required this.isDisconnect,
    this.duaration,
  });

  final bool isLoading;
  final bool changeUI;
  final bool isDisconnect;
  final Widget icon;
  final String text;
  final String? duaration;
  final Color backgroundColor;
  final Function()? onPressed;
  final EdgeInsetsGeometry? margin;
  final double height;

  @override
  State<LoadingButtons> createState() => _LoadingButtonsState();
}

class _LoadingButtonsState extends State<LoadingButtons>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();
  @override
  void initState() {
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0.6,
    end: 1,
  ).animate(_controller);
  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 0.4, end: 0.05).animate(_controller);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: widget.isLoading || widget.isDisconnect
          ? 
           Align(
              child: Stack(
                children: [
                  Align(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Color(0xffdec9e9),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration:  BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              // ignore: lines_longer_than_80_chars
                              gradient: LinearGradient(
                                colors: widget.isLoading
                                    ? [
                                        const Color(0xffdec9e9),
                                        const Color(0xffdec9e9)
                                      ]
                                    : widget.changeUI
                                        ? [
                                            const Color(0xffdec9e9),
                                            const Color(0xffdec9e9)
                                          ]
                                        : [
                                            const Color(0xff6a3bed),
                                            const Color(0xff6a3bed)
                                          ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
            top: MediaQuery.of(context).size.height/22,
                        left: MediaQuery.of(context).size.width/2.65,

                    child: Align(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        padding: const EdgeInsets.all(23),
                        child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) =>
                                const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ],
                                ).createShader(bounds),
                            child: Align(
                                child: widget.isLoading
                                    ? LoadingAnimationWidget.hexagonDots(color: Colors.black, size: 50)

                                    //  Container(
                                    //     decoration: const BoxDecoration(
                                    //         image: DecorationImage(
                                    //           image:
                                    //               AssetImage('assets/images/giphy.gif'),
                                    //         ),
                                    //         shape: BoxShape.circle),
                                    //   )
                                    :widget.changeUI?  const Icon(
                                        Icons.storm_rounded,
                                        size: 50,
                                      ): Icon(Icons.stop_outlined))),
                      ),
                    ),
                  ),
                ],
              ),
            ): Stack(
              children: [
                Align(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 150 * 1.5,
                        height: 150 * 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Color(0xff6a3bed)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 30,
                  left: MediaQuery.of(context).size.width / 3.4,
                  child: Align(
                    child: Stack(
                      children: [
                        Align(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Color(0xff6a3bed),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                    // ignore: lines_longer_than_80_chars
                                    gradient: LinearGradient(
                                      colors: widget.isLoading
                                          ? [
                                              const Color(0xff6a3bed),
                                              const Color(0xff6a3bed)
                                            ]
                                          : widget.changeUI
                                              ? [
                                                  const Color(0xff6a3bed),
                                                  const Color(0xff6a3bed)
                                                ]
                                              : [
                                                  const Color(0xff6a3bed),
                                                  const Color(0xff6a3bed)
                                                ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomRight,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 40,
                          left: MediaQuery.of(context).size.width / 20,
                          child: Align(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(23),
                              child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) =>
                                      const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white,
                                    Colors.white,
                                        ],
                                      ).createShader(bounds),
                                  child: Align(
                                      child: widget.isLoading
                                          ? LoadingAnimationWidget.hexagonDots(color: Colors.black, size: 50)

                                          //  Container(
                                          //     decoration: const BoxDecoration(
                                          //         image: DecorationImage(
                                          //           image:
                                          //               AssetImage('assets/images/giphy.gif'),
                                          //         ),
                                          //         shape: BoxShape.circle),
                                          //   )
                                          :  widget.changeUI?  const Icon(
                                        Icons.storm_rounded,
                                        size: 80,
                                      ): Icon(Icons.stop_outlined, size: 80))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
