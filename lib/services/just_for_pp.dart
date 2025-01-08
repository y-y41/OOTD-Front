// Widget buildWeatherInfo() {
//   if (widget.selectedDate != null && forecastData != null) {
//     // Display forecast data
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.my_location,
//                 color: Colors.black,
//                 size: 24,
//               ),
//               Text(
//                 widget.cityName,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Container(
//                 width: 1,
//                 height: 24,
//                 color: Colors.black,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 DateFormat('yyyy년 MM월 dd일').format(widget.selectedDate!),
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600),
//               )
//             ],
//           ),
//           const SizedBox(height: 20),
//           Text('Temperature: ${forecastData!['main']['temp']}°C'),
//           Text('Feels Like: ${forecastData!['main']['feels_like']}°C'),
//           Text('Humidity: ${forecastData!['main']['humidity']}%'),
//           Text('Wind Speed: ${forecastData!['wind']['speed']} m/s'),
//           Text('Condition: ${forecastData!['weather'][0]['description']}'),
//         ],
//       ),
//     );
//   } else if (weatherData != null) {
//     // Display current weather data
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Current Weather in ${weatherData!.cityName}',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         const SizedBox(height: 20),
//         Text('Temperature: ${weatherData!.temperature}°C'),
//         Text('Feels Like: ${weatherData!.feelsLike}°C'),
//         Text('Condition: ${weatherData!.condition}'),
//         Text('Humidity: ${weatherData!.humidity}%'),
//         Text('Wind Speed: ${weatherData!.windSpeed} m/s'),
//         Text('Rain Volume: ${weatherData!.rainVolume} mm'),
//         const SizedBox(height: 20),
//         Text(
//           'Hourly Forecast',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: weatherData!.hourlyTemperature.entries.map((entry) {
//             return Column(
//               children: [
//                 Text('${entry.key}:00'),
//                 Text('${entry.value}°C'),
//               ],
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//   return const SizedBox.shrink();
// }
