import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../core/di/injection.dart';
import '../../field_suite/domain/repositories/field_suite_repository.dart';
import '../bloc/field_suite_bloc.dart';
import '../bloc/field_suite_event.dart';
import '../bloc/field_suite_state.dart';
import '../widgets/drawing_toolbar.dart';
import '../widgets/measurement_overlay.dart';

class FieldSuitePage extends StatefulWidget {
  final String fieldId;
  final String fieldName;

  const FieldSuitePage({
    super.key,
    required this.fieldId,
    required this.fieldName,
  });

  @override
  State<FieldSuitePage> createState() => _FieldSuitePageState();
}

class _FieldSuitePageState extends State<FieldSuitePage> {
  MaplibreMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FieldSuiteBloc(
        repo: sl<FieldSuiteRepository>(),
        fieldId: widget.fieldId,
        fieldName: widget.fieldName,
      )..add(FieldSuiteInit(widget.fieldId)),
      child: BlocListener<FieldSuiteBloc, FieldSuiteState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          if (state.infoMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.infoMessage!)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Field Suite – ${widget.fieldName}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  context.read<FieldSuiteBloc>().add(FieldSuiteSave());
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<FieldSuiteBloc>().add(FieldSuiteDelete());
                  context.pop();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              _buildMap(),
              const Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Center(child: DrawingToolbar()),
              ),
              BlocBuilder<FieldSuiteBloc, FieldSuiteState>(
                builder: (context, state) {
                  return MeasurementOverlay(points: state.points);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return BlocBuilder<FieldSuiteBloc, FieldSuiteState>(
      builder: (context, state) {
        return MaplibreMap(
          styleString:
              'https://demotiles.maplibre.org/style.json', // يمكن استبداله لاحقاً
          onMapCreated: (controller) async {
            _mapController = controller;
            // يمكن لاحقاً إضافة مصادر NDVI / Zones هنا
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(15.3694, 44.1910), // اليمن كنقطة افتراضية
            zoom: 10,
          ),
          onMapClick: (point, latLng) {
            final bloc = context.read<FieldSuiteBloc>();
            if (bloc.state.freeDrawMode) {
              bloc.add(FieldSuiteFreeDrawAdd(latLng));
            } else {
              bloc.add(FieldSuiteAddPoint(latLng));
            }
          },
        );
      },
    );
  }
}
