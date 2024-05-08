import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'passwords_event.dart';
part 'passwords_state.dart';

class PasswordsBloc extends Bloc<PasswordsEvent, PasswordsState> {
  PasswordsBloc() : super(PasswordsInitial()) {
    on<PasswordsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
