import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/child_model.dart';
import '../../services/app_state.dart';
import '../../widgets/child_selector_overlay.dart';

class GrowthMonitoringScreen extends StatefulWidget {
  const GrowthMonitoringScreen({super.key});

  @override
  State<GrowthMonitoringScreen> createState() => _GrowthMonitoringScreenState();
}

class _GrowthMonitoringScreenState extends State<GrowthMonitoringScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submitGrowth(AppState appState) async {
    if (_formKey.currentState!.validate()) {
      final h = double.parse(_heightController.text);
      final w = double.parse(_weightController.text);
      
      await appState.addGrowthRecord(appState.selectedChildId!, h, w);
      
      _heightController.clear();
      _weightController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Matagumpay na naitala ang sukat ng paglaki!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final activeChild = appState.selectedChild;

    return ChildSelectorOverlay(
      child: activeChild == null
          ? const SizedBox()
          : Scaffold(
              appBar: AppBar(
          title: const Text('Pagsubaybay sa Paglaki'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Entry form for new measurements
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'I-record ang bagong Sukat',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _heightController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Taas (Height in cm)',
                                  prefixIcon: Icon(Icons.height_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Kailangan ang taas';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Maling numero';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _weightController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Timbang (Weight in kg)',
                                  prefixIcon: Icon(Icons.scale_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Kailangan ang timbang';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Maling numero';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _submitGrowth(appState),
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('I-save ang Sukat'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Growth Chart
              if (activeChild.growthHistory.isNotEmpty) ...[
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tsart ng Timbang (Growth Curve)',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Makikita rito ang pagbabago sa timbang ng bata.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: GrowthChartPainter(
                              records: activeChild.growthHistory,
                              lineColor: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // History List
              Text(
                'Kasaysayan ng mga Sukat',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              activeChild.growthHistory.isEmpty
                  ? const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'Wala pang nai-record na sukat para sa batang ito.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activeChild.growthHistory.length,
                      itemBuilder: (context, index) {
                        final rec = activeChild.growthHistory[index];
                        final formattedDate = '${rec.date.day}/${rec.date.month}/${rec.date.year}';

                        // Calculate age at record time
                        final ageDiff = rec.date.difference(activeChild.birthDate);
                        final ageInYears = ageDiff.inDays / 365.0;
                        final totalMonths = (ageDiff.inDays / 30.4375).floor();
                        final years = totalMonths ~/ 12;
                        final months = totalMonths % 12;

                        String ageAtRecord = '';
                        if (years > 0) {
                          ageAtRecord = '$years taon at $months buwan';
                        } else {
                          ageAtRecord = '$months buwan';
                        }

                        final bmiInterpretation = rec.getBmiInterpretation(ageInYears);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primaryContainer.withAlpha(51),
                              child: Icon(
                                Icons.calendar_month_outlined,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            title: Text('Taas: ${rec.height} cm | Timbang: ${rec.weight} kg'),
                            subtitle: Text('Edad: $ageAtRecord | Petsa: $formattedDate\nBMI: ${rec.bmi.toStringAsFixed(1)} ($bmiInterpretation)'),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Growth Line Chart
class GrowthChartPainter extends CustomPainter {
  final List<GrowthRecord> records;
  final Color lineColor;

  GrowthChartPainter({required this.records, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (records.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw horizontal grid lines
    const gridLinesCount = 4;
    final gridSpacing = size.height / gridLinesCount;
    for (var i = 0; i <= gridLinesCount; i++) {
      final y = i * gridSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Min and Max Weight
    double minW = records.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    double maxW = records.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
    
    // Safety check for single record
    if (minW == maxW) {
      minW = minW - 5 < 0 ? 0 : minW - 5;
      maxW = maxW + 5;
    }

    final dx = records.length > 1 ? size.width / (records.length - 1) : size.width;

    final points = <Offset>[];
    for (var i = 0; i < records.length; i++) {
      final w = records[i].weight;
      final x = records.length > 1 ? i * dx : size.width / 2;
      
      // Map weight to Y coordinate
      final y = size.height - ((w - minW) / (maxW - minW)) * (size.height - 20) - 10;
      points.add(Offset(x, y));
    }

    // Draw lines between points
    if (records.length > 1) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    // Draw dots and text
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      canvas.drawCircle(p, 5.0, dotPaint);

      // Draw value text above dot
      textPainter.text = TextSpan(
        text: '${records[i].weight}kg',
        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(p.dx - 12, p.dy - 18));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
