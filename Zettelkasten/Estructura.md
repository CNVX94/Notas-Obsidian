#Zettelkasten #estructura

# Estructura del vault

Flujo canónico:

```
Journal → Inbox → Input → Zettelkasten → Output
(diario)  (captura) (fuente) (conocimiento) (producción)
```

## Carpetas
- `Journal/` — diario, formato `YYYY-MM-DD.md`.
- `Inbox/` — capturas rápidas, temporal.
- `Input/` — notas provenientes de fuente externa (curso, libro, artículo).
- `Zettelkasten/` — conocimiento propio ya procesado, MOCs.
- `Output/` — entregables, proyectos, producción final.
- `Imagenes/` — todas las imágenes, referenciadas con `![[Imagenes/archivo.png]]`.

## MOCs
Índices temáticos en `Zettelkasten/` con prefijo `MOC - <tema>.md`.

## Iteraciones
El vault crece → se archiva en `0xxx_Archivo/` y se reinician las carpetas activas. Ver `0001_Archivo/migration.md` o el comando `/archive-vault`.

## Memoria del agente
`Memoria/` es persistente y no se archiva nunca.