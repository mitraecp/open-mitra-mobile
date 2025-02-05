import 'dart:io';
// ignore_for_file: avoid_print

/// Atualiza o pubspec.yaml com o novo nome e ícone
Future<void> updatePubspec(String appName, String iconPath) async {
  final pubspecFile = File('pubspec.yaml');

  if (!await pubspecFile.exists()) {
    print('❌ Arquivo pubspec.yaml não encontrado!');
    return;
  }

  String content = await pubspecFile.readAsString();

  // Expressão regular para encontrar a configuração do flutter_launcher_icons que contém image_path
  final launcherIconsRegex = RegExp(r'flutter_launcher_icons:\n(\s{2,}android: true[\s\S]*?image_path:\s*"[^"]+"[\s\S]*?)(?=\n\w|$)', multiLine: true);
  final launcherIconsMatch = launcherIconsRegex.firstMatch(content);

  if (launcherIconsMatch != null) {
    // Mantém o conteúdo original, mas substitui apenas o image_path
    String updatedLauncherIcons = launcherIconsMatch.group(1)!.replaceAll(
        RegExp(r'image_path:\s*"[^"]+"'), 'image_path: "$iconPath"');
    content = content.replaceAll(launcherIconsRegex, 'flutter_launcher_icons:\n$updatedLauncherIcons');
  } else {
    content += '''

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "$iconPath"
  remove_alpha_ios: true
''';
  }

  // Substitui as configurações do launcher_name
  final newAppNameConfig = '''
launcher_name:
  default: "$appName"
''';

  // Verifica se já existe a configuração de launcher_name
  if (RegExp(r'launcher_name:\n(\s+default: [^\n]+[\s\S]*?)(?=\n\w|$)', multiLine: true).hasMatch(content)) {
    content = content.replaceAll(
        RegExp(r'launcher_name:\n(\s+default: [^\n]+[\s\S]*?)(?=\n\w|$)', multiLine: true),
        newAppNameConfig);
  } else {
    content += '\n$newAppNameConfig'; // Adiciona ao final se não existir
  }

  await pubspecFile.writeAsString(content);
  print('✅ pubspec.yaml atualizado com sucesso.');
}
