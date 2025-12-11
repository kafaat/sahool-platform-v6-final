import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

/// أدوات الرسم للحقول - رسم + قص + قياس مساحة
class DrawingToolsWidget extends StatefulWidget {
  final DrawingMode mode;
  final Function(DrawingMode)? onModeChanged;
  final Function()? onUndo;
  final Function()? onRedo;
  final Function()? onClear;
  final Function()? onComplete;
  final int pointsCount;
  final double? calculatedArea;

  const DrawingToolsWidget({
    super.key,
    this.mode = DrawingMode.none,
    this.onModeChanged,
    this.onUndo,
    this.onRedo,
    this.onClear,
    this.onComplete,
    this.pointsCount = 0,
    this.calculatedArea,
  });

  @override
  State<DrawingToolsWidget> createState() => _DrawingToolsWidgetState();
}

class _DrawingToolsWidgetState extends State<DrawingToolsWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Main Tools Panel
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isExpanded ? 200 : 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Toggle Button
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isExpanded ? AppColors.primarySurface : Colors.transparent,
                    borderRadius: _isExpanded 
                        ? const BorderRadius.vertical(top: Radius.circular(16))
                        : BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.draw,
                        color: _isExpanded ? AppColors.primary : AppColors.textPrimary,
                        size: 24,
                      ),
                      if (_isExpanded) ...[
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'أدوات الرسم',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.expand_less,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              if (_isExpanded) ...[
                const Divider(height: 1),
                
                // Drawing Tools
                _buildToolItem(
                  icon: Icons.polygon_outlined,
                  label: 'رسم حقل',
                  isActive: widget.mode == DrawingMode.polygon,
                  onTap: () => widget.onModeChanged?.call(DrawingMode.polygon),
                ),
                _buildToolItem(
                  icon: Icons.crop_square,
                  label: 'مستطيل',
                  isActive: widget.mode == DrawingMode.rectangle,
                  onTap: () => widget.onModeChanged?.call(DrawingMode.rectangle),
                ),
                _buildToolItem(
                  icon: Icons.circle_outlined,
                  label: 'دائرة',
                  isActive: widget.mode == DrawingMode.circle,
                  onTap: () => widget.onModeChanged?.call(DrawingMode.circle),
                ),
                
                const Divider(height: 1),
                
                // Edit Tools
                _buildToolRow([
                  _buildSmallButton(Icons.undo, widget.onUndo, 'تراجع'),
                  _buildSmallButton(Icons.redo, widget.onRedo, 'إعادة'),
                  _buildSmallButton(Icons.delete_outline, widget.onClear, 'مسح', isDestructive: true),
                ]),
                
                const Divider(height: 1),
                
                // Finish Button
                if (widget.pointsCount >= 3)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: widget.onComplete,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('إنهاء الرسم'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
        
        // Area Display
        if (widget.mode != DrawingMode.none && widget.calculatedArea != null)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.straighten, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      _formatArea(widget.calculatedArea!),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.pointsCount} نقاط',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildToolItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primarySurface : Colors.transparent,
          border: isActive 
              ? Border(right: BorderSide(color: AppColors.primary, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isActive)
              Icon(
                Icons.check,
                color: AppColors.primary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  Widget _buildSmallButton(IconData icon, VoidCallback? onTap, String tooltip, {bool isDestructive = false}) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? AppColors.errorLight : AppColors.neutral100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDestructive ? AppColors.error : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  String _formatArea(double areaInSqMeters) {
    if (areaInSqMeters < 10000) {
      return '${areaInSqMeters.toStringAsFixed(0)} م²';
    } else {
      final hectares = areaInSqMeters / 10000;
      return '${hectares.toStringAsFixed(2)} هكتار';
    }
  }
}

enum DrawingMode {
  none,
  polygon,
  rectangle,
  circle,
}
