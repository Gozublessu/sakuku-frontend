import 'package:flutter/material.dart';
import 'dart:async';

class HoverWrapper extends StatefulWidget {
  final Widget child;
  final double scale;
  final bool enabled;
  final Duration duration;
  final Duration hoverDelay;

  const HoverWrapper({
    super.key,
    required this.child,
    this.scale = 1.07,
    this.duration = const Duration(milliseconds: 150),
    this.enabled = true,
    this.hoverDelay = Duration.zero,
  });

  @override
  State<HoverWrapper> createState() => _HoverWrapperState();
}

class _HoverWrapperState extends State<HoverWrapper> {
  bool _isHovering = false;
  Timer? _hoverTimer;

  void _handleEnter() {
    if (!widget.enabled) return;

    if (widget.hoverDelay == Duration.zero) {
      setState(() => _isHovering = true);
    } else {
      _hoverTimer = Timer(widget.hoverDelay, () {
        if (mounted && widget.enabled) {
          setState(() => _isHovering = true);
        }
      });
    }
  }

  void _handleExit() {
    _hoverTimer?.cancel();
    if (_isHovering) {
      setState(() => _isHovering = false);
    }
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && _isHovering;

    return MouseRegion(
      onEnter: (_) => _handleEnter(),
      onExit: (_) => _handleExit(),
      child: AnimatedScale(
        scale: active ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
