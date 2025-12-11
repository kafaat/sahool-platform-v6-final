import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Header with current weather
          SliverToBoxAdapter(
            child: _buildWeatherHeader(),
          ),
          
          // Hourly forecast
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildHourlyForecast(),
            ),
          ),
          
          // 7-day forecast
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildWeeklyForecast(),
            ),
          ),
          
          // Weather details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildWeatherDetails(),
            ),
          ),
          
          // Agricultural insights
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildAgriculturalInsights(),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'الرياض، السعودية',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الثلاثاء، 9 ديسمبر',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wb_sunny, color: Colors.amber, size: 100),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '28',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'مشمس جزئياً',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الشعور: 30°',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherStat(Icons.water_drop, '45%', 'رطوبة'),
              _buildWeatherStat(Icons.air, '12 كم/س', 'رياح'),
              _buildWeatherStat(Icons.umbrella, '0%', 'أمطار'),
              _buildWeatherStat(Icons.wb_sunny_outlined, 'UV 6', 'أشعة'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التوقعات بالساعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildHourItem('الآن', Icons.wb_sunny, '28°', true),
              _buildHourItem('1 م', Icons.wb_sunny, '29°', false),
              _buildHourItem('2 م', Icons.cloud, '28°', false),
              _buildHourItem('3 م', Icons.cloud, '27°', false),
              _buildHourItem('4 م', Icons.wb_sunny, '26°', false),
              _buildHourItem('5 م', Icons.nights_stay, '24°', false),
              _buildHourItem('6 م', Icons.nights_stay, '22°', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHourItem(String time, IconData icon, String temp, bool isNow) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isNow ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isNow ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          Icon(
            icon,
            color: isNow ? Colors.white : (icon == Icons.wb_sunny ? Colors.amber : AppColors.neutral500),
            size: 28,
          ),
          Text(
            temp,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isNow ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyForecast() {
    final days = [
      ('الأربعاء', Icons.wb_sunny, 30, 22),
      ('الخميس', Icons.cloud, 28, 20),
      ('الجمعة', Icons.wb_cloudy, 26, 18),
      ('السبت', Icons.wb_sunny, 29, 21),
      ('الأحد', Icons.wb_sunny, 31, 23),
      ('الاثنين', Icons.cloud, 27, 19),
      ('الثلاثاء', Icons.wb_sunny, 28, 20),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'توقعات 7 أيام',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...days.map((day) => _buildDayItem(day.$1, day.$2, day.$3, day.$4)),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day, IconData icon, int high, int low) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Icon(
            icon,
            color: icon == Icons.wb_sunny ? Colors.amber : AppColors.neutral500,
            size: 24,
          ),
          const Spacer(),
          Text(
            '$low°',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Container(
            width: 80,
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.orange.shade300],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            '$high°',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Row(
      children: [
        Expanded(child: _buildDetailCard('الضغط الجوي', '1013 hPa', Icons.speed)),
        const SizedBox(width: 12),
        Expanded(child: _buildDetailCard('الرؤية', '10 كم', Icons.visibility)),
      ],
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildAgriculturalInsights() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.agriculture, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'توصيات زراعية',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightRow(Icons.check_circle, AppColors.success, 'الطقس مناسب للري في الصباح الباكر'),
          _buildInsightRow(Icons.warning_amber, AppColors.warning, 'تجنب الرش خلال ساعات الظهيرة'),
          _buildInsightRow(Icons.info_outline, AppColors.info, 'ظروف مثالية لزراعة المحاصيل الشتوية'),
        ],
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
