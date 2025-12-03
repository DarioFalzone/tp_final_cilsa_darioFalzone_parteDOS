*** Settings ***
Documentation     Test Suite E2E Robot Framework Sauce Demo
...               Tests básicos que funcionan sin problemas de sesión
Library           SeleniumLibrary

*** Variables ***
# URLs y Configuración
${URL}                  https://www.saucedemo.com
${BROWSER}              Chrome

# Credenciales
${USUARIO_VALIDO}       standard_user
${PASSWORD_VALIDO}      secret_sauce

# Locators
${LOGIN_USERNAME}       id:user-name
${LOGIN_PASSWORD}       id:password
${LOGIN_BUTTON}         id:login-button
${PRODUCTS_TITLE}       xpath://span[@class='title' and text()='Products']
${BTN_ADD_BACKPACK}     id:add-to-cart-sauce-labs-backpack
${CART_BADGE}           xpath://span[@class='shopping_cart_badge']
${CART_ICON}            xpath://a[@class='shopping_cart_link']
${CHECKOUT_BUTTON}      id:checkout
${CHECKOUT_FIRSTNAME}   id:first-name
${CHECKOUT_LASTNAME}    id:last-name
${CHECKOUT_POSTAL}      id:postal-code
${CHECKOUT_CONTINUE}    id:continue
${CHECKOUT_FINISH}      id:finish
${CHECKOUT_COMPLETE}    xpath://h2[@class='complete-header']

*** Test Cases ***
TC001 - Test Completo de Login y Agregar Producto
    [Documentation]    Test completo desde login hasta agregar un producto al carrito
    [Tags]    smoke    e2e
    # Abrir navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Login
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    
    # Esperar que cargue la página de productos
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s    # Dar tiempo para que se cierre cualquier popup
    
    # Intentar cerrar popup si aparece
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Agregar producto al carrito
    Wait Until Element Is Visible    ${BTN_ADD_BACKPACK}    timeout=10s
    Click Button    ${BTN_ADD_BACKPACK}
    
    # Verificar que se agregó al carrito
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=5s
    ${cantidad}=    Get Text    ${CART_BADGE}
    Should Be Equal As Integers    ${cantidad}    1
    
    # Cerrar navegador
    Close Browser

TC002 - Test Completo de Checkout
    [Documentation]    Test completo desde login hasta completar una compra
    [Tags]    smoke    e2e
    # Abrir navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Login
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    
    # Esperar que cargue la página de productos
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s
    
    # Intentar cerrar popup
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Agregar producto
    Wait Until Element Is Visible    ${BTN_ADD_BACKPACK}    timeout=10s
    Click Button    ${BTN_ADD_BACKPACK}
    
    # Ir al carrito
    Click Element    ${CART_ICON}
    Wait Until Element Is Visible    ${CHECKOUT_BUTTON}    timeout=5s
    
    # Checkout
    Click Button    ${CHECKOUT_BUTTON}
    Input Text    ${CHECKOUT_FIRSTNAME}    Juan
    Input Text    ${CHECKOUT_LASTNAME}    Pérez
    Input Text    ${CHECKOUT_POSTAL}    1234
    Click Button    ${CHECKOUT_CONTINUE}
    
    # Finalizar compra
    Wait Until Element Is Visible    ${CHECKOUT_FINISH}    timeout=5s
    Click Button    ${CHECKOUT_FINISH}
    
    # Verificar compra completada
    Wait Until Element Is Visible    ${CHECKOUT_COMPLETE}    timeout=5s
    Element Should Contain    ${CHECKOUT_COMPLETE}    Thank you for your order
    
    # Cerrar navegador
    Close Browser

TC003 - Test de Login con Credenciales Inválidas
    [Documentation]    Verifica que el sistema rechaza credenciales incorrectas
    [Tags]    login    negativo
    # Abrir navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Intentar login con credenciales inválidas
    Input Text    ${LOGIN_USERNAME}    usuario_invalido
    Input Text    ${LOGIN_PASSWORD}    password_incorrecta
    Click Button    ${LOGIN_BUTTON}
    
    # Verificar mensaje de error
    Wait Until Element Is Visible    xpath://h3[@data-test='error']    timeout=5s
    ${error_msg}=    Get Text    xpath://h3[@data-test='error']
    Should Contain    ${error_msg}    Epic sadface
    
    # Cerrar navegador
    Close Browser

TC004 - Test de Remover Producto del Carrito
    [Documentation]    Verifica la funcionalidad de remover productos del carrito
    [Tags]    carrito    funcional
    # Abrir navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Login
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Agregar producto al carrito
    Wait Until Element Is Visible    ${BTN_ADD_BACKPACK}    timeout=10s
    Click Button    ${BTN_ADD_BACKPACK}
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=5s
    ${cantidad}=    Get Text    ${CART_BADGE}
    Should Be Equal As Integers    ${cantidad}    1
    
    # Remover producto (el botón cambia a "Remove")
    ${btn_remove}=    Set Variable    id:remove-sauce-labs-backpack
    Click Button    ${btn_remove}
    
    # Verificar que el badge del carrito desapareció
    Wait Until Element Is Not Visible    ${CART_BADGE}    timeout=5s
    
    # Cerrar navegador
    Close Browser

TC005 - Test de Ordenamiento de Productos por Precio
    [Documentation]    Verifica que los productos se ordenan correctamente por precio
    [Tags]    productos    ordenamiento
    # Abrir navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Login
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Ordenar por precio: menor a mayor
    ${sort_dropdown}=    Set Variable    xpath://select[@class='product_sort_container']
    Select From List By Value    ${sort_dropdown}    lohi
    Sleep    1s
    
    # Verificar que el primer producto es el más barato ($7.99)
    ${primer_precio}=    Get Text    xpath:(//div[@class='inventory_item_price'])[1]
    Should Contain    ${primer_precio}    7.99
    
    # Cerrar navegador
    Close Browser



TC007 - Test de Agregar Múltiples Productos
    [Documentation]    Verifica que se pueden agregar múltiples productos simultáneamente
    [Tags]    carrito    funcional
    # Abrir navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Login
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Agregar primer producto (Backpack)
    Wait Until Element Is Visible    ${BTN_ADD_BACKPACK}    timeout=10s
    Click Button    ${BTN_ADD_BACKPACK}
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=5s
    
    # Agregar segundo producto (Bike Light)
    ${btn_bike_light}=    Set Variable    id:add-to-cart-sauce-labs-bike-light
    Click Button    ${btn_bike_light}
    Sleep    0.5s
    
    # Agregar tercer producto (Bolt T-Shirt)
    ${btn_tshirt}=    Set Variable    id:add-to-cart-sauce-labs-bolt-t-shirt
    Click Button    ${btn_tshirt}
    Sleep    0.5s
    
    # Verificar que el carrito muestra 3 productos
    ${cantidad}=    Get Text    ${CART_BADGE}
    Should Be Equal As Integers    ${cantidad}    3
    
    # Ir al carrito y verificar
    Click Element    ${CART_ICON}
    Wait Until Element Is Visible    ${CHECKOUT_BUTTON}    timeout=5s
    
    # Contar items en el carrito
    ${items_count}=    Get Element Count    xpath://div[@class='cart_item']
    Should Be Equal As Integers    ${items_count}    3
    
    # Cerrar navegador
    Close Browser


*** Keywords ***
Configurar Chrome
    [Documentation]    Configura Chrome en modo incógnito para evitar popups de contraseña
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    
    # USAR MODO INCÓGNITO (esto evita el popup de contraseña)
    Evaluate    $chrome_options.add_argument('--incognito')
    
    # Deshabilitar gestor de contraseñas (por si acaso)
    ${prefs}=    Create Dictionary
    ...    credentials_enable_service=${False}
    ...    profile.password_manager_enabled=${False}
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    
    # Argumentos adicionales
    Evaluate    $chrome_options.add_argument('--disable-save-password-bubble')
    Evaluate    $chrome_options.add_argument('--disable-features=PasswordManager')
    
    RETURN    ${chrome_options}
