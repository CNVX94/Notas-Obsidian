---
fecha: 2026-08-04
tipo: sintesis
proyecto: CINLAT iTMS Axon
fuente: "[[Revalidacion flujo.txt]] (transcripción reunión con Chris, 04-ago-2026)"
tags: [axon, sintesis, revalidacion-flujo, programa-embarques, ruta-lechera, tipos-pedido, contexto-agente]
---

#Apunte #axon

# Axon iTMS — Revalidación de flujo con Chris (2026-08-04)

> Síntesis del flujo revalidado (sin relleno). Reunión extensa: tipos de pedido, programa de embarques, ruta lechera, tarifas/zonas, y recorrido de vistas del iTMS con decisiones de rediseño/poda.
> Reunión previa relacionada: [[Sintesis-2026-07-24-Axon-Flujo-Pedidos]] · [[Reunion-2026-07-24-Axon-Flujo-MVP-por-fases]].
> Plan de reparto de los rediseños: [[Plan-2026-08-04-Reparto-Redisenos-iTMS]].

---

## 1. Reglas DURAS (mandan sobre todo)

1. **Todo opera por ZONA, no por radio.** El motor solo cotiza **zona-origen → zona-destino**. Chris vio la vista de radios ("interesante") pero la **descartó**: un radio se sale de zona y rompe tarifas.
2. **Ruta lechera = misma zona destino.** Perinorte + Satélite (Zona Metropolitana) sí forman lechera; Lindavista (CDMX) no → se separa como directo aparte. Mezclar zonas rompe el motor.
   - **Acción futura confirmada:** mecanismo para armar rutas con ~20 puntos de distintas zonas indicando con qué zona se cobra cada tramo.
3. **Consolidación = mismo lugar + misma fecha + NO mezclar clientes/compañías + SÍ Y SOLO SI CABE** (cubicaje). Ejemplo: Movado (150 hijos) + Zeppelin (20) puede dar ~15 t → no se consolida aunque "se pueda". Un consolidado puede partirse en 2+ viajes por capacidad.
4. **Alto valor (Hermes) = exclusivo/dedicado.** No mezcla con nadie. Puede armar lechera solo entre puntos del mismo Hermes.
5. **Destino (última milla) ≠ Punto de Entrega Operativo (PEO).** Directo: coinciden. Centralizado: PEO = CEDIS, última milla = tiendas (hijos). PEO vacío cuando CINLAT no hace la última milla.
6. **La cita solo ORDENA paradas** dentro de la ruta; NO habilita/impide la lechera (eso lo hace la zona). Sin cita, la hora da igual.
7. **No todo sale de CINLAT.** En recolección tienda→tienda el pedido nunca toca CINLAT; solo gestiona el transporte.

## 2. Tipos de pedido — matriz `Matriz de Pedidos.xlsx`

Grid literal de la matriz. Columnas: Consolida · Destino última milla (UM) · Punto de Entrega Operativo (PEO) · Recolección en CEDIS · D=PEO · Programar transporte · Usa Zona-Zona (Z-Z) · Calcula tarifa · Tracking/Monitoreo · Paquetería · Guía · Cita en CEDIS.

| Tipo | Regla | Cons | UM | PEO | Rec.CEDIS | D=PEO | Transp | Z-Z | Tarifa | Track | Paq | Guía | Cita CEDIS |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Directo** | 1 pedido, directo a tienda | SI | SI* | SI | NO | SI* | SI | SI | SI | SI | – | – | SI |
| **Marketplace** | Ecommerce, embarcado en patio por paquetería; destinos NO se guardan en lista de PE | SI | SI | NO | SI | NO | NO | NO | NO | NO | SI | SI | NO |
| **Centralizado (Pedido K)** | Pedido K con 1..N hijos, se entregan en CEDIS/HUB | SI | NO | SI | NO | NO/SI | SI | SI | SI | SI | – | – | SI |
| **Pedido A (hijo)** | Pedido hijo de un centralizado | SI | SI | SI | NO | NO | – | – | – | – | – | – | – |
| **Ruta Lechera** | Varios PE el mismo día, distintos lugares, misma zona, sin regla que impida consolidar. Orden por hora de cita; sin cita → operador o ruta óptima Google (f(tráfico…)). Conjunto de directos consolidados | SI | SI | SI | NO | SI | SI | SI | SI | SI | – | – | SI |
| **Consolidado** | Varios directos/centralizados con MISMO PEO, misma fecha, si caben y son consolidables | SI | SI | SI | NO | SI* | SI | SI | SI | SI | – | – | SI |
| **Directo Exclusivo** | Directo a tienda; consolidable solo por excepción (mismo cliente/compañía según reglas) | Excep. | NO | SI | SI | NO | SI | SI | SI | SI | – | – | SI |
| **Embarque en CINLAT (cliente recoge)** | El cliente manda su transporte a recoger en el CEDIS | N/A | SI | N/A | SI | NO | NO | NO | NO | NO | – | – | SI |
| **Envío por UPS** | Foráneo directo a tienda por paquetería (no MKP); destinos son tiendas/CEDIS (sí en catálogo) | SI | SI | N/A | SI | NO | SI* paq | NO | SI* (cajas) | NO | SI | SI | NO |
| **Recolección tienda (transporte)** | Directo inverso: recoge en tienda, entrega en CEDIS/otra tienda; CINLAT solo gestiona transporte | N/A | SI* | SI | NO | SI | SI | SI | SI | SI | – | – | NO (cita en tienda) |
| **Recolección tienda (paquetería)** | Igual, pero CINLAT gestiona paquetería | N/A | SI | NO | NO | NO | SI | NO | SI (cajas) | NO | SI | SI | NO |

**Notas de la matriz:**
- `SI*` = con matiz. En UPS y recolección-paquetería, el transporte/tarifa `*` lo hace/cobra la **paquetería por cajas**, no el transporte propio.
- **Marketplace:** la dirección del comprador se guarda como **dato**, no como punto de entrega en catálogo (a diferencia de UPS, cuyos destinos SÍ están en catálogo).
- **Cita:** casi todos en CEDIS; NO en Marketplace/UPS; la **recolección** tiene cita **en tienda**, no en CEDIS.
- **Recolección** son **dos** tipos: gestión de transporte vs gestión de paquetería (directo inverso). Fase 2, ~20/mes; el dato viene de **Torre**, no de P8.

> ⚠️ **Conflicto a confirmar con Chris (letra "K"):** la matriz modela **Centralizado = Pedido K** (padre con hijos) y **Pedido A = hijo**. En la transcripción se dijo que **K = consolidador de facturación/timbrado (varias compañías)**, distinto del Centralizado. La matriz NO incluye ese "K de facturación". Confirmar cuál es el modelo final antes de codificar.

## 3. Concepto clave: Programa ≠ Viaje

- **Programa de Embarques = planeación** (qué, cuándo, agrupación). **Viaje = materialización física** (quién lleva, chofer, unidad, cita origen, flete, de dónde a dónde).
- **1 programa → N viajes** (transportista se asigna **por viaje**).
- **Accesorios (maniobras, custodia) van en el PROGRAMA; el flete va en el VIAJE.** La vista de costos debe verse como **una nota/factura** con todo junto (hoy separado = confunde).
- Maniobra/custodia **las decide y autoriza el operador**; el sistema no las impone, solo registra quién decide y quién paga.

## 4. Datos / Ingesta P8 (Richie)

- **3 fechas por pedido:** entrega acordada, **cita confirmada (la buena, fecha+hora)**, vencimiento. Ventana: entrega ≤ cita ≤ vencimiento.
- Las fechas de cita NO vienen a nivel pedido → unir tabla **`embarquecita`/SC020** por número de pedido. Sube el proceso de ~12h a ~24h (dividir por bloques).
- **Barrido sobre TODOS los pedidos** (la cita se reprograma), acotado a 3 días.
- P8 **no tiene POD/entregado** → usar **fecha de embarque nula = pendiente** como bandera.
- **Motor de tarifas renombrado:** B1/B2 → **Motor 1 (unidad)** y **Motor 2 (caja)**. Ya en código + docs, investigar cómo quedó.
- Falta persistir/mostrar el **número de cadena** (tienda/sucursal) en el punto de entrega (Bruno verifica) y los campos **largo/corto** de Joaquín en la ingesta de productos.

## 5. Rediseños de vista (mapeados a las capturas de la reunión)

- **Zonas (modal árbol+mapa):** cambiar **logos de clientes → puntos de color** (paleta fija o random) por **rendimiento**. Coberturas de Richie quedan bien.
- **Viajes (estilo prototipo/ILUMINA):** lista que **indique tipo** (ruta lechera/directo), **mapa grande** (carrito + trazado), **paradas + secuencia + bitácora de viaje**. Detalle de viaje = como el monitoreo pero de ese viaje. Monitoreo en vivo multi-carrito = **Fase 2**.
- **Tipo de nodo:** se define en **NODOS**, no en editar-cliente (ahí solo se guarda interno). Un nodo puede: recolectar/origen, patio, transferir, aceptar devoluciones.
- **Recolección en el modal Nuevo Pedido:** hoy está **invertido**. Al elegir "recolección", el **origen** debe cargar los **nodos de recolección del cliente** (ej. Hermes/Plaza Mazaryk); el destino = punto de entrega (ej. CINLAT). Ajustar qué lista se llena según flujo (entrega vs recolección).
- **Programa de Embarques:** sábana tipo Excel; **orden por fecha en cascada** (lo próximo a vencer arriba, **rojo** para próximos); **columna de ZONA**; marcar centralizados; **desglose de qué pedidos** trae cada programa; **no permitir programa vacío** ni generar manifiesto sin pedidos. Renombrar "Planificación" → Programa de Embarques (vista central); los **bloqueos aparecen arriba en el programa**, no en el pedido.
- **Detalle del pedido:** subir el **contenido** (lo importante), bajar la **bitácora**.
- **Patios:** cuadritos de andenes + **foco parpadeante** (sin cita); citas en **calendario**; todo patio/andenes/citas/recolección en **un menú**. (Sesión aparte.)
- **Tablero de pedidos:** quitar la vista tabla (duplica Pedidos), dejar **kanban**, combinar con **Control operativo**; priorizar por **fecha/vencimiento** (color vencidos), no por tipo. Paginar Pedidos con **queries server-side**, no datatable.
- **Empaquetar:** mover al **detalle del pedido** (simple), reutilizar el auto-empaque; ya se quitó del detalle del programa.

## 6. Reglas de cliente / seguros

- **Custodia / seguro / dedicado** se definen a nivel **cliente-compañía**, con **vigencia + zonas**. Bug: la regla "dedicado" de Hermes **no brinca** al crear el pedido — debería preseleccionar dedicado + warning.
- **Pólizas:** sacarlas de catálogo suelto y **cablearlas al transporte/unidad**; número de póliza = **índice único**. Si carga > límite asegurado → **warning "¿necesitas custodia?"**.
- **Rutas de riesgo:** **sugieren** custodio, **no bloquean**. La opción "evitar" no sirve, arreglarla.

## 7. Tarifas / Contratos

- Tarifa vive **independiente** del contrato; pasa a **verde/usable** solo cuando el **contrato se aprueba**. Cada tarifa lleva su estatus propio.
- **Aprobada = lock/candado:** respeta precio de fecha a fecha, **no se modifica** ni reabriendo contrato. → **Reponer el candadito** (se quitó); "sin contrato" también bloqueado.
- **Cotizador** (vendedor) usa **solo aprobadas y vigentes** (hoy muestran todas solo por pruebas). Tarifario = pirámide de consulta; Cotizador = cotización real.
- **Switch on/off por carril por transportista** para que al bajar la matriz (Excel) solo salgan los carriles que trabaja (apagados hasta abajo).

## 8. Bugs / gaps confirmados

- **Ruta lechera (CORE):** la secuencia de paradas se pierde; toma cliente del **primer** pedido; no valida pedido ya en otro viaje; no considera medidas del vehículo; "Optimizar Google" intermitente; elige transportista solo (más barato **aunque no quepa/cotice**). *(Coincide con los huecos del MVP ya documentados.)*
- **Destinos sin zona** ingestados → rompen cotización por zona. Revisar CP→zona.
- **Centralizados sin hijos** registrados (no debería pasar).
- **Consolidación:** marca "hub" y **bloquea mezclar clientes** aunque el pedido sea consolidable — el bloqueo "un programa no mezcla clientes" es **incorrecto** para consolidables.

## 9. Estrategia iTMS vs MVP

- Se **calca visualmente** el MVP en el iTMS (mismo CORE). Posible **rehacer el MVC** (Chris lo dejó en la mesa) — **decisión: NO rehacer, ajustar/podar** (ver análisis abajo).
- **Tamaño real del portal iTMS:** 82 controllers · 101 vistas de página · 110 módulos JS · 86 CSS · ~1,070 actions.
  - **Rediseñar (en su lugar):** ~8 vistas (Programa, Viajes, Zonas, Patio, Tablero, Detalle pedido, Empaquetar, modal Recolección).
  - **Podar puro (bajo riesgo):** Trazador de rutas, Productos-tarifarios, Sellos (ocultar), Catálogos-extensión, Licitaciones (ocultar).
  - **Podar con cuidado:** Políticas operativas, Incidentes ('cierre' ambiguo), Registros (backend lo usan Reglas/Pedidos).
  - **Conservar:** ~85 vistas (catálogos + core).
  - **Shims muertos:** Ubicaciones, TarifasV2, Conciliacion.
- Rehacer = tirar 101 vistas para arreglar 8 → trampa. "Disperso/basura" = menú saturado + vistas muertas → **poda, no reescritura**.

## 10. Deadline + acciones abiertas

- **Programa de Embarques liberado antes de fin de agosto** (usuarios empiezan a usarlo).
- Número de **cadena** en punto de entrega (Bruno verifica); campos largo/corto de Joaquín en ingesta; Richie termina datos y pasa a front con Bruno.
- Confirmar con Chris antes de podar: (1) "cierre" ¿solo Incidentes o todo el grupo Cierre/Finanzas?; (2) Contratos de tarifas se conserva; (3) "catálogos globales" = quitar cards QUITAR del hub `/Datos`, NO el hub.
