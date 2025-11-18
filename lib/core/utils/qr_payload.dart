class QrPayload {
  final String sid;
  final String c;
  final String lot;
  const QrPayload({required this.sid, required this.c, required this.lot});
  Map<String, dynamic> toJson() => {'sid': sid, 'c': c, 'lot': lot};
  factory QrPayload.fromJson(Map<String, dynamic> json) => QrPayload(
        sid: json['sid'] as String,
        c: json['c'] as String,
        lot: json['lot'] as String,
      );
}



