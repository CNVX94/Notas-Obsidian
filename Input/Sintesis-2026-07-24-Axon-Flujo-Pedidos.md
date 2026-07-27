---
fecha: 2026-07-24
tipo: sintesis
proyecto: CINLAT iTMS Axon
fuente: "[[2026-07-24]] (Journal, sesión de recorrido de flujos con Chris)"
tags: [axon, sintesis, contexto-agente, flujo-pedidos]
---

#Apunte #axon

# Axon iTMS — Contexto mínimo para retomar (2026-07-24)

> Síntesis del recorrido end-to-end del flujo de pedidos hecho con Chris. Fuente: [[2026-07-24]].
> Documentación de Chris (fuente independiente): [[Doc-Chris-69-Panorama-Operativo-Axon]].
> Reunión previa del mismo día (catálogos/cotizador): [[Reunion-2026-07-24-Axon-Puntos]].

## 1. Estado actual

- El core operativo de Axon está mayormente construido. Lo que falta es **cablear vistas y cerrar huecos de UI**, no reconstruir dominio.
- La sesión recorrió el diagrama de flujo **punto 1 → punto 9 (Etapa 1)**: recepción de pedidos, reglas de negocio, validación de productos, consolidación, asignación de transporte, liberación de carga, tracking, cierre.
- Existen dos universos de pedido ya implementados por Chris en el MVP: **Marketplace/paquetería** e **Inteligente/B2B**. Faltan clientes de prueba cargados (compañía GST con Daikin y Werfen, productos de 3.5 kg).
- **Portal de monitoreo es el único portal que no existe** todavía.

## 2. Objetivos activos

1. **Ingesta P8 (Richi)**: bajar pedidos con su instrucción de trabajo; el tipado y distribución de pedidos queda del lado de P8, Axon consume.
2. **Refactor de navegación en tres bloques**: `Flujo` · `Portales` · `Herramientas` (catálogos). Patio hoy vive en Flujo y **no debería** — es operación de instalaciones.
3. **Cotizador**: convertir el offcanvas del carrito en modal más grande; visibilizar accesorios, maniobras, custodias externas y los dos márgenes (costo proveedor + margen al cliente).
4. **Manifiestos**: crear el **consolidado de manifiestos** (no existe).
5. **Control operativo**: filtros por forma de envío y tipo; marcar si el pedido es de paquetería; solo muestra pedidos en curso (cerrados van a historial).
6. **Citas CEDIS + checklists** de puntos de control por tipo de visita.
7. Rediseño del **monitoreo de patio**.

## 3. Decisiones tomadas

- **Tres estatus de pedido** acordados: `Nuevo` (llegó de P8, sin trabajar, solo solicitud) → `Trabajado` (en caja, pesado, en tarima) → `En patio` (físicamente listo para subir a transporte).
- El estatus que llega de P8 usa `I` / `R` / blanco. **Blanco = ya procesado para operaciones (status 1)**; para P8 el blanco es vacío. Falta definir formalmente blanco vs vacío vs `null` y validarlo contra SCT.
- La **instrucción de trabajo** que baja con cada pedido se guarda en la bitácora/notas del pedido.
- El **snapshot operativo** se replantea como **tablero de pedidos** agrupado por estatus (recomendación de Chris), no como canvas.
- **Tracking ≠ monitoreo**: tracking es por guía (paquetería: FedEx, UPS, etc.) o por viaje; monitoreo es un portal aparte y entra en **fase 2**.
- **Ruteo**: no se envían todos los puntos a Maps porque recalcula. Se avisa cuando la ruta no está 100 % definida y se deja la traza en las instrucciones de viaje. Hay línea trazada en función de la geocerca.
- **POD = objeto de evidencia**, no un archivo: fotos del manifiesto, sello, documento interno, acuse de recibo, o coordenadas de entrega geolocalizadas.
- **Vocabulario de consolidación** (cerrado en la sesión):
  - *Directo*: al destino final.
  - *Centralizado*: varios pedidos entregados en un solo punto, que no es el destino final.
  - *Consolidado*: varios pedidos sin relación padre-hijo que se entregan en el mismo punto (ej. Liverpool Punta Norte con carga de compañías distintas y misma fecha, para ahorrar transporte).
  - *Ruta lechera*: varios puntos de entrega en un mismo envío. Consolidado **no** implica ruta lechera.
- **Cotización**: el flete base lleva margen, más escolta externa y maniobras de terceros; todo transparente al cliente. Se evaluó agregar tiempo mínimo de entrega + 1 hora al mapa del cotizador.

## 4. Problemas conocidos y riesgos

| # | Problema | Nota |
|---|---|---|
| 1 | Con sesión iniciada, navegar a `/login` vuelve a mostrar el login | Bug abierto, asignado a Michael |
| 2 | Vista "Tarifas" debe deprecarse (queda "Tarifario") | Pendiente de retirar |
| 3 | Faltan transportes en la matriz del Tarifario + falta logo de carrier | |
| 4 | En "Clientes" se listan compañías | Confusión de jerarquía en la vista |
| 5 | Sync de productos desde P8 arrastra destinos **en cascada** amarrados a clientes | No se pueden traer destinos de forma independiente |
| 6 | Carta porte / importaciones dentro del core | Chris no sabe por qué está ahí. Carta porte ≠ manifiesto: es el formato que ampara el traslado, firmado con CFDI. **Falta definir alcance** |
| 7 | Vistas de embarques deben soportar 30+ embarques cómodamente | Riesgo de UX al escalar |
| 8 | La bitácora del viaje es manual | Falta cablearla con los eventos del viaje |
| 9 | Despacho y "firmado por": no se sabe cómo está implementado hoy | Requiere revisión |
| 10 | Puntos de entrega: no cargar todos los destinos de golpe en el mapa | Cargar por cliente |

## 5. Trabajo pendiente

**Pedidos e ingesta**
- Definir semántica `I` / `R` / blanco / vacío / `null` y validar contra SCT.
- Recuperar la guía de archivo aparte para pedidos B2B (cuando detecte archivo, buscar guía).
- Segunda fase de pedido: recuperar distribución de cajas y peso de caja desde P8 (peso extra por caja).
- Cargar clientes de prueba de la compañía GST (Daikin, Werfen).

**Vistas faltantes**
- Vista de pedidos para Axon (hoy solo existe en MVP).
- Consolidado de manifiestos.
- Rediseño de monitoreo de patio.
- Filtros en control operativo (forma de envío, tipo).
- Portal de monitoreo (fase 2).
- Refinar vistas de entrega/carga y del checklist de viaje.

**Citas y patio**
- Código de cita + QR, a quién notificar la entrada, requisitos de acceso.
- Gestión de citas y recepción de quien llega sin cita (walk-in).
- Reasignación de andén/patio cuando el asignado está ocupado.
- Puntos de inspección obligatorios y flujo de inspección en recepción.
- Aviso de privacidad para documentos privados.
- Checklist de entrada y de salida (rechazo solo se activa si hay rechazo).

**Viajes**
- Cita programable desde el viaje (ya se sabe qué viaje y qué porteador llegan).
- Checklist de revisión de puntos de control en `Viajes/Detalle`.
- Más datos de transportista y operador, con match contra la unidad.
- Poder cerrar el viaje y subir evidencia después.
- Fecha compromiso en formato 24 h con incrementos de media hora.
- Poder reasignar porteador distinto cuando falla el asignado.

## 6. Próximos pasos sugeridos

1. Cerrar la definición de estatus de pedido con Richi y P8 — bloquea la ingesta y el tablero de pedidos.
2. Ejecutar el refactor de navegación (Flujo / Portales / Herramientas) y sacar Patio de Flujo: es el cambio estructural del que dependen varias vistas.
3. Arreglar el bug de `/login` (aislado, rápido).
4. Cotizador → modal, con el desglose completo de accesorios y márgenes. Es lo que valida el motor de precios antes de cargar pedidos.
5. Construir el consolidado de manifiestos y los filtros de control operativo.
6. Definir con negocio el alcance de carta porte / importaciones antes de tocar código.

## 7. Ambigüedades del Journal (no resueltas, no asumidas)

- "las reglas quedan del lado de P8 para **amazar** y distribuir" — término no identificado (posiblemente "amarrar").
- "**Pre pal** es que estando en embarques lo materializamos" — frase incompleta.
- "a menos que **pedudi** diga mandarlo directo" — palabra ilegible.
- "lo tomo como una retroalimentación más por **chocar**" — posiblemente "checar".
- La entrada termina truncada en "Chris revisa flujos para…"; falta el cierre de la sesión.
- Marcados con `(?)` en el original y sin confirmar: si los pedidos confirmados realmente no se pueden borrar; si el inicio de viaje puede dispararse desde Axon; si dos paqueterías distintas realmente no pueden ir en el mismo camión.
