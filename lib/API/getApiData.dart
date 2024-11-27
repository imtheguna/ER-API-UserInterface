import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

final dio = Dio();

class GetAPIData {
  Future<Uint8List?> downloadRAWimage(url) async {
    try {
      final response = await dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("Failed to retrieve image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> downloadJSON(url) async {
    print(url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.data.toString()) as Map<String, dynamic>;

        return data;
      } else {
        print("Failed to retrieve image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<int> isAPIAvailable({required String url, required bool isNew}) async {
    // ignore: unused_local_variable
    final dio = Dio();
    const interval = Duration(seconds: 10);
    const timeout = Duration(minutes: 10);
    final endTime = DateTime.now().add(timeout);
    Timer? timer;

    Future<int> checkApi() async {
      print('Checking API');
      if (DateTime.now().isAfter(endTime)) {
        timer?.cancel();
        return 0;
      }

      try {
        if (isNew == true) {
          print("API Test Called again");
          return 1;
        }

        final response = await dio.get(url); // Replace with your API endpoint
        if (response.statusCode == 200 && response.data['message'] == 'OK') {
          timer?.cancel();
          return 1;
        }
        return 0;
      } catch (e) {
        print('Error fetching data: $e');
        return 0;
      }
    }

    timer = Timer.periodic(interval, (timer) => checkApi());

    return checkApi();
  }
}
