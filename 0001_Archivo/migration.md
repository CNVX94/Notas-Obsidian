# Migration Guide — Zettelkasten Vault (Iteración 1)

> **Punto de entrada para agentes de IA.** Lee este archivo primero para entender la estructura del vault y poder trabajar automáticamente con las notas.

---

## 1. Mapa Completo del Vault

```
<vault>/
├── 0001_Archivo/        ← Iteración 1 (esta guía)
│   ├── Inbox/   Input/   Journal/   Output/   (vacías, estructura espejo)
│   └── migration.md     ← ESTE ARCHIVO
├── Imagenes/            ← Todas las imágenes del vault
├── Inbox/               ← Captura rápida (temporal)
├── Input/               ← Notas de fuente externa
├── Journal/             ← Diario personal (formato: YYYY-MM-DD.md)
├── Output/              ← Producción final
├── Zettelkasten/        ← Conocimiento propio y MOCs
├── Memoria/             ← Memoria PERSISTENTE del agente (no se archiva)
│   ├── Inbox/  Input/  Journal/  Output/
│   └── README.md
├── scripts/
│   ├── Archive-VaultIteration.ps1
│   └── Git-FullSync.ps1
├── AGENTS.md            ← Identidad y reglas del agente (personalizable)
└── README.md
```

---

## 2. Flujo del Sistema Zettelkasten

```
Journal → Inbox → Input → Zettelkasten → Output
(diario)  (captura) (fuente) (conocimiento) (producción)
```

### Regla rápida de enrutamiento

| ¿Qué tipo de nota es?                           | Carpeta destino |
|--------------------------------------------------|-----------------|
| Idea rápida, captura temporal                    | **Inbox/**      |
| Algo de tu día, reflexión personal              | **Journal/**    |
| Nota que proviene de una fuente externa (curso, libro, artículo) | **Input/** |
| Conocimiento que ya entendiste y es tuyo         | **Zettelkasten/** |
| Algo que produce un entregable, proyecto, solución | **Output/** |

---

## 3. Convención de Archivos

### Journal
- Formato: `YYYY-MM-DD.md`.
- Mismo día, dos entradas: `YYYY-MM-DD.2.md` o `YYYY-MM-DDdos.md`.

### Archivos generales
- Nombres en PascalCase o camelCase según lo que ya exista en la carpeta destino.
- Imágenes en `Imagenes/`, referenciadas con `![[Imagenes/archivo.png]]`.
- Tag en primera línea: `#tag1 #tag2`.

### Tags comunes
`#zettelkasten`, `#moc`, `#Apunte`. Añade los que tu dominio requiera.

---

## 4. MOCs (Mapas de Contenido)

Viven en `Zettelkasten/` con prefijo `MOC - <tema>.md`. Son índices temáticos. Crea uno cuando notes acumulen en un área (no antes).

---

## 5. Memoria del agente (carpeta `Memoria/`)

`Memoria/` es **persistente y transversal a iteraciones**: **nunca se archiva**. Estructura espejo del vault:

- `Memoria/Inbox/` — capturas del agente (intuiciones, observaciones del usuario).
- `Memoria/Input/` — inputs externos (docs, prompts efectivos, fragmentos de APIs).
- `Memoria/Journal/` — reflexiones de sesión (qué funcionó, qué no).
- `Memoria/Output/` — artefactos producidos (prompts refinados, plantillas).

**No guarda**: PATs, secretos, credenciales. Ver `AGENTS.md` sección 6.

---

## 6. Archivación de iteraciones (comando `/archive-vault`)

Cuando el vault crece demasiado, se archiva la iteración actual y se crea la siguiente.

### Archivos de iteración
- `0001_Archivo/` — Primera iteración (esta guía).
- `0002_Archivo/`, `0003_Archivo/`, `0004_Archivo/`... — secuencia creciente.

### Comando `/archive-vault`
- `/archive-vault` (default) — archiva **todo**: mueve Inbox/Input/Journal/Output a nueva `0xxx_Archivo/`, reubica imágenes sueltas en `Imagenes/`, recrea carpetas activas vacías.
- `/archive-vault keep` — excluye el journal más nuevo y sus imágenes referenciadas (se quedan activos en raíz).
- `/archive-vault all` — alias del default.

**`Memoria/` NUNCA se archiva.** Permanece intacta entre iteraciones — el agente siempre sabe dónde buscar su memoria.

### Cómo archivar (manualmente, si prefieres no usar el comando)
1. Crear nueva carpeta `0xxx_Archivo/` con subcarpetas `Inbox/`, `Input/`, `Journal/`, `Output/`.
2. Mover el contenido activo de raíz → `0xxx_Archivo/`.
3. Mover PNG sueltos de raíz → `Imagenes/` (Obsidian resuelve `![[...]]` desde cualquier carpeta).
4. Recrear carpetas activas vacías en raíz.
5. Copiar este `migration.md` al nuevo `0xxx_Archivo/` y actualizar el número de iteración.
6. Marcar este `migration.md` como HISTÓRICO (cambiar encabezado y "Última actualización").
7. Actualizar `README.md` y `AGENTS.md` con la nueva referencia.

---

## 7. Instrucciones para Auto-Trabajo (Agente IA)

### Paso 1 — Leer contexto
- Lee este archivo (`0xxx_Archivo/migration.md`) primero.
- Lee `AGENTS.md` para identidad, preferencias del usuario y restricciones.
- Revisa los MOCs relevantes en `Zettelkasten/`.

### Paso 2 — Leer notas relevantes
- Usa grep/glob para encontrar notas por tag, nombre, o contenido.
- Lee solo los archivos necesarios.
- Revisa `Memoria/` para contexto previo del agente sobre el usuario.

### Paso 3 — Procesar
| Tarea                          | Acción |
|--------------------------------|--------|
| Crear nota nueva               | Determinar carpeta destino con la regla de enrutamiento, crear archivo con tags |
| Organizar notas dispersas      | Mover de `Inbox/` a su carpeta destino |
| Actualizar MOC                 | Leer el MOC relevante, agregar nueva referencia |
| Archivar iteración             | Usar `/archive-vault` (preferido) o seguir sección 6 |
| Buscar información             | grep/glob sobre carpetas relevantes |
| Sincronizar con GitHub         | Usar `/git-full` (ver `AGENTS.md` sección 6) |

### Paso 4 — Verificar
- Carpetas correctas. Tags consistentes. Referencias entre notas no rotas.

### Paso 5 — Reportar
- Qué se hizo, qué se movió/creó. Sugerir próximos pasos.

---

## 8. Notas especiales

- `Zettelkasten/PlantillaEstudio.md` — prompt template para estudio con IA.
- `Zettelkasten/PlantillasPromts.md` — índice de plantillas de prompts.
- `Zettelkasten/ProcesamientoZettelkasten.md` — reflexiones sobre el flujo.
- `.gitignore` excluye `.obsidian/`, `.smart-env/`, `.webui_secret_key`, `Memoria/.secrets/`.

---

*Última actualización: 2026-07-15 — Versión template inicial, iteración 1*