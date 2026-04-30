import 'package:equatable/equatable.dart';

class ApkData extends Equatable {
  const ApkData({
    required this.url,
    required this.version,
    required this.size,
    required this.date,
  });

  final String url;
  final String version;
  final String size;
  final String date;

  @override
  List<Object?> get props => [url, version, size, date];
}
