enum ProtocolStatus { active, completed, pending }

extension ProtocolStatusLabel on ProtocolStatus {
  String get label => switch (this) {
        ProtocolStatus.active => 'Ativo',
        ProtocolStatus.completed => 'Concluído',
        ProtocolStatus.pending => 'Pendente',
      };
}

/// Representa uma próxima ação agendada do protocolo
class NextAction {
  final String label;    
  final String farmName;
  final String time;

  const NextAction({
    required this.label,
    required this.farmName,
    required this.time,
  });
}

/// Entidade de negócio: um protocolo IATF em andamento ou concluído
class ProtocolModel {
  final String id;
  final String farmName;
  final String lot;
  final String protocolName;
  final String currentPhase;
  final double progress;
  final String? imagePath;
  final ProtocolStatus status;

  const ProtocolModel({
    required this.id,
    required this.farmName,
    required this.lot,
    required this.protocolName,
    required this.currentPhase,
    required this.progress,
    required this.status,
    this.imagePath,
  });
}