class BoundingBox {
  final String label;
  final double confidence;
  final double x;
  final double y;
  final double width;
  final double height;

  BoundingBox({
    required this.label,
    required this.confidence,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory BoundingBox.fromRecognition(Map<String, dynamic> recognition) {
    return BoundingBox(
      label: recognition['detectedClass'] as String,
      confidence: recognition['confidenceInClass'] as double,
      x: recognition['rect']['x'] as double,
      y: recognition['rect']['y'] as double,
      width: recognition['rect']['w'] as double,
      height: recognition['rect']['h'] as double,
    );
  }
}
