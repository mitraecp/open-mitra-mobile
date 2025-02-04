//NOTE: Chamadas do javascrpit
class GlobalJavaScriptCall {
  //NOTE: Refresh da pagina
  String refreshComponents =
      "document.getElementById('app').__vue__.\$store.dispatch(\"PageBuilderStore/FILTER_AND_REFRESH_COMPONENTS\")";
//NOTE: Retorna true se tiver o loading na tela.
  String verifyPageHasLoad =
      "document.getElementById('app').__vue__.\$store.state.PageBuilderStore.pbTapumeLoading";
//NOTE: Scrpit para ativar o modo preview.
  String setToPreviewMode =
      "document.getElementById('app').__vue__.\$store.dispatch(\"NavBarStore/TOGGLE_PREVIEW_MODE\", true)";
//NOTE: Reload da pagina
  String reloadPage = 'window.location.reload()';
//NOTE: Retira os master detail na tela.
  String clearMasterDetail =
      "document.getElementById('app').__vue__.\$store.dispatch(\"DraggableStore/CLEAR_APPLYING_MASTER_DETAIL\")";

//NOTE: Salva entrada de dados
  String saveDataEntryScript =
      "document.getElementById('app').__vue__.\$store.dispatch(\"BaseTableStore/SAVE_DATA_ENTRY\", { reloadComponents: true });";

//NOTE: Cria o evento de clique.
  String createClickEvent =
      "const event = document.createEvent ('MouseEvents');";

//NOTE: Desfocar entrada de dados pelo evento de click
  String unfocusDataEntryByClickEvent =
      "event.initEvent ('mousedown', true, true); document.body.dispatchEvent (event);";

  String unfocusTableById(int id) {
    return "document.getElementById('hotTableID$id').__vue__.hotInstance.deselectCell();";
  }

//NOTE: Passa o valor digitado para web no entrado de dados.
  String setInputDataEntry = "document.activeElement.value=";

//NOTE: MOve a tela pelo eixo Y.
  String changePageHeightByTranslate(int value) {
    return "document.getElementById('app').style.transform = 'translateY(-${value}px)';";
  }

  //NOTE: Verificar, mas acho que ativa o scroll na pagina.
  String overflowScroll =
      "document.getElementById('dropWrapper').style.overflowY = 'scroll';";

  //NOTE: Reajusta o tamanho da pagina.
  String setPageHeight(int value) {
    return "document.getElementById('dropWrapper').style.height = '${value}px';";
  }

  //NOTE: Move o scroll para o final.
  String scrollGoTo =
      "document.getElementById('dropWrapper').scrollIntoView({block: \"end\"});";
  //NOTE: Move o scroll para o começo.
  String returnScroll =
      "document.getElementById('dropWrapper').scrollIntoView({block: \"start\"});";

  String selectAutoCompleteDataEntry(
      {required int id,
      required int row,
      required int col,
      required String descr}) {
    return "document.getElementById('hotTableID$id').__vue__.hotInstance.setDataAtCell($row,$col,'$descr')";
  }

  String webViewPostMessage(String message) {
    return 'window.postMessage(`$message`, "*")';
  }

  String webViewPostMessageWithObject(dynamic message) {
    return 'window.postMessage($message, "*")';
  }
}
