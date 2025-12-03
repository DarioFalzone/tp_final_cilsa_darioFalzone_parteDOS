# Suite de Tests Automatizados - Sauce Demo

Suite de pruebas end-to-end (E2E) desarrollada con Robot Framework para la aplicación web [Sauce Demo](https://www.saucedemo.com), una plataforma de e-commerce de demostración.

## 📋 Descripción del Proyecto

Este proyecto implementa una suite de pruebas automatizadas que valida las funcionalidades principales de Sauce Demo, incluyendo autenticación, gestión de carrito de compras, ordenamiento de productos y proceso completo de checkout.

## 🎯 Casos de Prueba Implementados

La suite contiene **6 casos de prueba** que cubren diferentes escenarios funcionales:

| ID | Caso de Prueba | Categoría | Descripción |
|----|----------------|-----------|-------------|
| TC001 | Login y Agregar Producto | Smoke / E2E | Valida login exitoso y adición de producto al carrito |
| TC002 | Checkout Completo | Smoke / E2E | Ejecuta el flujo completo desde login hasta confirmación de compra |
| TC003 | Login con Credenciales Inválidas | Login / Negativo | Verifica rechazo de credenciales incorrectas |
| TC004 | Remover Producto del Carrito | Carrito / Funcional | Valida eliminación de productos del carrito |
| TC005 | Ordenamiento por Precio | Productos / Ordenamiento | Verifica ordenamiento ascendente por precio |
| TC007 | Agregar Múltiples Productos | Carrito / Funcional | Valida adición de múltiples productos simultáneamente |

## 🛠️ Tecnologías Utilizadas

- **Robot Framework 7.0**: Framework de automatización de pruebas
- **SeleniumLibrary 6.2.0**: Biblioteca para automatización de navegadores web
- **Python 3.x**: Lenguaje de programación base
- **Google Chrome**: Navegador utilizado para la ejecución de pruebas

## 📦 Instalación y Configuración

### Requisitos Previos

1. **Python 3.7 o superior** instalado en el sistema
2. **Google Chrome** instalado y actualizado
3. **pip** (gestor de paquetes de Python)

### Configuración del Entorno

1. **Clonar o descargar el proyecto** en un directorio local

2. **Activar entorno virtual** (opcional pero recomendado):
   ```bash
   # En Windows
   python -m venv .venv
   .venv\Scripts\activate
   
   # En Linux/Mac
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **Instalar dependencias**:
   ```bash
   pip install -r requirements.txt
   ```

## ▶️ Ejecución de Pruebas

### Ejecutar Toda la Suite

```bash
python -m robot test_robotFramework_sauceDemo.robot
```

### Ejecutar por Tags (Categorías)

```bash
# Solo pruebas de tipo smoke (pruebas críticas)
python -m robot --include smoke test_robotFramework_sauceDemo.robot

# Solo pruebas de login
python -m robot --include login test_robotFramework_sauceDemo.robot

# Solo pruebas de carrito
python -m robot --include carrito test_robotFramework_sauceDemo.robot

# Solo pruebas de ordenamiento
python -m robot --include ordenamiento test_robotFramework_sauceDemo.robot
```

### Ejecutar Caso de Prueba Específico

```bash
python -m robot --test "TC001 - Test Completo de Login y Agregar Producto" test_robotFramework_sauceDemo.robot
```

## 📊 Resultados y Reportes

Después de ejecutar las pruebas, Robot Framework genera automáticamente tres archivos:

1. **`report.html`** - Reporte visual con estadísticas y gráficos
2. **`log.html`** - Log detallado de la ejecución paso a paso
3. **`output.xml`** - Datos de ejecución en formato XML

**Para visualizar los resultados**: Abrir `report.html` en cualquier navegador web.

## 🔧 Solución Técnica: Popup de Contraseña

### Problema Identificado

Durante la ejecución de pruebas, Google Chrome muestra un popup de advertencia ("Cambia la contraseña") cuando detecta que las credenciales pueden haber sido comprometidas en filtraciones de datos. Este popup bloquea la interacción con los elementos de la página y causa fallos en los tests.

### Solución Implementada

La solución adoptada fue configurar Chrome para ejecutarse en **modo incógnito** mediante el argumento `--incognito`. Este modo:

- Evita la aparición de popups de seguridad de contraseñas
- No guarda historial ni cookies entre sesiones
- Proporciona un entorno limpio y predecible para cada test

**Implementación en el código**:
```robot
Configurar Chrome
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()
    Evaluate    $chrome_options.add_argument('--incognito')
    RETURN    ${chrome_options}
```

Esta configuración se aplica automáticamente en todos los test cases, garantizando ejecuciones consistentes sin intervención manual.

## 📁 Estructura del Proyecto

```
.
├── test_robotFramework_sauceDemo.robot # Suite principal de pruebas (6 test cases)
├── requirements.txt                    # Dependencias del proyecto
├── README.md                           # Documentación del proyecto (este archivo)
├── report.html                         # Reporte de ejecución (generado automáticamente)
├── log.html                            # Log detallado (generado automáticamente)
└── output.xml                          # Datos XML (generado automáticamente)
```

## 🔑 Credenciales de Prueba

La aplicación Sauce Demo proporciona credenciales públicas para testing:

- **Usuario**: `standard_user`
- **Contraseña**: `secret_sauce`

Estas credenciales están configuradas como variables en el archivo de pruebas y no requieren modificación.

## 🧪 Arquitectura de las Pruebas

### Diseño de Test Cases

Cada test case sigue un patrón autocontenido:

1. **Setup**: Configuración de Chrome y apertura del navegador
2. **Ejecución**: Pasos del test (login, interacciones, validaciones)
3. **Teardown**: Cierre del navegador

Este diseño garantiza:
- Independencia entre tests
- Ejecución en cualquier orden
- Estado limpio para cada prueba
- Facilidad de mantenimiento

### Estructura de un Test Case

```robot
TC00X - Nombre del Test
    [Documentation]    Descripción del objetivo del test
    [Tags]    categoria1    categoria2
    
    # Setup
    ${chrome_options}=    Configurar Chrome
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    
    # Pasos del test
    # ...
    
    # Teardown
    Close Browser
```

## 🎓 Buenas Prácticas Implementadas

1. **Uso de Variables**: Todas las URLs y credenciales están centralizadas en la sección `Variables`
2. **Locators Semánticos**: Los selectores utilizan IDs únicos cuando es posible (ej: `id:user-name`)
3. **Waits Explícitos**: Se utiliza `Wait Until Element Is Visible` para garantizar sincronización
4. **Tags Descriptivos**: Cada test está etiquetado para facilitar ejecuciones selectivas
5. **Documentación Clara**: Cada test case incluye documentación de su propósito
6. **Independencia**: Cada test abre y cierra su propia sesión de navegador

## ❗ Resolución de Problemas

### Error: "No module named robot"

**Causa**: Robot Framework no está instalado en el entorno actual.

**Solución**:
```bash
pip install -r requirements.txt
```

### Error: Chrome no se abre

**Causa**: ChromeDriver no coincide con la versión de Chrome instalada.

**Solución**: El paquete `webdriver-manager` gestiona automáticamente las versiones. Asegurar que esté instalado:
```bash
pip install webdriver-manager
```

### Error: "Element not visible"

**Causa**: El popup de contraseña está bloqueando la interacción.

**Solución**: La configuración de modo incógnito en `test_robotFramework_sauceDemo.robot` debería prevenir esto. Verificar que el keyword `Configurar Chrome` esté siendo llamado correctamente.

## 🚀 Extensión de la Suite

Para agregar nuevos test cases, seguir este patrón:

1. Crear un nuevo test case en la sección `*** Test Cases ***`
2. Asignar tags apropiados para categorización
3. Incluir el setup (`Configurar Chrome` + `Open Browser`)
4. Implementar los pasos del test
5. Incluir el teardown (`Close Browser`)

## 📧 Información del Proyecto

- **Aplicación bajo prueba**: [Sauce Demo](https://www.saucedemo.com)
- **Framework**: Robot Framework 7.0
- **Lenguaje**: Python 3.x
- **Navegador**: Google Chrome (modo incógnito)

---

**Última actualización**: Diciembre 2023
