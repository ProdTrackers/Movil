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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';

import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/injection_container.dart';

import '../../bloc/locate_product_bloc.dart';

class LocateProductScreen extends StatefulWidget {
  final ItemEntity item;

  const LocateProductScreen({
    super.key,
    required this.item,
  });

  static const String routeName = '/locate-product';

  @override
  State<LocateProductScreen> createState() => _LocateProductScreenState();
}

class _LocateProductScreenState extends State<LocateProductScreen> {
  latlong.LatLng? _userLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoadingUserLocation = true;
  String? _userLocationError;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() {
      _isLoadingUserLocation = true;
      _userLocationError = null;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _userLocationError = 'Los servicios de ubicación están desactivados.';
          _isLoadingUserLocation = false;
        });
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _userLocationError = 'Se denegaron los permisos de ubicación.';
            _isLoadingUserLocation = false;
          });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _userLocationError =
          'Los permisos de ubicación están denegados permanentemente.';
          _isLoadingUserLocation = false;
        });
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _userLocation = latlong.LatLng(position.latitude, position.longitude);
          _isLoadingUserLocation = false;
        });
        _fitBoundsIfNeeded(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userLocationError = 'Error al obtener la ubicación del usuario: ${e.toString()}';
          _isLoadingUserLocation = false;
        });
        print("Error en _determinePosition: $e");
      }
    }
  }

  void _fitBoundsIfNeeded(BuildContext blocContext) {
    if (!mounted) {
      print("_fitBoundsIfNeeded llamado pero el widget no está montado.");
      return;
    }

    LocateProductState productState;
    try {
      productState = blocContext.read<LocateProductBloc>().state;
    } catch (e) {
      print(
          "Error al leer LocateProductBloc en _fitBoundsIfNeeded: $e. El BLoC podría no estar listo o el contexto es incorrecto.");
      return;
    }

    if (productState is LocateProductLoaded &&
        _userLocation != null &&
        productState.iotDevice.latitude != null &&
        productState.iotDevice.longitude != null) {
      final productLocation = latlong.LatLng(
          productState.iotDevice.latitude!, productState.iotDevice.longitude!);

      var bounds = LatLngBounds.fromPoints([_userLocation!, productLocation]);
      try {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(50.0),
          ),
        );
        print("Map bounds fitted successfully.");
      } catch (e) {
        print("Error al ajustar límites del mapa en _fitBoundsIfNeeded (posiblemente mapa no completamente listo internamente): $e");
      }
    } else {
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocateProductBloc>()
        ..add(FetchDeviceLocation(widget.item.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Localizar: ${widget.item.name}'),
          actions: [
            if (_userLocationError != null || _isLoadingUserLocation)
              IconButton(
                icon: const Icon(Icons.my_location),
                tooltip: _isLoadingUserLocation
                    ? "Obteniendo tu ubicación..."
                    : "Reintentar obtener tu ubicación",
                onPressed: _isLoadingUserLocation ? null : _determinePosition,
              )
          ],
        ),
        body: BlocConsumer<LocateProductBloc, LocateProductState>(
          listener: (listenerContext, productState) {
            if (productState is LocateProductLoaded) {
            }
          },
          builder: (builderContext, productState) {
            if (productState is LocateProductLoading || productState is LocateProductInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (productState is LocateProductError) {
              print("Error al cargar la ubicación del producto (LocateProductBloc): ${productState.message}");
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No se pudo cargar la información de ubicación del producto.", textAlign: TextAlign.center),
                ),
              );
            } else if (productState is LocateProductLocationNotAvailable) {
              print("Ubicación del producto no disponible (LocateProductBloc): ${productState.message}");
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("La ubicación de este producto no está disponible actualmente.", textAlign: TextAlign.center),
                ),
              );
            } else if (productState is LocateProductLoaded) {
              if (productState.iotDevice.latitude == null ||
                  productState.iotDevice.longitude == null) {
                print("Datos de ubicación del producto incompletos (LocateProductBloc): Dispositivo ID ${widget.item.id}, IoT ID ${productState.iotDevice.id}");
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Información de ubicación del producto incompleta.", textAlign: TextAlign.center),
                  ),
                );
              }

              final deviceLocation = latlong.LatLng(
                  productState.iotDevice.latitude!,
                  productState.iotDevice.longitude!);

              List<Marker> markers = [];
              markers.add(Marker(
                  width: 80.0,
                  height: 80.0,
                  point: deviceLocation,
                  child: Tooltip(
                    message: "${widget.item.name}\nUbicación actual",
                    child: Icon(Icons.location_pin,
                        color: Colors.red[700], size: 40),
                  )));

              if (_userLocation != null) {
                markers.add(Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _userLocation!,
                    child: Tooltip(
                      message: "Tu ubicación",
                      child: Icon(Icons.person_pin_circle,
                          color: Theme.of(builderContext).primaryColor, size: 40),
                    )));
              }

              String distanceText = "";
              if (_userLocation != null) {
                final distanceInMeters = Geolocator.distanceBetween(
                  _userLocation!.latitude,
                  _userLocation!.longitude,
                  deviceLocation.latitude,
                  deviceLocation.longitude,
                );
                if (distanceInMeters > 1000) {
                  distanceText =
                  "Distancia: ${(distanceInMeters / 1000).toStringAsFixed(1)} km";
                } else {
                  distanceText =
                  "Distancia: ${distanceInMeters.toStringAsFixed(0)} m";
                }
              }

              latlong.LatLng initialMapCenter = deviceLocation;
              double initialMapZoom = 13.0;

              return _buildMapAndInfo(builderContext, builderContext,
                  initialMapCenter, initialMapZoom, markers, distanceText);
            }
            print("Estado no manejado en LocateProductScreen builder: $productState");
            return const Center(child: Text("Cargando información..."));
          },
        ),
      ),
    );
  }

  Widget _buildMapAndInfo(
      BuildContext mapUiContext,
      BuildContext contextForFitBounds,
      latlong.LatLng initialCenter,
      double initialZoom,
      List<Marker> markers,
      String distanceText) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: initialZoom,
              maxZoom: 18.5,
              minZoom: 3.0,
              onMapReady: () {
                print("Mapa listo (onMapReady callback)!");
                _fitBoundsIfNeeded(contextForFitBounds);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.prodtrackers.lockitem_movil',
                tileProvider: NetworkTileProvider(),
              ),
              MarkerLayer(
                markers: markers,
              ),
              if (_userLocation != null &&
                  markers.any((m) => m.point == _userLocation) &&
                  markers.any((m) => m.point != _userLocation))
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [
                        _userLocation!,
                        markers.firstWhere((m) => m.point != _userLocation!).point
                      ],
                      strokeWidth: 4.0,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors',
                    style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                alignment: Alignment.bottomRight,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Localización para: ${widget.item.name}',
                      style: Theme.of(mapUiContext).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingUserLocation)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(strokeWidth: 2),
                          SizedBox(width: 8),
                          Text("Obteniendo tu ubicación...")
                        ],
                      )
                    else if (_userLocationError != null)
                      Text(
                        "Tu ubicación: $_userLocationError",
                        style: TextStyle(color: Colors.orange[700]),
                        textAlign: TextAlign.center,
                      )
                    else if (_userLocation != null)
                        Text(
                          "Tu ubicación: Lat: ${_userLocation!.latitude.toStringAsFixed(3)}, Lng: ${_userLocation!.longitude.toStringAsFixed(3)}",
                          textAlign: TextAlign.center,
                        ),
                    if (distanceText.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(distanceText,
                          style: Theme.of(mapUiContext).textTheme.titleMedium,
                          textAlign: TextAlign.center),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver a Detalles'),
                      onPressed: () => Navigator.pop(mapUiContext),
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


// Muestra los errores en pantalla
/*
  Widget _buildErrorOrInfoView(BuildContext errorContext, String message,
          {bool isError = false, VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.location_off_outlined,
              color: isError
                  ? Theme.of(errorContext).colorScheme.error
                  : Colors.grey[600],
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: isError
                      ? Theme.of(errorContext).colorScheme.error
                      : Theme.of(errorContext).textTheme.bodyLarge?.color),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar Carga del Producto'),
                onPressed: onRetry,
              )
            ]
          ],
        ),
      ),
    );
  }
  */
}