import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static late final enc.Encrypter _aesEncrypter;
  static late final Chacha20 _chacha20;
  static late final SecretKey _chachaKey;
  static late final List<int> _hiveKey;

  static Future<void> init() async {
    String? aesKey = await _storage.read(key: 'aes_key_v1');
    if (aesKey == null) {
      final key = enc.Key.fromSecureRandom(32);
      aesKey = base64.encode(key.bytes);
      await _storage.write(key: 'aes_key_v1', value: aesKey);
    }
    _aesEncrypter = enc.Encrypter(enc.AES(enc.Key(base64.decode(aesKey))));

    String? chachaKeyStr = await _storage.read(key: 'chacha_key_v1');
    if (chachaKeyStr == null) {
      final key = await Chacha20().newSecretKey();
      chachaKeyStr = base64.encode(await key.extractBytes());
      await _storage.write(key: 'chacha_key_v1', value: chachaKeyStr);
    }
    _chacha20 = Chacha20();
    _chachaKey = SecretKey(base64.decode(chachaKeyStr));

    String? hiveKeyStr = await _storage.read(key: 'hive_key_v1');
    if (hiveKeyStr == null) {
      _hiveKey = Hive.generateSecureKey();
      await _storage.write(key: 'hive_key_v1', value: base64.encode(_hiveKey));
    } else {
      _hiveKey = base64.decode(hiveKeyStr);
    }
  }

  static Future<String> encryptTriple(String plainText) async {
    final iv = enc.IV.fromSecureRandom(16);
    final aesEncrypted = _aesEncrypter.encrypt(plainText, iv: iv);
    final layer1 = '${aesEncrypted.base64}:${iv.base64}';
    final nonce = _chacha20.newNonce();
    final chachaEncrypted = await _chacha20.encrypt(
      utf8.encode(layer1), secretKey: _chachaKey, nonce: nonce);
    final layer2 = '${base64.encode(nonce)}:${base64.encode(chachaEncrypted.cipherText)}';
    return base64.encode(utf8.encode(layer2));
  }

  static Future<String> decryptTriple(String encryptedText) async {
    final layer2 = utf8.decode(base64.decode(encryptedText));
    final parts2 = layer2.split(':');
    final nonce = base64.decode(parts2[0]);
    final cipherText = base64.decode(parts2[1]);
    final chachaDecrypted = await _chacha20.decrypt(
      SecretBox(cipherText, nonce: nonce, mac: Mac.empty), secretKey: _chachaKey);
    final layer1 = utf8.decode(chachaDecrypted);
    final parts1 = layer1.split(':');
    final aesData = parts1[0];
    final iv = enc.IV.fromBase64(parts1[1]);
    return _aesEncrypter.decrypt64(aesData, iv: iv);
  }

  static HiveCipher getHiveCipher() => HiveAesCipher(_hiveKey);
}
