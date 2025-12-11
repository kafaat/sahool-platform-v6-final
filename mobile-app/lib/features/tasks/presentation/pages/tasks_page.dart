import 'package:flutter/material.dart';
import '../../../../presentation/theme/app_colors.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('المهام'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterSheet),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'قيد الانتظار'),
            Tab(text: 'قيد التنفيذ'),
            Tab(text: 'مكتملة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTasksList(),
          _buildTasksList(status: 'pending'),
          _buildTasksList(status: 'in_progress'),
          _buildTasksList(status: 'completed'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('مهمة جديدة', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تصفية حسب',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildFilterChip('الكل', 'all'),
          _buildFilterChip('ري', 'irrigation'),
          _buildFilterChip('تسميد', 'fertilization'),
          _buildFilterChip('فحص', 'inspection'),
          _buildFilterChip('حصاد', 'harvesting'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = value);
          Navigator.pop(context);
        },
        selectedColor: AppColors.primarySurface,
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildTasksList({String? status}) {
    final tasks = [
      _TaskData('ري حقل القمح الشمالي', 'ري', 'عاجل', 'pending', 'اليوم 6:00 ص', 'حقل القمح'),
      _TaskData('فحص حقل البرسيم', 'فحص', 'عالي', 'pending', 'غداً 8:00 ص', 'حقل البرسيم'),
      _TaskData('تسميد حقل الذرة', 'تسميد', 'متوسط', 'in_progress', 'بعد غد', 'حقل الذرة'),
      _TaskData('حصاد حقل الشعير', 'حصاد', 'عالي', 'pending', 'الأسبوع القادم', 'حقل الشعير'),
      _TaskData('صيانة نظام الري', 'صيانة', 'منخفض', 'completed', 'أمس', 'جميع الحقول'),
    ];

    final filteredTasks = status != null
        ? tasks.where((t) => t.status == status).toList()
        : tasks;

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: AppColors.neutral300),
            const SizedBox(height: 16),
            const Text('لا توجد مهام', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) => _buildTaskCard(filteredTasks[index]),
    );
  }

  Widget _buildTaskCard(_TaskData task) {
    final priorityColor = _getPriorityColor(task.priority);
    final statusColor = _getStatusColor(task.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_getTypeIcon(task.type), color: priorityColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.field,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (task.status != 'completed')
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                      activeColor: AppColors.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    task.dueDate,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.priority,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: priorityColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusLabel(task.status),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عاجل': return AppColors.error;
      case 'عالي': return AppColors.warning;
      case 'متوسط': return AppColors.info;
      default: return AppColors.success;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return AppColors.success;
      case 'in_progress': return AppColors.info;
      default: return AppColors.warning;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed': return 'مكتمل';
      case 'in_progress': return 'قيد التنفيذ';
      default: return 'قيد الانتظار';
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'ري': return Icons.water_drop;
      case 'تسميد': return Icons.eco;
      case 'فحص': return Icons.search;
      case 'حصاد': return Icons.agriculture;
      default: return Icons.build;
    }
  }
}

class _TaskData {
  final String title;
  final String type;
  final String priority;
  final String status;
  final String dueDate;
  final String field;

  _TaskData(this.title, this.type, this.priority, this.status, this.dueDate, this.field);
}
