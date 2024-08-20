import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/Models/CurrentForeCastModel.dart';
import 'package:weather/Services/Utilities/appUrls.dart';

import '../../Models/HourlyForeCastModel.dart';


class Apiservices{

  Future<CurrentForeCastModel> fatchCurrentWeatherData () async{

    final response=await http.get(Uri.parse(AppUrl.curEndpointUrl));

    if(response.statusCode == 200){
      var data=jsonDecode(response.body);
      return CurrentForeCastModel.fromJson(data);
    }else{
      throw Exception('Error');
    }
  }

  Future<HourlyForeCastModel> fatchHourlyWeatherData () async{

    final response=await http.get(Uri.parse(AppUrl.hourlyEndPointUrl));

    if(response.statusCode == 200){
      var data=jsonDecode(response.body);
      return HourlyForeCastModel.fromJson(data);
    }else{
      throw Exception('Error');
    }
  }
}