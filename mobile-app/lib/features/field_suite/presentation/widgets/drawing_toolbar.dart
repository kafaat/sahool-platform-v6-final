import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/field_suite_bloc.dart';
import '../bloc/field_suite_event.dart';
import '../bloc/field_suite_state.dart';

class DrawingToolbar extends StatelessWidget {
  const DrawingToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldSuiteBloc, FieldSuiteState>(
      builder: (context, state) {
        final bloc = context.read<FieldSuiteBloc>();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _btn(
                icon: Icons.timeline,
                label: 'نقاط',
                selected: !state.freeDrawMode,
                onTap: () => bloc.add(const FieldSuiteToggleFreeDraw()),
              ),
              const SizedBox(width: 6),
              _btn(
                icon: Icons.gesture,
                label: 'حر',
                selected: state.freeDrawMode,
                onTap: () => bloc.add(const FieldSuiteToggleFreeDraw()),
              ),
              const SizedBox(width: 6),
              _btn(
                icon: Icons.undo,
                label: 'تراجع',
                onTap: () => bloc.add(FieldSuiteUndo()),
              ),
              const SizedBox(width: 6),
              _btn(
                icon: Icons.redo,
                label: 'إعادة',
                onTap: () => bloc.add(FieldSuiteRedo()),
              ),
              const SizedBox(width: 6),
              _btn(
                icon: Icons.satellite_alt,
                label: 'NDVI',
                selected: state.showNdvi,
                onTap: () => bloc.add(FieldSuiteToggleNdvi()),
              ),
              const SizedBox(width: 6),
              _btn(
                icon: Icons.layers,
                label: 'Zones',
                selected: state.showZones,
                onTap: () => bloc.add(FieldSuiteToggleZones()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _btn({
    required IconData icon,
    required String label,
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.greenAccent : Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.greenAccent : Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
