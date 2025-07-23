class Meter {
  final int assignmentId;
  final String accountNum;
  final String accountName;
  final String address;
  final String previousReading;
  final String currentReading;
  final String meterType;
  final String serialNo;
  final String billFactor;
  final String resettable;
  final int predecimals;
  final int postdecimals;
  final String schmrDate;
  final String status;
  final String assignedDate;
  final String latitude;
  final String longitude;

  Meter({
    required this.assignmentId,
    required this.accountNum,
    required this.accountName,
    required this.address,
    required this.previousReading,
    required this.currentReading,
    required this.meterType,
    required this.serialNo,
    required this.billFactor,
    required this.resettable,
    required this.predecimals,
    required this.postdecimals,
    required this.schmrDate,
    required this.status,
    required this.assignedDate,
    required this.latitude,
    required this.longitude
  });

  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      assignmentId: json['assignment_id'],
      accountNum: json['AccountNum'],
      accountName: json['AccountName'],
      address: json['Address'],
      previousReading: json['PreviousReading'],
      currentReading: json['CurrentReading'],
      meterType: json['MeterType'],
      serialNo: json['SerialNo'],
      billFactor: json['BillFactor'],
      resettable: json['Resettable'],
      predecimals: json['Predecimals'],
      postdecimals: json['Postdecimals'],
      schmrDate: json['SchmrDate'],
      status: json['status'],
      assignedDate: json['assigned_date'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
