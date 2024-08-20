import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_load_kit/flutter_load_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/Models/CurrentForeCastModel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../View_Models/home_view_model.dart';
import '../data/response/Status.dart';
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {


  @override
  void initState() {
    super.initState();
    final weatherModel = Provider.of<HomeViewModel>(context,listen: false);
    weatherModel.fetchCurrentData();
    weatherModel.fetchHourlyData();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate= DateFormat("MMMM, d").format(DateTime.now());
    // final weatherProvider = Provider.of<HomeViewModel>(context);
    // final hourlyData= weatherProvider.hourlyData!.hourly;
    return Scaffold(
      // backgroundColor: Colors.deepPurple,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage('https://i.pinimg.com/474x/bf/ce/24/bfce24c33b1c6085caaccb224f000c10.jpg')
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<HomeViewModel>(
                  builder: (context, value, child) {
                    switch (value.currentWeatherList.status) {
                      case Status.LOADING:
                        return Center(child: LoadKitWaterDroplet(
                          size: 60,
                        ));
                      case Status.ERROR:
                        return Center(child: Text(value.currentWeatherList.message.toString()));
                      case Status.COMPLETED:
                        final weather=value.currentWeatherList.data;
                     return Center(
                       child: Column(
                         children: [
                           Text(weather!.name.toString(),
                             style: GoogleFonts.poppins(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w600,letterSpacing: 1),
                           ),
                           Text('${weather.main!.tempCelsius!.toStringAsFixed(0)}°C',
                             style: GoogleFonts.abel(fontSize: 35,color: Colors.white,fontWeight: FontWeight.w400,letterSpacing: 1),
                           ),
                           WeatherInfo(weather: weather),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('Max:${weather.main!.tempMaxCelsius!.toStringAsFixed(0)}°',
                                 style: GoogleFonts.abel(color: Colors.white,fontWeight: FontWeight.w600,letterSpacing: 1),
                               ),
                               SizedBox(width: 10,),
                               Text('Min:${weather.main!.tempMinCelsius!.toStringAsFixed(0)}°',
                                 style: GoogleFonts.abel(color: Colors.white,fontWeight: FontWeight.w600,letterSpacing: 1),
                               ),
                             ],
                           ),
                           SizedBox(height: 30,),
                           Container(
                             height: 400,  // Parent container height
                             width: 400,   // Parent container width
                             child: Padding(
                               padding: const EdgeInsets.only(left: 5.0),
                               child: Stack(
                                 children: [
                                   // First Container
                                   Padding(
                                     padding: const EdgeInsets.only(left: 50.0),
                                     child: Container(
                                       height: 250,
                                       width: 300,
                                       decoration: BoxDecoration(
                                         image: DecorationImage(
                                           image: AssetImage("images/House.png"),
                                           fit: BoxFit.cover,
                                         ),
                                       ),
                                     ),
                                   ),
                                   // Second Container
                                   Transform.translate(
                                     offset: Offset(0, 210), // Adjust this to control the overlap
                                     child: Container(
                                       height: 250,
                                       width: 380,
                                       child: ClipRRect(
                                         borderRadius: BorderRadius.all(Radius.circular(25)),
                                         child: BackdropFilter(
                                           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                           child: Container(
                                             decoration: BoxDecoration(
                                               color: Colors.grey.withOpacity(0.1),
                                               borderRadius: BorderRadius.all(Radius.circular(25)),
                                             ),
                                             child: Column(
                                               children: [
                                                 Padding(
                                                   padding: const EdgeInsets.only(left: 30,top: 10,right: 30),
                                                   child: Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                     children: [
                                                       Text("Today",style: GoogleFonts.poppins(
                                                           fontWeight: FontWeight.w700,color: Colors.white),),
                                                       Text(formattedDate,style: GoogleFonts.poppins(
                                                           fontWeight: FontWeight.w700,color: Colors.white),),
                                                     ],
                                                   ),
                                                 ),
                                                 Divider(),
                                                 SizedBox(height: 10,),
                                                 Expanded(
                                                   child: Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: ListView.builder(
                                                       scrollDirection: Axis.horizontal,
                                                       itemCount: value.hourlyWeatherList.data!.hourly!.time!.length,
                                                       itemBuilder: (context, index) {
                                                         final hourlyData = value.hourlyWeatherList.data;
                                                         final timeFormat = DateTime.parse(hourlyData!.hourly!.time![index].toString());
                                                         final tempCelsius = hourlyData.hourly!.temperature2m![index]; // Already in Celsius
                                                         String formattedTime = DateFormat("hh:mm a").format(timeFormat);
                                                         String weatherIcon = hourlyData.hourly!.getWeatherIcon(tempCelsius);

                                                         return Padding(
                                                           padding: const EdgeInsets.all(8.0),
                                                           child: Container(
                                                             height: 120,
                                                             width: 80,
                                                             decoration: BoxDecoration(
                                                               borderRadius: BorderRadius.circular(30),
                                                               border: Border.all(color: Colors.white),
                                                             ),
                                                             child: Column(
                                                               mainAxisAlignment: MainAxisAlignment.center,
                                                               children: [
                                                                 Text(formattedTime, style: GoogleFonts.poppins(color: Colors.white)),
                                                                 SizedBox(height: 10),
                                                                 Text(weatherIcon, style: TextStyle(fontSize: 30)),
                                                                 SizedBox(height: 10),
                                                                 Text('${tempCelsius.toStringAsFixed(1)}°C', style: GoogleFonts.poppins(color: Colors.white)), // Display Celsius
                                                               ],
                                                             ),
                                                           ),
                                                         );
                                                       },
                                                     ),
                                                   ),
                                                 )

                                               ],
                                             ),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),

                         ],
                       ),
                     );
                      default:
                        return Container();
                   }
                 }),
            ]
                    ),
          ),
      ]
      ),
    );
  }
}
class WeatherInfo extends StatelessWidget {
  final CurrentForeCastModel weather;

  const WeatherInfo({Key? key, required this.weather}) : super(key: key);

  String getCloudDescription(int cloudiness) {
    if (cloudiness == 0) {
      return 'Clear';
    } else if (cloudiness > 0 && cloudiness <= 20) {
      return 'Mostly Clear';
    } else if (cloudiness > 20 && cloudiness <= 50) {
      return 'Partly Cloudy';
    } else if (cloudiness > 50 && cloudiness <= 80) {
      return 'Mostly Cloudy';
    } else if (cloudiness > 80 && cloudiness <= 100) {
      return 'Overcast';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${getCloudDescription(weather.clouds!.all!)}',style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,color: Colors.grey
        ),),
      ],
    );
  }
}

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  const GlassMorphism({
    Key? key,
    required this.child,
    required this.start,
    required this.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(start),
                Colors.white.withOpacity(end),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.5,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
class Hourly {
  // Existing code...
  String getWeatherIcon(double temperatureCelsius) {
    if (temperatureCelsius <= 0) {
      return '❄️'; // Snow icon
    } else if (temperatureCelsius > 0 && temperatureCelsius <= 10) {
      return '🌧️'; // Rain icon
    } else if (temperatureCelsius > 10 && temperatureCelsius <= 20) {
      return '☁️'; // Cloud icon
    } else if (temperatureCelsius > 20 && temperatureCelsius <= 30) {
      return '🌤️'; // Partly sunny icon
    } else {
      return '☀️'; // Sunny icon
    }
  }
}



