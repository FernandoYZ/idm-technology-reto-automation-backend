# Reto QA Backend – API de Usuarios ServeRest con Karate DSL

Suite de pruebas automatizadas del CRUD de `/usuarios` de [ServeRest](https://serverest.dev/).

## Requisitos

- Java 17 o superior (probado con Java 21)
- No necesitas Maven instalado: el proyecto incluye Maven Wrapper (`mvnw`)

## Ejecución

```bash
# Toda la suite
./mvnw test            # Linux / macOS
mvnw.cmd test          # Windows

# Solo casos positivos o negativos
./mvnw test -Dkarate.options="--tags @happy"
./mvnw test -Dkarate.options="--tags @unhappy"

# Contra otra URL (por ejemplo, ServeRest local con npx serverest)
./mvnw test -DurlBase=http://localhost:3000
```

## Reporte

Al terminar se genera el reporte HTML en `target/karate-reports/karate-summary.html`.

## Estructura

```
src/test/java
├── karate-config.js            # Configuración global (urlBase, timeouts)
├── logback-test.xml            # Nivel de logs
├── esquemas/                   # Esquemas JSON reutilizables
│   ├── usuario.json
│   ├── lista-usuarios.json
│   ├── usuario-creado.json
│   └── mensaje.json
├── helpers/
│   ├── datos.js                # Genera un usuario con datos aleatorios
│   ├── crear-usuario.feature   # Crea un usuario y devuelve su id (@ignore)
│   └── eliminar-usuario.feature# Elimina un usuario por id (@ignore)
└── usuarios/                   # Un feature por endpoint
    ├── listar-usuarios.feature     # GET    /usuarios
    ├── registrar-usuario.feature   # POST   /usuarios
    ├── buscar-usuario.feature      # GET    /usuarios/{_id}
    ├── actualizar-usuario.feature  # PUT    /usuarios/{_id}
    ├── eliminar-usuario.feature    # DELETE /usuarios/{_id}
    └── UsuariosTest.java           # Runner JUnit 5 (ejecución paralela)
```

## Cobertura

| Endpoint | Casos positivos (@happy) | Casos negativos (@unhappy) |
|---|---|---|
| GET /usuarios | Listar todos con esquema · Filtrar por email | Email inexistente → lista vacía · `administrador` inválido → 400 |
| POST /usuarios | Registro válido → 201 | Email duplicado · Campos vacíos · Email mal formado · `administrador` inválido · Campos obligatorios faltantes |
| GET /usuarios/{_id} | Buscar por ID existente | ID inexistente → 400 · ID con formato inválido → 400 |
| PUT /usuarios/{_id} | Actualizar y verificar con GET | Email de otro usuario → 400 · Nombre vacío → 400 · ID inexistente → 201 (crea el usuario) |
| DELETE /usuarios/{_id} | Eliminar y verificar con GET | ID inexistente → "Nenhum registro excluído" · Usuario con carrito → 400 |

Consulta la estrategia en [ESTRATEGIA.md](ESTRATEGIA.md).
