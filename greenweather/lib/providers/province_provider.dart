import 'package:flutter/material.dart';

class ProvinceProvider extends ChangeNotifier {
  String _selectedProvince = 'Bangkok';

  //province
  final Map<String, Map<String, String>> _provinces = {
    "Bangkok": {"en": "Bangkok", "th": "กรุงเทพมหานคร"},
    "Chiang Mai": {"en": "Chiang Mai", "th": "เชียงใหม่"},
    "Nakhon Ratchasima": {"en": "Nakhon Ratchasima", "th": "นครราชสีมา"},
    "Chonburi": {"en": "Chonburi", "th": "ชลบุรี"},
    "Hat yai": {"en": "Songkhla", "th": "สงขลา"},
    "Khon Kaen": {"en": "Khon Kaen", "th": "ขอนแก่น"},
    "Udon Thani": {"en": "Udon Thani", "th": "อุดรธานี"},
    "Phuket": {"en": "Phuket", "th": "ภูเก็ต"},
    "Ayutthaya": {"en": "Ayutthaya", "th": "พระนครศรีอยุธยา"},
    // "Sukhothai": {"en": "Sukhothai", "th": "สุโขทัย"},
    "Nakhon Si Thammarat": {"en": "Nakhon Si Thammarat", "th": "นครศรีธรรมราช"},
    "Ratchaburi": {"en": "Ratchaburi", "th": "ราชบุรี"},
    "Surat Thani": {"en": "Surat Thani", "th": "สุราษฎร์ธานี"},
    // "Chaiyaphum": {"en": "Chaiyaphum", "th": "ชัยภูมิ"},
    "Lampang": {"en": "Lampang", "th": "ลำปาง"},
    // "Lamphun": {"en": "Lamphun", "th": "ลำพูน"},
    // "Nakhon Nayok": {"en": "Nakhon Nayok", "th": "นครนายก"},
    "Pattani": {"en": "Pattani", "th": "ปัตตานี"},
    // "Singburi": {"en": "Sing buri", "th": "สิงห์บุรี"},
    // "Trat": {"en": "Trat", "th": "ตราด"},
    // "Roi Et": {"en": "Roi Et", "th": "ร้อยเอ็ด"},
    "Sakon Nakhon": {"en": "Sakon Nakhon", "th": "สกลนคร"},
    // "Phetchabun": {"en": "Phetchabun", "th": "เพชรบูรณ์"},
    "Nakhon Pathom": {"en": "Nakhon Pathom", "th": "นครปฐม"},
    // "Prachin Buri": {"en": "Prachin Buri", "th": "ปราจีนบุรี"},
    // "Chumphon": {"en": "Chumphon", "th": "ชุมพร"},
    "Kanchanaburi": {"en": "Kanchanaburi", "th": "กาญจนบุรี"},
    // "Mae Hong Son": {"en": "Mae Hong Son", "th": "แม่ฮ่องสอน"},
    "Nakhon Phanom": {"en": "Nakhon Phanom", "th": "นครพนม"},
    // "Phichit": {"en": "Phichit", "th": "พิจิตร"},
    "Phitsanulok": {"en": "Phitsanulok", "th": "พิษณุโลก"},
    // "Chachoengsao": {"en": "Chachoengsao", "th": "ฉะเชิงเทรา"},
    "Nan": {"en": "Nan", "th": "น่าน"},
    // "Yasothon": {"en": "Yasothon", "th": "ยโสธร"},
    // "Ang Thong": {"en": "Ang Thong", "th": "อ่างทอง"},
    //"Surin": {"en": "Surin", "th": "สุรินทร์"},
    "Phrae": {"en": "Phrae", "th": "แพร่"},
    // "Buri Ram": {"en": "Buri Ram", "th": "บุรีรัมย์"},
    "Prachuap Khiri Khan": {
      "en": "Prachuap Khiri Khan",
      "th": "ประจวบคีรีขันธ์"
    },
    "Saraburi": {"en": "Saraburi", "th": "สระบุรี"},
    "Nong Khai": {"en": "Nong Khai", "th": "หนองคาย"},
    "Phayao": {"en": "Phayao", "th": "พะเยา"},
    "Samut Prakan": {"en": "Samut Prakan", "th": "สมุทรปราการ"},
    "Samut Sakhon": {"en": "Samut Sakhon", "th": "สมุทรสาคร"},
    "Samut Songkhram": {"en": "Samut Songkhram", "th": "สมุทรสงคราม"},
    "Uthai Thani": {"en": "Uthai Thani", "th": "อุทัยธานี"},
    "Suphan Buri": {"en": "Suphan Buri", "th": "สุพรรณบุรี"},
    "Ubon Ratchathani": {"en": "Ubon Ratchathani", "th": "อุบลราชธานี"},
    // "Nong Bua Lamphu": {"en": "Nong Bua Lamphu", "th": "หนองบัวลำภู"},
    "Tak": {"en": "Tak", "th": "ตาก"},
    "Nakhon Sawan": {"en": "Nakhon Sawan", "th": "นครสวรรค์"},
    // "Chanthaburi": {"en": "Chanthaburi", "th": "จันทบุรี"},
    "Yala": {"en": "Yala", "th": "ยะลา"},
  };
  Map<String, Map<String, String>> get provinces => _provinces;
  String get selectProvince => _selectedProvince;
  void setProvince(String province) {
    _selectedProvince = province;
    notifyListeners();
  }
}
