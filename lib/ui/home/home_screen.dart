import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/models/protocol_model.dart';
import '../../routing/app_routes.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<HomeViewModel, bool>(
      (vm) => vm.state.isLoading
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: context.read<HomeViewModel>().onRefresh,
              child: CustomScrollView(
                slivers: const [
                  _HomeAppBar(),
                  SliverToBoxAdapter(child: _HeaderSection()),
                  _ProtocolList(),
                  SliverToBoxAdapter(child: _FooterSection()),
                ],
              ),
            ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SliverAppBar(
      backgroundColor: cs.surfaceContainerLow,
      surfaceTintColor: cs.tertiaryContainer,
      elevation: 0,
      pinned: true,
      floating: false,
      title: Text(
        'IATF Mobile',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu_rounded, color: cs.onSurface),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundColor: cs.primaryContainer,
            radius: 22,
            child: Icon(Icons.person_outline_rounded, color: cs.primary, size: 22),
          ),
          onPressed: () => context.go(AppRoutes.profile),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final state = context.select<HomeViewModel, HomeState>((vm) => vm.state);

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, ${state.userName}',
            style: tt.headlineSmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Acompanhe seus protocolos ativos e próximos passos para hoje.',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          if (state.nextAction != null)
            _NextActionCard(action: state.nextAction!),
        ],
      ),
    );
  }
}

class _NextActionCard extends StatelessWidget {
  final NextAction action;
  const _NextActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Próxima ação',
                        style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 2),
                    Text(action.label,
                        style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(action.farmName,
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: cs.secondary),
                    const SizedBox(height: 2),
                    Text(action.time,
                        style: tt.labelLarge?.copyWith(
                            color: cs.secondary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: FilledButton.icon(
              onPressed: context.read<HomeViewModel>().onStartProcedurePressed,
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Text('Iniciar Procedimento'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolList extends StatelessWidget {
  const _ProtocolList();

  @override
  Widget build(BuildContext context) {
    final protocols = context.select<HomeViewModel, List<ProtocolModel>>(
      (vm) => vm.state.activeProtocols,
    );

    if (protocols.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'Nenhum protocolo encontrado.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      sliver: SliverList.separated(
        itemCount: protocols.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _ProtocolCard(protocol: protocols[index]),
      ),
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  final ProtocolModel protocol;
  const _ProtocolCard({required this.protocol});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.read<HomeViewModel>().onProtocolTapped(protocol.id),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
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
                      children: [
                        Expanded(
                          child: Text(protocol.farmName,
                              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                        _StatusBadge(status: protocol.status),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(protocol.lot,
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 10),
                    Text('Protocolo',
                        style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
                    Text(protocol.protocolName,
                        style: tt.bodySmall?.copyWith(
                            color: cs.secondary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Progresso - ${protocol.currentPhase}',
                            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
                        const Spacer(),
                        Text('${(protocol.progress * 100).toInt()}%',
                            style: tt.labelSmall?.copyWith(color: cs.primary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: protocol.progress,
                        minHeight: 6,
                        backgroundColor: cs.surfaceContainerHigh,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: protocol.imagePath != null
                  ? Image.asset(protocol.imagePath!, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _CattlePlaceholder(cs: cs))
                  : _CattlePlaceholder(cs: cs),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProtocolStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (color, bg) = switch (status) {
      ProtocolStatus.active    => (cs.primary, cs.primaryContainer),
      ProtocolStatus.completed => (cs.tertiary, cs.tertiaryContainer),
      ProtocolStatus.pending   => (cs.secondary, cs.secondaryContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status.label,
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _CattlePlaceholder extends StatelessWidget {
  final ColorScheme cs;
  const _CattlePlaceholder({required this.cs});

  @override
  Widget build(BuildContext context) => Container(
        color: cs.primaryContainer,
        child: Icon(Icons.pets_rounded, color: cs.primary, size: 36),
      );
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: OutlinedButton(
        onPressed: context.read<HomeViewModel>().onSeeAllPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: const Text('Ver todos'),
      ),
    );
  }
}
