import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/models/protocol_template_model.dart';
import 'protocols_view_model.dart';

class ProtocolsScreen extends StatelessWidget {
  const ProtocolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProtocolsViewModel(),
      child: const _ProtocolsView(),
    );
  }
}

// View principal
class _ProtocolsView extends StatelessWidget {
  const _ProtocolsView();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<ProtocolsViewModel, bool>(
      (vm) => vm.state.isLoading,
    );
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: criar novo protocolo
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header fixo
            const _ProtocolsHeader(),

            // Lista que rola por baixo do header
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: context.read<ProtocolsViewModel>().onRefresh,
                      child: const _ProtocolsList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProtocolsHeader extends StatelessWidget {
  const _ProtocolsHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar manual
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
                  onPressed: () => context.pop(),
                ),
                Text(
                  'Protocolos',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Barra de busca
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: _SearchBar(),
          ),

          // Chips de ordenação
          const _SortChips(),

          Divider(height: 1, color: cs.outlineVariant),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final vm = context.read<ProtocolsViewModel>();

    return Container(
      height: 48,
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
                hintText: 'Buscar protocolo',
                hintStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.tune_rounded,
              color: cs.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () {
              // TODO: abrir filtros avançados
            },
          ),
        ],
      ),
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips();

  @override
  Widget build(BuildContext context) {
    final selectedSort = context.select<ProtocolsViewModel, ProtocolSort>(
      (vm) => vm.state.selectedSort,
    );
    final vm = context.read<ProtocolsViewModel>();

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: ProtocolSort.values.map((sort) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(sort.label),
              selected: sort == selectedSort,
              onSelected: (_) => vm.onSortChanged(sort),
              showCheckmark: sort == selectedSort,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Lista de protocolos
class _ProtocolsList extends StatelessWidget {
  const _ProtocolsList();

  @override
  Widget build(BuildContext context) {
    final protocols = context
        .select<ProtocolsViewModel, List<ProtocolTemplateModel>>(
          (vm) => vm.state.displayProtocols,
        );

    if (protocols.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum protocolo encontrado.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: protocols.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _ProtocolTemplateCard(protocol: protocols[index]),
    );
  }
}

// Card de protocolo
class _ProtocolTemplateCard extends StatelessWidget {
  final ProtocolTemplateModel protocol;
  const _ProtocolTemplateCard({required this.protocol});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final vm = context.read<ProtocolsViewModel>();

    return GestureDetector(
      onTap: () => vm.onProtocolTapped(protocol.id),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Borda esquerda colorida
              Container(width: 4, color: cs.primary),

              // Conteúdo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome + badge de duração
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              protocol.name,
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (protocol.durationDays != null) ...[
                            const SizedBox(width: 8),
                            _DurationBadge(days: protocol.durationDays!),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Descrição
                      Text(
                        protocol.description,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Fármacos base
                      Text(
                        'FÁRMACOS BASE',
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: protocol.baseDrugs
                            .map((drug) => _DrugChip(label: drug))
                            .toList(),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => vm.onProtocolTapped(protocol.id),
                            child: Row(
                              children: [
                                Text(
                                  'Ver Detalhes',
                                  style: tt.labelMedium?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: cs.primary,
                                ),
                              ],
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

class _DurationBadge extends StatelessWidget {
  final int days;
  const _DurationBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 12, color: cs.secondary),
          const SizedBox(width: 4),
          Text(
            '$days Dias',
            style: TextStyle(
              fontSize: 11,
              color: cs.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrugChip extends StatelessWidget {
  final String label;
  const _DrugChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
