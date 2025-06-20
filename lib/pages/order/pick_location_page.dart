import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({super.key});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  LatLng? _pickedLatLng;
  LatLng? _currentLatLng;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      // Default ke Yogyakarta jika tidak dapat izin
      setState(() {
        _currentLatLng = LatLng(-7.797068, 110.370529);
      });
      return;
    }
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLatLng = LatLng(pos.latitude, pos.longitude);
      _pickedLatLng ??= _currentLatLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi di Map')),
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter:
                    _pickedLatLng ?? _currentLatLng ?? LatLng(50.5, 30.51),
                initialZoom: 16,
                onTap: (tapPosition, point) {
                  setState(() {
                    _pickedLatLng = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (_pickedLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _pickedLatLng!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
      floatingActionButton: _pickedLatLng != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context, _pickedLatLng);
              },
              label: const Text('Pilih Lokasi Ini'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
