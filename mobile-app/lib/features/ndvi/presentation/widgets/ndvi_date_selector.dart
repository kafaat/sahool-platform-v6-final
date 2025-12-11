import 'package:flutter/material.dart';

import '../../../../domain/entities/ndvi_scene_entity.dart';

typedef NdviSceneTapCallback = void Function(NdviSceneEntity scene);

class NdviDateSelector extends StatelessWidget {
  final List<NdviSceneEntity> scenes;
  final NdviSceneEntity? selected;
  final NdviSceneTapCallback onTap;

  const NdviDateSelector({
    super.key,
    required this.scenes,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (scenes.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final scene = scenes[index];
          final isSelected = selected?.id == scene.id;
          return ChoiceChip(
            label: Text(_formatDate(scene.date)),
            selected: isSelected,
            onSelected: (_) => onTap(scene),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: scenes.length,
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return '$d/$m';
  }
}
