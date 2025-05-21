import 'dart:convert';
import 'package:intl/intl.dart';

// Top-level function to parse the entire API response
EmployeeResponse employeeResponseFromJson(String str) => EmployeeResponse.fromJson(json.decode(str));

String employeeResponseToJson(EmployeeResponse data) => json.encode(data.toJson());

class EmployeeResponse {
  List<Employee> results;
  Info info;

  EmployeeResponse({
    required this.results,
    required this.info,
  });

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) => EmployeeResponse(
    results: List<Employee>.from(json["results"].map((x) => Employee.fromJson(x))),
    info: Info.fromJson(json["info"]),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "info": info.toJson(),
  };
}

class Employee {
  Gender? gender;
  Name? name;
  Location? location;
  String? email;
  Login? login;
  Dob? dob;
  Dob? registered;
  String? phone;
  String? cell;
  Id? id;
  Picture? picture;
  String? nat;

  Employee({
    this.gender,
    this.name,
    this.location,
    this.email,
    this.login,
    this.dob,
    this.registered,
    this.phone,
    this.cell,
    this.id,
    this.picture,
    this.nat,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    gender: json["gender"] != null ? genderValues.map[json["gender"]] : null,
    name: json["name"] != null ? Name.fromJson(json["name"]) : null,
    location: json["location"] != null ? Location.fromJson(json["location"]) : null,
    email: json["email"],
    login: json["login"] != null ? Login.fromJson(json["login"]) : null,
    dob: json["dob"] != null ? Dob.fromJson(json["dob"]) : null,
    registered: json["registered"] != null ? Dob.fromJson(json["registered"]) : null,
    phone: json["phone"],
    cell: json["cell"],
    id: json["id"] != null ? Id.fromJson(json["id"]) : null,
    picture: json["picture"] != null ? Picture.fromJson(json["picture"]) : null,
    nat: json["nat"],
  );

  Map<String, dynamic> toJson() => {
    "gender": gender != null ? genderValues.reverse[gender] : null,
    "name": name?.toJson(),
    "location": location?.toJson(),
    "email": email,
    "login": login?.toJson(),
    "dob": dob?.toJson(),
    "registered": registered?.toJson(),
    "phone": phone,
    "cell": cell,
    "id": id?.toJson(),
    "picture": picture?.toJson(),
    "nat": nat,
  };

  // Getters for formatted fields with null safety
  String get fullName => name != null
      ? '${name!.title.toString().split('.').last} ${name!.first} ${name!.last}'
      : 'Unknown';
  String get dobDate {
    if (dob != null && dob!.date != null) {
      return DateFormat('dd MMM, yyyy').format(dob!.date!);
    }
    return 'N/A';
  }
  String get registeredDate {
    if (registered != null && registered!.date != null) {
      return DateFormat('dd MMM, yyyy').format(registered!.date!);
    }
    return 'N/A';
  }
  String get genderString => gender != null
      ? gender.toString().split('.').last.toUpperCase()[0] + gender.toString().split('.').last.substring(1).toLowerCase()
      : 'N/A';
  String get pictureUrl => picture?.large ?? 'https://via.placeholder.com/150';
}

class Dob {
  DateTime? date;
  int? age;

  Dob({
    this.date,
    this.age,
  });

  factory Dob.fromJson(Map<String, dynamic> json) => Dob(
    date: json["date"] != null ? DateTime.parse(json["date"]) : null,
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "date": date?.toIso8601String(),
    "age": age,
  };
}

enum Gender {
  FEMALE,
  MALE
}

final genderValues = EnumValues({
  "female": Gender.FEMALE,
  "male": Gender.MALE
});

class Id {
  String? name;
  String? value;

  Id({
    this.name,
    this.value,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };
}

class Location {
  Street? street;
  String? city;
  String? state;
  String? country;
  dynamic postcode;
  Coordinates? coordinates;
  Timezone? timezone;

  Location({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.coordinates,
    this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    street: json["street"] != null ? Street.fromJson(json["street"]) : null,
    city: json["city"],
    state: json["state"],
    country: json["country"],
    postcode: json["postcode"],
    coordinates: json["coordinates"] != null ? Coordinates.fromJson(json["coordinates"]) : null,
    timezone: json["timezone"] != null ? Timezone.fromJson(json["timezone"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "street": street?.toJson(),
    "city": city,
    "state": state,
    "country": country,
    "postcode": postcode,
    "coordinates": coordinates?.toJson(),
    "timezone": timezone?.toJson(),
  };
}

class Coordinates {
  String? latitude;
  String? longitude;

  Coordinates({
    this.latitude,
    this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Street {
  int? number;
  String? name;

  Street({
    this.number,
    this.name,
  });

  factory Street.fromJson(Map<String, dynamic> json) => Street(
    number: json["number"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "name": name,
  };
}

class Timezone {
  String? offset;
  String? description;

  Timezone({
    this.offset,
    this.description,
  });

  factory Timezone.fromJson(Map<String, dynamic> json) => Timezone(
    offset: json["offset"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "offset": offset,
    "description": description,
  };
}

class Login {
  String? uuid;
  String? username;
  String? password;
  String? salt;
  String? md5;
  String? sha1;
  String? sha256;

  Login({
    this.uuid,
    this.username,
    this.password,
    this.salt,
    this.md5,
    this.sha1,
    this.sha256,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    uuid: json["uuid"],
    username: json["username"],
    password: json["password"],
    salt: json["salt"],
    md5: json["md5"],
    sha1: json["sha1"],
    sha256: json["sha256"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "username": username,
    "password": password,
    "salt": salt,
    "md5": md5,
    "sha1": sha1,
    "sha256": sha256,
  };
}

class Name {
  Title? title;
  String? first;
  String? last;

  Name({
    this.title,
    this.first,
    this.last,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    title: json["title"] != null ? titleValues.map[json["title"]] : null,
    first: json["first"],
    last: json["last"],
  );

  Map<String, dynamic> toJson() => {
    "title": title != null ? titleValues.reverse[title] : null,
    "first": first,
    "last": last,
  };
}

enum Title {
  Miss,
  Mr,
  Mrs,
  Ms
}

final titleValues = EnumValues({
  "Miss": Title.Miss,
  "Mr": Title.Mr,
  "Mrs": Title.Mrs,
  "Ms": Title.Ms
});

class Picture {
  String? large;
  String? medium;
  String? thumbnail;

  Picture({
    this.large,
    this.medium,
    this.thumbnail,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    large: json["large"],
    medium: json["medium"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "large": large,
    "medium": medium,
    "thumbnail": thumbnail,
  };
}

class Info {
  String? seed;
  int? results;
  int? page;
  String? version;

  Info({
    this.seed,
    this.results,
    this.page,
    this.version,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    seed: json["seed"],
    results: json["results"],
    page: json["page"],
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "seed": seed,
    "results": results,
    "page": page,
    "version": version,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}