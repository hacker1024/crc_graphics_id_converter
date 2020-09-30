import 'crc32.dart';

String convertGraphicsBaseId(int baseId) => CRC32.compute('graphics_area_info_obj$baseId').toString();
