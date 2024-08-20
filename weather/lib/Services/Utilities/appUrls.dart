

class AppUrl{

  static const String curBaseUrl='https://api.openweathermap.org/data/2.5/weather?';
  static const String curEndpointUrl= curBaseUrl+'lat=34.8237&lon=71.6866&appid=40855b9ea6e64a678e580577f9a2c79d';

  static const String hourlyBaseUrl='https://api.open-meteo.com';
  static const String hourlyEndPointUrl=hourlyBaseUrl+'/v1/forecast?latitude=52.52&longitude=13.41&&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m';


}