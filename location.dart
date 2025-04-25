import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GeofenceMapPage extends StatefulWidget {
  const GeofenceMapPage({super.key});

  @override
  State<GeofenceMapPage> createState() => _GeofenceMapPageState();
}

class _GeofenceMapPageState extends State<GeofenceMapPage> {
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Geofence Map'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89F7FE), Color(0xFF66A6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: latitude == null || longitude == null
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(latitude!, longitude!),
                        zoom: 16.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: LatLng(latitude!, longitude!),
                              radius: 80, // in meters
                              useRadiusInMeter: true,
                              color: Colors.redAccent.withOpacity(0.3),
                              borderStrokeWidth: 2,
                              borderColor: Colors.redAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Your Current Location",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Latitude: ${latitude!.toStringAsFixed(6)}"),
                              Text("Longitude: ${longitude!.toStringAsFixed(6)}"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _getCurrentLocation,
        label: const Text("Refresh Location"),
        icon: const Icon(Icons.my_location),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location of the Centre"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GeofenceMapPage()),
              );
            },
            icon: const Icon(Icons.map),
            label: const Text("Open Real-Time Map"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
