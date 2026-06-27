enum BiometricSource { smartwatch, welltionDevice }

enum BiometricPhase { before, after }

enum ReadinessLevel { low, medium, high }

class BiometricMetrics {
  final double readinessScore;
  final ReadinessLevel readinessLevel;
  final double heartRate;
  final double hrv;
  final String sleepFuelRating;
  final double sleepFuelHrvDelta;
  final double sleepFuelBpmDelta;
  final String priorDayStress;
  final double priorDayStressHrv;
  final double sleepBankPercent;
  final String sleepBankBalance;
  final double spo2Avg;
  final String spo2Range;
  final double respirationRateAvg;
  final String respirationRange;

  const BiometricMetrics({
    required this.readinessScore,
    required this.readinessLevel,
    required this.heartRate,
    required this.hrv,
    required this.sleepFuelRating,
    required this.sleepFuelHrvDelta,
    required this.sleepFuelBpmDelta,
    required this.priorDayStress,
    required this.priorDayStressHrv,
    required this.sleepBankPercent,
    required this.sleepBankBalance,
    required this.spo2Avg,
    required this.spo2Range,
    required this.respirationRateAvg,
    required this.respirationRange,
  });
}

class BiometricSessionModel {
  final String id;
  final String userId;
  final String? deviceId;
  final BiometricSource source;
  final DateTime recordedAt;
  final BiometricPhase phase;
  final BiometricMetrics metrics;

  const BiometricSessionModel({
    required this.id,
    required this.userId,
    this.deviceId,
    required this.source,
    required this.recordedAt,
    required this.phase,
    required this.metrics,
  });
}
