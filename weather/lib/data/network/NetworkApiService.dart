
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../app_exception.dart';
import 'BaseApiUrl.dart';

import 'package:http/http.dart' as http;

class Networkapiservice extends BaseApiServices{
  @override
  Future getGetApiResponse(String url) async{

    dynamic responseJson;
    try{
      final response= await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    }on SocketException{

      throw FetchDataException("No internet connectiion");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async{
    dynamic responseJson;
    try{
      Response response=await post(
        Uri.parse(url),
            body: data
      ).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    }on SocketException{
      throw FetchDataException("No internet connectiion");
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response){

    switch(response.statusCode){
    case 200:
        dynamic responseJson=jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorisedException(response.body.toString());
        default:
          throw FetchDataException("Error accurse while communication with server"+
              "with status code"+response.statusCode.toString());
    }

  }

}