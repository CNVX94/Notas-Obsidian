---
description: Archivar iteracion actual del vault (mover Inbox/Input/Journal/Output a 0xxx_Archivo/, reubicar imagenes en Imagenes/, recrear carpetas activas). Memoria/ nunca se archiva.
subtask: true
---

El usuario quiere archivar la iteracion actual del vault Zettelkasten.

Argumentos recibidos: "$ARGUMENTS"

Determina el flag segun el argumento:
- Si contiene "keep" -> ejecuta con `-KeepCurrentJournal`
- Si contiene "all" o esta vacio -> default (archivar todo)

Ejecuta el script:
!`pwsh scripts/Archive-VaultIteration.ps1$($ARGUMENTS -match 'keep' ? ' -KeepCurrentJournal' : '')`

Si el script reporta exito, confirma al usuario en UNA linea el resumen que escupio el script (numero de nueva iteracion, conteos). No agregues explicacion.

Si el script aborta (nada que archivar, carpeta ya existe, etc.), muestra el mensaje de error del script tal cual y sugiere al usuario que revise. No intentes arreglarlo tu.

No hagas commit ni push despues — eso es `/git-full`.