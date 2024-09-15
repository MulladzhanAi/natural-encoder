import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final double width;
  final double height;
  final bool enabled;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    this.width=200,
    this.height=50,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(!enabled) return;
        onTap();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: enabled ? Colors.lightBlue : Colors.grey,
        ),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
