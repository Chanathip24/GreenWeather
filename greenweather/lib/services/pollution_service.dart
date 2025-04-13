import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/pollutionModel.dart';

class PollutionService {
  final Dio dio = Dio();

  final String? _apiUrl = dotenv.env['API_URL'] ?? "http://10.0.0.2:8082";

  Future<Pollutionmodel> getPollutionbycity(String cityName) async{
    try{
      final response = await dio.get("$_apiUrl/pm/",queryParameters: {
        'location' : cityName
      });
      
      if(response.statusCode == 200){
        
        return Pollutionmodel.fromJson(response.data['data']);
      }else{
        throw Exception("Failed to load weather data ${response.statusCode}");
      }
    }catch(e){
      print(e);
      throw Exception("Failed to fetch pollution");
    }
  }
}