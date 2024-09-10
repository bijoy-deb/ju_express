import 'package:dartz/dartz.dart';

import '../../../../core/error/error_message.dart';
import '../../../source/data/model/static_content/static_content_res.dart';

abstract class IStaticContentsUseCase {
  Future<Either<ErrorMessage, StaticContentRes>> getStaticContents();
}
