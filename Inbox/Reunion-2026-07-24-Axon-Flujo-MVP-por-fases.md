---
fecha: 2026-07-24
tags: [axon, mvp, flujo, rediseño, chris]
fuentes:
  - Reunión mañana 13:26 (ingesta + clasificación pedidos)
  - Reunión tarde 16:00 (recorrido MVP completo)
  - docs/operacion/69_PANORAMA_OPERATIVO_COMPLETO_EQUIPO.md (Chris, commit 69c20d4c, verificado vs código)
  - Anotaciones de Bruno sobre las capturas
---

# Flujo MVP de Chris → iTMS — mapa por fases

> Destilado de las 2 reuniones del 24-jul (sin relleno), cruzado con el doc 69 de Chris
> (qué **ya existe** en Axon) y con las anotaciones de Bruno sobre las capturas.
> Leyenda: `[MVP→portar]` `[decisión]` `[requerimiento]` `[bug]` `[duda]`.
> `✅ ya en Axon` = confirmado por doc 69; `🆕 nuevo` = no existe aún.

---

## 0. Reorganización global de la app (decisión marco)

> **PRIORIDAD DE CHRIS — UX / rediseño.** Lo que más le importa del rediseño es la **experiencia de
> interfaz**: que los **menús se entiendan** (qué hace cada cosa), que los **pasos del flujo queden
> claros** (orden y siguiente acción evidentes), y que cada vista guíe al operador sin ambigüedad.
> No es solo mover módulos: es que la navegación *explique* el flujo operativo por sí sola.
> Aplica de forma transversal a TODO lo de abajo — cada `[MVP→portar]` debe rediseñarse con ese lente
> (etiquetas claras, descripción de cada acción/punto de control, secuencia visible, sin dobles caminos).

- `[requerimiento]` Remapear todos los módulos en **3 categorías**: **Flujo** · **Portales** · **Herramientas (catálogos)**.
- `[decisión]` Renombrar herramienta **"Snapshot" → "Tablero de pedidos"** (Chris explícito). Layout **vertical** (validado en vivo, se descartó horizontal).
- `[decisión]` **CEDIS y Patio SEPARADOS** (pestañas distintas). Chris pidió a Bruno evaluar/reemplazar la vista Cedis del MVP con lo que ya tiene Axon.
  - ✅ doc 69 §D.3 respalda: **3 mundos que NO se mezclan** — A·Facility (acceso patio), B·POD Latamel, C·EXIT_CHECKLIST. Legacy `/MonitorPatio`+`ControlPointTemplate` **deprecado**; lo nuevo va por Facility.

---

## 1. Pedidos

**Estatus del pedido (lado Axon):**
- `[decisión]` 3 estatus: **Nuevo** (llega de P8, campo "blanco"/vacío, solo solicitud) → **Trabajado** (en cajas, pesado, apilado en patio) → **Pre-embarque/Patio** (físicamente en patio esperando unidad).
- `[decisión]` Solo se ingieren pedidos P8 en estatus "blanco"; los demás aún pueden cancelarse por el cliente.
- `[decisión]` NO se guardan borradores en el flujo real: ciclo interno MVP = Borrador→Confirmado→Aprobado, pero la ingesta P8 llega **ya auto-confirmada/auto-aprobada**.
  - ✅ doc 69 §F: Pedidos **Operativo** (`OrderApprovalStatusEnum`, guardas de duplicados). Chris agregó enums `OrderTypeCatalog`+`ShipmentPatternCatalog` en este commit.
- `[duda]` Validar los 3 estatus contra proyecto/documento **SCT**; definir si string vacío o null.

**Tipo de pedido (viene desde ingesta P8, NO manual):**
- `[decisión]` 2 tipos: **Paquetería/Parcel** (guía + paquetería externa; NO genera PE reutilizable) · **Inteligente/B2B** (PE fijo, fecha/hora comprometida + cita ~1h para KPI).
  - ✅ doc 69 §C.1: `OrderTypeEnum{Parcel|Intelligent}` + regla de oro Parcel≠B2B (doc 67).
- `[requerimiento]` Clasificación definida en ingesta P8 (Richie).
- `[requerimiento]` Validar tipos de entrega faltantes: consolidado, centralizado, muy disperso (hoy solo "directo").

**Motor de paquetería por guía:**
- `[MVP→portar]` Detección por alias/prefijo de guía (ya construido, usado en Torre de Control): "Coppel Express"="Coppel"; prefijo "PE"=Estafeta; "MEL"=Mercado Envíos.
- `[requerimiento]` Guía con prefijo no identificado → decidir: registrar nueva paquetería o ligar alias a existente.
- `[bug/duda]` Origen (Torre de Control) no trae campo limpio de paquetería; llega texto libre ("FER","Mail","UPS"). Extraer de archivo de guías (primeras 3 columnas).

**Vistas a portar:**
- `[MVP→portar]` **Pedidos → Crear** (alta manual: nº, cliente, PE/dirección, guía, SKUs, cantidades, fechas).
- `[MVP→portar]` **Pedidos → Tabla** (agrupados por tipo).
- `[MVP→portar]` **Detalle de pedido "cabecero"** — confirma anotación Bruno: header con clasificación/estatus, columna de **Flujo**, sección inferior con info de manifiesto, **3ª columna = detalle packing/cajas ("la línea")**, bitácora hacia abajo ilimitada.
- `[requerimiento]` Campo **Notas** para trasladar la "instrucción de trabajo" P8 a la bitácora (ya hay notas colapsable en detalle).
- `[requerimiento]` Pedidos cerrados (delivery completo) salen de la lista activa → **historial aparte**; no seguir en control operativo activo.

---

## 2. Empaque / PE

- `[decisión]` Empaque/sellado se recibe **automático desde P8** (import + actualización); parte "muy transparente" con integración P8.
- `[decisión]` Cantidad surtida puede diferir de la solicitada (piden 200, surten 150) → el pedido debe actualizarse con la cantidad realmente surtida (es lo que se embarca).
- `[decisión]` Al confirmar/aprobar, packing pasa a **100% automático** al recuperar de P8 (fase 2); en demo fue manual (1 caja/pedido default, repartir peso).
- `[requerimiento]` Distribución piezas/peso en cajas **automática** (Richie).
- `[bug]` Barra de progreso de packing (la "línea" de %) no se pinta bien conforme avanza (10 de 100 no marca 10%).
  - ✅ doc 69 §F: Packing **Parcial** (vaciar libera productos, puede invalidar cierre físico).

---

## 3. Consolidación / Manifiestos

- `[decisión]` 2 tipos de manifiesto: **B2B** (pedido inteligente; requiere crear viaje que agrupa varios manifiestos) · **Paquetería** (NO genera trip).
- `[decisión]` Manifiesto de paquetería **exclusivo por compañía/cliente pagador** — no mezclar compañías distintas aunque vayan por misma paquetería.
  - ✅ doc 69 §C.1/§F: manifiestos multi-owner, cross-client solo con política explícita.
- `[requerimiento]` 🆕 Crear concepto **"consolidado de manifiestos"**: 2 manifiestos distintos pueden ir en la **misma unidad/placa** si son de la **misma paquetería** (aunque de compañías diferentes).
- `[MVP→portar]` **Manifiesto impreso** (detalle con carga total + conteo de evidencias esperadas, 1/pedido) — confirma anotación Bruno ("la vista limpia que le gustó"). Portar tal cual.
- `[requerimiento]` **PDF de manifiesto** — confirma anotación Bruno: falta **logo CINLAT + nombre de compañía**; agrupar por compañía; cita pickup/delivery con fecha/hora; totales; estatus de despacho; campo "firmado por".
  - ✅ doc 69 FR-006 (documentos) = **Parcial**.
- `[MVP→portar]` Vista **paquetería consolidada** (agrupar/filtrar pedidos por paquetería antes de manifestar) + momento de impresión — confirma anotación Bruno.
- `[MVP→portar]` Tablero **Despachado / En tránsito** — confirma anotación Bruno ("hasta aquí ya irían en tránsito"): al despachar (placa+operador+evidencia) manifiesto→Despachado→En tránsito; arranca tracking de guía independiente por pedido.
- `[bug]` **Orden invertido** en cierre de paquetería: debe ser **cerrar manifiesto → despachar → tracking** (en demo se brincó el paso). Corregir orden de botones.
- `[requerimiento]` Falta paso **"Cerrar para liquidación"** (pasa a otra bandeja); liquidación como módulo = **fase 2**.
- `[decisión]` **Manifiesto vs Cartaporte**: Manifiesto = doc logístico/aduanero interno (agrupa envíos, contrato transporte + control fiscal); Cartaporte = CFDI de autoridad (ampara traslado, sobre todo importaciones/frontera; se sube firmado).
- `[requerimiento]` Generar automático: manifiestos, cartaporte, etiquetas, instrucciones de entrega, órdenes de cita.
- `[duda]` No quedó claro por qué se mencionó Cartaporte aquí si aplica sobre todo a importaciones.

---

## 4. Planificación / Armado de rutas

**Tipos de envío (pedido inteligente):**
- `[MVP→portar]` **Directo** (una tienda/punto único) · **Centralizado** (padre grande con hijos chicos; entregar el grande como unidad) · **Consolidado** (varios pedidos independientes, incluso distintas compañías, mismo punto+fecha, un transporte, sin padre-hijo) · **Ruta lechera** (distancia real entre puntos; para en cada uno, llama al responsable, firma POD por cada uno).
  - ✅ doc 69 §C.2: `ShipmentPatternEnum{Direct|MilkRun|ConsolidatedHub|CustomerPickup}`.
- `[duda→RESUELTO por doc 69]` **"Entrega en patio"** (cliente llega a recoger con su propio transporte, solo "recolección", sin transporte propio): Chris quería validar si está en alcance. **✅ doc 69 §C.4 confirma: YA EXISTE en el core** como `CustomerPickup` (Caso B2), modelado Domain→Api→WebMvc (`CustomerPickupReceipt`, `/ProgramaEmbarques` patrón "Recolección cliente"). Cierra con transferencia de custodia en vez de POD Latamel. **NO es flujo nuevo.** Única brecha: no enlaza `FacilityVisit` de la unidad del cliente (extensión menor).

**Programa de embarques (solo inteligente):**
- `[MVP→portar]` Trae solo pedidos empaquetados; crea manifiesto (directo/centralizado/lechera, folio ej. `WF-202607-1-directo`); **preplaneación**: transportista candidato, ver si ya tiene cotización, fecha compromiso (24h, slots 30min), notas ("POD obligatorio","ruta definida").
- `[decisión]` En programa de embarques **solo visualizar** lo planeado; **materializar (crear viaje) SOLO en Armado de rutas**, no aquí.
- `[bug]` Al confirmar transportista pedía "materializar" cuando debía tomarlo de lo preseleccionado — Chris revisa de su lado.
- `[requerimiento]` Rediseñar preplaneación a **tarjetas/kanban** (crecerá a ~30 embarques/día; lista actual no escala).
  - ✅ doc 69 §F: ProgramaEmbarques **Operativo** (Intelligent).

**Armado de rutas (planificación + cotización):**
- `[MVP→portar]` Agrupa pedidos por tipo (directo/centralizado/lechera); abrir grupo carga el **Cotizador** (trae cajas, recomienda transportista por tarifa); autorizar maniobras/accesorios (cargos extra).
- `[MVP→portar]` "Crear viaje y porteador" → nº de viaje automático (ej. viaje 24), pedido sale de preplaneación.
- `[requerimiento]` Indicar manualmente placa/conductor cuando el transportista ya lo confirmó (hoy solo el transportista asigna desde su portal).
  - ✅ doc 69 §F: ArmadoRutas **Operativo** (ruta CORE preferida).

**Optimización / tarifas:**
- `[requerimiento]` Conciliación automática, cubicaje, reglas, optimización de rutas (lechera: sugerir mejor ruta) — considerando disponibilidad, ventanas, costos, tiempos.
- `[decisión]` Por ahora solo se considera **costo**.
- `[requerimiento]` Asignación automática de transporte ligada a cubicaje: unidad, operador, cita, horario.
- `[duda]` Ruteo Google Maps: no mandar todos los puntos exactos (Maps recalcula al abrir en app transportista). Fase 1: ruta sugerida como texto/instrucción no vinculante; monitoreo real vs sugerida = **Fase 2**.
- `[requerimiento]` Catálogos de accesorios: **proveedor de maniobras** + **proveedor de custodias** (tiempo extra/custodia/maniobra = accesorios propios CINLAT).
  - ✅ doc 69 §B.4/§F: Custodios y Maniobras **Operativo** (catálogo + tarifas propias). **Ya existen** — validar contra lo del MVP.
- `[requerimiento]` Tarifas autorizadas por tipo de unidad + destino (destinos por catálogo P8).

---

## 5. Cita / Patio / CEDIS / YMS

> **Regla marco:** CEDIS ≠ Patio (separados). Puntos de control ✅ = Facility Mundo A en doc 69.

**Patio:**
- `[MVP→portar]` Muestra llegadas a patio (andén, etc.).
- `[MVP→portar]` Paquetería walk-in/sin cita (ej. FedEx): unidad llega sin cita → asignar andén manual.
- `[bug]` "Cola de vehículo" en Patio sin datos aún (Chris revisa).

**Agenda del CEDIS:**
- `[MVP→portar]` Crear **citas administrativas** (no solo recolección/entrega/carga) — ej. visita al CEDIS sin transporte. Tipos: viaje (recolección/entrega/carga), visita administrativa.
- `[requerimiento]` Campo dedicado para **responsables/autorizados a pasar** (hoy se improvisa en notas — NO debe ir en notas libres).
- `[requerimiento]` Campo **código de cita para generar QR**.
- `[requerimiento]` Campo "contacto" de la cita = **selección de persona** (no texto libre).
- `[MVP→portar]` Dentro de agenda CEDIS: **Recepción** (visitas/transportistas SIN cita), **reasignación de andén** (andén inhabilitado→otro), **puntos de inspección** (checklist por cita, foto ID con aviso privacidad), **control de andenes** (tamaño unidad vs andén, sin datos aún), **historial**, **revisión de PODs** (cotejo físico de doc entregada vs sistema).
- `[requerimiento]` Vistas de revisión POD y andenes: mejorar ("pueden dispersarse"), no son flujo principal.

**Puntos de control:**
- `[MVP→portar]/[requerimiento]` Catálogo precargado en MVP (ej. "Security", "FAC Admin"/"Revisión documentación de entrada", checklist de vehículos). Contenido: ID obligatoria, licencia federal, ID con foto, examen médico, carta no antecedentes, comprobante domicilio, constancia capacitación (doc); condición física, póliza seguro, tarjeta circulación, nivel combustible (vehículo).
- `[requerimiento]` **Imprimir la descripción** de cada punto de control — confirma anotación Bruno (para saber cuándo usar cada uno; mencionado sobre "Revisión documentación de entrada"). → 🆕 falta campo descripción + impresión en el catálogo.
- `[duda]` Chris cree que los catálogos de puntos de control "no están en Axon" — **confirmar**: ✅ doc 69 §D.3 dice que SÍ existe `FacilityControlPointTemplate` (Mundo A). Cotejar catálogo MVP vs Axon.

**Monitor de Patio / Estación (el "check, check, check"):**
- `[MVP→portar]` Confirma anotación Bruno: llegada del transportista = asignado → aceptado → llega persona → chequeo de puntos (licencia, ID foto, examen médico…) → sin novedad/inspección unidad → checklist de salida. Paso "rechazo/reinicio" solo si algo se rechazó.
  - ⚠️ doc 69 §D.3: el legacy `/MonitorPatio`+`ControlPointTemplate` está **deprecado**; portar sobre **Facility (Mundo A)**, no sobre el legacy.

**Operación de Instalaciones ("Facility Operation"):**
- `[duda]` Aparece de pasada al confirmar cita de viaje; audio no la desarrolla. Corresponde a anotación Bruno "falta vista Operación de Instalaciones".
  - ✅ Pista fuerte: Chris tocó **`FacilityOperationsService.cs`** en este mismo commit → equivale a **Facility / `/FacilityVisits`** (doc 69 §D.1). **Confirmar con Chris qué contiene exactamente.**

**Vista de viaje (cita + checklist):**
- `[requerimiento]` Agregar a "viaje": control de citas + checklist de puntos de control (hoy el checklist de llegada está mezclado ahí; debería ir en otra vista de patio).
- `[decisión]` Cita del viaje se **confirma de ambos lados** (portal transportista + operador).
- `[requerimiento]` Viaje debe traer automático nombre de unidad + conductor tras confirmación del portal transportista.
- `[decisión]` Portal transportista valida tipo de unidad asignada vs solicitada (**aviso, no bloqueo** — puede asignar otra bajo su responsabilidad). Bruno: ya se trabajó parcial en el portal transportista del iTMS.
- `[bug]` Falta en viaje (B2B) el equivalente al **checklist de carga** que sí tiene paquetería (iniciar carga→en curso→corte físico→terminada→despachar).
- `[bug]` Botón "Despachar" del viaje poco visible ("medio escondido").
- `[requerimiento]` Cablear **bitácora/logs automáticos** de cada evento del armado del viaje (hoy manual).

---

## 6. Carrier / Tracking

- `[decisión]` **2 trackings distintos**: tracking de paquetería (guía por proveedor externo) vs tracking de viaje (monitoreo interno B2B). NO confundir.
- `[MVP→portar]` Estados tracking de viaje: en ruta → llegando a destino → esperando descarga → finalizado.
- `[requerimiento]` Tracking cubre: liberación de carga, salida de unidades, comunicación con operador, confirmación de inicio de ruta (desde app conductor o inicio de viaje).
- `[requerimiento]` Falta **Portal de Monitoreo** (mapa con unidades en tiempo real); no en MVP por falta de integración GPS.
- `[MVP→NO portar]` El **simulador manual** de posiciones (clic para mover) NO se porta tal cual; en producción viene de la app/PWA del conductor.
- `[bug]` Simulador no completó bien el recorrido en la demo.
- `[requerimiento]` Fase 2: integración tracking con paqueterías (UPS entrega PODs digitales para conciliar con manifiesto; Estafeta/FedEx rastreo por nº guía).
  - ✅ doc 69 FR-007 **Parcial** (fases de ruta + GPS PWA; sin telemetría vehicular/mapa flota en vivo). §G.3: paquetería vía API UPS = **No iniciado**.

---

## 7. Liquidación / POD

- `[decisión]` **POD ≠ solo foto**: puede ser foto de manifiesto firmado, sello, doc interno (acuse), o dato electrónico (coordenadas geolocalizadas). Cualquier objeto que evidencie la entrega.
  - ✅ doc 69 §E.2/Mundo B: `PodRequirementTemplate` (árbol Global→Compañía→Cliente→PE).
- `[requerimiento/regla dura]` **Viaje NO se cierra sin sus PODs** (obligatorios en todas las entregas). ✅ doc 69 §E.2 confirma (cierre financiero bloquea sin POD/ePOD).
- `[MVP→portar]` POD **descargable** desde el viaje; comprobante = archivo electrónico generado automático al cerrar viaje.
- `[duda]` Contradicción a aclarar: ¿se puede subir evidencia **después** de cerrado el viaje? (se dijo que no, luego que sí si queda abierta). Definir regla exacta.
- `[requerimiento]` Paso "Cerrar para liquidación" existe; liquidación como módulo = **fase 2**.
- `[requerimiento]` Accesorios de tarifa: tiempo extra (espera del transportista en CEDIS), custodias, maniobras (con catálogos de proveedor).

---

## 8. Herramientas (Control operativo · Tablero · Catálogos)

- `[MVP→portar]` **Control operativo**: visión agregada por pedido (paquetería, inteligentes sin asignar, en patio…).
- `[requerimiento]` Más filtros en control operativo: separar por forma de envío/tipo de entrega. Columna tipo de pedido (Marketplace vs B2B).
- `[decisión]` **Snapshot → "Tablero de pedidos"** (Kanban vertical): agrupa por estatus, cliente, destino, tipo de entrega; Marketplace muestra "sin destino". Bruno: "esta vista sí la quiero ya".
- `[requerimiento]` Catálogo de puntos de control debe existir también en Axon/iTMS.

---

## Bugs a corregir (lista corta)

1. Barra de progreso de packing no pinta el % real (Empaque).
2. Orden invertido cierre paquetería: cerrar manifiesto ANTES de despachar (Manifiestos).
3. "Materializar" se pedía en programa de embarques (debe ser solo Armado rutas) — Chris.
4. "Cola de vehículo" en Patio sin datos — Chris.
5. Falta checklist de carga en viaje B2B (existe en paquetería).
6. Botón "Despachar" del viaje poco visible.
7. Simulador de tracking no completó recorrido (no se porta igual).

## Renames / decisiones de nomenclatura

- Snapshot → **Tablero de pedidos**.
- Reorganizar módulos en **Flujo / Portales / Herramientas**.
- CEDIS y Patio → **vistas separadas**.
- Monitor de Patio legacy → portar sobre **Facility (Mundo A)**, no sobre el catálogo legacy.

## Cabos sueltos a cerrar con Chris / negocio

- [ ] Confirmar qué contiene exactamente **"Operación de Instalaciones" / Facility Operation** (Chris tocó `FacilityOperationsService.cs`).
- [ ] Regla real de subida de evidencia **tras cerrar viaje** (declaración contradictoria).
- [ ] Validar los 3 estatus de pedido contra **SCT** (string vacío vs null).
- [ ] De dónde sale **cada dato desde P8** ("donde nos vamos a pelear es de dónde consigo esto de P8").
- [ ] Cotejar catálogo de **puntos de control** MVP vs `FacilityControlPointTemplate` de Axon.
- [ ] Diseñar preplaneación/programa de embarques **escalable** (~30/día) en cards.
- [ ] `CustomerPickup` ("entrega en patio"): decidir si se enlaza `CustomerPickupReceipt` ↔ `FacilityVisit` (única brecha; ya opera sin eso).

## Confirmación de anotaciones de Bruno (capturas)

| Anotación Bruno | Estado |
|---|---|
| CEDIS ≠ Patio (separar) | ✅ confirmado (reunión + doc 69 §D.3 tres mundos) |
| Falta imprimir la descripción (puntos de control) | ✅ confirmado (Revisión doc de entrada) → 🆕 campo + impresión |
| Puntos de control según necesidad | ✅ confirmado → cotejar vs Facility Axon |
| Vista "Operación de Instalaciones" | ⚠️ pista: `FacilityOperationsService.cs`; confirmar contenido con Chris |
| Portar "paquetería consolidada" + impresión manifiestos | ✅ confirmado |
| Vista limpia que le gustó = manifiesto impreso | ✅ confirmado |
| "Hasta aquí en tránsito" = tablero Despachado/En tránsito | ✅ confirmado |
| "Cabecero" = detalle pedido, packing en 3ª columna, "la línea" | ✅ confirmado |
| "La idea sea un check" = Monitor Patio/Estación | ✅ confirmado (portar sobre Facility, no legacy) |
| Logo CINLAT + compañía en PDF manifiesto | ✅ confirmado (FR-006 Parcial) |

---

_Ver también: [[Reunion-2026-07-24-Axon-Puntos]] · doc repo `69_PANORAMA_OPERATIVO_COMPLETO_EQUIPO.md`_
