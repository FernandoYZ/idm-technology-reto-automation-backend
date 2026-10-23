# Estrategia de automatización – Backend

## Enfoque

- **Un feature por endpoint**: cada archivo agrupa los escenarios de una operación CRUD, así es fácil ubicar qué falla.
- **Casos positivos y negativos separados por tags** (`@happy`, `@unhappy`), para ejecutarlos por grupo.
- **Pruebas independientes**: cada escenario crea sus propios datos y no depende del orden ni de datos existentes en el ambiente compartido.

## Patrones utilizados

| Patrón | Dónde | Por qué |
|---|---|---|
| Data Builder | `helpers/datos.js` | Genera usuarios únicos (UUID) y evita colisiones de email en un ambiente público compartido. |
| Reusable Feature (call) | `helpers/crear-usuario.feature`, `helpers/eliminar-usuario.feature` | Centraliza el arrange y el cleanup; los features de prueba solo describen el comportamiento. |
| Schema as Data | `esquemas/*.json` | Los contratos se definen una sola vez con los marcadores de Karate (`#string`, `#regex`, `#array`) y se reutilizan en todos los features. |
| Data-Driven Testing | `Scenario Outline` en `registrar-usuario.feature` | Un solo escenario cubre todas las variantes de campos inválidos u obligatorios. |
| Teardown con `afterScenario` | `buscar`, `actualizar`, `listar`, `registrar` | Elimina los usuarios creados aunque el escenario falle, para no ensuciar la base. |

## Validaciones

- Código de estado HTTP.
- Esquema JSON de la respuesta (`match ==` y `match each`).
- Mensajes de negocio exactos (ServeRest responde en portugués).
- Verificación de efecto: después de un PUT o DELETE se consulta con GET para confirmar el cambio.

## Hallazgos del comportamiento de la API

- `PUT /usuarios/{_id}` con un ID inexistente **no devuelve un error**: crea el usuario (201). Se automatizó tal como está documentado.
- `DELETE /usuarios/{_id}` con un ID inexistente devuelve **200** con `"Nenhum registro excluído"`, no 404.
- No se puede eliminar un usuario que tiene un carrito registrado (400).

## Configuración

- `karate-config.js` define `urlBase`, que se puede cambiar con `-DurlBase=...` para apuntar a un ServeRest local.
- La ejecución es paralela (4 hilos), posible gracias a que los datos son únicos por escenario.
