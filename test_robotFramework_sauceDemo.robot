*** Settings ***
Documentation     Suite de Pruebas E2E para Sauce Demo con Robot Framework
...               Pruebas fundamentales de flujo completo y validación de sesión
Library           SeleniumLibrary

*** Variables ***
# URLs y Configuración Global
${URL}                  https://www.saucedemo.com
${BROWSER}              Chrome

# Credenciales de Acceso
${USUARIO_VALIDO}       standard_user
${PASSWORD_VALIDO}      secret_sauce

# Selectores (Locators)
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
TC001 - Flujo Completo: Inicio de Sesión y Selección de Producto
    [Documentation]    Valida el flujo desde el inicio de sesión hasta la adición de un producto al carrito.
    [Tags]    smoke    e2e
    # Inicialización del navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Inicio de sesión
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    
    # Validación de carga del inventario
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s    # Dar tiempo para que se cierre cualquier popup
    
    # Manejo preventivo de popups emergentes
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Selección y adición de producto
    Wait Until Element Is Visible    ${BTN_ADD_BACKPACK}    timeout=10s
    Click Button    ${BTN_ADD_BACKPACK}
    
    # Verificación visual en el carrito
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=5s
    ${cantidad}=    Get Text    ${CART_BADGE}
    Should Be Equal As Integers    ${cantidad}    1
    
    # Cierre de sesión y navegador
    Close Browser

TC002 - Flujo Completo de Compra (Checkout)
    [Documentation]    Valida el proceso completo desde el inicio de sesión hasta la finalización de la compra.
    [Tags]    smoke    e2e
    # Inicialización del navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Inicio de sesión
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    
    # Validación de carga del inventario
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s
    
    # Manejo preventivo de popups
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Selección de producto
    Wait Until Element Is Visible    ${BTN_ADD_BACKPACK}    timeout=10s
    Click Button    ${BTN_ADD_BACKPACK}
    
    # Navegación al carrito
    Click Element    ${CART_ICON}
    Wait Until Element Is Visible    ${CHECKOUT_BUTTON}    timeout=5s
    
    # Proceso de Checkout
    Click Button    ${CHECKOUT_BUTTON}
    Input Text    ${CHECKOUT_FIRSTNAME}    Juan
    Input Text    ${CHECKOUT_LASTNAME}    Pérez
    Input Text    ${CHECKOUT_POSTAL}    1234
    Click Button    ${CHECKOUT_CONTINUE}
    
    # Finalización de la compra
    Wait Until Element Is Visible    ${CHECKOUT_FINISH}    timeout=5s
    Click Button    ${CHECKOUT_FINISH}
    
    # Confirmación de orden completada
    Wait Until Element Is Visible    ${CHECKOUT_COMPLETE}    timeout=5s
    Element Should Contain    ${CHECKOUT_COMPLETE}    Thank you for your order
    
    # Cierre de sesión y navegador
    Close Browser

TC003 - Validación de Login con Credenciales Inválidas
    [Documentation]    Verifica que el sistema rechace correctamente el acceso con credenciales erróneas.
    [Tags]    login    negativo
    # Inicialización del navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Intento de acceso con datos incorrectos
    Input Text    ${LOGIN_USERNAME}    usuario_invalido
    Input Text    ${LOGIN_PASSWORD}    password_incorrecta
    Click Button    ${LOGIN_BUTTON}
    
    # Validación del mensaje de error
    Wait Until Element Is Visible    xpath://h3[@data-test='error']    timeout=5s
    ${error_msg}=    Get Text    xpath://h3[@data-test='error']
    Should Contain    ${error_msg}    Epic sadface
    
    # Cierre de sesión y navegador
    Close Browser

TC004 - Funcionalidad de Remover Producto del Carrito
    [Documentation]    Valida la capacidad de eliminar productos previamente agregados al carrito.
    [Tags]    carrito    funcional
    # Inicialización del navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Inicio de sesión
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Adición de producto al carrito
    Wait Until Element Is Visible    ${BTN_ADD_BACKPACK}    timeout=10s
    Click Button    ${BTN_ADD_BACKPACK}
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=5s
    ${cantidad}=    Get Text    ${CART_BADGE}
    Should Be Equal As Integers    ${cantidad}    1
    
    # Eliminación del producto (el botón cambia a "Remove")
    ${btn_remove}=    Set Variable    id:remove-sauce-labs-backpack
    Click Button    ${btn_remove}
    
    # Verificación de actualización en el carrito
    Wait Until Element Is Not Visible    ${CART_BADGE}    timeout=5s
    
    # Cierre de sesión y navegador
    Close Browser

TC005 - Validación de Ordenamiento por Precio
    [Documentation]    Confirma que el filtro de ordenamiento por precio funcione correctamente.
    [Tags]    productos    ordenamiento
    # Inicialización del navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Inicio de sesión
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Aplicación de filtro: Precio (menor a mayor)
    ${sort_dropdown}=    Set Variable    xpath://select[@class='product_sort_container']
    Select From List By Value    ${sort_dropdown}    lohi
    Sleep    1s
    
    # Validación del primer ítem (debe ser el de menor precio: $7.99)
    ${primer_precio}=    Get Text    xpath:(//div[@class='inventory_item_price'])[1]
    Should Contain    ${primer_precio}    7.99
    
    # Cierre de sesión y navegador
    Close Browser



TC006 - Adición de Múltiples Productos
    [Documentation]    Verifica la capacidad de agregar varios productos al carrito simultáneamente.
    [Tags]    carrito    funcional
    # Inicialización del navegador
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Inicio de sesión
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD_VALIDO}
    Click Button    ${LOGIN_BUTTON}
    Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=10s
    Sleep    2s
    Run Keyword And Ignore Error    Press Keys    None    ESCAPE
    Sleep    0.5s
    
    # Adición del primer producto (Backpack)
    Wait Until Element Is Visible    ${BTN_ADD_BACKPACK}    timeout=10s
    Click Button    ${BTN_ADD_BACKPACK}
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=5s
    
    # Adición del segundo producto (Bike Light)
    ${btn_bike_light}=    Set Variable    id:add-to-cart-sauce-labs-bike-light
    Click Button    ${btn_bike_light}
    Sleep    0.5s
    
    # Adición del tercer producto (Bolt T-Shirt)
    ${btn_tshirt}=    Set Variable    id:add-to-cart-sauce-labs-bolt-t-shirt
    Click Button    ${btn_tshirt}
    Sleep    0.5s
    
    # Verificación del contador en el icono del carrito
    ${cantidad}=    Get Text    ${CART_BADGE}
    Should Be Equal As Integers    ${cantidad}    3
    
    # Navegación y validación en la página del carrito
    Click Element    ${CART_ICON}
    Wait Until Element Is Visible    ${CHECKOUT_BUTTON}    timeout=5s
    
    # Conteo de elementos en la lista
    ${items_count}=    Get Element Count    xpath://div[@class='cart_item']
    Should Be Equal As Integers    ${items_count}    3
    
    # Cierre de sesión y navegador
    Close Browser


*** Keywords ***
Configurar Chrome
    [Documentation]    Configura las opciones de Chrome, incluyendo modo incógnito para evitar persistencia de sesiones.
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    
    # Activación de modo incógnito (previene popups de guardado de contraseña)
    Evaluate    $chrome_options.add_argument('--incognito')
    
    # Desactivación del gestor de contraseñas
    ${prefs}=    Create Dictionary
    ...    credentials_enable_service=${False}
    ...    profile.password_manager_enabled=${False}
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    
    # Argumentos adicionales
    Evaluate    $chrome_options.add_argument('--disable-save-password-bubble')
    Evaluate    $chrome_options.add_argument('--disable-features=PasswordManager')
    
    RETURN    ${chrome_options}
