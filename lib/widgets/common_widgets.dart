import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    required this.color,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: AppDecorations.glassContainer(
        color: color,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class GlassIconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double borderRadius;
  final double iconSize;

  const GlassIconContainer({
    super.key,
    required this.icon,
    required this.color,
    this.size = 50,
    this.borderRadius = 15,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: AppDecorations.iconContainer(
        color: color,
        borderRadius: borderRadius,
        size: size,
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }
}

class AnimatedMenuCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final Duration delay;

  const AnimatedMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.elastic,
    ));

    // Start animation with delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value * (_isPressed ? 0.95 : 1.0),
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: GlassContainer(
              color: widget.color,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 50,
                    color: widget.color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightBeige.withOpacity(0.7),
                          height: 1.3,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient? gradient;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          (gradient ?? AppGradients.primaryGradient).createShader(bounds),
      child: Text(
        text,
        style: (style ?? const TextStyle()).copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;

  const LoadingIndicator({
    super.key,
    this.color,
    this.width = 50,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary.withOpacity(0.8),
        ),
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: AppAnimations.normal,
          width: currentPage == index ? 30 : 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: currentPage == index
                ? (activeColor ?? AppColors.primary)
                : (inactiveColor ?? AppColors.lightBeige.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.isFullWidth = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget button = Transform.scale(
          scale: 1.0 - (_controller.value * 0.05),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor ?? AppColors.primary,
              foregroundColor: widget.textColor ?? AppColors.onPrimary,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              minimumSize: widget.isFullWidth 
                  ? const Size(double.infinity, 50)
                  : null,
            ),
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

        return widget.isFullWidth 
            ? SizedBox(width: double.infinity, child: button) 
            : button;
      },
    );
  }
}