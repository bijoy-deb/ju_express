import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/model/common/status_message_res.dart';

import '../../../../core/error/error_message.dart';
import '../../../../domain/usecase/contact_us/i_contact_us_usecase.dart';

part 'contact_us_event.dart';
part 'contact_us_state.dart';

@injectable
class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final IContactUsUseCase _useCase;
  ContactUsBloc(this._useCase) : super(ContactUsInitial()) {
    on<SendMessage>((event, emit) async {
      emit(SendingMessage());
      var result = await _useCase.sendMessage(
          name: event.name,
          email: event.email,
          mobile: event.mobile,
          cCode: event.cCode,
          message: event.message);
      result.fold(
          (l) => emit(MessageSentError(l)), (r) => emit(MessageSent(r)));
    });
  }
}
