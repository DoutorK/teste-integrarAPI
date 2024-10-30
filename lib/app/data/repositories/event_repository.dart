import 'dart:convert';

import 'package:xotecariri/app/data/http/exceptions.dart';
import 'package:xotecariri/app/data/http/http_client.dart';
import 'package:xotecariri/app/data/models/event_model.dart';

abstract class IEventRepository {
   Future<List<EventModel>> getEventos();
}

class EventRepository implements IEventRepository {

  final IHttpClient client;

  EventRepository({required this.client});

  @override
  Future<List<EventModel>> getEventos() async {
    final response = await client.get(
      url: 'https://xote-api-development.up.railway.app/xote/get',
    );

    if (response.statusCode == 200){
      final List<EventModel> eventos = [];
    
      final body = jsonDecode(response.body);
 
      body['XoteEventos'].map((item) {
        final EventModel evento = EventModel.fromMap(item);
        eventos.add(evento);

      }).toList();
      return eventos;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não é valida');
    } else {
      throw Exception('Não foi possivel acessar os eventos');
    }
  }
}