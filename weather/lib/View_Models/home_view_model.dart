
import 'package:flutter/widgets.dart';
import 'package:weather/Models/CurrentForeCastModel.dart';
import 'package:weather/Models/HourlyForeCastModel.dart';

import '../data/response/API_RESPONSE.dart';
import '../respositry/Home_repsitory.dart';

class HomeViewModel with ChangeNotifier{

  final _myRepo=HomeRepository();

  ApiResponse<CurrentForeCastModel> currentWeatherList = ApiResponse.loading();
  ApiResponse<HourlyForeCastModel> hourlyWeatherList = ApiResponse.loading();



  setCurrWeather(ApiResponse<CurrentForeCastModel> response1){
    currentWeatherList = response1;
    notifyListeners();
  }
  setHourlyWeather(ApiResponse<HourlyForeCastModel> response1){
    hourlyWeatherList = response1;
    notifyListeners();
  }

  Future<void> fetchCurrentData() async{

     setCurrWeather(ApiResponse.loading());
    _myRepo.fetchWeatherCurrentData().then((value){
      setCurrWeather(ApiResponse.completed(value));
    }).onError((error, stackTrace){
      setCurrWeather(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchHourlyData() async{

    setCurrWeather(ApiResponse.loading());
    _myRepo.fetchWeatherHourlytData().then((value){
      if(value != null){
        return setHourlyWeather(ApiResponse.completed(value));
      }else{
        return setHourlyWeather(ApiResponse.error("Data is null"));
      }

    }).onError((error, stackTrace){
      setHourlyWeather(ApiResponse.error(error.toString()));
    });
  }
}