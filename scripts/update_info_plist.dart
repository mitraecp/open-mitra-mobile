import 'dart:io';
// ignore_for_file: avoid_print

/// Atualiza o Info.plist com o novo nome do app
Future<void> updateInfoPlist(String appName) async {
  final infoPlistFile = File('ios/Runner/Info.plist');

  if (!await infoPlistFile.exists()) {
    print('❌ Arquivo Info.plist não encontrado!');
    return;
  }

  String content = await infoPlistFile.readAsString();

  // Expressão regular corrigida para lidar com ${PRODUCT_NAME}
  final displayNameRegex = RegExp(
    r'(<key>CFBundleDisplayName<\/key>\s*<string>)([\s\S]*?)(<\/string>)',
    multiLine: true,
  );

  // Verifica se o CFBundleDisplayName já existe
  if (displayNameRegex.hasMatch(content)) {
    // Substitui o valor existente pelo novo nome do app
    content = content.replaceAllMapped(displayNameRegex, (match) {
      return '${match.group(1)}$appName${match.group(3)}';
    });
    print('✅ CFBundleDisplayName atualizado.');
  } else {
    // Se não existir, adiciona a chave antes do fechamento do dicionário principal
    const dictCloseTag = '</dict>';
    final newEntry = '\n\t<key>CFBundleDisplayName</key>\n\t<string>$appName</string>';
    if (content.contains(dictCloseTag)) {
      content = content.replaceFirst(dictCloseTag, '$newEntry\n$dictCloseTag');
      print('✅ CFBundleDisplayName adicionado.');
    } else {
      print('❌ Estrutura do Info.plist não está no formato esperado.');
      return;
    }
  }

  await infoPlistFile.writeAsString(content);
  print('✅ Info.plist atualizado com sucesso.');
}
