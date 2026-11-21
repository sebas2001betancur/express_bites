import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _avisos = FlutterLocalNotificationsPlugin();

Future<void> iniciarAvisos() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _avisos.initialize(
      settings: const InitializationSettings(android: android));
  await _avisos
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

Future<void> avisarPedidoListo(String claimId) async {
  const detalles = NotificationDetails(
    android: AndroidNotificationDetails('pedidos', 'Pedidos',
        importance: Importance.high, priority: Priority.high),
  );
  await _avisos.show(
    id: claimId.hashCode,
    title: 'Tu pedido está listo',
    body: 'Pasa por la barra con el código $claimId',
    notificationDetails: detalles,
  );
}
