
class Bluetooth_shared {
  String name;
  String address;
  int type;
  bool isConnected;
  int bondState;

  //name: HC-06, address: 98:D3:31:F4:1B:4E, type: 1, isConnected: false, bondState: 12

  Bluetooth_shared();

  Bluetooth_shared.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        address = json['adress'],
        type = json['type'],
        isConnected = json['isConnected'],
        bondState = json['bondState'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'adress': address,
    'type': type,
    'isConnected:': isConnected,
    'bondState':bondState,
  };
}