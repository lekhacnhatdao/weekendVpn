import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openvpn/presentations/page/billing/premium_page.dart';
import 'package:openvpn/resources/assets.gen.dart';

class Custompretimum extends StatefulWidget {
  const Custompretimum({super.key});

  @override
  State<Custompretimum> createState() => _CustompretimumState();
}

class _CustompretimumState extends State<Custompretimum> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PremiumPage()));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              
              child: Assets.images.crown.image(height: 40),
            ),
            
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Go Premium',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
                Text(
                    'Click to open promotional\n packages to see\n detailed information'),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 10,
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
