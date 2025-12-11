import 'dart:math';
import 'astral_house.dart';
import 'field_astral_recommendation.dart';

/// محرك بسيط للتقويم الزراعي الفلكي
/// يعتمد على اليوم من السنة لتحديد المنزلة (28 منزلة تدور طوال السنة)
class FieldAstralEngine {
  static final List<AstralHouse> _houses = [
    AstralHouse(
      id: 1,
      name: 'الشرطين',
      description: 'بداية موسم مناسب لتهيئة الأرض والزراعة المبكرة في المناطق المعتدلة.',
      seasonTag: 'تهيئة الأرض',
    ),
    AstralHouse(
      id: 2,
      name: 'البطين',
      description: 'جيّد لزراعة الحبوب وسقي الشتلات بحذر.',
      seasonTag: 'زراعة الحبوب',
    ),
    AstralHouse(
      id: 3,
      name: 'الثريا',
      description: 'منزلة خصبة، تناسب التسميد الخفيف والري المنتظم.',
      seasonTag: 'خصب ونماء',
    ),
    AstralHouse(
      id: 4,
      name: 'الدبران',
      description: 'يستحسن فيها متابعة الأمراض الفطرية والحشرية.',
      seasonTag: 'مراقبة الأمراض',
    ),
    AstralHouse(
      id: 5,
      name: 'الهقعة',
      description: 'ملائمة لتقليل الري في الأراضي الثقيلة.',
      seasonTag: 'إدارة الري',
    ),
    AstralHouse(
      id: 6,
      name: 'الهنعة',
      description: 'جيّدة لزراعة الخضروات الورقية والسماد العضوي.',
      seasonTag: 'خضروات وسماد',
    ),
    AstralHouse(
      id: 7,
      name: 'الذراع',
      description: 'ملائمة للتقليم الخفيف ومتابعة نمو الأشجار.',
      seasonTag: 'تقليم خفيف',
    ),
    AstralHouse(
      id: 8,
      name: 'النثرة',
      description: 'يُفضّل فيها مكافحة الحشائش وتنظيم قنوات الري.',
      seasonTag: 'مكافحة الأعشاب',
    ),
    AstralHouse(
      id: 9,
      name: 'الطرفة',
      description: 'ملائمة لزراعة محاصيل العلف كالبرسيم.',
      seasonTag: 'محاصيل علفية',
    ),
    AstralHouse(
      id: 10,
      name: 'الجبهة',
      description: 'مرحلة مناسبة لتسميد الأشجار المثمرة.',
      seasonTag: 'تسميد الأشجار',
    ),
    AstralHouse(
      id: 11,
      name: 'الزبرة',
      description: 'جيّدة لعمليات الحراثة السطحية وتهوية التربة.',
      seasonTag: 'حراثة سطحية',
    ),
    AstralHouse(
      id: 12,
      name: 'الصرفة',
      description: 'بداية تحوّل في المواسم، يجب الانتباه لتغيرات الطقس.',
      seasonTag: 'تحوّل موسمي',
    ),
    AstralHouse(
      id: 13,
      name: 'العواء',
      description: 'تفضّل فيها عمليات ترميم السدود والحواجز الترابية.',
      seasonTag: 'إدارة المياه',
    ),
    AstralHouse(
      id: 14,
      name: 'السماك',
      description: 'ملائمة لزراعة البقوليات ومتابعة رطوبة التربة.',
      seasonTag: 'بقوليات',
    ),
    AstralHouse(
      id: 15,
      name: 'الغفر',
      description: 'مرحلة جيدة للتسميد العضوي ونقل السماد إلى الحقول.',
      seasonTag: 'سماد عضوي',
    ),
    AstralHouse(
      id: 16,
      name: 'الزبانا',
      description: 'ملائمة لزراعة المحاصيل الزيتية كالسمسم.',
      seasonTag: 'محاصيل زيتية',
    ),
    AstralHouse(
      id: 17,
      name: 'الإكليل',
      description: 'وقت مناسب للتطعيم الخفيف للأشجار.',
      seasonTag: 'تطعيم الأشجار',
    ),
    AstralHouse(
      id: 18,
      name: 'القلب',
      description: 'يركّز فيها على مراقبة الإجهاد الحراري للنبات.',
      seasonTag: 'إجهاد حراري',
    ),
    AstralHouse(
      id: 19,
      name: 'الشولة',
      description: 'مرحلة جيّدة لحصاد المحاصيل المبكرة.',
      seasonTag: 'حصاد مبكر',
    ),
    AstralHouse(
      id: 20,
      name: 'النعائم',
      description: 'ملائمة لتجهيز الأرض للموسم القادم.',
      seasonTag: 'تجهيز للموسم القادم',
    ),
    AstralHouse(
      id: 21,
      name: 'البلدة',
      description: 'وقت مناسب لصيانة معدات الري والحراثة.',
      seasonTag: 'صيانة معدات',
    ),
    AstralHouse(
      id: 22,
      name: 'سعد الذابح',
      description: 'جيّدة لتقسيم الحقول وإعداد الخطط للموسم.',
      seasonTag: 'تخطيط زراعي',
    ),
    AstralHouse(
      id: 23,
      name: 'سعد بلع',
      description: 'تركّز على إدارة المخزون وتخزين المحاصيل.',
      seasonTag: 'تخزين المحصول',
    ),
    AstralHouse(
      id: 24,
      name: 'سعد السعود',
      description: 'مرحلة خصبة، جيدة للزراعة في الأودية وسهول تهامة.',
      seasonTag: 'خصب في الأودية',
    ),
    AstralHouse(
      id: 25,
      name: 'سعد الأخبية',
      description: 'ملائمة لحفر الآبار وتجهيز خزانات المياه.',
      seasonTag: 'آبار ومياه',
    ),
    AstralHouse(
      id: 26,
      name: 'المقدم',
      description: 'ينصح فيها بمراقبة الآفات والحشرات قبل تكاثرها.',
      seasonTag: 'مراقبة الآفات',
    ),
    AstralHouse(
      id: 27,
      name: 'المؤخر',
      description: 'مرحلة مراجعة عامة لحالة الحقول وإغلاق الموسم.',
      seasonTag: 'إغلاق موسم',
    ),
    AstralHouse(
      id: 28,
      name: 'الرشا',
      description: 'بداية دورة جديدة، مناسبة للتخطيط للموسم التالي.',
      seasonTag: 'بداية دورة جديدة',
    ),
  ];

  /// يحسب اليوم من السنة ويحوّله إلى منزلة (تقريب مناسب للاستخدام الزراعي العام)
  static AstralHouse currentHouse([DateTime? now]) {
    final DateTime date = now ?? DateTime.now().toUtc();
    final startOfYear = DateTime.utc(date.year, 1, 1);
    final dayOfYear = date.difference(startOfYear).inDays + 1;
    final index = (dayOfYear - 1) % _houses.length;
    return _houses[index];
  }

  /// يبني توصيات كاملة لحقل محدد
  static FieldAstralRecommendation analyzeField({
    required String cropType,
    required double ndvi,
  }) {
    final house = currentHouse();

    // نص فلكي مختصر من وصف المنزلة
    final astralAdvice = 'اليوم منزلة ${house.name}: ${house.description}';

    // تحليل بسيط حسب NDVI
    String ndviAdvice;
    if (ndvi < 0.35) {
      ndviAdvice = 'مؤشر الحيوية منخفض — يفضّل مراجعة الري والتسميد وتحسين تهوية التربة.';
    } else if (ndvi < 0.55) {
      ndviAdvice = 'مؤشر الحيوية متوسط — راقب الإجهاد المائي ووازن بين الري والتسميد.';
    } else {
      ndviAdvice = 'مؤشر الحيوية جيد — استمر على برنامج الري والتسميد الحالي مع المراقبة الدورية.';
    }

    // توصيات مبنية على نوع المحصول (بشكل مبسّط)
    final String cropLower = cropType.toLowerCase();
    String cropAdvice;
    if (cropLower.contains('قمح')) {
      cropAdvice = 'للـقمح في هذه الفترة يفضّل الري المنتظم مع عدم إغراق التربة، '
          'ومتابعة ظهور أي اصفرار غير طبيعي في الأوراق.';
    } else if (cropLower.contains('ذرة')) {
      cropAdvice = 'الذرة تحتاج رطوبة مناسبة في مرحلة النمو الخضري، '
          'مع جرعة نيتروجين كافية حسب نتائج تحليل التربة.';
    } else if (cropLower.contains('سمسم')) {
      cropAdvice = 'السمسم حساس للرطوبة الزائدة — تجنّب الري الثقيل وتأكد من صرف المياه جيداً.';
    } else if (cropLower.contains('برسيم') || cropLower.contains('alfalfa')) {
      cropAdvice = 'للبـرسيم يُنصح بالقص عند طول مناسب ثم ري خفيف لتحفيز نمو جديد.';
    } else {
    } else {
      cropAdvice = 'استمر في متابعة هذا المحصول وفقاً للتقويم الزراعي المحلي وحالة الطقس والتربة في حقلك.';
    }

    return FieldAstralRecommendation(
      house: house,
      astralAdvice: astralAdvice,
      ndviAdvice: ndviAdvice,
      cropAdvice: cropAdvice,
    );
  }
}
