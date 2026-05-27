import 'package:flutter/foundation.dart';
import '../../domain/models/protocol_model.dart';

/// Filtros disponíveis na home
enum ProtocolFilter { all, active, completed, pending }

extension ProtocolFilterLabel on ProtocolFilter {
  String get label => switch (this) {
    ProtocolFilter.all => 'Todos',
    ProtocolFilter.active => 'Ativos',
    ProtocolFilter.completed => 'Concluídos',
    ProtocolFilter.pending => 'Pendentes',
  };
}

class HomeState {
  final List<ProtocolModel> protocols;
  final ProtocolFilter selectedFilter;
  final NextAction? nextAction;
  final bool isLoading;
  final String userName;

  const HomeState({
    this.protocols = const [],
    this.selectedFilter = ProtocolFilter.all,
    this.nextAction,
    this.isLoading = false,
    this.userName = '',
  });

  /// Protocolos filtrados conforme seleção do chip
  List<ProtocolModel> get filteredProtocols {
    if (selectedFilter == ProtocolFilter.all) return protocols;
    return protocols
        .where(
          (p) => switch (selectedFilter) {
            ProtocolFilter.active => p.status == ProtocolStatus.active,
            ProtocolFilter.completed => p.status == ProtocolStatus.completed,
            ProtocolFilter.pending => p.status == ProtocolStatus.pending,
            ProtocolFilter.all => true,
          },
        )
        .toList();
  }
  
  List<ProtocolModel> get activeProtocols =>
    protocols.where((p) => p.status == ProtocolStatus.active).toList();

  HomeState copyWith({
    List<ProtocolModel>? protocols,
    ProtocolFilter? selectedFilter,
    NextAction? nextAction,
    bool? isLoading,
    String? userName,
  }) {
    return HomeState(
      protocols: protocols ?? this.protocols,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      nextAction: nextAction ?? this.nextAction,
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
    );
  }
}

class HomeViewModel extends ChangeNotifier {
  HomeState _state = const HomeState();

  HomeState get state => _state;

  HomeViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    // TODO: substituir por chamadas reais ao repositório
    await Future.delayed(const Duration(milliseconds: 800));

    _state = _state.copyWith(
      isLoading: false,
      userName: 'Dr. João',
      nextAction: const NextAction(
        label: 'Inseminação',
        farmName: 'Fazenda Boa Vista',
        time: '14:00',
      ),
      protocols: _mockProtocols(),
    );

    notifyListeners();
  }

  void onFilterChanged(ProtocolFilter filter) {
    _state = _state.copyWith(selectedFilter: filter);
    notifyListeners();
  }

  Future<void> onRefresh() async => _loadData();

  void onStartProcedurePressed() {
    // TODO: navegar para tela de procedimento
  }

  void onSeeAllPressed() {
    // TODO: navegar para lista completa de protocolos
  }

  void onProtocolTapped(String protocolId) {
    // TODO: navegar para detalhe do protocolo
  }

  List<ProtocolModel> _mockProtocols() {
    final farms = [
      (
        'Fazenda Boa Vista',
        'Lote A2',
        'Sincrodiol 2,0 mL',
        'D0',
        0.0,
        ProtocolStatus.active,
      ),
      (
        'Fazenda Serra Verde',
        'Lote B1',
        'Crestar + BE',
        'D7',
        0.45,
        ProtocolStatus.active,
      ),
      (
        'Agropecuária Silva',
        'Lote C3',
        'OvSynch',
        'D11',
        0.78,
        ProtocolStatus.active,
      ),
      (
        'Fazenda Santa Cruz',
        'Lote D5',
        'Sincrodiol 2,0 mL',
        'D14',
        1.0,
        ProtocolStatus.completed,
      )
    ];

    return List.generate(farms.length, (i) {
        final (farmName, lot, protocol, phase, progress, status) = farms[i];
        final index = (i + 1).toString().padLeft(3, '0');

        return ProtocolModel(
          id: '${i + 1}',
          farmName: farmName,
          lot: lot,
          protocolName: protocol,
          currentPhase: phase,
          progress: progress,
          status: status,
          imagePath: 'lib/assets/images/catle$index.jpg',
        );
      });
    }
}
