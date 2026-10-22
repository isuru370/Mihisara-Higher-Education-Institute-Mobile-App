/// Settings that differ per institute. Override at build time, e.g.
///   flutter build apk --dart-define=INSTITUTE_NAME="Mihisara Higher Education Institute"
class AppConfig {
  AppConfig._();

  /// Printed on payment and admission receipts and PDFs.
  static const String instituteName = String.fromEnvironment(
    'INSTITUTE_NAME',
    defaultValue: 'Mihisara Higher Education Institute',
  );
}
