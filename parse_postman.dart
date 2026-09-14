import 'dart:convert';
import 'dart:io';

void parseItem(Map<String, dynamic> item, String prefix) {
  if (item.containsKey('item')) {
    // It's a folder
    print('$prefix[Folder] ${item['name']}');
    for (var subItem in item['item']) {
      parseItem(subItem, '$prefix  ');
    }
  } else if (item.containsKey('request')) {
    // It's a request
    var req = item['request'];
    var method = req['method'];
    var url = '';
    if (req['url'] is Map) {
      url = req['url']['raw'] ?? '';
    } else if (req['url'] is String) {
      url = req['url'];
    }
    print('$prefix- [${item['name']}] $method $url');
  }
}

void main() {
  final file = File('rocket_mobile_api.postman_collection.json');
  final jsonString = file.readAsStringSync();
  final data = jsonDecode(jsonString);
  
  print('Collection: ${data['info']['name']}');
  
  for (var item in data['item']) {
    parseItem(item, '');
  }
}
