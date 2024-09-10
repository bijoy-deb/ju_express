import 'package:dartz/dartz.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/static_content/static_content_res.dart';

abstract class IStaticContentsRepository {
  Future<Either<ErrorMessage, StaticContentRes>> getStaticContents();
}
