import 'dart:convert';

import 'package:itike/models/api_response.dart';
import 'package:itike/models/destination.dart';
import 'package:itike/models/ticket.dart';
import 'package:itike/services/user_service.dart';
import 'package:itike/utils/app_constants.dart';
import 'package:http/http.dart' as http;

// getting all tickets
Future<ApiResponse> getTickets(String date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse('$ticketsURL/$date'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['tickets']
            .map((d) => Ticket.fromJson(d))
            .toList();
        apiResponse.data as List<dynamic>;
        print("Gotten the tickets successfully");
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

//creating a ticket
Future<ApiResponse> createTicket(int destId, String date, String time) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('$ticketsURL/$destId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'date': date,
          'time': time
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        print("Ticket created successfully");
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

//checking if a ticket exist
Future<ApiResponse> checkTicket(int destId, String date, String time) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('$checkTicketURL/$destId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'date': date,
          'time': time
        });

    switch (response.statusCode) {
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        print("Ticket exist");
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
