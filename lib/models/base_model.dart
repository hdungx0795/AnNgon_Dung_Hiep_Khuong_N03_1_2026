abstract class BaseModel<ID> {
  ID get id;
  Map<String, dynamic> toJson();
}
