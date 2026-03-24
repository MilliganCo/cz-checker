import 'package:json_annotation/json_annotation.dart';

part 'check_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CheckResponse {
  final String status;

  CheckResponse({required this.status});

  /// true, если код находится в обороте
  bool get isInCirculation =>
      status.toLowerCase() == 'in_circulation';
  bool get isError => status.toUpperCase().startsWith('ERROR');

  factory CheckResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckResponseToJson(this);
} 