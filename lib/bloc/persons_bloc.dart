import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/bloc_actions.dart';
import 'package:testingbloc_course/bloc/person.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoreingOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

@immutable
class FetchResults {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResults(
      {required this.persons, required this.isRetrievedFromCache});

  @override
  String toString() =>
      'FetchResults (isRetrievedFromCache = $isRetrievedFromCache, persons= $persons)';

  @override
  bool operator ==(covariant FetchResults other) =>
      persons.isEqualToIgnoreingOrdering(other.persons) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrievedFromCache);
}

class PersonsBloc extends Bloc<LoadAction, FetchResults?> {
  final Map<String, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cacheResults = _cache[url]!;
          final persons = FetchResults(
            persons: cacheResults,
            isRetrievedFromCache: true,
          );
          emit(persons);
        } else {
          final loader = event.loader;
          final persons = await loader(url);
          _cache[url] = persons;
          final results = FetchResults(
            persons: persons,
            isRetrievedFromCache: false,
          );
          emit(results);
        }
      },
    );
  }
}
