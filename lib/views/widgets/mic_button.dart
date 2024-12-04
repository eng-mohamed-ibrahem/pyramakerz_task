import 'package:flutter/material.dart';

class MicButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;

  const MicButton({
    super.key,
    required this.isListening,
    required this.onTap,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isListening ? _scaleAnimation.value : 1.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.isListening ? Colors.redAccent : Colors.blueAccent,
              shape: BoxShape.circle,
              boxShadow: [
                if (widget.isListening)
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.6),
                    spreadRadius: 4,
                  ),
              ],
            ),
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Colors.black.withOpacity(.05),
                  )
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
              child: IconButton(
                icon: const Icon(Icons.mic),
                onPressed: widget.onTap,
              ),
            ),
          ),
        );
      },
    );
  }
}
