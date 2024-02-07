import 'package:flutter/material.dart';

class CustomiPhoneWidget extends StatelessWidget {
  final Widget child;
  const CustomiPhoneWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Color del fondo
      child: ClipPath(
        clipper: CustomClipperWidget(),
        child: Container(
          color: Colors.white, // Color del área recortada (la forma del iPhone)
          child: Center(child: child),
        ),
      ),
    );
  }
}

class CustomClipperWidget extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Puedes ajustar estos valores para obtener la forma deseada
    const double radius = 30.0;
    final double height = size.height;
    final double width = size.width;

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(width - radius, 0);
    path.quadraticBezierTo(width, 0, width, radius);
    path.lineTo(width, height - radius);
    path.quadraticBezierTo(width, height, width - radius, height);
    path.lineTo(radius, height);
    path.quadraticBezierTo(0, height, 0, height - radius);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
