#Prompts
Objetivo Genera una nota de síntesis dentro del directorio `/Input` cuyo propósito sea proporcionar el contexto mínimo necesario para que cualquier agente o desarrollador comprenda rápidamente el estado actual del proyecto, los objetivos inmediatos y el trabajo pendiente. La nota debe ser breve, precisa y enfocada en facilitar futuras sesiones de planificación. Contexto La fuente principal de información es el archivo más reciente ubicado en `/Journal`. Adicionalmente existe documentación elaborada por Chris en el proyecto Axon, asociada al commit: `69c20d4c04df9715175210dc28b88d5ad906d1f3` Ruta del proyecto: `C:\Users\desarrollo 6\Documents\GitHub\CINLAT.iTMS.Axon` Esta documentación representa una fuente de conocimiento independiente y deberá procesarse por separado. Tareas Parte 1 - Síntesis del Journal

1. Localiza el archivo más reciente dentro de `/Journal`.
2. Corrige únicamente errores evidentes de sintaxis, ortografía o formato, sin alterar el significado del contenido.
3. Agrega al inicio del Journal una referencia (enlace o ruta) hacia la nueva nota de síntesis generada.
4. Crea una nueva nota dentro de `/Input`.

La nota debe incluir únicamente la información relevante para comprender:

- Estado actual del proyecto.
- Objetivos activos.
- Decisiones importantes tomadas.
- Problemas conocidos o riesgos.
- Trabajo pendiente.
- Próximos pasos sugeridos.

Evita copiar texto literalmente salvo cuando sea estrictamente necesario. Parte 2 - Documentación de Chris En paralelo, revisa la documentación introducida en el commit: `69c20d4c04df9715175210dc28b88d5ad906d1f3` Genera una segunda nota independiente que contenga:

- Resumen del contenido.
- Objetivos que persigue.
- Conceptos importantes.
- Cambios relevantes respecto al proyecto.
- Etiquetas apropiadas para clasificar esta documentación dentro del contexto del proyecto Axon.

No mezcles esta información con la síntesis del Journal. Parte 3 - Comparación Una vez generadas ambas notas, realiza una comparación entre ellas indicando:

- Información coincidente.
- Información presente únicamente en el Journal.
- Información presente únicamente en la documentación de Chris.
- Posibles inconsistencias.
- Información que convendría incorporar a la base de conocimiento compartida.

Criterios de calidad La síntesis debe:

- Priorizar claridad sobre cantidad de información.
- Servir como contexto para futuros agentes de código.
- Eliminar información redundante.
- Conservar únicamente información accionable.
- Ser fácil de leer en menos de cinco minutos.

Si existe alguna ambigüedad, indícala explícitamente en lugar de asumir información. Procede cuidadosamente y verifica que cada conclusión esté respaldada por la documentación revisada.