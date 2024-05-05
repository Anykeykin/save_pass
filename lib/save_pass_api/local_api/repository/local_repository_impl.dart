import 'package:save_pass/save_pass_api/local_api/datasource/sql_local_service.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';

class LocalRepositoryImpl implements LocalRepository {
  @override
  bool deletePass() {
   return SqlLocalService.deletePass();
  }

  @override
  bool editPass() {
    return SqlLocalService.editPass();
  }

  @override
  getAllPass() {
    // TODO: implement getAllPass
    throw UnimplementedError();
  }

  @override
  readPass() {
    // TODO: implement readPass
    throw UnimplementedError();
  }

  @override
  bool savePass() {
    // TODO: implement savePass
  }
}
