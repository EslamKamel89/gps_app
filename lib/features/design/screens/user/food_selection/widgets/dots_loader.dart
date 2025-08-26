// import 'package:flutter/material.dart';

// class DotsLoader extends StatefulWidget {
//   const DotsLoader({super.key});

//   @override
//   State<DotsLoader> createState() => _DotsLoaderState();
// }

// class _DotsLoaderState extends State<DotsLoader> with SingleTickerProviderStateMixin {
//   late final AnimationController _c = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 900),
//   )..repeat();
//   @override
//   void dispose() => _c.dispose();

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _c,
//       builder: (context, _) {
//         final v = (_c.value * 3).floor() % 3;
//         return Text('.' * (v + 1), style: Theme.of(context).textTheme.titleLarge);
//       },
//     );
//   }
// }
