import 'package:flutter/material.dart';
import 'package:greenweather/model/adviceModel.dart';
import 'package:greenweather/model/pollutionModel.dart';
import 'package:greenweather/services/pollution_service.dart';

class PollutionProvider extends ChangeNotifier {
  Pollutionmodel? _currentPollution;
  bool _isLoading = false;
  String? _error;
  Advicemodel? _adviceModel;

  Pollutionmodel? get currentPollution => _currentPollution;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Advicemodel? get adviceModel => _adviceModel;

  final PollutionService _pollutionService = PollutionService();

  //get advice
  Map<String, dynamic> getAirQualityInfo(int aqi) {
    String description;
    String generalAdvice;
    String sensitiveAdvice;
    String outdoorAdvice;
    String status;
    Color color;

    if (aqi <= 50) {
      description =
          'คุณภาพอากาศอยู่ในเกณฑ์ดี เหมาะสำหรับทุกคนในการทำกิจกรรมกลางแจ้ง';
      generalAdvice = 'คุณภาพอากาศดี สามารถทำกิจกรรมกลางแจ้งได้ตามปกติ';
      sensitiveAdvice = 'กลุ่มเสี่ยงสามารถทำกิจกรรมกลางแจ้งได้ตามปกติ';
      outdoorAdvice = 'เหมาะสำหรับกิจกรรมกลางแจ้งทุกประเภท';
      status = 'ดี';
      color = Colors.green;
    } else if (aqi <= 100) {
      description =
          'คุณภาพอากาศยังอยู่ในเกณฑ์ที่ยอมรับได้ แต่อาจมีมลพิษที่ส่งผลต่อบุคคลที่มีความไวต่อมลพิษ';
      generalAdvice =
          'คุณภาพอากาศยอมรับได้ แต่อาจมีมลพิษที่เป็นอันตรายต่อคนบางกลุ่มที่มีความไวต่อมลพิษ';
      sensitiveAdvice =
          'กลุ่มเสี่ยงควรพิจารณาลดการทำกิจกรรมกลางแจ้งที่ต้องออกแรงมากหรือเป็นเวลานาน';
      outdoorAdvice = 'สามารถทำกิจกรรมกลางแจ้งได้ แต่ควรสังเกตอาการผิดปกติ';
      status = 'ปานกลาง';
      color = Colors.amber[800]!; // Using a darker yellow (amber[800])
    } else if (aqi <= 150) {
      description =
          'สมาชิกของกลุ่มเสี่ยง (ผู้สูงอายุ เด็ก และผู้ที่มีโรคหัวใจหรือปอด) อาจได้รับผลกระทบ';
      generalAdvice =
          'กลุ่มคนทั่วไปควรเฝ้าระวังอาการผิดปกติ การไอ หรือหายใจลำบาก';
      sensitiveAdvice =
          'กลุ่มเสี่ยงควรลดการทำกิจกรรมกลางแจ้งที่ต้องออกแรงมาก และเฝ้าระวังอาการผิดปกติ';
      outdoorAdvice =
          'ควรพิจารณาลดระยะเวลาการทำกิจกรรมกลางแจ้ง โดยเฉพาะการออกกำลังกายหนัก';
      status = 'ไม่ดีต่อกลุ่มเสี่ยง';
      color = Colors.orange;
    } else if (aqi <= 200) {
      description =
          'ทุกคนเริ่มได้รับผลกระทบต่อสุขภาพ กลุ่มเสี่ยงอาจได้รับผลกระทบรุนแรงกว่า';
      generalAdvice =
          'ทุกคนควรลดการทำกิจกรรมกลางแจ้งที่ต้องออกแรงมาก และพิจารณาใช้หน้ากากอนามัย N95 หากต้องอยู่กลางแจ้ง';
      sensitiveAdvice =
          'กลุ่มเสี่ยงควรหลีกเลี่ยงการทำกิจกรรมกลางแจ้งทุกชนิด และสวมหน้ากากอนามัย N95 หากต้องออกนอกบ้าน';
      outdoorAdvice =
          'ควรหลีกเลี่ยงการออกกำลังกายกลางแจ้ง และทำกิจกรรมในร่มแทน';
      status = 'ไม่ดี';
      color = Colors.red;
    } else if (aqi <= 300) {
      description = 'คำเตือนด้านสุขภาพ ทุกคนอาจได้รับผลกระทบรุนแรงต่อสุขภาพ';
      generalAdvice =
          'ทุกคนควรหลีกเลี่ยงกิจกรรมกลางแจ้งทุกชนิด ใช้เครื่องฟอกอากาศในบ้าน และสวมหน้ากาก N95 หากต้องออกนอกบ้าน';
      sensitiveAdvice =
          'กลุ่มเสี่ยงควรอยู่ในอาคารและหลีกเลี่ยงกิจกรรมทางกายทุกชนิด';
      outdoorAdvice =
          'ควรงดกิจกรรมกลางแจ้งทุกประเภท และปิดหน้าต่างเพื่อป้องกันมลพิษเข้าบ้าน';
      status = 'แย่มาก';
      color = Colors.purple;
    } else {
      description =
          'คำเตือนฉุกเฉินด้านสุขภาพ: ทุกคนมีแนวโน้มที่จะได้รับผลกระทบอย่างรุนแรง';
      generalAdvice =
          'ภาวะฉุกเฉิน! ทุกคนควรอยู่ในอาคารและลดกิจกรรมทางกาย สวมหน้ากาก N95 หากจำเป็นต้องออกนอกบ้าน';
      sensitiveAdvice =
          'กลุ่มเสี่ยงควรอยู่ในอาคารที่มีเครื่องฟอกอากาศและลดกิจกรรมทางกายให้น้อยที่สุด';
      outdoorAdvice =
          'ห้ามทำกิจกรรมกลางแจ้งทุกประเภท ควรอยู่ในอาคารที่มีระบบกรองอากาศ';
      status = 'อันตราย';
      color = Colors.brown;
    }

    return {
      "status": status,
      "description": description,
      "generalAdvice": generalAdvice,
      "sensitiveAdvice": sensitiveAdvice,
      "outdoorAdvice": outdoorAdvice,
      "color": color
    };
  }

  //fetch pollution apo
  Future<void> fetchPollution(String location) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final pollutionData =
          await _pollutionService.getPollutionbycity(location);
      //current pollution
      _currentPollution = pollutionData;
      //map advice
      final adviceMap = getAirQualityInfo(_currentPollution!.aqi);

      //create model
      _adviceModel = Advicemodel.fromJson(adviceMap);
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
