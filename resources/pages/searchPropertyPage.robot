*** Settings ***
Resource    ../common/commonKeywords.robot
Library     Collections


*** Variables ***
${XPATH_ANUNCIO}                 xpath=(//a[@class='olx-adcard__link'])      

# Teto de segurança se a página tiver muitos cards (evita run longo)
${MAX_ANUNCIOS_PAGINA}           200

# Dicionários
@{TITLES_CONDITIONAL}    
...    Mensal          mensal                    MENSAL                Flat
...    Loft            LOFT                      Studio                Chácara
...    Fazenda/Sítio   Galpão/Depósito/Armazém   Hotel/Pousada/Chalé   Prédio Inteiro
...    Terreno/Lote    Temporada                 temporada             TEMPORADA
...    Kit             kitnet                    Kitnet                Kitinete

# Preenchido em runtime por "Averigua os anúncios existentes": chave = href, valor = title
${ANUNCIOS_SELECIONADOS}          ${NONE}

*** Keywords ***
Ir para página de imóveis com os filtros aplicados
    New Page                  url=${URL_BASE_IMOVEIS}/${CIDADE}/${REGIÃO}?ps=${PREÇO_MIN}&pe=${PREÇO_MAX}&sf=1  wait_until=domcontentloaded
    # Monta xpath=(...)[1] via Catenate: ${XPATH_ANUNCIO}[1] seria acesso a item (retorna a letra 'p')
    ${primeiroAnuncio}=       Catenate    SEPARATOR=    ${XPATH_ANUNCIO}    [1]
    Wait For Elements State   ${primeiroAnuncio}    visible    timeout=${DEFAULT_TIMEOUT}
    ...                       message=Nenhum card de anúncio encontrado. A OLX pode estar bloqueando o ambiente (IP de datacenter / headless).

Seleciona os anúncios válidos
    [Arguments]                   ${anunciosValidos}

    Verifica se dicionário está vázio  ${anunciosValidos}

    ${hrefsParaRemover}           Create List

    FOR    ${href}    ${title}    IN    &{anunciosValidos}
        FOR  ${palavra}    IN     @{TITLES_CONDITIONAL}
             ${titleLower}        Evaluate    $title.lower()
             ${palavraLower}      Evaluate    $palavra.lower()
             ${contemPalavra}     Evaluate    $palavraLower in $titleLower

             IF  ${contemPalavra}
                 Append To List   ${hrefsParaRemover}    ${href}
                 Log              [Removido] "${title}" contém palavra proibida: "${palavra}"    console=True
                 BREAK
             END
        END
    END

    FOR    ${href}    IN    @{hrefsParaRemover}
        Remove From Dictionary    ${anunciosValidos}    ${href}
    END

    Log                           Anúncios válidos restantes: ${anunciosValidos}    console=True
    RETURN                        ${anunciosValidos}
    
Filtra os anúncios na data de hoje
    &{anunciosValidos}            Create Dictionary
    ${max_i_exclusivo}            Evaluate         ${MAX_ANUNCIOS_PAGINA} + 1

    FOR  ${i}  IN RANGE  1  ${max_i_exclusivo}
         ${locator}               Catenate         SEPARATOR=    ${XPATH_ANUNCIO}    [${i}]
         ${href}                  Get Attribute    ${locator}    href
         ${title}                 Get Attribute    ${locator}    title

         ${publicacaoRecente}     Verifica se o anúncio foi publicado há mais de 24h   i=${i}
      
        IF  ${publicacaoRecente}
            Set To Dictionary     ${anunciosValidos}    ${href}    ${title}
        ELSE
            BREAK
        END
    END

    Set Suite Variable            ${ANUNCIOS_SELECIONADOS}    ${anunciosValidos}
    RETURN                        ${anunciosValidos}
    

# Keywords auxiliares
Verifica se o título do anúncio contém as palavras-chave
    [Arguments]                   ${title}
    ${contemPalavraChave}         Run Keyword And Return Status    Should Contain Any    ${title}    @{TITLES_CONDITIONAL}
    RETURN                        ${contemPalavraChave}

Verifica se o anúncio foi publicado há mais de 24h
    [Arguments]                   ${i}
    ${dataPublicacao}             Get Text    //*[@id="main-content"]/div[9]/section[${i}]/div[1]
    ${publicacaoRecente}          Run Keyword And Return Status    Should Contain    ${dataPublicacao}    Hoje
    RETURN                        ${publicacaoRecente}

Verifica se dicionário está vázio
    [Arguments]                   ${anunciosValidos}
    ${tamanho}                    Get Length    ${anunciosValidos}
    Log                           ${anunciosValidos}  
    IF  ${tamanho} == 0
        Log                       Nenhum anúncio para filtrar.    console=True
        Enviar email com os dados coletados  ${anunciosValidos}
    END         
