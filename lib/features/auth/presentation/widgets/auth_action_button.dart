import 'package:flutter/material.dart';

class AuthActionButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final bool isOutlined;
  final Color color;
  final VoidCallback? onPressed;

  const AuthActionButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.color,
    this.isOutlined = false,
    this.onPressed,
  });

  @override
  State<AuthActionButton> createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _isPressed ? 0.98 : 1,
        child: _buildContainer(context),
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final padding = height * 0.02;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(vertical: padding),
      decoration: _buildDecoration(context),
      child: Center(child: _buildChild(context)),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    final radius = MediaQuery.of(context).size.width * 0.035;
    return BoxDecoration(
      color: widget.isOutlined ? Colors.transparent : widget.color,
      borderRadius: BorderRadius.circular(radius),
      border: widget.isOutlined
          ? Border.all(color: widget.color, width: 1.5)
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildChild(BuildContext context) {
    if (widget.isLoading) {
      return _loadingIndicator(context);
    }
    return Text(
      widget.label,
      style: TextStyle(
        color: widget.isOutlined ? widget.color : Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _loadingIndicator(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.05;
    return SizedBox(
      height: size,
      width: size,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
