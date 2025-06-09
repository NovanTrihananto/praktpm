import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class KantorMapsScreen extends StatefulWidget {
  const KantorMapsScreen({super.key});

  @override
  State<KantorMapsScreen> createState() => _KantorMapsScreenState();
}

class _KantorMapsScreenState extends State<KantorMapsScreen> {
  final LatLng kantorPusat = const LatLng(-7.755036379546166, 110.41390543768733); // tambak boyo
  GoogleMapController? mapController;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Minta izin lokasi
    await Permission.location.request();

    // Cek apakah izin diberikan
    if (await Permission.location.isGranted) {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } else {
      // Jika izin ditolak
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin lokasi diperlukan.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = CameraPosition(
      target: _currentPosition ?? kantorPusat,
      zoom: 14,
    );

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('kantorPusat'),
        position: kantorPusat,
        infoWindow: const InfoWindow(title: "Kantor Pusat Kursus Online"),
      ),
      if (_currentPosition != null)
        Marker(
          markerId: const MarkerId('posisiSaya'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: "Posisi Anda Sekarang"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kantor Pusat"),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}
