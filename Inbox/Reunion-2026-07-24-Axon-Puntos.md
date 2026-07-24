---
fecha: 2026-07-24
tipo: reunion
proyecto: CINLAT iTMS Axon
participantes: [Bruno, Richi, Chris, Michael]
fuente: transcripcion 20260724_110554 + capturas de Chris
tags: [axon, reunion, pendientes]
---

# Reunión 2026-07-24 — Axon iTMS (puntos y pendientes)

## Contexto
Richi re-ingestó clientes (Cursor pidió borrar datos; al borrar clientes la **cascada arrasó las tarifas**). Las tarifas se **restauraron desde backup** (`backup_transportistas.sql`, 572 tarifas por carril/zona, ON CONFLICT DO NOTHING — corrió limpio, FKs íntegros). Objetivo de la sesión: dejar catálogos + **cotizador** al 100 para **validar el motor de precios** antes de cargar pedidos.

Estados: ✅ hecho · 🔧 en progreso · ⏳ pendiente · 🔴 no da tiempo (fuera de alcance corto).

---

## 1. Ingesta y datos — Richi
- ✅ Re-ingesta más limpia que ayer (agrupada bien; Liverpool SA con sus destinos).
- ⏳ **CP inválidos de P8** (`99999`, `88888`): el algoritmo les agrega un `0` y **ubica mal** (99990→Zacatecas, real es Ixtapa/Zihuatanejo Edomex; 88888→Tamaulipas Méndez, real Morelos). Son excepciones a corregir a mano; baja prioridad (destinos desconocidos/rurales).
- ⏳ Faltan: **asignar CP pendientes a zonas** + re-ingestar → 100%.
- ⚠️ Datos de origen sucios (Victor/CINLAT): RFC basura (Suburbia Apodaca RFC "sub2024"), Christian Dior = 3 registros con RFC distinto, misma compañía 18 (clientes 1/2/3). Compañías que **no tienen clientes** en el sandbox (Claudalie/Caudalie: Victor no la cargó). → pedir a Victor **cargar todos los clientes**.
- 🔧 **Geocodificación (Google Maps)** de destinos implementada como job aparte (3 intentos, luego manual). Falta probar.
- ⏳ **Socios logísticos**: llegaron placas/vehículos de transportistas (carpeta Transportes v1/v2 con operadores) → ingestar ("claudiazo").

## 2. Zonas / Cobertura
- ⏳ **Zona Metropolitana**: definir municipios conurbados. Candidatos mencionados: Naucalpan, Tlalnepantla (de Baz), Ecatepec (de Morelos), Cuautitlán, Cuautitlán Izcalli, Atizapán de Zaragoza, Coacalco, Nezahualcóyotl, Lerma. Los CP de ZM traen "punto" y no pasan SEPOMEX → Richi no los ingestó (por eso ZM = 0 destinos). **Owner: Chris/Bruno definen lista; luego se carga.**
- ⏳ **Modal de cobertura**: agrupar por **Estado + Municipio** (no lista plana de CP); tope de 500 por solicitud → mostrar todos agrupados. UX.
- ℹ️ Las 54/55 zonas ya quedaron con cobertura CP (solo faltaba ZM).

## 3. Login — Michael
- ⏳ **Bug**: tras iniciar sesión, si vas a `/login` **sigue mostrando el login** (debería redirigir estando autenticado). **Michael lo toma.**

## 4. Tarifas / Tarifario / Cotizador — Chris
- 🔴/⏳ **Vista "Tarifas"** (B1/B2 — *captura 1, modal Nueva tarifa "sin ruta comercial"*): **se depreca** ("esta se va"). La buena es **Tarifario**. Además quitar la columna "sin ruta comercial".
- 🔧 **Vista "Tarifario"** (*captura 2, matriz porteador × clase*): es la correcta. **Faltan los transportes** (algunos tipos de vehículo/carriers no cargan en la matriz) → arreglar. Falta **logo** de un carrier (Belcar/Gmax). Ya muestra extras del transportista.
- 🔧 **Cotizador** (*captura 3, carrito offcanvas*):
  - Bug: **no cargaba clientes** (Chris lo arregló, subiendo cambios).
  - **Offcanvas del carrito → hacerlo más grande / convertir en modal** para apreciar accesorios/maniobras/custodias externas + los dos márgenes (default y flete). "Ya está la base."
  - Custodia/maniobra pueden ser de **otro carrier (externas)**; transparente al cliente. En la cotización se agregan a mano.
  - Mapa = **solo ilustrativo** (el destino no trae coords → no se traza ruta). OK así.
  - **Crítico**: el cotizador valida el motor de precios; debe quedar bien antes de pedidos.

## 5. Clientes / Compañías / Productos / Puntos de entrega
- ✅ **Perfil cliente — editar punto de entrega** (*captura 5*): en editar **no salía el buscador de mapa/Places como en Agregar** → **CORREGIDO** (editar = agregar pre-llenado: buscador Places + pin en la ubicación actual + dirección editable). *Owner: Bruno/Michael.*
- ⏳ **Perfil cliente — lista de puntos**: mostrar **todos** y al clicar uno mostrar **solo ese a la derecha** (ficha). El código ya lo hace; falta reproducir el bug exacto reportado.
- ⏳ **Compañías — editar** (*captura 4, modal Editar cliente*): el editar de **compañía** debe tener **los mismos campos/info que el modal de Editar cliente** (logo, comercial/SLA, contacto…). Homologar. **Además quitar un campo que es "de proceso, no de catálogo"** (en la transcripción se oye "cumpleaños" — error de speech-to-text; Richi dijo que ya lo había quitado). Identificar cuál al abrir el modal.
- ⏳ **Clientes por compañía**: bug de vista — el número grande (ej. "52") es el **# de compañía, no la cantidad de clientes** → confunde; agregar tooltip/helper que aclare (como en Productos).
- 🔧 **Logos**: mostrar logo de compañía en destinos/cadenas importantes (Liverpool, Palacio de Hierro). No todos los clientes; solo destinos grandes. *Concepto clave*: una cadena (Liverpool) aparece 3× porque cada compañía (Latamel/Movado/TP-Link) vende en **distintas tiendas** de esa cadena — los puntos de entrega SON las tiendas.
- 🔧 **Productos** (*captura 4*): vista buena. Cambiar label "sincronizar" → **"Sincronizar desde ERP"**. El sync por compañía trae productos (P8/Torre de Control) + **en cascada los destinos** amarrados a clientes (los destinos no se sincronizan solos).
- ⏳ **Vista global Puntos de entrega (/DeliveryPoints)**: no trae todos de golpe / sin orden. Agregar **filtro compañía→cliente**; mapa por cliente; no cargar los ~1494/79k de golpe.

## 6. Pedidos / Filtros — Bruno
- ✅ **Filtro cliente en Pedidos**: select → **input typeahead** con lazy-load (50 + scroll trae otros 50, con loader; no lanza todo de golpe). Hecho. + filtro **Compañía** server-side + **Modalidad** server-side.

## 7. Proceso / Portal Transportista (mayormente 🔴)
- Conciliación con **1 semana de retraso**; recorrer el plan.
- 🔴 Licitación, recolección con evidencia, manifiesto de recolecciones, motor de cierre → **no da tiempo** en el corto plazo.
- Bruno + Richi trabajan **pedidos/citas**. El **MVP** tiene mucho hecho; falta pasarlo al ITMS + **rediseño de vistas** para agrupar mejor.
- Portal transportista: bandejas de viajes para aceptar; confirmación + asignación de vehículo ya casi; falta confirmación.

---

## Reparto Bruno ↔ Michael
(Richi = ingesta, aparte. Chris en reunión → sus mejoras de tarifas pasan a nosotros.)

| # | Punto | Sugerido | Estado |
|---|---|---|---|
| 1 | Login: `/login` sigue apareciendo autenticado | **Michael** | ⏳ |
| 2 | Editar punto de entrega = agregar (mapa/Places) | Bruno | ✅ |
| 3 | Lista puntos: todos + clic → solo uno (repro) | **Bruno** | ⏳ |
| 4 | Editar compañía = campos de editar cliente + quitar campo "de proceso" (transcrito "cumpleaños") | **Michael** | ⏳ |
| 5 | Clientes x compañía: aclarar "# compañía ≠ # clientes" | **Michael** | ⏳ |
| 6 | Productos: label "Sincronizar desde ERP" | **Michael** | ⏳ |
| 7 | /DeliveryPoints: filtro compañía→cliente + mapa por cliente | **Bruno** | ⏳ |
| 8 | Zona Metropolitana: definir + cargar municipios | **Bruno** | ⏳ |
| 9 | Modal cobertura: agrupar Estado+Municipio | **Bruno** | ⏳ |
| 10 | Cotizador offcanvas → modal más grande | **Bruno** | ⏳ |
| 11 | Tarifario: faltan transportes en la matriz + logos | **Michael** | 🔧 |
| 12 | Deprecar vista "Tarifas" (queda Tarifario) | **Michael** | ⏳ |
| — | Republicar API+operador+transportista (deploy) | Bruno | ⏳ |

## Backend / infra (nuestro lado, pendiente de deploy)
- Republicar **API + operador + transportista** desde DESARROLLO: desbloquea 503 y activa filtro cliente/compañía/modalidad, `lite`, badge HU-consolidada, B2B preview, KPI 30d.
