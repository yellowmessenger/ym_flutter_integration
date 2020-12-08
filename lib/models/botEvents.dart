/// Bot event model
///
/// * Event code
/// * Event data
class BotEvent {
  String code, data;
  BotEvent({this.code, this.data});

  BotEvent.fromJson(Map<String, dynamic> json) {
    /// Event code to identify or distinguish the event
    code = json['code'];

    /// Data received for the event code
    data = json['data'];
  }
}
