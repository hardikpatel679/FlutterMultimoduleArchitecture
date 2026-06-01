class DimensionModel {
  final double width;
  final double height;
  final double depth;

  DimensionModel({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory DimensionModel.fromJson(Map<String, dynamic> json) {
    return DimensionModel(
      width: double.tryParse(json['width']?.toString() ?? '0') ?? 0.0,
      height: double.tryParse(json['height']?.toString() ?? '0') ?? 0.0,
      depth: double.tryParse(json['depth']?.toString() ?? '0') ?? 0.0,
    );
  }
}