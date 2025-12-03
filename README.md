# Trabajo Integrador Parte Dos: Automatización con Robot Framework

Este proyecto es una suite de pruebas automatizadas para la aplicación de e-commerce de demostración en https://www.saucedemo.com. Utiliza Robot Framework, SeleniumLibrary y Python para ejecutar pruebas end-to-end (E2E) de login, gestión de carrito, ordenamiento de productos y proceso completo de checkout en Google Chrome.

## Casos de Prueba Implementados

Cada ejecución de la suite ejecuta los siguientes 6 casos de prueba:

### Test case 1: Flujo Completo - Inicio de Sesión y Selección de Producto

En este caso de prueba, se configura Chrome en modo incógnito para evitar popups de contraseña. Se abre la página de Sauce Demo. Se ingresa el nombre de usuario "standard_user" y la contraseña "secret_sauce". Se hace clic en el botón de login. Se verifica que la página de productos cargue correctamente mostrando el título "Products". Se agrega el producto "Sauce Labs Backpack" al carrito. Se verifica que el badge del carrito muestre "1" producto agregado.

### Test case 2: Flujo Completo de Compra (Checkout)

En este caso de prueba, se inicia sesión con las credenciales válidas "standard_user" y "secret_sauce". Se agrega el producto "Sauce Labs Backpack" al carrito. Se hace clic en el icono del carrito para revisar los productos. Se procede al checkout ingresando los datos del comprador: nombre "Juan", apellido "Pérez" y código postal "1234". Se continúa a la página de resumen y se finaliza la compra. Se verifica que aparezca el mensaje de confirmación "Thank you for your order" indicando que la compra se completó exitosamente.

### Test case 3: Validación de Login con Credenciales Inválidas

En este caso de prueba, se abre la página de login. Se ingresa un nombre de usuario incorrecto "usuario_invalido" y una contraseña incorrecta "password_incorrecta". Se hace clic en el botón Submit. Se verifica que aparezca el mensaje de error que contiene "Epic sadface", confirmando que el sistema rechaza correctamente las credenciales erróneas.

### Test case 4: Funcionalidad de Remover Producto del Carrito

En este caso de prueba, se inicia sesión exitosamente y se agrega el producto "Sauce Labs Backpack" al carrito. Se verifica que el badge del carrito muestre "1". Luego, se hace clic en el botón "Remove" para eliminar el producto del carrito. Se verifica que el badge del carrito desaparezca completamente de la interfaz, confirmando que el producto fue removido exitosamente.

### Test case 5: Validación de Ordenamiento por Precio

En este caso de prueba, se inicia sesión y se accede a la página de productos. Se selecciona la opción de ordenamiento "Price (low to high)" desde el dropdown de filtros. Se espera a que los productos se reordenen. Se verifica que el primer producto mostrado tenga el precio más bajo, que debería ser "$7.99", confirmando que el ordenamiento funciona correctamente.

### Test case 6: Adición de Múltiples Productos

En este caso de prueba, se inicia sesión y se agregan tres productos diferentes al carrito: "Sauce Labs Backpack", "Sauce Labs Bike Light" y "Sauce Labs Bolt T-Shirt". Se verifica que el badge del carrito muestre "3" productos. Se navega a la página del carrito y se cuenta el número de items visibles. Se confirma que hay exactamente 3 productos en el carrito, validando la capacidad de agregar múltiples productos simultáneamente.

## Estructura del Proyecto

```
tp_parte_dos_cilsa_df/
├─ test_robotFramework_sauceDemo.robot  # Suite principal de pruebas (6 test cases)
├─ requirements.txt                      # Dependencias del proyecto (Robot Framework, SeleniumLibrary)
├─ README.md                             # Documentación del proyecto (este archivo)
├─ report.html                           # Reporte de ejecución (generado automáticamente)
├─ log.html                              # Log detallado (generado automáticamente)
└─ output.xml                            # Datos XML (generado automáticamente)
```

## Requisitos Previos

- Python 3.7 o superior instalado en el sistema
- Google Chrome browser instalado y actualizado
- pip (gestor de paquetes de Python)
- Conexión a internet para acceder a la página de pruebas

## Instalación y Configuración

El proyecto está configurado para ejecutarse con dependencias mínimas. Solo se requieren dos bibliotecas principales.

### Dependencias Incluidas

- **robotframework**: Framework de automatización de pruebas (versión 7.0)
- **robotframework-seleniumlibrary**: Biblioteca para automatización web (versión 6.2.0)
- **webdriver-manager**: Gestión automática de drivers de navegadores (se instala automáticamente con SeleniumLibrary)

### Configuración del Entorno

Opcionalmente, se puede crear un entorno virtual para aislar las dependencias:

```bash
# En Windows
python -m venv .venv
.venv\Scripts\activate

# En Linux/Mac
python3 -m venv .venv
source .venv/bin/activate
```

Instalar las dependencias:

```bash
pip install -r requirements.txt
```

## Cómo Ejecutar las Pruebas

### Ejecutar toda la suite de pruebas:

```bash
python -m robot test_robotFramework_sauceDemo.robot
```

### Ejecutar por tags (categorías):

```bash
# Solo pruebas smoke (críticas)
python -m robot --include smoke test_robotFramework_sauceDemo.robot

# Solo pruebas de login
python -m robot --include login test_robotFramework_sauceDemo.robot

# Solo pruebas de carrito
python -m robot --include carrito test_robotFramework_sauceDemo.robot

# Solo pruebas de ordenamiento
python -m robot --include ordenamiento test_robotFramework_sauceDemo.robot
```

### Ejecutar un caso de prueba específico:

```bash
python -m robot --test "TC001 - Flujo Completo: Inicio de Sesión y Selección de Producto" test_robotFramework_sauceDemo.robot
```

## Configuración de Navegadores

### Chrome

✅ Funciona automáticamente - ChromeDriver se gestiona automáticamente por SeleniumLibrary

**Ubicación**: Detectada automáticamente por Selenium

**Modo especial**: Todas las pruebas se ejecutan en **modo incógnito** (`--incognito`) para evitar popups de guardado de contraseña que interfieren con las pruebas automatizadas

**No requiere configuración adicional**

## Características Técnicas

✅ **Pruebas E2E Completas**: Cobertura desde login hasta checkout completo

✅ **Modo Incógnito**: Configuración automática de Chrome con `--incognito` para evitar popups de contraseña

✅ **Manejo de Popups**: Estrategia preventiva con `Press Keys None ESCAPE` para cerrar popups emergentes

✅ **Waits Explícitos**: Uso de `Wait Until Element Is Visible` con timeouts configurados (5-10 segundos)

✅ **Variables Centralizadas**: URLs, credenciales y locators organizados en sección `*** Variables ***`

✅ **Tags Categorización**: Cada test etiquetado para ejecución selectiva (smoke, e2e, login, carrito, etc.)

✅ **Tests Autocontenidos**: Cada test abre y cierra su propia sesión de navegador para independencia total

✅ **Reportes Visuales**: Generación automática de `report.html` y `log.html` con detalles de ejecución

## Scripts Disponibles

### Comandos de Robot Framework

```bash
# Ejecutar toda la suite
python -m robot test_robotFramework_sauceDemo.robot

# Ejecutar por tags
python -m robot --include smoke test_robotFramework_sauceDemo.robot
python -m robot --include login test_robotFramework_sauceDemo.robot
python -m robot --include carrito test_robotFramework_sauceDemo.robot
python -m robot --include ordenamiento test_robotFramework_sauceDemo.robot

# Ejecutar test específico
python -m robot --test "TC001*" test_robotFramework_sauceDemo.robot
```

### Visualización de Resultados

Después de la ejecución, abrir `report.html` en cualquier navegador para ver:

- Estadísticas generales (PASS/FAIL)
- Gráficos de resultados
- Detalles de cada test case
- Tiempos de ejecución
- Screenshots (si se configuran)

## Credenciales de Prueba

La aplicación Sauce Demo proporciona credenciales públicas para testing:

- **Usuario**: `standard_user`
- **Contraseña**: `secret_sauce`
- **URL**: https://www.saucedemo.com

## Solución Técnica Implementada: Popup de Contraseña de Chrome

### Problema Identificado

Durante la ejecución de pruebas, Google Chrome muestra un popup de advertencia ("Cambia la contraseña") cuando detecta credenciales que pueden haber sido comprometidas en filtraciones de datos. Este popup bloquea la interacción con los elementos de la página y causa fallos en los tests.

### Solución Implementada

La solución adoptada fue configurar Chrome para ejecutarse en **modo incógnito** mediante el argumento `--incognito`. Este modo:

- Evita la aparición de popups de seguridad de contraseñas
- No guarda historial ni cookies entre sesiones
- Proporciona un entorno limpio y predecible para cada test

**Implementación en el código** (Keyword personalizado):

```robot
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
```

Esta configuración se aplica automáticamente en todos los test cases mediante la llamada al keyword `Configurar Chrome` al inicio de cada prueba, garantizando ejecuciones consistentes sin intervención manual.

## Registro de Tiempos de Ejecución

| Test Case | Descripción | Tiempo Promedio |
|-----------|-------------|-----------------|
| TC001 | Login y Agregar Producto | ~8-10 s |
| TC002 | Checkout Completo | ~12-15 s |
| TC003 | Login Inválido | ~4-5 s |
| TC004 | Remover Producto | ~8-10 s |
| TC005 | Ordenamiento por Precio | ~7-9 s |
| TC007 | Múltiples Productos | ~10-12 s |
| **Total Suite** | **6 Test Cases** | **~49-61 s** |

*Tiempos aproximados en ejecución con conexión estable*

## Notas Importantes

- Las pruebas están configuradas para ejecutarse en modo **visible** (no headless) para facilitar la observación del comportamiento y debugging.
- Los navegadores se abren y cierran automáticamente durante las pruebas para garantizar independencia entre test cases.
- Si las pruebas fallan, revisar `log.html` para ver el detalle paso a paso de la ejecución, incluyendo screenshots capturados en caso de error.
- El proyecto utiliza **modo incógnito** en Chrome como solución permanente al problema de popups de contraseña, eliminando configuraciones manuales del navegador.
- Cada test case es completamente autocontenido: no depende del estado de tests previos y limpia su propio estado al finalizar.
- Se implementan **esperas explícitas** (`Wait Until Element Is Visible`) en lugar de sleeps fijos para mejorar la robustez y reducir falsos positivos.
- Los **locators** utilizan preferentemente IDs únicos (`id:user-name`, `id:login-button`) para mayor estabilidad ante cambios en la UI.
- La suite está optimizada para Windows pero es compatible con Linux/Mac con Python 3.7+.

## Arquitectura de las Pruebas

### Diseño de Test Cases

Cada test case sigue un patrón estándar de tres fases:

1. **Setup**: Configuración de Chrome en modo incógnito y apertura del navegador
2. **Ejecución**: Pasos del test (login, interacciones, validaciones)
3. **Teardown**: Cierre del navegador para limpiar el estado

Este diseño garantiza:

- **Independencia entre tests**: Un test fallido no afecta a los demás
- **Ejecución en cualquier orden**: No hay dependencias secuenciales
- **Estado limpio**: Cada test comienza con un navegador fresco
- **Facilidad de mantenimiento**: Estructura clara y predecible

### Tags de Categorización

| Tag | Descripción |
|-----|-------------|
| `smoke` | Pruebas críticas que validan funcionalidad esencial |
| `e2e` | Pruebas de flujo completo end-to-end |
| `login` | Pruebas de autenticación |
| `negativo` | Casos de prueba negativos (validación de errores) |
| `carrito` | Funcionalidad del carrito de compras |
| `funcional` | Pruebas de funcionalidades específicas |
| `productos` | Gestión de productos |
| `ordenamiento` | Filtros y ordenamiento |

## Resolución de Problemas

### Error: "No module named robot"

**Causa**: Robot Framework no está instalado en el entorno actual.

**Solución**:

```bash
pip install -r requirements.txt
```

### Error: Chrome no se abre o falla al iniciar

**Causa**: ChromeDriver no coincide con la versión de Chrome instalada.

**Solución**: SeleniumLibrary gestiona automáticamente las versiones. Reinstalar dependencias:

```bash
pip uninstall robotframework-seleniumlibrary
pip install robotframework-seleniumlibrary
```

### Error: "Element not visible" o elementos no clickeables

**Causa 1**: El popup de contraseña está bloqueando la interacción.

**Solución**: Verificar que el keyword `Configurar Chrome` esté siendo llamado correctamente al inicio de cada test.

**Causa 2**: Timing issue - elemento aún no está listo.

**Solución**: Los tests ya implementan `Wait Until Element Is Visible` con timeouts apropiados. Verificar la conexión a internet y que la página cargue correctamente.

### Las pruebas fallan aleatoriamente

**Causa**: Problemas de red o latencia variable.

**Solución**: Aumentar los timeouts en las líneas con `Wait Until Element Is Visible`:

```robot
Wait Until Element Is Visible    ${PRODUCTS_TITLE}    timeout=15s  # Aumentar de 10s a 15s
```

## Extensión de la Suite

Para agregar nuevos test cases, seguir este patrón:

```robot
TC00X - Nombre Descriptivo del Test
    [Documentation]    Descripción clara del objetivo y alcance del test
    [Tags]    categoria1    categoria2
    
    # Setup
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Pasos del test
    Input Text    ${LOGIN_USERNAME}    ${USUARIO_VALIDO}
    # ...más pasos...
    
    # Validaciones
    Wait Until Element Is Visible    ${ELEMENTO_ESPERADO}    timeout=10s
    
    # Teardown
    Close Browser
```

**Recomendaciones**:

1. Usar nombres descriptivos que indiquen la funcionalidad probada
2. Incluir documentación clara del propósito del test
3. Asignar tags apropiados para categorización
4. Mantener independencia: cada test debe abrir y cerrar su propio navegador
5. Usar variables centralizadas para locators y datos de test
6. Implementar esperas explícitas en lugar de sleeps fijos

---

**Proyecto**: Trabajo Integrador Parte Dos - CILSA  
**Tecnología**: Robot Framework 7.0 + SeleniumLibrary 6.2.0  
**Aplicación bajo prueba**: [Sauce Demo](https://www.saucedemo.com)  
**Última actualización**: Diciembre 2025
