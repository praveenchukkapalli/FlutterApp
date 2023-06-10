import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get userID => getField<String>('User_ID');
  set userID(String? value) => setField<String>('User_ID', value);

  String? get phoneNumber => getField<String>('phone_number');
  set phoneNumber(String? value) => setField<String>('phone_number', value);

  String? get gender => getField<String>('gender');
  set gender(String? value) => setField<String>('gender', value);

  String? get userType => getField<String>('user_type');
  set userType(String? value) => setField<String>('user_type', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  DateTime? get dob => getField<DateTime>('dob');
  set dob(DateTime? value) => setField<DateTime>('dob', value);

  String? get profilePicUrl => getField<String>('profile_pic_url');
  set profilePicUrl(String? value) =>
      setField<String>('profile_pic_url', value);
}
