import 'package:dartz/dartz.dart';
import 'package:ju_express/source/data/model/home/home_page_int_res.dart';

import '../../../../core/error/error_message.dart';

abstract class IHomeUseCase {
  Future<Either<ErrorMessage, HomePageIntRes>> getHomePageInt();
}
