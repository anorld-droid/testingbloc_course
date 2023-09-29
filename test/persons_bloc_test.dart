// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:testingbloc_course/bloc/bloc_actions.dart';
// import 'package:testingbloc_course/bloc/person.dart';
// import 'package:testingbloc_course/bloc/persons_bloc.dart';

// const mockedPersons1 = [
//   Person(
//     name: 'Foo 1',
//     age: 21,
//   ),
//   Person(
//     name: 'Bar 1',
//     age: 34,
//   ),
// ];

// const mockedPersons2 = [
//   Person(
//     name: 'Foo 1',
//     age: 21,
//   ),
//   Person(
//     name: 'Bar 1',
//     age: 34,
//   ),
// ];

// Future<Iterable<Person>> mockGetPersons1(String _) =>
//     Future.value(mockedPersons1);
// Future<Iterable<Person>> mockGetPersons2(String _) =>
//     Future.value(mockedPersons2);

// void main() {
//   group(
//     'Testing bloc',
//     () {
//       late PersonsBloc bloc;

//       setUp(
//         () => bloc = PersonsBloc(),
//       );

//       blocTest<PersonsBloc, FetchResults?>(
//         'Test initial State',
//         build: () => bloc,
//         verify: (bloc) => expect(bloc.state, null),
//       );

//       //fecth mock data(persons1) and compare it with fetch results
//       blocTest<PersonsBloc, FetchResults?>(
//         'Mock retrieving persons from first iterable',
//         build: () => bloc,
//         act: (bloc) {
//           bloc.add(
//             const LoadPersonsAction(
//               url: 'dummy_url_1',
//               loader: mockGetPersons1,
//             ),
//           );
//           bloc.add(
//             const LoadPersonsAction(
//               url: 'dummy_url_1',
//               loader: mockGetPersons1,
//             ),
//           );
//         },
//         expect: () => [
//           const FetchResults(
//             persons: mockedPersons1,
//             isRetrievedFromCache: false,
//           ),
//           const FetchResults(
//             persons: mockedPersons1,
//             isRetrievedFromCache: true,
//           ),
//         ],
//       );

//       //fecth mock data(persons2) and compare it with fetch results
//       blocTest<PersonsBloc, FetchResults?>(
//         'Mock retrieving persons from second iterable',
//         build: () => bloc,
//         act: (bloc) {
//           bloc.add(
//             const LoadPersonsAction(
//               url: 'dummy_url_2',
//               loader: mockGetPersons2,
//             ),
//           );
//           bloc.add(
//             const LoadPersonsAction(
//               url: 'dummy_url_2',
//               loader: mockGetPersons2,
//             ),
//           );
//         },
//         expect: () => [
//           const FetchResults(
//             persons: mockedPersons2,
//             isRetrievedFromCache: false,
//           ),
//           const FetchResults(
//             persons: mockedPersons2,
//             isRetrievedFromCache: true,
//           ),
//         ],
//       );
//     },
//   );
// }
