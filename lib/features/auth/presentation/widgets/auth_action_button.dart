import 'package:flutter/material.dart';

class AuthActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final bool isPressed;
  final bool isOutlined;
  final Color color;
  final VoidCallback? onPressed;
  final ValueChanged<bool> onPressState;

  const AuthActionButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.isPressed,
    required this.color,
    required this.onPressState,
    this.isOutlined = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressState(true),
      onTapUp: (_) => onPressState(false),
      onTapCancel: () => onPressState(false),
      onTap: onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: isPressed ? 0.98 : 1,
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
      color: isOutlined ? Colors.transparent : color,
      borderRadius: BorderRadius.circular(radius),
      border: isOutlined ? Border.all(color: color, width: 1.5) : null,
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
    if (isLoading) {
      return _loadingIndicator(context);
    }
    return Text(
      label,
      style: TextStyle(
        color: isOutlined ? color : Colors.white,
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
