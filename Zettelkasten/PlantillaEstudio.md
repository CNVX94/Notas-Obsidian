#Apunte #Prompt

# Plantilla de Estudio

Prompt template para estudio asistido por IA. Copia y rellena losplaceholders al iniciar una sesión de estudio.

---

## Prompt

> Estoy estudiando **{{TEMA}}** desde la fuente **{{LIBRO/CURSO/ARTICULO}}**.
>
> Mi nivel actual: **{{principiante|intermedio|avanzado}}**.
>
> Objetivo de esta sesión: **{{objetivo_concreto}}** (ej: entender X, comparar Y, resolver Z).
>
> Modo: **{{explicación guiada|preguntas y respuestas|resumen para ficha Zettelkasten}}**.
>
> Reglas:
> - No inventes. Si no sabes, dilo.
> - Cita la fuente si la conoces.
> - Termina con 3 preguntas de comprobación.
> - Sugiere 2 conexiones con temas que YA conozco (mira mi vault si tienes acceso).

## Ficha Zettelkasten resultante

Al terminar, produce una ficha con:

```
#tag1 #tag2
# <Título conciso>

<tesis en 1-2 líneas>

## Idea principal
...

## Conexiones
- [[nota existente]] — relación
- [[nota existente]] — relación

## Preguntas abiertas
- ...
```