class TestObservation {
  final String parameter;
  final double? observedValue;
  final double? requiredValue;
  final String remarks;

  TestObservation({
    required this.parameter,
    this.observedValue,
    this.requiredValue,
    required this.remarks,
  });
}