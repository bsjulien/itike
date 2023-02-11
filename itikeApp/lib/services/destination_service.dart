import 'dart:convert';

import 'package:itike/models/api_response.dart';
import 'package:itike/models/destination.dart';
import 'package:itike/services/user_service.dart';
import 'package:itike/utils/app_constants.dart';
import 'package:http/http.dart' as http;

// getting kigali location for homepage

Future<ApiResponse> gethomeDest() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(homeDestURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        print("its getting here");
        apiResponse.data = jsonDecode(response.body)['Destinations']
            .map((d) => Destination.fromJson(d))
            .toList();
        apiResponse.data as List<dynamic>;
        print("Gotten the destinations successfully");
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//getting startpoint locations

Future<ApiResponse> getStartpoints() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(startPointURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        print("its getting here");
        apiResponse.data = jsonDecode(response.body)['startpoints']
            .map((d) => Destination.fromJson(d))
            .toList();
        apiResponse.data as List<dynamic>;
        print("Gotten the startpoints successfully");
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//getting endpoints locations

Future<ApiResponse> getEndpoints(String startpoint) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$endPointURL/$startpoint'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        print("its getting here");
        apiResponse.data = jsonDecode(response.body)['endpoints']
            .map((d) => Destination.fromJson(d))
            .toList();
        apiResponse.data as List<dynamic>;
        print("Gotten the endpoints successfully");
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//getting destination information

Future<ApiResponse> getDestInfo(String startpoint, String endpoint) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$destInfoURL/$startpoint/$endpoint'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        print("its getting here");
        apiResponse.data = jsonDecode(response.body)['destinationinfo']
            .map((d) => Destination.fromJson(d))
            .toList();
        apiResponse.data as List<dynamic>;
        print("Gotten the destination info successfully");
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }

  return apiResponse;
}
