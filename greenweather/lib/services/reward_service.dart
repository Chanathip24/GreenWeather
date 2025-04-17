import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greenweather/model/Rewardmodel.dart';

class RewardService {
  final Dio _dio = Dio();
  final String? _apiUrl = dotenv.env['API_URL'] ?? "http://10.0.0.2:8082";

  //get all Reward
  Future<List<Reward>> getRewards() async {
    try {
      final response = await _dio.get('$_apiUrl/reward');
      if (response.statusCode != 200) {
        throw Exception("Failed with status code: ${response.statusCode}");
      }
      List data = response.data['data'];

      return data.map((review) => Reward.fromJson(review)).toList();
    } on DioException catch (e) {
      print(e.response?.data);
      throw Exception("Failed to get all rewards : ${e.message}");
    } catch (e) {
      throw Exception("Unexpected Error $e");
    }
  }

  //get reward by id
  Future<Reward> getRewardbyid(int rewardId) async {
    try {
      final response = await _dio.get('$_apiUrl/reward/$rewardId');

      if (response.statusCode != 200) {
        throw Exception("Failed with status code: ${response.statusCode}");
      }
      return Reward.fromJson(response.data['data']);
    } on DioException catch (e) {
      print(e.response?.data);
      throw Exception("Failed to get reward by id : ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error : $e");
    }
  }

  //create
  Future<Reward> createReward(Reward reward) async {
    try {
      final response =
          await _dio.post('$_apiUrl/reward/create', data: reward.toJson());
      if (response.statusCode != 201) {
        throw Exception(
            "Failed to create with status code ${response.statusCode}");
      }
      return Reward.fromJson(response.data['data']);
    } on DioException catch (e) {
      print(e.response?.data);
      throw Exception("Failed to create ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error :$e");
    }
  }

  //update
  Future<Reward> updateReward(Reward reward) async {
    try {
      final response =
          await _dio.put('$_apiUrl/reward/${reward.id}', data: reward.toJson());

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to update data with status code ${response.statusCode}");
      }
      return Reward.fromJson(response.data['data']);
    } on DioException catch (e) {
      print(e.response?.data);
      throw Exception("Failed to update reward ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error $e");
    }
  }

  //rewardItem
  Future<RewardItem> createRewardItem(RewardItem item) async {
    try {
      final response =
          await _dio.post('$_apiUrl/reward/value', data: item.toJson());

      if (response.statusCode != 201) {
        throw Exception(
            "Failed to create Reward Item with status code ${response.statusCode}");
      }
      return RewardItem.fromJson(response.data['data']);
    } on DioException catch (e) {
      print(e.response?.data);
      throw Exception("Failed to create Reward item ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error $e");
    }
  }
}
