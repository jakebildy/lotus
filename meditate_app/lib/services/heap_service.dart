import 'package:get/get.dart';
import 'package:heap_flutter_bridge/heap_flutter_bridge.dart';

class HeapService extends GetxService {
  HeapService() {
    _init();
  }

  void _init() async {
    Heap().startRecording("1307034901");
  }

  Future<void> logEvent(
      String eventName, Map<String, dynamic>? eventValues) async {
    if (eventValues != null) {
      Heap().track(eventName, eventValues);
      return;
    }
    Heap().track(eventName);
  }
}
