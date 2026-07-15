---
description: Git add + commit + push full sync (setup interactivo si no hay remote, auth via Git Credential Manager). Restriccion HARD: el agente nunca es colaborador del repo, nunca escribe PATs.
subtask: true
---

El usuario quiere sincronizar el vault con GitHub (git add + commit + push).

Argumentos recibidos: "$ARGUMENTS"

Extrae el mensaje de commit de $ARGUMENTS (si viene vacio, el script genera default `vault sync YYYY-MM-DD HH:mm`). Si $ARGUMENTS tiene texto entre comillas o sin comillas, pasalo como `-Message "<texto>"`.

Ejecuta el script:
!`pwsh scripts/Git-FullSync.ps1$($ARGUMENTS -and $ARGUMENTS.Trim() -ne 'keep' -and $ARGUMENTS.Trim() -ne 'all' ? " -Message `"$ARGUMENTS`"" : '')`

Si el script reporta exito, confirma al usuario en UNA linea: commit hash + rama + mensaje + repo. No agregues explicacion.

Si el script aborta por auth (GCM no configurado):
- informa al usuario que ejecute `git config --global credential.helper manager`
- NO escribas el PAT en Memoria/ ni en ningun archivo. Ver AGENTS.md seccion 6.
- NO intentes arreglar la auth tu mismo.

Si el script aborta por non-fast-forward:
- informa: ejecuta `git pull --rebase origin <branch>` y vuelve a correr `/git-full`.
- NO intentes resolver el merge tu mismo.

Para otros abortos, muestra el output del script tal cual y sugiere al usuario revisar.