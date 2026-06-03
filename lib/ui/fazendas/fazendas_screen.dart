import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/farm_model.dart';
import 'fazendas_view_model.dart';

class FazendasScreen extends StatelessWidget {
  const FazendasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FazendasViewModel(),
      child: const _FazendasView(),
    );
  }
}

class _FazendasView extends StatelessWidget {
  const _FazendasView();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<FazendasViewModel, bool>(
      (vm) => vm.state.isLoading,
    );
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
       floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<FazendasViewModel>(),
        child: const Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: cs.surfaceContainerHighest,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: context.read<FazendasViewModel>().onRefresh,
                child: CustomScrollView(
                  slivers: const [
                    SliverToBoxAdapter(child: _FazendasHeader()),
                    _FarmList(),
                    SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
      ),
    );
  }
}

// Header
class _FazendasHeader extends StatelessWidget {
  const _FazendasHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final vm = context.read<FazendasViewModel>();

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Minhas Fazendas',
            style: tt.headlineMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Busca
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.search_rounded, color: cs.onSurfaceVariant, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: vm.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Buscar Fazenda...',
                      hintStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Lista de fazendas
class _FarmList extends StatelessWidget {
  const _FarmList();

  @override
  Widget build(BuildContext context) {
    final farms = context.select<FazendasViewModel, List<FarmModel>>(
      (vm) => vm.state.displayFarms,
    );

    if (farms.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'Nenhuma fazenda encontrada.',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      sliver: SliverList.separated(
        itemCount: farms.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _AnimatedFarmCard(
          farm: farms[index],
          index: index,
        ),
      ),
    );
  }
}

// Wrapper com animação de entrada
class _AnimatedFarmCard extends StatefulWidget {
  final FarmModel farm;
  final int index;

  const _AnimatedFarmCard({required this.farm, required this.index});

  @override
  State<_AnimatedFarmCard> createState() => _AnimatedFarmCardState();
}

class _AnimatedFarmCardState extends State<_AnimatedFarmCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Stagger
    Future.delayed(Duration(milliseconds: 20 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: _FarmCard(farm: widget.farm),
      ),
    );
  }
}

// Card de fazenda
class _FarmCard extends StatelessWidget {
  final FarmModel farm;
  const _FarmCard({required this.farm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final vm = context.read<FazendasViewModel>();

    // Cores baseadas no status
    final (statusColor, statusBg, accentColor) = switch (farm.status) {
      FarmStatus.upToDate => (
          cs.primary,
          cs.primaryContainer,
          cs.primary,
        ),
      FarmStatus.pendingAction => (
          cs.error,
          cs.errorContainer,
          cs.error,
        ),
      FarmStatus.inactive => (
          cs.onSurfaceVariant,
          cs.surfaceContainerHigh,
          cs.onSurfaceVariant,
        ),
    };

    return GestureDetector(
      onTap: () => vm.onFarmTapped(farm.id),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: accentColor.withAlpha(10),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.landscape_rounded,
                              color: cs.primary,
                              size: 24,
                            ),
                          ),
                          _StatusBadge(
                            status: farm.status,
                            color: statusColor,
                            bg: statusBg,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        farm.name,
                        style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${farm.city}, ${farm.state}',
                            style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Divider(height: 1, color: cs.outlineVariant),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PROTOCOLOS ATIVOS',
                                style: tt.labelSmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${farm.activeLotes.toString().padLeft(2, '0')} lotes',
                                style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final FarmStatus status;
  final Color color;
  final Color bg;
  const _StatusBadge({required this.status, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    final icon = switch (status) {
      FarmStatus.upToDate      => Icons.check_circle_outline_rounded,
      FarmStatus.pendingAction => Icons.warning_amber_rounded,
      FarmStatus.inactive      => Icons.pause_circle_outline_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
