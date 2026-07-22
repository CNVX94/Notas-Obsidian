---
name: zettelkasten
description: Use when working with Zettelkasten notes, organizing notes, creating MOCs, routing notes to correct folders, or processing the vault structure. Triggers on keywords like zettelkasten, notes, inbox, archive, MOC, vault, migration, note organization.
---

# Zettelkasten Vault Skill

When working in this Zettelkasten vault, always start by reading `_Archivo/migration.md` and `AGENTS.md` to understand the full vault structure, rules, and agent identity.

## Quick Reference

### Flow
```
Journal -> Inbox -> Input -> Zettelkasten -> Output
(diario)   (captura) (fuente) (conocimiento) (produccion)
```

### Routing Rules
- Idea rapida, captura temporal -> **Inbox/**
- Diario personal, reflexion del dia -> **Journal/** (formato: YYYY-MM-DD.md)
- Nota de fuente externa (curso, libro, articulo) -> **Input/**
- Conocimiento propio ya procesado -> **Zettelkasten/**
- Produccion, entregable, proyecto -> **Output/**

### Key Files
- **Identity & rules**: `AGENTS.md`
- **Vault guide (latest)**: `_Archivo/migration.md`
- **MOCs live in**: `Zettelkasten/`
- **Images live in**: `Imagenes/`
- **Journal format**: `YYYY-MM-DD.md` in `Journal/`

### Memoria/
- Carpeta PERSISTENTE del agente. **Nunca se archiva**.
- Estructura espejo del vault: `Memoria/{Inbox,Input,Journal,Output}/`.
- Ver `AGENTS.md` seccion 4 para que guardar y que no.

### Archive Convention
- **Una sola carpeta**: `_Archivo/` (subcarpetas `Inbox/Input/Journal/Output/` + `NotasPlanas/` para legacy).
- No se crean carpetas numeradas `0xxx_Archivo/` nuevas.
- Guia activa: `_Archivo/migration.md`.

### MCP Obsidian
- El plugin `obsidian-local-rest-api` expone MCP nativo (`https://127.0.0.1:27124/mcp/`, auth `Bearer {env:OBSIDIAN_API_KEY}`).
- Usa sus herramientas (`vault_*`, `search_*`, `tag_list`, `command_*`, `open_file`) cuando Obsidian este abierto. Fallback a grep/glob/edit si no responde.
- Ver `AGENTS.md` seccion 7.

### Tags
Common Obsidian tags: `#zettelkasten`, `#moc`, `#Apunte`, `#Prompt`. Anade los que tu dominio requiera.

## Migration Command (`/archive-vault`)

Archivo el contenido activo moviendo `Inbox/`, `Input/`, `Journal/`, `Output/` a la carpeta UNICA `_Archivo/` (no crea numeradas), reubicando imagenes en `Imagenes/`, recreando carpetas activas vacias.

- `/archive-vault` (default) — archiva **todo** (incluido journal mas nuevo y sus imagenes -> `Imagenes/`).
- `/archive-vault keep` — excluye el journal mas nuevo y sus imagenes referenciadas (se quedan activos en raiz).
- `/archive-vault all` — alias del default.

### Regla de duplicados
- Si activo.mtime >= archivado.mtime -> reemplaza (sobreescribe el archivado).
- Si activo.mtime < archivado.mtime -> salta (preserva el archivado mas reciente).

`Memoria/` NUNCA se archiva. `Imagenes/` permanece intacta.

Detalles: `scripts/Archive-VaultIteration.ps1`.

## Git Sync Command (`/git-full`)

`git add -A` + `commit` + `push`. Setup interactivo si no hay `origin`. Mensaje default: `vault sync YYYY-MM-DD HH:mm`, override con `/git-full "mi mensaje"`.

### Restriccion HARD
El agente NUNCA se configura como colaborador del repo GitHub.
El agente NUNCA escribe PATs ni secretos a `Memoria/` ni a ningun archivo.
Auth via Git Credential Manager (encriptada por SO). Ver `AGENTS.md` seccion 6.

Detalles: `scripts/Git-FullSync.ps1`.

## Auto-Work Steps
1. Read `AGENTS.md` (identity, preferencias del usuario, restricciones).
2. Read `_Archivo/migration.md` para estructura actual.
3. Busca con grep/glob。
4. Procesa segun tipo (crear, organizar, archivar, sync git, etc.).
5. Verifica carpetas y tags.
6. Reporta que se hizo (una linea si fue comando mecanico).