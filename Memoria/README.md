# Memoria/ — Memoria persistente del agente

Esta carpeta es la **memoria del agente** que opera este vault. Diferente del contenido del usuario (`Inbox/`, `Input/`, `Journal/`, `Output/` de la raíz), `Memoria/` es **persistente y transversal a iteraciones**: **nunca se archiva** con `/archive-vault`.

## Estructura (espejo del vault)

- `Memoria/Inbox/` — capturas del agente: intuiciones, observaciones del usuario, pendientes contextual.
- `Memoria/Input/` — inputs externos: docs relevantes aprendidas, ejemplos de prompts efectivos, fragmentos de APIs.
- `Memoria/Journal/` — reflexiones de sesión: qué funcionó, qué no, patrones del usuario. Formato libre.
- `Memoria/Output/` — artefactos producidos: prompts refinados, plantillas, resúmenes generados.

## Reglas

1. **No se archiva nunca.** El comando `/archive-vault` mueve las carpetas del vault pero deja `Memoria/` intacta.
2. **No guarda secretos.** PATs, tokens y credenciales NO van aquí. Van en Git Credential Manager (ver `AGENTS.md` sección 6). `.gitignore` bloquea `Memoria/.secrets/`, `*.secret`, `*.token`.
3. **Es del agente, no del usuario.** El usuario puede leer y editar libremente, pero el agente la mantiene activa entre sesiones e iteraciones.

## Cómo escribir

- Cuando aprendas algo del usuario (preferencia, patrón, corrección), anótalo en la subcarpeta correspondiente.
- Archivos en formato libre, prefijo según subcarpeta: `Inbox/*.md`, `Input/*.md`, `Journal/*.md`, `Output/*.md`.
- Mantén entradas concisas — el objetivo es contexto, no prosa.

Ver `AGENTS.md` sección 4 para más detalles.