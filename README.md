# Open Mitra Mobile

## 📱 Sobre
Open Mitra Mobile é o repositório que permite ao usuário que publicou um projeto no Mitra configurar suas chaves pessoais das lojas Google Play e Apple App Store, possibilitando a publicação do aplicativo de forma integrada.

## 🚀 Começando
Baixe o repositorio e siga o passo a passo.

### 1️⃣ Use a chave de publicação com o script
Pega a chave criptografada e rode o script:
dart scripts/descrypt_project_data.dart "inserir-chave"

### 1️⃣ Verifique os dados no arquivo `project_config.dart`
O icone de publicação do app precisa ser local, adicione ele no assets do projeto, e adicione o caminho como:
`"assets/icon/caminho-da-imagem.jpg"`
* Atenção para o tipo da imagem no final '.jgp', '.png' ou outros * 
Caso queira alterar o nome de publicação do seu app, ou alterar o icone de publicação, altere neste arquivo antes de ir para o proximo passo.

### 2️⃣ Execute o script de configuração, para gerar o nome e o icone do projeto
Após ajustar as configurações, rode o script para aplicar as mudanças:
```dart
dart scripts/update_app_config.dart
```
Caso precise conceder permissão de execução ao script (necessário em macOS/Linux), execute:
```dart
chmod +x scripts/update_app_config.dart
```
### 2️⃣ Login com o google


