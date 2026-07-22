# Migration Guide — Zettelkasten Vault

> **Punto de entrada para agentes de IA.** Lee este archivo primero para entender la estructura del vault y poder trabajar automáticamente con las notas.

---

## 1. Mapa del vault

```
vault/
├── _Archivo/                  ← Carpeta ÚNICA de archivado (persistente)
│   ├── Inbox/                ← capturas archivadas
│   ├── Input/                ← notas de fuente externa archivadas
│   ├── Journal/              ← journals archivados (formato YYYY-MM-DD.md)
│   ├── Output/               ← entregables archivados
│   ├── NotasPlanas/          ← notas legacy sin estructura (opcional)
│   └── migration.md          ← ESTE ARCHIVO
├── Imagenes/                  ← Todas las imágenes (referencias ![[Imagenes/...]] nunca se rompen)
├── Inbox/  Input/  Journal/  Output/   ← carpetas activas
├── Zettelkasten/              ← Conocimiento propio y MOCs
├── Memoria/                   ← PERSISTENTE del agente, no se archiva nunca
├── scripts/
│   ├── Archive-VaultIteration.ps1
│   └── Git-FullSync.ps1
├── AGENTS.md                  ← Identidad y reglas del agente (personalizable)
└── README.md
```

---

## 2. Modelo de archivado (UNA sola carpeta)

Todo el histórico del vault vive en **una sola carpeta** `_Archivo/`. El comando `/archive-vault` mueve el contenido de las carpetas activas a `_Archivo/{Inbox,Input,Journal,Output}/` **sin crear carpetas numeradas** (`0xxx_Archivo/`).

### Regla de duplicados
Si un archivo activo tiene el mismo nombre que uno ya archivado en `_Archivo/`:
- **Si el activo tiene `mtime` ≥ archivado** → el activo reemplaza al archivado (sobreescribe).
- **Si el activo tiene `mtime` < archivado** → el script salta el activo (preserva el archivado, que es más reciente).

Principio: la versión más reciente del usuario es la canónica. La bitácora detallada vive en `git log`.

---

## 3. Flujo Zettelkasten

```
Journal → Inbox → Input → Zettelkasten → Output
(diario)  (captura) (fuente) (conocimiento) (producción)
```

Ver `AGENTS.md` sección 2 para reglas de enrutamiento.

---

## 4. Memoria del agente

`Memoria/` **no se archiva nunca**. Es persistente entre archivados. Estructura espejo del vault (`Inbox/Input/Journal/Output/`). Ver `AGENTS.md` sección 4.

---

## 5. MCP de Obsidian (acceso directo al vault)

El plugin **`obsidian-local-rest-api`** (de Adam Coddington) expone un servidor MCP nativo dentro de Obsidian. Con él, el agente puede leer/escribir/buscar notas y ejecutar comandos de Obsidian directamente, sin tocar el filesystem a mano.

### Configuración (opencode.json, ya incluida)
```json
"mcp": {
  "obsidian": {
    "type": "remote",
    "url": "https://127.0.0.1:27124/mcp/",
    "enabled": true,
    "oauth": false,
    "headers": { "Authorization": "Bearer {env:OBSIDIAN_API_KEY}" }
  }
}
```

### Setup del usuario (una sola vez)
1. Instala y habilita el plugin **Local REST API** en Obsidian (Community plugins).
2. En Obsidian: **Settings → Local REST API → Copy API Key**.
3. Define la variable de entorno (PowerShell, usuario):
   ```powershell
   [Environment]::SetEnvironmentVariable('OBSIDIAN_API_KEY','<tu-api-key>','User')
   ```
4. Certificado autofirmado: si el cliente MCP rechaza TLS, descarga y confía el certificado de `https://127.0.0.1:27124/obsidian-local-rest-api.crt`, o habilita el servidor HTTP (`Settings → Local REST API → Enable HTTP server`) y usa `http://127.0.0.1:27123/mcp/`.
5. **Obsidian debe estar abierto** con el plugin habilitado para que el MCP responda.

### Herramientas MCP disponibles
`vault_list`, `vault_read`, `vault_write`, `vault_append`, `vault_patch`, `vault_delete`, `vault_move`, `vault_get_document_map`, `active_file_get_path`, `periodic_note_get_path`, `search_query`, `search_simple`, `tag_list`, `command_list`, `command_execute`, `open_file`.

### Reglas
- **La API key NUNCA se commitea** — vive solo en la variable de entorno del usuario.
- Si el MCP no responde (Obsidian cerrado / plugin deshabilitado), el agente hace **fallback** a grep/glob/edit directos sobre archivos del vault (ya tiene acceso al filesystem).
- Ver `AGENTS.md` sección 7 para el uso operativo.

---

## 6. Archivado futuro (`/archive-vault`)

- `/archive-vault` (default) — archiva **todo**: mueve `Inbox/Input/Journal/Output` activos a `_Archivo/...`, reubica PNG sueltos en `Imagenes/`, recrea carpetas activas vacías.
- `/archive-vault keep` — excluye el journal más nuevo y sus imágenes referenciadas (se quedan activos en raíz).
- `/archive-vault all` — alias del default.

`Memoria/` NUNCA se archiva. `Imagenes/` permanece intacta (referencias `![[...]]` preservadas).

Detalles: `scripts/Archive-VaultIteration.ps1` (`-WhatIf`, `-KeepCurrentJournal`, `-JournalDate`).

---

## 7. Estado actual

- **Journals archivados**: 0 (template nuevo, sin contenido)
- **Journal activo**: ninguno
- **Total en `_Archivo/`**: 0 archivos
- **Último archivado**: nunca (template inicial)

---

## 8. Instrucciones para Auto-Trabajo (Agente IA)

### Paso 1 — Leer contexto
- Lee este archivo (`_Archivo/migration.md`) primero.
- Lee `AGENTS.md` para identidad, preferencias del usuario y restricciones.
- Revisa los MOCs relevantes en `Zettelkasten/`.

### Paso 2 — Leer notas relevantes
- Si el MCP `obsidian` está disponible, usa sus herramientas (`search_simple`, `vault_read`, `tag_list`).
- Si no, usa grep/glob sobre las carpetas relevantes (incluida `_Archivo/`).
- Revisa `Memoria/` para contexto previo del agente sobre el usuario.

### Paso 3 — Procesar
| Tarea                          | Acción |
|--------------------------------|--------|
| Crear nota nueva               | Determinar carpeta destino, crear archivo con tags (vía MCP `vault_write` o edit) |
| Organizar notas dispersas      | Mover de `Inbox/` a su carpeta destino |
| Actualizar MOC                 | Leer el MOC relevante, agregar referencia (MCP `vault_append`/`vault_patch`) |
| Archivar contenido             | Usar `/archive-vault` |
| Buscar información             | MCP `search_simple`/`search_query`, o grep/glob |
| Sincronizar con GitHub         | Usar `/git-full` (ver `AGENTS.md` sección 6) |

### Paso 4 — Verificar
- Carpetas correctas. Tags consistentes. Referencias entre notas no rotas.

### Paso 5 — Reportar
- Qué se hizo, qué se movió/creó. Sugerir próximos pasos.

---

*Última actualización: 2026-07-21 — Template inicial con modelo `_Archivo/` único + MCP Obsidian*