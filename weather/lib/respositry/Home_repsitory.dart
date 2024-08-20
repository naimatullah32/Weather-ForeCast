

import 'package:weather/Models/CurrentForeCastModel.dart';
import 'package:weather/Models/HourlyForeCastModel.dart';
import 'package:weather/Services/Utilities/appUrls.dart';

import '../data/network/BaseApiUrl.dart';
import '../data/network/NetworkApiService.dart';

class HomeRepository{

  BaseApiServices _ApiServices = Networkapiservice();

  Future<CurrentForeCastModel> fetchWeatherCurrentData() async {

    try {
      dynamic response = await _ApiServices.getGetApiResponse(AppUrl.curEndpointUrl);

      return response=CurrentForeCastModel.fromJson(response);

    } catch (e) {

      throw e;

    }
  }
  Future<HourlyForeCastModel> fetchWeatherHourlytData() async {

    try {
      dynamic response = await _ApiServices.getGetApiResponse(AppUrl.hourlyEndPointUrl);

      return response=HourlyForeCastModel.fromJson(response);

    } catch (e) {

      throw e;

    }
  }

}