---
fecha: 2026-08-04
tipo: plan
proyecto: CINLAT iTMS Axon
tags: [axon, plan, reparto, redisenos, mvc, ejecucion]
---

#Apunte #axon

# Plan de reparto — Rediseños iTMS (post revalidación 2026-08-04)

> Reparto de los rediseños + poda que salieron de [[Sintesis-2026-08-04-Axon-Revalidacion-Flujo]], con specs por tarea.
> Roles: **Bruno** = Planificación/Rutas · **Michael** = Ejecución · **Richi** = ingesta P8 (backend).
> Decisión de fondo: **ajustar el iTMS, NO rehacer el MVC** (solo ~8 de ~101 vistas necesitan rediseño).

---

## Reparto por persona (colas ordenadas)

| # | Bruno | Michael |
|---|---|---|
| 1 | **Programa de Embarques** (deadline fin de agosto) | **Viajes — refactor ILUMINA** |
| 2 | **Detalle del pedido** (+ integrar Empaquetar) | **Patio** (andenes + citas calendario) |
| 3 | **Modal Recolección + Nodos** | **Zonas** (puntos de color) |
| — | | **Tablero de pedidos** (kanban + control operativo) |

**Compartido / coordinado:** **poda segura** · **ruta lechera CORE** (backend/Chris).

> **Richi** sigue en **ingesta P8** (backend), la dependencia que alimenta el Programa. Su ayuda en vistas se define después.

---

## Michael

### 1. Viajes — refactor ILUMINA

Basada en las capturas de ILUMINA de la reunión.

**Qué:** rediseñar la vista de Viajes (`ViajesController` + `Views/Viajes/`) del iTMS.

**Lista de viajes:**
- Indicar el **tipo** de cada viaje: `Ruta lechera` o `Directo` (badge).
- Desglosable: al abrir, ver sus paradas.

**Detalle de un viaje:**
- **Mapa grande** protagonista (carrito + trazado del viaje).
- Panel de **paradas** con su **secuencia** (1, 2, 3…).
- **Bitácora de viaje** (rescatarla — eventos/estatus).
- Métricas de ruta (tiempo, riesgo, entregado) al costado, tipo tarjeta.
- El detalle de un viaje = como el monitoreo general, pero **de ese viaje**.

**Fuera de alcance (Fase 2):** monitoreo en vivo multi-carrito (varios viajes a la vez). No hacerlo ahora.

**Referencia visual:** capturas ILUMINA (`apps.gstech.com.mx:9060/tms/tower`) — vista Seguimiento (tarjeta de ruta) + detalle de viaje (SECUENCIA OPERATIVA, PARADAS, Métricas de Ruta).

**Área:** Ejecución / monitoreo.

### 2. Patio (andenes + citas)

- Quitar el **"plano 2"** (materialización rara).
- Retomar la vista de **cuadritos de andenes** con **foco parpadeante** para los que no tienen cita (se ve mejor y más simple).
- **Citas en calendario:** seleccionar patio → andén → ver horarios disponibles.
- **Unificar en un solo menú** todo patio / andenes / citas / recolecciones-en-patio.
- Archivos: `PatioController` (+ Facility: Appointments/Visits/DockScheduling), `Views/Patio/`, `patio.js`.
- Nota: Chris lo retoma en sesión aparte, pero puede avanzar la base.

### 3. Zonas (puntos de color)

- Cambiar en el mapa el render de **logos/imágenes de clientes → puntos de color** (paleta fija o random por cliente).
- Motivo: **rendimiento** — con imágenes y muchos puntos se traba.
- Mantener el árbol Compañía→Cliente→Punto. Las coberturas de Richie quedan bien (no tocar).
- Archivos: `ZonasController`, `Views/Zonas/`, `zonas.js/css`.

### 4. Tablero de pedidos (kanban)

- **Quitar la vista TABLA** (se duplica con Pedidos); dejar solo **kanban/cards**.
- **Combinar** el tablero (snapshot) con **Control operativo** (casi iguales): el control operativo dice qué hacer **ahora** por cada pedido.
- **Priorizar por FECHA/vencimiento** (color para vencidos), no por tipo.
- Archivos: `OperacionController`, `Views/Operacion/`, `operacion-panorama.js`.

---

## Bruno

### 1. Programa de Embarques (deadline fin de agosto)

- Sábana tipo Excel legible.
- **Orden por fecha en cascada** (más próximo a vencer arriba; **rojo** para próximos a vencer).
- Agregar **columna de ZONA**; **marcar/distinguir** centralizados vs directos.
- **Desglose:** poder ver qué pedidos trae cada programa (hoy no se ve).
- Al seleccionar 1-2 pedidos, según destino: crear **directo / consolidado / ruta lechera** → eso crea el programa.
- **Reglas:** no permitir programa **vacío** (0 pedidos); botón **Generar Manifiesto no procede** sin pedidos.
- Renombrar **"Planificación" → "Programa de Embarques"** (vista central).
- Los **bloqueos** (lo que falta antes de avanzar) aparecen **arriba en el programa**, no en el pedido.
- La **fecha del programa = día de salida**, no la cita (la cita es por pedido).
- Archivos: `ProgramaEmbarquesController`, `Views/ProgramaEmbarques/`, `ArmadoRutasController` (rename), `programa-embarques.js/css`.

### 2. Detalle del pedido (+ integrar Empaquetar)

- **Subir el contenido/detalle** del pedido (lo principal a mostrar) — hoy queda muy abajo.
- **Bajar la bitácora** al final (que no crezca empujando el contenido). El cabecero está bien.
- **Integrar el empaquetar** desde el detalle, **reusando el auto-empaque que ya hizo Michael** (backend listo). Mantenerlo simple.
- Completar datos de P8 (valor factura ya está; falta **cita/promesa**).
- Archivos: `Views/Pedidos/Detalle.cshtml`, `pedido-detalle.js`.

### 3. Modal Recolección + Nodos

- Agregar **"recolección"** al select del modal de Nuevo Pedido.
- Cuando es recolección, el **ORIGEN** carga los **nodos de recolección del cliente** (ej. Hermes / Plaza Mazaryk), **no** los orígenes normales; **destino** = punto de entrega (ej. CINLAT).
- Hoy está **invertido** (carga las listas equivocadas) → arreglar qué lista se llena según el flujo (entrega vs recolección). En pedido inteligente el origen carga solo puntos de origen + crossdock.
- Archivos: `Views/Pedidos/` (modal), `pedidos.js`, `NodesController`.

- El Programa necesita de Richi (P8) las fechas de cita + zona en destinos → coordinar.

## Richi — Ingesta P8 (backend)

Su ingesta alimenta el Programa:
- El Programa necesita **datos reales**: fechas de cita + zona en destinos.
- Unir tabla **`embarquecita`/SC020** (fecha embarque, cita, confirmación, autorización) por número de pedido.
- **Barrido** sobre todos los pedidos (3 días), fecha embarque nula = pendiente.
- Arreglar **destinos sin zona** (rompe la cotización del Programa).
- Agregar **cadena** (tienda/sucursal) y campos **largo/corto** de Joaquín.
- Su ayuda en **vistas: se define después**.

---

## Dependencia de datos

La **ingesta P8 de Richi** (fechas de cita + zona en destinos) alimenta el **Programa de Embarques** de Bruno.

## Pendientes a confirmar con Chris

1. "cierre" en la poda → ¿solo Incidentes o todo el grupo Cierre/Finanzas?
2. Contratos de tarifas → se conserva (no está en ninguna lista).
3. "catálogos globales" → quitar cards QUITAR del hub `/Datos`, NO el hub.
4. Ruta lechera CORE (secuencia, validaciones) → dimensionar con Chris (es backend/CORE).

## Deadline

**Programa de Embarques liberado antes de fin de agosto 2026** — usuarios empiezan a usarlo.
