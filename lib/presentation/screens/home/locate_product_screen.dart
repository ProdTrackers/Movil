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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;

import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/injection_container.dart';

import '../../bloc/locate_product_bloc.dart';

class LocateProductScreen extends StatelessWidget {
  final ItemEntity item;

  const LocateProductScreen({super.key, required this.item,});

  static const String routeName = '/locate-product';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocateProductBloc>()..add(FetchDeviceLocation(item.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Localizar: ${item.name}'),
        ),
        body: BlocBuilder<LocateProductBloc, LocateProductState>(
          builder: (context, state) {
            if (state is LocateProductLoading || state is LocateProductInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LocateProductLoaded) {
              if (state.iotDevice.latitude == null || state.iotDevice.longitude == null) {
                return _buildErrorOrInfoView(context, "El dispositivo IoT no tiene coordenadas válidas o no fue encontrado.");
              }
              final deviceLocation = latlong.LatLng(state.iotDevice.latitude!, state.iotDevice.longitude!);

              final productMapMarker = Marker(
                  width: 80.0,
                  height: 80.0,
                  point: deviceLocation,
                  child: Tooltip( // <-- Usar 'child' directamente
                    message: "${item.name}\nUbicación actual",
                    child: Icon(Icons.location_pin, color: Colors.red[700], size: 40),
                  )
              );
              return _buildMapAndInfo(context, deviceLocation, productMapMarker);
            } else if (state is LocateProductLocationNotAvailable) {
              return _buildErrorOrInfoView(context, state.message, onRetry: () {
                context.read<LocateProductBloc>().add(FetchDeviceLocation(item.id));
              });
            } else if (state is LocateProductError) {
              return _buildErrorOrInfoView(context, state.message, isError: true, onRetry: () {
                context.read<LocateProductBloc>().add(FetchDeviceLocation(item.id));
              });
            }
            return const Center(child: Text('Estado no manejado o desconocido.'));
          },
        ),
      ),
    );
  }

  Widget _buildMapAndInfo(BuildContext context, latlong.LatLng location, Marker mapMarker) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: location,      // CORREGIDO
              initialZoom: 17.0,          // CORREGIDO
              maxZoom: 18.5,
              minZoom: 3.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.lockitem_movil',
                tileProvider: NetworkTileProvider(), // CORREGIDO (o investiga Caching)
                // attributionBuilder ELIMINADO DE AQUÍ
              ),
              MarkerLayer(
                markers: [mapMarker],
              ),
              SimpleAttributionWidget(    // AÑADIDO
                source: Text(
                  'OpenStreetMap contributors',
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                ),
                alignment: Alignment.bottomRight, // Para posicionarlo
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Localización para: ${item.name}',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              'Coordenadas Actuales:',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Lat: ${location.latitude.toStringAsFixed(6)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Lng: ${location.longitude.toStringAsFixed(6)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver a Detalles'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorOrInfoView(BuildContext context, String message, {bool isError = false, VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.location_off_outlined,
              color: isError ? Theme.of(context).colorScheme.error : Colors.grey[600],
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isError ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}