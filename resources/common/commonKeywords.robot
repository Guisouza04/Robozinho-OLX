*** Settings ***
Library   Browser
Library   String
Library   ../../libraries/EmailLibrary.py
Resource  ../../variables/testData.robot

*** Keywords ***
Abrir navegador
  New Browser           chromium            headless=True    args=["--start-maximized"]
  New Context           viewport=None
  Set Browser Timeout   ${DEFAULT_TIMEOUT}

Fechar Navegador
    Close Browser

# Serviço de Email
Enviar email com os dados coletados
    [Arguments]         ${anunciosValidos}
    Log                 Enviando email com os dados coletados...    console=True

    ${corpo}=           Montar Corpo Anuncios    ${anunciosValidos}

    Enviar Email Gmail
    ...                 remetente=${EMAIL_REMETENTE}
    ...                 senha=${EMAIL_SENHA}
    ...                 destinatario=${EMAIL_DESTINATARIO}
    ...                 assunto=Imóveis OLX - Novos Anúncios
    ...                 corpo=${corpo}

    Log                 ✅ Email enviado!    console=True
