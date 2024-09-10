import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_message.dart';
import '../../../source/data/model/static_content/static_content_res.dart';
import '../../../source/data/repositories/static_content/i_static_content_repository.dart';
import 'i_static_content_usecase.dart';

@Injectable(as: IStaticContentsUseCase)
class StaticContentsUseCase extends IStaticContentsUseCase {
  late final IStaticContentsRepository _repository;
  StaticContentsUseCase(this._repository);

  @override
  Future<Either<ErrorMessage, StaticContentRes>> getStaticContents() {
    return _repository.getStaticContents();
  }
}
