import 'package:dartz/dartz.dart';
import 'package:ju_express/core/error/error_message.dart';
import 'package:ju_express/source/data/model/home/home_page_int_res.dart';

abstract class IHomeRepository {
  Future<Either<ErrorMessage, HomePageIntRes>> getHomePageInt();
}
