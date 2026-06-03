enum FarmStatus { upToDate, pendingAction, inactive }

extension FarmStatusInfo on FarmStatus {
  String get label => switch (this) {
        FarmStatus.upToDate     => 'Em Dia',
        FarmStatus.pendingAction => 'Ação Pendente',
        FarmStatus.inactive     => 'Inativo',
      };
}

class FarmModel {
  final String id;
  final String name;
  final String city;
  final String state;
  final int activeLotes;
  final FarmStatus status;
  final String? imagePath;

  const FarmModel({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.activeLotes,
    required this.status,
    this.imagePath,
  });
}