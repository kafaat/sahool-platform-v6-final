import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../presentation/theme/app_colors.dart';

/// مناطق الإدارة الذكية - K-Means Clustering مثل Trimble
class ManagementZonesWidget extends StatefulWidget {
  final List<ManagementZone> zones;
  final Function(ManagementZone)? onZoneSelected;

  const ManagementZonesWidget({
    super.key,
    required this.zones,
    this.onZoneSelected,
  });

  @override
  State<ManagementZonesWidget> createState() => _ManagementZonesWidgetState();
}

class _ManagementZonesWidgetState extends State<ManagementZonesWidget> {
  int? _selectedZoneIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.grid_view, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مناطق الإدارة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'تحليل K-Means للحقل',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.zones.length} مناطق',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Zones Distribution Chart
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 180,
              child: Row(
                children: [
                  // Pie Chart
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: widget.zones.asMap().entries.map((entry) {
                          final index = entry.key;
                          final zone = entry.value;
                          final isSelected = _selectedZoneIndex == index;
                          
                          return PieChartSectionData(
                            value: zone.areaPercent,
                            title: '${zone.areaPercent.round()}%',
                            titleStyle: TextStyle(
                              fontSize: isSelected ? 14 : 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            color: zone.color,
                            radius: isSelected ? 55 : 45,
                            badgeWidget: isSelected ? _buildBadge(zone) : null,
                            badgePositionPercentageOffset: 1.2,
                          );
                        }).toList(),
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            if (response?.touchedSection != null) {
                              setState(() {
                                _selectedZoneIndex = response!.touchedSection!.touchedSectionIndex;
                              });
                              if (_selectedZoneIndex != null && _selectedZoneIndex! < widget.zones.length) {
                                widget.onZoneSelected?.call(widget.zones[_selectedZoneIndex!]);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Legend
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.zones.asMap().entries.map((entry) {
                        final index = entry.key;
                        final zone = entry.value;
                        final isSelected = _selectedZoneIndex == index;
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedZoneIndex = index);
                            widget.onZoneSelected?.call(zone);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? zone.color.withOpacity(0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected ? Border.all(color: zone.color, width: 1.5) : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: zone.color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        zone.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        '${zone.areaHectares.toStringAsFixed(1)} هكتار',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${zone.areaPercent.round()}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: zone.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Divider(height: 1),
          
          // Zone Details
          if (_selectedZoneIndex != null && _selectedZoneIndex! < widget.zones.length)
            _buildZoneDetails(widget.zones[_selectedZoneIndex!]),
          
          // Recommendations
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'التوصيات',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRecommendationCard(
                  icon: Icons.water_drop,
                  title: 'الري المتغير',
                  description: 'تطبيق معدلات ري مختلفة حسب المنطقة',
                  color: AppColors.info,
                ),
                const SizedBox(height: 8),
                _buildRecommendationCard(
                  icon: Icons.eco,
                  title: 'التسميد الموضعي',
                  description: 'زيادة السماد في المناطق الضعيفة بنسبة 20%',
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(ManagementZone zone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text(
        zone.name,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: zone.color,
        ),
      ),
    );
  }

  Widget _buildZoneDetails(ManagementZone zone) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: zone.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: zone.color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: zone.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.landscape, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      zone.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem('المساحة', '${zone.areaHectares.toStringAsFixed(1)} هكتار'),
              _buildStatItem('NDVI', zone.ndviRange),
              _buildStatItem('الإنتاجية', zone.productivityLevel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ManagementZone {
  final String id;
  final String name;
  final String description;
  final Color color;
  final double areaPercent;
  final double areaHectares;
  final String ndviRange;
  final String productivityLevel;
  final List<List<double>>? polygon;

  const ManagementZone({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.areaPercent,
    required this.areaHectares,
    required this.ndviRange,
    required this.productivityLevel,
    this.polygon,
  });
}
