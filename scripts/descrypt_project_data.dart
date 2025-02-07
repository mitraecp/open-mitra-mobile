// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart';

const String SECRET_KEY = 'chave-open-mitra-publish';
const String CONFIG_FILE_PATH = 'lib/settings/project_config.dart';

Future<void> main(List<String> arguments) async {
  print('🔄 Iniciando descriptografia...');
  if (arguments.isEmpty) {
    print('❌ Nenhuma chave criptografada fornecida!');
    return;
  }

  final encryptedData = arguments[0];
  print('🔄 Descriptografando dados do projeto...');

  try {
    final decryptedJson = decryptProjectData(encryptedData);
    final Map<String, dynamic> data = jsonDecode(decryptedJson);
    print('✅ Descriptografado com sucesso!');
    print('🔄 Atualizando configurações do projeto...');
    await updateProjectConfig(data);
    print('✅ Configuração atualizada com sucesso!');
  } catch (e) {
    print('❌ Erro ao processar os dados: $e');
  }
}

String decryptProjectData(String encryptedData) {
  final key = Key.fromUtf8(SECRET_KEY.padRight(32, ' '));
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

  final encryptedParts = encryptedData.split(':');
  if (encryptedParts.length != 2) {
    throw Exception('Formato inválido de dado criptografado');
  }

  final iv = IV.fromBase64(encryptedParts[0]);
  final decrypted = encrypter.decrypt64(encryptedParts[1], iv: iv);

  return decrypted;
}

Future<void> updateProjectConfig(Map<String, dynamic> data) async {
  final configFile = File(CONFIG_FILE_PATH);

  if (!await configFile.exists()) {
    print('❌ Arquivo de configuração não encontrado!');
    return;
  }

  String content = await configFile.readAsString();

  content = content
      .replaceAll(RegExp(r"String\s+appName\s*=\s*'[^']*';"),
          "String appName = '${data['name']}';")
      .replaceAll(RegExp(r"String\s+appDomain\s*=\s*'[^']*';"),
          "String appDomain = '${data['dns']}';")
      .replaceAll(RegExp(r"int\s+appWorkspaceId\s*=\s*\d+;"),
          "int appWorkspaceId = ${int.tryParse(data['workspaceId'].toString()) ?? 0};")
      .replaceAll(RegExp(r"int\s+appProjectId\s*=\s*\d+;"),
          "int appProjectId = ${int.tryParse(data['id'].toString()) ?? 0};")
      .replaceAll(RegExp(r"String\s+appProjectLogoUrl\s*=\s*'[^']*';"),
          "String appProjectLogoUrl = '${data['icon']}';")
      .replaceAll(RegExp(r"String\s+appProjectLocalLogoPath\s*=\s*'[^']*';"),
          "String appProjectLocalLogoPath = '${data['icon']}';")
      .replaceAll(RegExp(r"String\s+appProjectName\s*=\s*'[^']*';"),
          "String appProjectName = '${data['name']}';")
      .replaceAll(RegExp(r"String\s+appProjectPrimaryColor\s*=\s*'[^']*';"),
          "String appProjectPrimaryColor = '${data['color']}';");

  await configFile.writeAsString(content);
}
