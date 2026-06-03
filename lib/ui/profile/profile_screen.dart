import 'package:flutter/material.dart';
import 'package:iatf_mobile/routing/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProfileViewModel>();
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cs.surfaceContainerLow,
        title: Text(
          'IATF Mobile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go(AppRoutes.home),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: cs.primaryContainer,
              child: Icon(Icons.person, size: 70, color: cs.primary),
            ),

            const SizedBox(height: 12),

            Text(
              vm.name,
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(vm.crm, style: tt.labelSmall),
            ),

            const SizedBox(height: 24),

            // Card sincronização
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_done_outlined),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sincronização Offline',
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('Status: Sincronizado agora', style: tt.bodySmall),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: vm.onSync,
                    icon: const Icon(Icons.sync),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Configurações da Conta', style: tt.titleLarge),
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.person_outline,
                    title: 'Dados Pessoais',
                    onTap: vm.onPersonalData,
                  ),
                  _Divider(),
                  _MenuTile(
                    icon: Icons.notifications_none,
                    title: 'Notificações do Sistema',
                    onTap: vm.onNotifications,
                  ),
                  _Divider(),
                  _MenuTile(
                    icon: Icons.shield_outlined,
                    title: 'Privacidade e Segurança',
                    onTap: vm.onPrivacy,
                  ),
                  _Divider(),
                  _MenuTile(
                    icon: Icons.settings_outlined,
                    title: 'Configurações',
                    onTap: vm.onSettings,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: vm.onLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Sair da Conta'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Icon(icon, color: cs.onSurfaceVariant),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
