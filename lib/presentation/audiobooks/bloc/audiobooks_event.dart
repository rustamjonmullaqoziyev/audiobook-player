part of 'audiobooks_bloc.dart';

abstract class AudiobooksEvent {}

class GetAudiobook extends AudiobooksEvent {}

class GetAudiobookFromLocalDatabase extends AudiobooksEvent {}
