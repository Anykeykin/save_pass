import 'package:save_pass/save_pass_api/local_api/datasource/sql_local_service.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';

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
  List<PassModel> getAllPass() {
    return SqlLocalService.getAllPass();
  }

  @override
  PassModel readPass() {
    return SqlLocalService.readPass();
  }

  @override
  bool savePass(PassModel passModel) {
    return SqlLocalService.savePass(passModel);
  }

  @override
  openSqlDatabase() {
    return SqlLocalService.openSqlDatabase();
  }
}
