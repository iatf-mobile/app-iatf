/// Representa um protocolo IATF disponível
class ProtocolTemplateModel {
  final String id;
  final String name;
  final String description;
  final int? durationDays;       
  final List<String> baseDrugs;
  final int usageCount;
  final DateTime createdAt;

  const ProtocolTemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.baseDrugs,
    required this.usageCount,
    required this.createdAt,
    this.durationDays,
  });
}

/// Ordenação disponível na tela de protocolos
enum ProtocolSort { mostUsed, alphabetical, recent }

extension ProtocolSortLabel on ProtocolSort {
  String get label => switch (this) {
        ProtocolSort.mostUsed     => 'Mais Usados',
        ProtocolSort.alphabetical => 'A-Z',
        ProtocolSort.recent       => 'Recentes',
      };
}