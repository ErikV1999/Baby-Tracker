

class Appointment {
  String doctor = '';
  DateTime time = DateTime.now();
  String hospital = '';
  String street = '';
  String city = '';
  String state = '';
  int notificationID = 0;
  String phone = '';
  String reasonForVisit = '';
  String results = '';

  Appointment(Map appointmentData, Map doctorData) {
    doctor = doctorData['doctor'];
    time = DateTime.parse(appointmentData['time'].toDate().toString());
    hospital = doctorData['hospital'];
    street = doctorData['street'];
    city = doctorData['city'];
    state = doctorData['state'];
    notificationID = appointmentData['notificationID'];
    phone = doctorData['phone'];
    reasonForVisit = appointmentData['reasonForVisit'];
    results = appointmentData['results'];
  }

}