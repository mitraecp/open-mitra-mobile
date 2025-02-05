// ignore_for_file: avoid_print

import 'dart:io';

import 'update_info_plist.dart';
import 'uptate_pubspec.dart';

Future<void> main() async {
  print('🔄 Iniciando atualização do nome e ícone do app...');

  // Caminho do arquivo de configuração
  final configFile = File('lib/settings/project_config.dart');

  if (!await configFile.exists()) {
    print('❌ Arquivo de configuração não encontrado!');
    return;
  }

  // Lê o conteúdo do arquivo
  final content = await configFile.readAsString();

  // Expressões regulares para extrair os valores desejados
  final appNameRegex = RegExp(r"String\s+appName\s*=\s*'([^']+)';");
  final iconRegex =
      RegExp(r"String\s+appLocalAppImageIconPath\s*=\s*'([^']+)';");

  final appNameMatch = appNameRegex.firstMatch(content);
  final iconMatch = iconRegex.firstMatch(content);

  if (appNameMatch == null ||
      iconMatch == null ||
      appNameMatch.group(1)?.trim() == '' ||
      iconMatch.group(1)?.trim() == '') {
    print(
        '❌ Não foi possível encontrar as configurações esperadas no arquivo.');
    return;
  }

  final appName = appNameMatch.group(1);
  final iconPath = iconMatch.group(1);

  print('✅ Nome do App: $appName');
  print('✅ Caminho do Ícone: $iconPath');

  // Atualiza o pubspec.yaml para refletir as mudanças
  await updatePubspec(appName!, iconPath!);

  // Executa flutter_launcher_icons para aplicar as mudanças
  await runCommand('flutter', ['pub', 'get']);
  await runCommand('dart', ['run', 'flutter_launcher_icons']);
  await runCommand('dart', ['run', 'launcher_name:main']);

  // Atualiza o Info.plist para refletir as mudanças do nome
  await updateInfoPlist(appName);

  print('✅ Configuração concluída!');
}

/// Executa um comando no terminal
Future<void> runCommand(String command, List<String> args) async {
  final result = await Process.run(command, args, runInShell: true);
  print(result.stdout);
  print(result.stderr);
}
