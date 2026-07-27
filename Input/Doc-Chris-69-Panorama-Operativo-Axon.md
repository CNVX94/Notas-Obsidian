---
fecha: 2026-07-24
tipo: input-documentacion
proyecto: CINLAT iTMS Axon
autor: Christian Pioquinto H.
fuente: "commit 69c20d4c04df9715175210dc28b88d5ad906d1f3 — \"Pedidos Flujos\" (repo CINLAT.iTMS.Axon)"
tags: [axon, documentacion, panorama-operativo, gap-analysis, parcel-vs-b2b, customer-pickup, tarifas, arquitectura]
---

#Apunte #axon

# Doc de Chris — Panorama operativo completo (commit `69c20d4c`)

> Fuente independiente del Journal. Comparación entre ambas: ver §7 de esta nota.
> Síntesis del Journal: [[Sintesis-2026-07-24-Axon-Flujo-Pedidos]].

## 1. Qué entró en el commit

Commit `69c20d4c04df9715175210dc28b88d5ad906d1f3`, "Pedidos Flujos", 25 archivos.

**Documentación** (lo relevante para conocimiento):
- `docs/operacion/69_PANORAMA_OPERATIVO_COMPLETO_EQUIPO.md` — **nuevo, 492 líneas**. Es el documento principal.
- `docs/operacion/65_TRES_MUNDOS_CHECKLISTS_CITA_POD.md` — +8 líneas: brecha `CustomerPickup` sin Mundo A.
- `docs/operacion/67_REGLAS_ORO_PARCEL_VS_B2B.md` — +8 líneas: `CustomerPickup` es B2B, no Parcel.
- 3 imágenes: láminas del cliente (arquitectura TO-BE, alcance y reglas, matriz FR).

**Código** (contexto, no es el objeto de esta nota): `TripService.SetStopAppointmentAsync` (fijar ventana de cita de una parada sin exigir Draft/Planned, usado por "Agendar cita CEDIS" y por sincronización desde `FacilityAppointment`), dos catálogos nuevos de etiquetas ES para UI (`OrderTypeCatalog`, `ShipmentPatternCatalog`), y ajustes en vistas de Manifiestos, Viajes y Control Operativo.

## 2. Objetivo del documento

Material de consulta para **compartir con todo el equipo**: qué pide el cliente, qué ya hace Axon hoy, cómo está organizado el modelo y cómo se opera en la UI. Su premisa declarada: **todo está verificado contra código** (Domain/Application/WebMvc), y lo que no existe se marca explícitamente como brecha. No sustituye a los docs 58/61/65/66/67 ni a los de flujos — los agrega en un solo panorama.

## 3. Conceptos importantes

### Modelo comercial y geográfico
- Jerarquía fuerte de tres niveles: **Compañía → Cliente → Punto de entrega (PE)**. Ningún cliente sin `CompanyId`; la jerarquía nunca cruza compañías. `Product` pertenece solo a `Company`.
- Un pedido de P8 **sin destino fuerte queda no operativo/reintentable** — no se crea destino a mano desde el header.
- **Zona** = agrupación abstracta de códigos postales (reemplaza el catálogo EAV legacy). Resolución de zona: captura manual gana; si no, se deriva por CP → municipio → estado, y **no autoasigna** si hay 0 o más de una candidata.
- **Carril (`Lane`)** = par direccional `OriginZone → DestinationZone`. **Es la identidad vigente de tarifa y de riesgo.** `CommercialRoute` (CEDIS→PE) quedó como legacy: sigue viva como trazabilidad interna del Cotizador, pero ya no es clave de precio.

### Tarifas
- **Regla de oro: solo `Locked` cotiza.** Los otros estados (`Draft`, `CarrierProposal`, `CinlatProposal`, `UnderNegotiation`, `InRevision`, `Superseded`) no participan.
- Conviven **dos motores**: V1 (`Lane`/`Tariff`, el operativo del Cotizador/Tarifario) y V2 (`RateProduct`/`RateRow`/`CarrierZone`, desacoplado del Cotizador, útil para portal transportista y tarifas por caja/peso).
- El Cotizador arma un "carrito": flete + accesorios + custodia/maniobra + margen CINLAT, y guarda `RateQuote`. Usa **una sola dimensión a la vez** (peso *o* volumen, nunca ambas como base).
- Custodia y maniobras tienen proveedores y tarifas propias, independientes del flete. Los accesorios requieren autorización explícita por contrato.

### Parcel vs Inteligente — separación obligatoria
Invariantes duras ya validadas en código/UI:
1. Parcel **no entra** a Programa de Embarques.
2. Parcel **no crea viaje Axon** — su tracking es por guía.
3. `/Paqueteria` = Parcel · `/ManifiestosB2B` = Intelligent · `/Manifests` = solo tablero, sin crear.
4. Detalle Parcel muestra guías, no partidas de packing.
5. Despacho Parcel = placa + operador + evidencia simple; sin gate EXIT ni firmas duales.
6. API sin parámetro `flow` → default `Intelligent`.
7. Nunca GUID crudo en pantalla, siempre folio.

### Patrones de envío (`ShipmentPatternEnum`)
`Direct` · `MilkRun` (ruta lechera) · `ConsolidatedHub` · `ParcelPickup` (existe en el enum pero **retirado del workbench**) · `CustomerPickup`.

### `CustomerPickup` — el caso nuevo del commit
Retiro en CEDIS: el cliente manda su propia unidad a recoger en patio CINLAT.
- **Veredicto de Chris: ya existe en el core**, modelado Domain → Application → Api → WebMvc. No es una brecha de diseño.
- Es **B2B Inteligente**, nunca Parcel; pasa por `/ProgramaEmbarques`.
- No asigna carrier ni unidad, **no crea `Trip`**, no hay tracking GPS, no hay POD Latamel, no hay cargo `Freight` ni liquidación a transportista, no hay `EXIT_CHECKLIST`.
- Cierra con **transferencia de custodia** (`CustomerPickupReceipt`): receptor, identificación enmascarada, patio del mismo origen, cantidad que debe coincidir exactamente con el snapshot congelado del manifiesto. Marca pedidos `Delivered` y el manifiesto `Documented`.
- Estados de UI propios: "Preparando → Listo para entrega → Entregado"; **nunca "En camino"**.
- **Brechas reconocidas**: (a) no está enlazado con `FacilityVisit`/`FacilityAppointment` — la portería/checklist de acceso de la unidad del cliente no queda trazada junto con la custodia; (b) la evidencia es una referencia de texto, no un adjunto nativo; (c) no hay superficie para que el cliente agende su hora de recolección.

### Tres mundos de checklist que NO se mezclan
| Mundo | Pregunta | Dónde |
|---|---|---|
| **A · Facility** | ¿Puede esta persona/unidad entrar y operar? | `/FacilityAppointments`, `/FacilityVisits` |
| **B · POD** | ¿Hay evidencia documental suficiente para liberar pago? | `/PodReview`, panel POD en `/Tracking/Detalle` |
| **C · EXIT_CHECKLIST + Tracking** | ¿La papelería está lista para salir? ¿En qué fase va el viaje? | `/Manifests`, `/Tracking` |

Regla dura: **no reutilizar el mismo catálogo ni la misma pantalla entre los tres.**

## 4. Estado por módulo (resumen)

- **Operativo**: Pedidos, Programa de Embarques V2, Manifiestos, Armado de Rutas, Licitaciones, Contratos, Cotizador, Tarifario, Zonas, Carriles, Rutas de riesgo, Custodios, Maniobras, Patio, Facility (citas/visitas/andenes), POD Latamel, Torre de Control, Incidencias, Devoluciones, Cobro y Liquidación cliente, Portal Transportista, Portal Conductor/PWA, Gateway, catálogos maestros.
- **Parcial**: Packing, Consolidación (agrupación es manual, sin sugeridor automático), Tarifas V2 (desacoplada), Tracking (sin GPS/telemetría en vivo), Reportes (KPIs mayormente `PendienteDato`), Integración P8 (falta smoke vivo contra DB2 real), Liquidación transportista (MVP, sin pago bancario ni SAT/PAC).
- **Pendiente**: Integración ERP/NetSuite (solo stub), Dashboard financiero.

## 5. Gap analysis contra los 16 FR del cliente

**Cubierto (4)**: FR-002 validación de pedidos · FR-008 POD y evidencias · FR-010 administración de tarifarios · FR-013 conciliación de facturas (MVP con lógica real, sin validación contra webservice del SAT).

**Parcial (8)**: FR-001 integración P8 (falta smoke vivo contra DB2; es *pull* programado, no push) · FR-003 consolidación (patrones sí, sugeridor automático no) · FR-005 asignación de transporte (operador decide, no 100 % automático) · FR-006 documentos (**no genera Carta Porte CFDI ni timbrado PAC**) · FR-007 tracking (sin proveedor de telemetría vehicular ni mapa de flota en vivo) · FR-009 KPIs (`PendienteDato` por diseño; el código nunca infiere valores desde datos parciales) · FR-011 costeo (flete automático, accesorios manuales) · FR-014 autorización de pago (sin límites de monto por perfil, sin pago bancario).

**No iniciado (4)**: FR-004 optimización de rutas (sin TSP ni secuenciador) · FR-012 Freight Audit · FR-015 integración ERP/NetSuite · FR-016 dashboard financiero.

**Excepciones de la lámina 2**: rechazos y devoluciones **cubiertos**; cancelación **parcial** (no hay write-back a P8, es read-only); paquetería vía API UPS **no iniciada** — no hay integración API con ninguna paquetería, la guía y el tracking se capturan a mano.

## 6. Cambios relevantes respecto al proyecto

1. **`CustomerPickup` queda cerrado como alcance**: la recomendación explícita es *no diseñar un flujo nuevo ni una integración externa*. Lo único a planear con negocio es el enlace `CustomerPickupReceipt` ↔ `FacilityVisit`.
2. **Los docs 65 y 67 quedan alineados** con esa decisión: el 67 gana una sección nueva y renumera "Documentos supersedidos" a §9.
3. **Se formaliza la deuda de nombres**: se documenta el glosario de nombres legacy que el equipo escucha vs el nombre real ("MonitorPatio" → `/Patio`, "ControlOperativo" → `/TorreControl` o `/Operacion`, "Conciliación" → `/LiquidacionCarrier`, "Facturación" no existe como módulo separado).
4. **Etiquetas ES centralizadas** en `OrderTypeCatalog` y `ShipmentPatternCatalog` — antes dispersas en vistas.
5. **Citas de parada desacopladas del estado del viaje**: `SetStopAppointmentAsync` permite fijar la cita sin exigir `Draft`/`Planned`; solo bloquea si la carga ya inició.

## 7. Nota de ruta obsoleta

El documento cierra apuntando a un canvas visual en `C:\Users\desarrolladores\.cursor\projects\...\panorama-operativo-axon.canvas.tsx` — es una ruta de la máquina de Chris, no reproducible en otros equipos.
