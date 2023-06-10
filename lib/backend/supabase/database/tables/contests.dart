import '../database.dart';

class ContestsTable extends SupabaseTable<ContestsRow> {
  @override
  String get tableName => 'contests';

  @override
  ContestsRow createRow(Map<String, dynamic> data) => ContestsRow(data);
}

class ContestsRow extends SupabaseDataRow {
  ContestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ContestsTable();

  String get contestId => getField<String>('contest_id')!;
  set contestId(String value) => setField<String>('contest_id', value);

  String? get hostName => getField<String>('host_name');
  set hostName(String? value) => setField<String>('host_name', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  int? get prizeMoney => getField<int>('prize_money');
  set prizeMoney(int? value) => setField<int>('prize_money', value);

  List<String> get participants => getListField<String>('participants');
  set participants(List<String>? value) =>
      setListField<String>('participants', value);

  List<String> get winners => getListField<String>('winners');
  set winners(List<String>? value) => setListField<String>('winners', value);

  String? get contestTitle => getField<String>('contest_title');
  set contestTitle(String? value) => setField<String>('contest_title', value);

  String? get contestDescription => getField<String>('contest_description');
  set contestDescription(String? value) =>
      setField<String>('contest_description', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);
}
