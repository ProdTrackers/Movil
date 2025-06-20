// ⚠️ ATENCIÓN: NO TOCAR, FUNCIONA Y NO SÉ PORQUE ⚠️
//
// Este fragmento de código fue escrito entre la 1 y las 4 de la mañana,
// bajo los efectos combinados de cafeína, desesperación y un bug que
// solo se manifiesta cuando nadie lo estaba mirando.
//
// No funciona si lo entiendes.
// No lo entiendes si funciona.
//
// Cualquier intento de refactorizar esto ha resultado en la invocación
// de problemas dimensionales, loops infinitos y un extraño parpadeo en el
// monitor que aún no puedo explicar.
//
// Si necesitas cambiar esto, primero reza, luego haz una copia de seguridad,
// y por último... suerte.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';

class LocateProductScreen extends StatefulWidget {
  final ItemEntity item;

  const LocateProductScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  static const String routeName = '/locate-product';

  @override
  State<LocateProductScreen> createState() => _LocateProductScreenState();
}

class _LocateProductScreenState extends State<LocateProductScreen> {
  static final LatLng genericCenter = LatLng(-12.0902, -77.0503);
  bool _mapReady = false;
  late GoogleMapController _mapController;

  final Marker _productMarker = Marker(
    markerId: MarkerId('product_location'),
    position: LatLng(-12.0902, -77.0503),
    infoWindow: InfoWindow(
      title: 'Producto localizado',
      snippet: 'Ubicación estimada',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localizar: ${widget.item.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: genericCenter,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    setState(() {
                      _mapReady = true;
                    });
                  },
                  markers: {_productMarker},
                ),
                if (!_mapReady)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pantalla para localizar el producto: ${widget.item.name}'),
                  const SizedBox(height: 10),
                  Text('ID del Ítem: ${widget.item.id}'),
                  Text('Tienda ID: ${widget.item.storeId}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Volver a Detalles'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
