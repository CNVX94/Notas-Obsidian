---
name: zettelkasten
description: Use when working with Zettelkasten notes, organizing notes, creating MOCs, routing notes to correct folders, or processing the vault structure. Triggers on keywords like zettelkasten, notes, inbox, archive, MOC, vault, migration, note organization.
---

# Zettelkasten Vault Skill

When working in this Zettelkasten vault, always start by reading `0001_Archivo/migration.md` (or the latest iteration indicated in `AGENTS.md`) and `AGENTS.md` to understand the full vault structure, rules, and agent identity.

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
- **Vault guide (latest iteration)**: `0001_Archivo/migration.md` (or `0xxx_Archivo/migration.md` — check `AGENTS.md` section 7 for the current reference)
- **MOCs live in**: `Zettelkasten/`
- **Images live in**: `Imagenes/`
- **Journal format**: `YYYY-MM-DD.md` in `Journal/`

### Memoria/
- Carpeta PERSISTENTE del agente. **Nunca se archiva**.
- Estructura espejo del vault: `Memoria/{Inbox,Input,Journal,Output}/`.
- Ver `AGENTS.md` seccion 4 para que guardar y que no.

### Archive Convention
- `0001_Archivo/` - Iteracion 1 (inicial)
- `0002_Archivo/`, `0003_Archivo/`, `0004_Archivo/`... - Secuencia creciente.
- Numeracion: `0001`, `0002`, `0003`, `0004`, `0005`...

### Tags
Common Obsidian tags: `#zettelkasten`, `#moc`, `#Apunte`, `#Prompt`. Anade los que tu dominio requiera.

## Migration Command (`/archive-vault`)

Archivo la iteracion actual moviendo `Inbox/`, `Input/`, `Journal/`, `Output/` a una nueva `0xxx_Archivo/`, reubicando imagenes en `Imagenes/`, recreando carpetas activas vacias, y actualizando `migration.md`, `README.md`, `AGENTS.md`.

- `/archive-vault` (default) — archiva **todo** (incluido journal mas nuevo y sus imagenes -> `Imagenes/`).
- `/archive-vault keep` — excluye el journal mas nuevo y sus imagenes referenciadas (se quedan activos en raiz).
- `/archive-vault all` — alias del default.

`Memoria/` NUNCA se archiva.

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
2. Read latest `0xxx_Archivo/migration.md` para estructura actual.
3. Busca con grep/glob。
4. Procesa segun tipo (crear, organizar, archivar, sync git, etc.).
5. Verifica carpetas y tags.
6. Reporta que se hizo (una linea si fue comando mecanico).