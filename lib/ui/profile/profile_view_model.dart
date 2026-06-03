import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final String name = 'Dr. João';
  final String crm = 'CRMV-SP 45892';

  final bool isSynced = true;

  void onPersonalData() {
    debugPrint('Dados pessoais');
  }

  void onNotifications() {
    debugPrint('Notificações');
  }

  void onPrivacy() {
    debugPrint('Privacidade');
  }

  void onSettings() {
    debugPrint('Configurações');
  }

  void onLogout() {
    debugPrint('Logout');
  }

  void onSync() {
    debugPrint('Sincronizar');
  }
}