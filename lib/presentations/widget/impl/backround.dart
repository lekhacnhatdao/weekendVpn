import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openvpn/resources/assets.gen.dart';

class Custombackground extends StatefulWidget {
  const Custombackground({super.key, required this.child});
  final Widget child;
  @override
  State<Custombackground> createState() => _CustombackgroundState();
}

class _CustombackgroundState extends State<Custombackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
            width: double.infinity,
            height: double.infinity,
            decoration:  BoxDecoration(
                
               image: DecorationImage(image: Assets.images.backgorund.image().image, fit: BoxFit.contain)
            ),
            child: widget.child);
  }
}