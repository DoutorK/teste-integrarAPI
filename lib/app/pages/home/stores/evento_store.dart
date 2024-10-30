import 'package:flutter/material.dart';
import 'package:xotecariri/app/data/http/exceptions.dart';
import 'package:xotecariri/app/data/http/http_client.dart';
import 'package:xotecariri/app/data/models/event_model.dart';
import 'package:xotecariri/app/data/repositories/event_repository.dart';

class EventoStore {

  final IEventRepository repository;
  
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false); 

  final ValueNotifier<List<EventModel>> state =
  ValueNotifier<List<EventModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  EventoStore({required this.repository, required HttpClient client});

  getEventos() async {
    isLoading.value = true;

    try {
    final result = await repository.getEventos();
    state.value = result;

    } on NotFoundException catch (e) {
      erro.value = e.message;
    }
    catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;  
  }
}  