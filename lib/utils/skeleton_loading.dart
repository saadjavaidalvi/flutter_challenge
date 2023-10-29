import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  final double height;
  final double width;

  const Skeleton({
    super.key,
    this.height = 20,
    this.width = 200,
  });

  @override
  createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    )..addListener(() {
        setState(() {});
      });

    _animationController.repeat();
  }

  @override
  void dispose() {
    if (_animationController.status == AnimationStatus.forward ||
        _animationController.status == AnimationStatus.reverse) {
      // ignore: invalid_use_of_protected_member
      _animationController.notifyStatusListeners(AnimationStatus.dismissed);
    }
    _animationController.dispose();
    //_animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(gradientPosition.value, 0),
          end: const Alignment(-1, 0),
          colors: const [
            Color(0xffE5E5E5),
            Color(0xffC4C4C4),
            Color(0xffE5E5E5),
          ],
        ),
      ),
    );
  }
}
