import 'package:wakili/core/storage/storage_preference_manager.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AccountLocalDatasource {
  final SharedPreferencesManager _preferencesManager;

  AccountLocalDatasource(this._preferencesManager);

  Future<void> changeLanguage(String code) async {
    await _preferencesManager.putString(
      SharedPreferencesManager.language,
      code,
    );
  }
}
