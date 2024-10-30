import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importação do url_launcher
import 'package:xotecariri/app/data/http/http_client.dart';
import 'package:xotecariri/app/data/repositories/event_repository.dart';
import 'package:xotecariri/app/pages/home/stores/evento_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EventoStore store = EventoStore(
    repository: EventRepository(
      client: HttpClient(),
    ),
    client: HttpClient(),
  );

  @override
  void initState() {
    super.initState();
    store.getEventos();
  }

  // Função para abrir a URL
  Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o URL $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Consumo da API',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          store.isLoading,
          store.erro,
          store.state,
        ]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.erro.value.isNotEmpty) {
            return Center(
              child: Text(
                store.erro.value,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (store.state.value.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum item na lista',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          // Renderiza a lista de eventos
          return ListView.builder(
            itemCount: store.state.value.length,
            itemBuilder: (context, index) {
              final evento = store.state.value[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(evento.image_url),
                      const SizedBox(height: 8.0),
                      Text(
                        evento.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        evento.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Data: ${evento.date}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Hora: ${evento.time}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Tipo: ${evento.type}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Pagamento: ${evento.pay ? 'Sim' : 'Não'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para abrir o link do Google Maps
                          launchUrl(evento.localgoogleurl);
                        },
                        child: const Text('Ver no Google Maps'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
