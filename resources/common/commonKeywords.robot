*** Settings ***
Library   Browser
Library   String
Library   ../../libraries/EmailLibrary.py
Resource  ../../variables/testData.robot

*** Keywords ***
Abrir navegador
  New Browser           chromium            headless=True
  ...                   args=["--disable-blink-features=AutomationControlled", "--no-sandbox", "--start-maximized"]
  New Context           viewport=None
  ...                   locale=pt-BR
  ...                   timezoneId=America/Sao_Paulo
  ...                   userAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36
  ...                   extraHTTPHeaders={"Accept-Language": "pt-BR,pt;q=0.9,en;q=0.8"}
  Set Browser Timeout   ${DEFAULT_TIMEOUT}

Fechar Navegador
    Close Browser

Capturar screenshot de diagnóstico
    # Executado no teardown quando o teste falha: registra o que a OLX entregou ao runner
    Run Keyword And Ignore Error    Take Screenshot    filename=diagnostico-falha    fullPage=True
    ${url}=    Run Keyword And Ignore Error    Get Url
    Log        URL no momento da falha: ${url}    console=True

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
