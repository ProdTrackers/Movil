import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockitem_movil/presentation/bloc/store_bloc.dart';
import 'package:lockitem_movil/presentation/widgets/store_list_item.dart';
import 'package:lockitem_movil/injection_container.dart';

class StoreListScreen extends StatelessWidget {
  const StoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StoreBloc>()..add(FetchAllStores()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tiendas Disponibles'),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        body: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state is StoreLoading || state is StoreInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StoreLoaded) {
              if (state.stores.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay tiendas disponibles en este momento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<StoreBloc>().add(FetchAllStores());
                },
                child: ListView.builder(
                  itemCount: state.stores.length,
                  itemBuilder: (context, index) {
                    final store = state.stores[index];
                    return StoreListItem(store: store);
                  },
                ),
              );
            } else if (state is StoreError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[400], size: 50),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                        onPressed: () {
                          context.read<StoreBloc>().add(FetchAllStores());
                        },
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Estado no manejado'));
          },
        ),
      ),
    );
  }
}