import 'package:flutter/foundation.dart';

import '../../domain/models/protocol_template_model.dart';

class ProtocolsState {
  final List<ProtocolTemplateModel> protocols;
  final ProtocolSort selectedSort;
  final String searchQuery;
  final bool isLoading;

  const ProtocolsState({
    this.protocols = const [],
    this.selectedSort = ProtocolSort.mostUsed,
    this.searchQuery = '',
    this.isLoading = false,
  });

  /// Lista filtrada por busca e ordenada conforme seleção
  List<ProtocolTemplateModel> get displayProtocols {
    var list = protocols.where((p) {
      if (searchQuery.isEmpty) return true;
      final q = searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.baseDrugs.any((d) => d.toLowerCase().contains(q));
    }).toList();

    switch (selectedSort) {
      case ProtocolSort.mostUsed:
        list.sort((a, b) => b.usageCount.compareTo(a.usageCount));
      case ProtocolSort.alphabetical:
        list.sort((a, b) => a.name.compareTo(b.name));
      case ProtocolSort.recent:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return list;
  }

  ProtocolsState copyWith({
    List<ProtocolTemplateModel>? protocols,
    ProtocolSort? selectedSort,
    String? searchQuery,
    bool? isLoading,
  }) {
    return ProtocolsState(
      protocols: protocols ?? this.protocols,
      selectedSort: selectedSort ?? this.selectedSort,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProtocolsViewModel extends ChangeNotifier {
  ProtocolsState _state = const ProtocolsState();

  ProtocolsState get state => _state;

  ProtocolsViewModel() {
    _loadData();
  }

  // Carregamento
  Future<void> _loadData() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _state = _state.copyWith(
      isLoading: false,
      protocols: _mockProtocols(),
    );
    notifyListeners();
  }

  // Ações
  void onSearchChanged(String query) {
    _state = _state.copyWith(searchQuery: query);
    notifyListeners();
  }

  void onSortChanged(ProtocolSort sort) {
    _state = _state.copyWith(selectedSort: sort);
    notifyListeners();
  }

  void onProtocolTapped(String protocolId) {
    // TODO: navegar para detalhe do protocolo
  }

  void onStartProtocolPressed(String protocolId) {
    // TODO: navegar para iniciar protocolo em uma fazenda
  }

  Future<void> onRefresh() async => _loadData();

  // Mock

  List<ProtocolTemplateModel> _mockProtocols() => [
        ProtocolTemplateModel(
          id: '1',
          name: 'PGF2α',
          description: 'Protocolo base de sincronização com prostaglandina.',
          baseDrugs: ['Prostaglandina F2α'],
          usageCount: 87,
          createdAt: DateTime(2023, 1, 10),
        ),
        ProtocolTemplateModel(
          id: '2',
          name: 'Ressincronização 14D',
          description: 'Diagnóstico super precoce com Doppler.',
          durationDays: 14,
          baseDrugs: ['Dispositivo P4 Usado', 'Cipionato Estradiol'],
          usageCount: 64,
          createdAt: DateTime(2023, 3, 5),
        ),
        ProtocolTemplateModel(
          id: '3',
          name: 'Novilhas Indução (J-Synch)',
          description: 'Foco em maximizar prenhez em novilhas.',
          durationDays: 6,
          baseDrugs: ['GnRH', 'Prostaglandina F2α', 'Benzoato Estradiol'],
          usageCount: 52,
          createdAt: DateTime(2023, 5, 20),
        ),
        ProtocolTemplateModel(
          id: '4',
          name: 'Sincrodiol 2,0 mL',
          description: 'Protocolo padrão com dispositivo intravaginal.',
          durationDays: 9,
          baseDrugs: ['Dispositivo P4', 'Benzoato Estradiol', 'eCG'],
          usageCount: 120,
          createdAt: DateTime(2022, 11, 1),
        ),
        ProtocolTemplateModel(
          id: '5',
          name: 'Crestar + BE',
          description: 'Implante auricular com benzoato de estradiol.',
          durationDays: 9,
          baseDrugs: ['Implante Crestar', 'Benzoato Estradiol', 'eCG'],
          usageCount: 43,
          createdAt: DateTime(2023, 7, 14),
        ),
        ProtocolTemplateModel(
          id: '6',
          name: 'OvSynch',
          description: 'Protocolo clássico de sincronização da ovulação.',
          durationDays: 10,
          baseDrugs: ['GnRH', 'Prostaglandina F2α'],
          usageCount: 98,
          createdAt: DateTime(2022, 8, 30),
        ),
      ];
}