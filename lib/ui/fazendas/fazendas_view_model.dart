import 'package:flutter/foundation.dart';
import '../../domain/models/farm_model.dart';

class FazendasState {
  final List<FarmModel> farms;
  final String searchQuery;
  final bool isLoading;

  const FazendasState({
    this.farms = const [],
    this.searchQuery = '',
    this.isLoading = false,
  });

  List<FarmModel> get displayFarms {
    if (searchQuery.isEmpty) return farms;
    final q = searchQuery.toLowerCase();
    return farms.where((f) =>
        f.name.toLowerCase().contains(q) ||
        f.city.toLowerCase().contains(q)).toList();
  }

  FazendasState copyWith({
    List<FarmModel>? farms,
    String? searchQuery,
    bool? isLoading,
  }) {
    return FazendasState(
      farms: farms ?? this.farms,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FazendasViewModel extends ChangeNotifier {
  FazendasState _state = const FazendasState();
  FazendasState get state => _state;

  FazendasViewModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    _state = _state.copyWith(
      isLoading: false,
      farms: _mockFarms(),
    );
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _state = _state.copyWith(searchQuery: query);
    notifyListeners();
  }

  void onFarmTapped(String farmId) {
    // TODO: navegar para detalhe da fazenda
  }

  void onAddFarmPressed() {
    // TODO: navegar para cadastro de fazenda
  }

  Future<void> onRefresh() async => _loadData();

  List<FarmModel> _mockFarms() => [
        const FarmModel(
          id: '1',
          name: 'Fazenda Primavera',
          city: 'Ribeirão Preto',
          state: 'SP',
          activeLotes: 14,
          status: FarmStatus.upToDate,
        ),
        const FarmModel(
          id: '2',
          name: 'Vale do Sol',
          city: 'Uberaba',
          state: 'MG',
          activeLotes: 3,
          status: FarmStatus.pendingAction,
        ),
        const FarmModel(
          id: '3',
          name: 'Estância Boa Vista',
          city: 'Campo Grande',
          state: 'MS',
          activeLotes: 28,
          status: FarmStatus.upToDate,
        ),
        const FarmModel(
          id: '4',
          name: 'Rancho das Águas',
          city: 'Barretos',
          state: 'SP',
          activeLotes: 7,
          status: FarmStatus.pendingAction,
        ),
      ];
}