import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/irrigation_bloc.dart';
import '../bloc/irrigation_event.dart';

class IrrigationAddPage extends StatefulWidget {
  final String fieldId;
  const IrrigationAddPage({super.key, required this.fieldId});

  @override
  State<IrrigationAddPage> createState() => _IrrigationAddPageState();
}

class _IrrigationAddPageState extends State<IrrigationAddPage> {
  final zoneCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  DateTime? startAt;

  @override
  void dispose() {
    zoneCtrl.dispose();
    durationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة دورة ري')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: zoneCtrl,
              decoration: const InputDecoration(labelText: 'رقم المنطقة'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationCtrl,
              decoration: const InputDecoration(labelText: 'المدة بالدقائق'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    startAt == null
                        ? 'وقت البدء: لم يُحدد'
                        : 'وقت البدء: ${startAt!.toLocal()}',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final date = await showDatePicker(
                      context: context,
                      firstDate: now.subtract(const Duration(days: 1)),
                      lastDate: now.add(const Duration(days: 365)),
                      initialDate: now,
                    );
                    if (date == null) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 12, minute: 0),
                    );
                    if (time == null) return;

                    setState(() {
                      startAt = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      ).toUtc();
                    });
                  },
                  child: const Text('اختيار وقت البدء'),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('حفظ'),
                onPressed: () {
                  final zone = int.tryParse(zoneCtrl.text) ?? 0;
                  final duration = int.tryParse(durationCtrl.text) ?? 0;
                  final body = {
                    'zone': zone,
                    'duration_minutes': duration,
                    'start':
                        (startAt ?? DateTime.now().toUtc()).toIso8601String(),
                  };
                  context
                      .read<IrrigationBloc>()
                      .add(AddCycle(fieldId: widget.fieldId, body: body));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
