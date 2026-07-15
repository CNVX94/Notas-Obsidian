# zettelkasten-template

Template de vault Zettelkasten para Obsidian con agente opencode personalizable, comando de archivación periódica (`/archive-vault`), y flujo git sincronizado (`/git-full`).

Pensado para usarse con el botón **"Use this template"** de GitHub: genera un repo nuevo, clonar, empezar a escribir.

---

## Cómo usar

### 1. Crear tu vault desde el template
- En GitHub: click **"Use this template"** sobre este repo → crea `<tu-usuario>/<tu-vault>`.
- Clona el nuevo repo a tu máquina.
- Ábrelo en Obsidian (carpeta del repo).

### 2. Personalizar el agente
- Edita `AGENTS.md` sección 3 ("Estilo del agente") con tus preferencias (nombre, idioma, nivel de detalle).
- El agente leerá esos valores en cada sesión.

### 3. Configurar Git Credential Manager (una sola vez)
```powershell
git config --global credential.helper manager
```
Esto permite que `git push` dispare un diálogo nativo de Windows la primera vez, guarde el PAT encriptado en el SO, y nunca lo pida de nuevo.

### 4. Flujo diario
- Escribe notas. Journal en `Journal/YYYY-MM-DD.md`, capturas en `Inbox/`, etc. (ver reglas en `AGENTS.md`).
- `/archive-vault` cuando el vault crezca → archiva la iteración en `0xxx_Archivo/`.
- `/git-full "mensaje"` o `/git-full` → commit + push a GitHub.

---

## Flujo Zettelkasten
```
Journal → Inbox → Input → Zettelkasten → Output
(diario)  (captura) (fuente) (conocimiento) (producción)
```

Ver `AGENTS.md` sección 2 para reglas de enrutamiento.

---

## Estructura
```
zettelkasten-template/
├── AGENTS.md                  ← identidad del agente (personalizable)
├── README.md                  ← este archivo
├── .gitignore / .gitattributes
├── 0001_Archivo/              ← iteración 1 (archivado inicial, estructura espejo)
│   └── migration.md           ← guía activa del vault
├── Imagenes/                  ← todas las imágenes
├── Inbox/  Input/  Journal/  Output/   ← carpetas activas (vacías)
├── Zettelkasten/              ← MOCs y plantillas
├── Memoria/                   ← memoria PERSISTENTE del agente (no se archiva)
├── scripts/
│   ├── Archive-VaultIteration.ps1
│   └── Git-FullSync.ps1
└── .opencode/
    ├── opencode.json
    ├── skills/zettelkasten/SKILL.md
    └── commands/
        ├── archive-vault.md
        └── git-full.md
```

---

## Comandos del agente

| Comando | Descripción |
|---------|-------------|
| `/archive-vault` | Archiva iteración (default: archiva todo). Mueve Inbox/Input/Journal/Output a nueva `0xxx_Archivo/`, reubica imágenes en `Imagenes/`, recrea carpetas activas. |
| `/archive-vault keep` | Igual pero excluye el journal más nuevo y sus imágenes (se quedan activos). |
| `/archive-vault all` | Alias del default. |
| `/git-full` | `git add -A` + `commit` + `push`. Setup interactivo si no hay remote. Mensaje default: `vault sync YYYY-MM-DD HH:mm`. |
| `/git-full "mensaje"` | Igual pero con mensaje custom. |

Ambos corren como **subtask** — el contexto del usuario no se llena con logs.

---

## Restricción de seguridad (ver `AGENTS.md` sección 6)

- El agente NUNCA se configura como colaborador del repo GitHub.
- El agente NUNCA escribe PATs ni secretos a `Memoria/` ni a ningún archivo del repo.
- Autenticación vía Git Credential Manager (GCM), PAT encriptado en el SO.
- `.gitignore` bloquea `Memoria/.secrets/`, `*.secret`, `*.token`.

---

## Por qué no incluye CodeGraph

CodeGraph indexa símbolos de código con tree-sitter (funciones, clases, call graphs). Su valor está en repos de código, no en prosa Markdown. Para un vault de notas, la indexación referencial real la provee Obsidian nativamente (tags `[[]]`, backlinks, MOCs) más grep nativo de opencode. Añadir codegraph aquí sumaría un `.codegraph/` costoso en tokens sin retorno útil.

Si en el futuro guardas **mucho código embebido** dentro de notas (snippets largos), puedes inicializarlo después siguiendo las instrucciones del proyecto CodeGraph.

---

*Template inicial — 2026-07-15*