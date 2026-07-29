---
description: Limpiar transcripciones crudas de Teams en Input/ (fusiona turnos, quita relleno, .txt -> .md compacto). Limpieza mecanica, no resume.
subtask: true
---

El usuario quiere limpiar la transcripcion cruda de una reunion antes de sintetizarla.

Argumentos recibidos: "$ARGUMENTS"

- Sin argumentos -> procesa todos los `.txt` de `Input/`.
- Con un nombre/ruta de archivo -> procesa solo ese.
- Si contiene "force" -> agrega `-Force` (sobreescribe el `.md` existente).

Ejecuta el script:

!`pwsh scripts/Clean-Transcript.ps1`

Si el script reporta exito, confirma al usuario en UNA linea el resumen que escupio (bloques -> turnos, relleno descartado, KB). No agregues explicacion.

Si aborta porque el `.md` ya existe, dile al usuario que use `/clean-transcript force`. No borres nada tu.

Reglas:
- El `.txt` crudo NUNCA se borra: es la fuente. El `.md` limpio es el que se lee para sintetizar.
- Esta limpieza es **mecanica**. No resumas ni interpretes en este paso — la sintesis va despues, en su propia nota de `Inbox/`.
- Si el script avisa "sin bloques Local/Online speaker", el archivo no es una transcripcion de Teams: reportalo y no lo toques.
