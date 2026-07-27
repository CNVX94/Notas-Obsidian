# Análisis de archivos de flota CINLAT — Transportes

Fecha: 24-jul-2026 · Analista: sesión Claude Code · Fuente: OneDrive `Clientes/CINLAT/Axon/Transportes`
BD consultada: `CINLAT.iTMS.Axon.QA` @ 192.168.10.20 (**solo lectura**, cero escrituras)

---

## 1. Veredicto del duplicado

**Usar `LISTADO DE UNIDADES Y OPERADORES  2026 V1.xlsx` (64 KB). Descartar el otro.**

1. V1 tiene 11 hojas contra 8; aporta **3 hojas exclusivas** — OPTER, DIRZO y SEND — con **143 vehículos y 139 filas de operador que no existen en el archivo sin V1** (63 % de todo el padrón).
2. Las 8 hojas comunes son **idénticas celda a celda**; las únicas diferencias son de encabezado/título, no de datos.
3. V1 es posterior: metadatos internos `modified = 2026-07-22 23:31` (Jorge Aparicio) vs `2026-06-24 05:30` (Augusto Zamora). Ambos comparten `created = 2012-01-11`, misma plantilla.

### ¿Es superset estricto?
Casi. **No se pierde ni un dato**, pero sí una etiqueta:

| Diferencia | En V1 | En sin-V1 | Impacto |
|---|---|---|---|
| MARCO POLO col. H `No. Tarimas` | ausente | encabezado presente, **columna 100 % vacía en las 21 filas** | Ninguno en datos. Señal de que negocio pensaba capturar tarimas por unidad → dato deseado que aún no existe. |
| TRANSCOR col. `FECHAS DE INGRESO` | encabezado presente (sin datos) | ausente | Ninguno. |
| Títulos ANEXO 2 | genérico / con nombre | variante | Cosmético. |

**Conclusión:** V1 es superset en datos. Lo único que "se pierde" al elegir V1 es el encabezado vacío `No. Tarimas`; anotarlo como requerimiento futuro, no como pérdida.

---

## 2. Inventario por archivo / hoja

### 2.1 `LISTADO DE UNIDADES Y OPERADORES  2026 V1.xlsx` — **EL BUENO**

11 hojas, 98 rangos de celdas combinadas, todas las hojas visibles.
Formato: bloque de título (filas 1-7, con logo/merges), luego encabezado real, luego datos. Varias hojas traen **dos bloques** (unidades arriba, personal abajo) separados por filas vacías.

| Hoja | Encabezado real | Columnas | Vehículos | Operadores | Periodo declarado |
|---|---|---|---|---|---|
| CATALOGO DE UNIDADES | R8 (col B) | `TIPO DE UNIDAD` | — | — | 2026 / junio |
| CATALOGO LINEAS | R8 (col A) | `NOMBRE PROVEEDOR, # PROVEEDOR, NOMBRE COMERCIAL` | — | — | 2026 / junio |
| OPTER | R6/R10/R21 (col A) y R6 (col E) | `UNIDAD, MATRICULA, OPERADOR` ×2 bloques laterales | 37 | 37 | 2026 / junio |
| DIRZO | R8 (col B) + R23 | `Marca, Submarca, modelo, Placas, Capacidad, No. ECO.` / `Área, Nombre conductor` | 10 | 6 | 2026 / junio |
| MARCO POLO | R8 + R34 | ídem / `NOMBRE, PUESTO, TELEFONO, FECHA DE INGRESO, NSS, CERTIFICACION` | 21 | 18 | 2026 / **abril** |
| QUMSA | R7 + R24 | ídem / `PUESTO, NOMBRE, TELEFONO, FECHA INGRESO, IMSS, CURP` | 13 | 20 | 2026 / junio |
| TRANSCOR | R8 + R24 | `No. Economico, Marca, Modelo, Placas, Tamaño` / `Puesto, Nombre, NSS, CURP, RFC, CERTIFICACION` | 13 | 11 | 2026 / **mayo** |
| GMAX | R8 + R41 + R63 | `Marca, Submarca, modelo, Placas, Capacidad, No. ECO.` / conductores / maniobras | 25 | 17 | **2023** / 09-09-2023 |
| SEND | R6 | `Unidad, operador, Placas numero, Tipo, Marca, Modelo, MARCA` (una sola tabla) | 96 | 96 | **2025** |
| CONTRERAS | R8 + R25 | unidades / personal | 8 | 7 | 2026 / **mayo** |
| D LOERA | R8 + R25 | unidades / personal | 5 | 5 | 2026 / **mayo** |
| **TOTAL** | | | **228** | **217** filas (208 reales, 205 nombres únicos) | |

**Muestra representativa (5 filas, hojas distintas):**

```
DIRZO      R13  Kenworth | (sin submarca) | 2000 | 292AN7 | 53 Ft | ECO 8
QUMSA      R8   CHEVROLET | SILVERADO 3500 | 2016 | KV-5616-A | 5 | Q-616
TRANSCOR   R10  ECO N/A | Freighliner | 2008 | 30AY3T | MUDANCERO
SEND       R9   ECO 85 | SIN OPERADOR FIJO | 604DH5 | 1 unidad Blindada | Kenworth | 2009
OPTER      R7   UNIDAD "1.5 ton" | LD-85-846 | Aldo Castellanos Flores   (sin marca/modelo/año/ECO)
```

**Estructuras que rompen un parser ingenuo:**
- **OPTER** tiene 2 tablas *lado a lado* (cols A-C y E-G) y 3 sub-bloques verticales con encabezado repetido (RABON 8 ton / 3.5 TON / AUTOS). No trae marca, modelo ni año — solo tipo, placa y operador.
- **QUMSA** invierte columnas: el encabezado dice `PERSONAL QUMSA` (nombre) primero, pero la data trae **PUESTO en col A y NOMBRE en col B**.
- **MARCO POLO y D LOERA** reusan literalmente el encabezado `PERSONAL QUMSA` (copy-paste de plantilla).
- **GMAX** separa conductores (R42-55) y maniobras (R64-66) en dos bloques distantes.

### 2.2 `LISTADO DE UNIDADES Y OPERADORES  2026.xlsx` — descartar
8 hojas (CATALOGO DE UNIDADES, CATALOGO LINEAS, MARCO POLO, TRANSCOR, GMAX, QUMSA, CONTRERAS, D LOERA). Subconjunto de V1.

### 2.3 `ENTRADAS Y SALIDAS DE SCT (AXON) 21_JUL_26.xlsx`
2 hojas: `Integraciones` (42 filas, 13 columnas, 0 merges) y `Hoja2` (vacía). Ver §5.

### 2.4 `1e8353a2-3862-408f-8994-0cb00fe1bce3.png`
**No aporta contexto de flota.** Es una captura de documentación de **tipos de pedido**: N = directo a tienda, A = centralizado (multi-tienda/CEDIS), P = promocional, e-commerce, K = virtual consolidado (solo facturación/timbrado, no requiere seguimiento ni POD). Es insumo del módulo Pedidos/ingesta P8, no de Carriers/Vehicles/Drivers.

---

## 3. Calidad de datos (conteos exactos, sobre V1)

### 3.1 Placas — lo mejor del archivo
| Métrica | Valor |
|---|---|
| Placas totales | 228 |
| Distintas (crudas) | 228 |
| Distintas (normalizadas, sin guiones/espacios/mayúsculas) | **228 → 0 duplicados** |
| Con guion | 48 (OPTER y QUMSA principalmente) |
| Con espacio interior | 4 (`NZK 4842`, `B21 BLK`, `LC 32-007`, `LF 24 723`) |
| En minúsculas | 1 (`79ba5u`, DIRZO R15) |
| Longitud normalizada | 6 chars: 161 · 7 chars: 67 · fuera de rango 5-8: **0** |

**Veredicto:** no hay colisión de placas. Sí hay **3 formatos conviviendo** (`29BA4C`, `KV-5616-A`, `LD-85-846`) → obligatorio normalizar antes de cargar porque `IX_Vehicles_PlateNumber` es UNIQUE.

### 3.2 Número económico — inservible como clave
| Métrica | Valor |
|---|---|
| Vehículos | 228 |
| ECO vacío o centinela | **77 (34 %)** |
| Desglose centinelas | `''` ×37, `s/n` ×21, `N/A` ×11, `S/N` ×8 |
| ECO duplicado dentro del mismo carrier | 1 caso: **TRANSCOR ECO `23` en R16 y R17** (placas 5104ZR y 5918ZR) |

Carriers con ECO 100 % ausente: MARCO POLO (21/21 `s/n`), CONTRERAS (8/8 `S/N`), OPTER (37/37 sin columna).

### 3.3 Capacidad / tipo de unidad — el peor campo
**43 valores crudos distintos para 228 unidades.** Mezcla al menos 5 unidades semánticas:
- toneladas con formato libre: `1.5 ton`, `1.5`, `1.5 TON`, `1.5 Ton`, `1.5 T` (5 escrituras del mismo valor)
- descripción de servicio: `1 unidad Blindada` ×24, `1 Unidad de 8 Ton.` ×18
- longitud de caja: `53 Ft`, `53Ft`, `53 PIES`
- volumen: `45 METROS CUBICOS`, `60 METROS CUBICOS`
- kilos: `700 KILOS`
- **modelo comercial en el campo de capacidad** (TRANSCOR): `SAVEIRO`, `CADDY`, `VIRTUS`, `TIGUAN`, `POLO` → 8 filas
- clase directa: `RABON`, `MUDANCERO`
- vacío: 1 (GMAX `LWW194A` Nissan Versa)

### 3.4 Modelo / año
**67 de 228 filas (29 %) tienen algo que no es un año de 4 dígitos en la columna `modelo`:**
- OPTER (37): la columna no existe, se rellenó con el tipo (`1.5 ton`, `3.5`, `T 64A-8`).
- GMAX (25): trae la **submarca** en `modelo` (`URVAN PANEL`, `TRACTOR`, `CAJA`, `T370`, `M2 35K`).
- DIRZO (5): año embebido en texto (`F 350 mod.2016`, `Rapid mod.2023`) y 1 celda vacía (`74BA2A`, marca "Salome").

### 3.5 Marcas — sin normalizar
**29 valores crudos** para ~15 marcas reales. Ejemplos: `Kenworth`(41)/`KENWORTH`(8); `Nissan`(28)/`NISSAN`(23); `FREIGHTLINER`(12)/`Freightliner`(4)/`freightliner`(2)/**`Freighliner`(2, typo)**; `DODGE`(3)/`Dodge`(2)/**`DOGE`(1, typo)**; `VOLKSWAGEN`(3)/`VW`(8).
Además **2 filas de DIRZO traen un nombre de persona en el campo Marca**: `Salome` (placa 74BA2A) y `Francisco Gzl` (placa 014AU5) — son unidades de terceros/subcontratadas registradas por dueño.

### 3.6 Operadores
| Métrica | Valor |
|---|---|
| Filas de personal | 217 |
| Filas `SIN OPERADOR FIJO` (placeholder, no persona) | **9** (todas SEND) |
| Personas reales | 208 |
| Nombres únicos | **205** |
| Nombres repetidos legítimos (mismo operador, 2 unidades) | 3: `SALVADOR MERIDA MENDOZA`, `JOSE JUAN MARINES SERMEÑO`, `MIGUEL AGUILAR VAZQUEZ` (todos SEND) |
| Puesto = OPERADOR | 190 |
| **No conductores** (Director, Gerente ×5, Maniobra ×5, Ayudante ×3, Contabilidad…) | **18** |

**Completitud de campos de identidad (sobre 208 personas):**

| Campo | Con dato | % | Nota |
|---|---|---|---|
| Nombre | 208 | 100 % | |
| CURP | 31 | 15 % | solo QUMSA y TRANSCOR |
| RFC | 11 | 5 % | solo TRANSCOR |
| NSS / IMSS | 36 | 17 % | 3 formatos: `45109593603`, `05-14-90-3685-6`, `1106820818-7` |
| Teléfono | 26 | 13 % | |
| Fecha de ingreso | 54 | 26 % | |
| **Núm. de licencia** | **0** | **0 %** | **la columna no existe en ninguna hoja** |
| **Vigencia de licencia** | **0** | **0 %** | ídem |
| Email | 0 | 0 % | |

**CURP con formato inválido: 6 de 31 (19 %)**
```
QUMSA    SAUL J. QUIROZ MONTES           QUMS820721FG9HDRNL04  (20 chars, RFC+CURP concatenados)
QUMSA    CLAUDIA J. LOPEZ PINEDA         LOPC800703HDFRNDJ03   (sexo H, nombre femenino)
QUMSA    DANIEL ENRIQUE ALANIZ OLIVEROS  AAOD830607HDFLL       (truncada, 15 chars)
QUMSA    ISAURO LOPEZ CRUZ               LOCI610924HDFRS07I    (mal formada)
TRANSCOR Victor Manuel Cortes Vazquez    45109593603           (es el NSS, copiado)
TRANSCOR Juan Antonio Benavides Gaspar   BEGJ970624HDFNS07     (17 chars)
```
Además **NSS duplicado**: `45109593603` aparece en TRANSCOR R25 (Victor Cortes Rojas) y R26 (Victor Manuel Cortes Vazquez) — padre e hijo con el mismo NSS capturado.

**RFC inválido: 1 de 11** — `CORH-671110` (TRANSCOR, sin homoclave).

**Fechas de ingreso en texto libre: 20 de 54 (37 %)**
`FUNDADORA`, `FUNDADOR`, `31 DE ENERO 2020`, `18 de Enero de 2017`, `20 de febrero de 2025`… conviven con 34 fechas reales tipo `datetime`.

### 3.7 Vínculo vehículo ↔ operador
| | |
|---|---|
| Vehículos con operador en la misma fila | **124** (SEND 96, OPTER 37 — menos 9 placeholders) |
| Vehículos sin vínculo alguno | **104** (DIRZO, MARCO POLO, QUMSA, TRANSCOR, GMAX, CONTRERAS, D LOERA: listas de unidades y de personal separadas, sin llave que las una) |

### 3.8 Frescura / vigencia
| Hoja | Periodo declarado | Antigüedad vs jul-2026 |
|---|---|---|
| GMAX | **2023 / 09-09-2023** | ~34 meses |
| SEND | **2025** (sin mes) | ~12+ meses |
| MARCO POLO | 2026 / abril | 3 meses |
| TRANSCOR, CONTRERAS, D LOERA | 2026 / mayo | 2 meses |
| OPTER, DIRZO, QUMSA | 2026 / junio | 1 mes |

**SEND y GMAX son las dos hojas más grandes en personal después de OPTER, y son las más viejas.** SEND (96 unidades, 42 % del padrón) está declarado periodo 2025.

### 3.9 Otros
- **Celdas combinadas: 98** en total (TRANSCOR sola tiene 31, con merges verticales de 2 filas en el bloque de personal). Requiere `unmerge` o lectura por celda ancla.
- **Filas vacías/basura:** ~140 filas físicas vacías entre bloques (D LOERA usa 44 filas para 10 registros útiles). No hay filas con basura parcial.
- **Encoding:** el archivo es UTF-8 correcto (`Tamaño`, `Muñoz`, `Sermeño`, `Jiménez` bien codificados). Lo que se ve mal en consola es cp1252 del terminal, no del origen.
- **Valores centinela detectados:** `N/A`, `S/N`, `s/n`, `SIN OPERADOR FIJO`, `TBC`, `FUNDADOR/A`.
- **Ninguna columna de seguro, verificación, permiso SCT o póliza** en ninguna hoja → 0 fechas de vencimiento que validar (no hay vencidos porque no hay dato).

---

## 4. Mapeo propuesto a la BD

### 4.0 Esquema real relevante (verificado en QA)
```
Carriers       Code(U,NN,30) Name(NN,200) Type(NN,30) ExternalCode(U,null,50) Rfc(20)
               Is3PL/Is2PL/IsAssetBased/IsParcel(NN bool) ServiceLevel(NN,20) BaseCurrency(NN,3)
               SctPermitNumber/Expiry, InsurancePolicyNumber/Expiry, FleetSize, IsActive
Vehicles       Code(U,NN,50) PlateNumber(U,NN,20) CarrierId(NN→Carriers,RESTRICT)
               VehicleClassId(NN→VehicleClasses,RESTRICT) Brand/Model(null,80) ModelYear(int,null)
               OwnershipStrategy(NN,30) BodyType(NN,80) TrailerCount(NN,def 0)
               LengthM/WidthM/HeightM/CapacityWeightKg/CapacityVolumeM3 (TODOS NN)
               AvailabilityStatus(NN,40) DefaultDriverId(null→Drivers,SET NULL) GpsDeviceId(U,null)
VehicleClasses Code(U,NN,30) Name(NN,100) Category(NN,30) + defaults nullables
Drivers        Code(U,NN,50) FullName(NN,200) CarrierId(NN→Carriers,RESTRICT)
               LicenseNumber(U,NN,80)  LicenseExpiry(NN, timestamp)
               TrackingMode(NN,30) AvailabilityStatus(NN,40) CanAccessMobileApp(NN,def false)
```
Valores string en uso: `Type` ∈ {ThirdPartyLogistics, AssetBased, Parcel} · `OwnershipStrategy` = `Tercerizada` · `AvailabilityStatus` = `Disponible` · `TrackingMode` ∈ {CarrierPortal, MobileApp} · `ServiceLevel` ∈ {Bronze, Silver, Gold} · `Category` ∈ {Motocicleta, Camioneta, Van, CamionRigido, Tractocamion, Otro}.

### 4.1 Hoja `CATALOGO LINEAS` → `Carriers`
| Columna Excel | Columna BD | Transformación |
|---|---|---|
| `NOMBRE PROVEEDOR` | `Name` | trim; es la razón social |
| `# PROVEEDOR` | **`ExternalCode`** | el UNIQUE parcial está libre (solo lo usan 2 registros soft-deleted). Es la llave del ERP P8 → **usar como clave de idempotencia** |
| `NOMBRE COMERCIAL` | `Code` (upper, sin espacios) + `Description` | 9 de 20 filas vienen vacías |
| — | `Type`, `Is3PL/Is2PL/IsAssetBased/IsParcel`, `ServiceLevel`, `BaseCurrency` | **NOT NULL, no vienen** → decisión de negocio |

### 4.2 Bloques de unidades → `Vehicles`
| Columna Excel | Columna BD | Transformación / riesgo |
|---|---|---|
| `Placas` / `MATRICULA` / `Placas numero` | `PlateNumber` | **normalizar**: upper, quitar `-` y espacios. UNIQUE global |
| `No. ECO.` / `No. Economico` / `Unidad` | `Code` | 34 % vacío + 1 duplicado intra-carrier → **no sirve solo**; usar `{CARRIER}-{PLACA}` |
| `Marca` | `Brand` | normalizar 29 → ~15 valores; corregir `Freighliner`, `DOGE` |
| `Submarca` / `modelo`(GMAX) / `MARCA`(SEND) | `Model` | columna distinta por hoja |
| `modelo` | `ModelYear` | solo si es año de 4 dígitos (161/228); extraer de `mod.2016` en DIRZO |
| `Capacidad` / `Tamaño` / `Tipo` | **`VehicleClassId`** (FK) + `BodyType` | ver 4.4 — mapeo parcial |
| hoja (nombre) | `CarrierId` (FK) | |
| `1 unidad Blindada` (SEND) | `BodyType` = "Blindada" | atributo de seguridad, no de capacidad |
| **— no viene —** | `LengthM, WidthM, HeightM, CapacityWeightKg, CapacityVolumeM3` | **5 columnas NOT NULL sin origen** → heredar de `VehicleClasses.Default*` |
| **— no viene —** | `OwnershipStrategy`, `AvailabilityStatus`, `TrailerCount` | default `Tercerizada` / `Disponible` / 0 |
| **— no viene —** | `Axles`, `GpsDeviceId`, seguros, `SctAuthorization` | quedan NULL |

**Columnas del Excel sin destino en BD:**
| Dato | Destino |
|---|---|
| `No. Tarimas` (encabezado vacío, MARCO POLO) | **no existe columna** → requeriría migración `Vehicles.PalletCapacity` |
| `45/60 METROS CUBICOS` (D LOERA), `53 PIES/Ft` | absorbible en `CapacityVolumeM3` / `BodyType`, con conversión manual |
| `Marca` = nombre de persona (DIRZO ×2) | señal de subcontrato; **no hay campo** de propietario distinto al carrier |

### 4.3 Bloques de personal → `Drivers`
| Columna Excel | Columna BD | Riesgo |
|---|---|---|
| `NOMBRE` / `Nombre conductor` / `operador` | `FullName` | 205 únicos |
| `PUESTO` / `Área` | — (filtro) | **18 filas NO son conductores** → excluir o mandar a `Employees` |
| `TELEFONO` | `Phone` / `MobilePhone` | 26/208; formato `55-30458363` |
| `FECHA DE INGRESO` | — | **no existe campo de antigüedad** en `Drivers` |
| `CURP`, `RFC`, `NSS/IMSS` | — | **ninguno tiene columna en `Drivers`** → se pierden salvo migración |
| `CERTIFICACION` (`RCONTROL`, `ACTIVO SEGURO`, `CAPITAL HUMANO`) | `TrainingCertificationExpiry`? | es un **nombre de proveedor de certificación, no una fecha** → no encaja |
| hoja | `CarrierId` | |
| **— no viene —** | **`LicenseNumber` (NOT NULL + UNIQUE)** | **BLOQUEADOR** |
| **— no viene —** | **`LicenseExpiry` (NOT NULL)** | **BLOQUEADOR** |
| **— no viene —** | `TrackingMode`, `AvailabilityStatus`, `CanAccessMobileApp` | default `CarrierPortal` / `Disponible` / false |

### 4.4 `Capacidad` → `VehicleClasses` (12 clases existentes)
Mapeo automático posible: **154 de 228 (67 %)**. Quedan **74 unidades (33 %) que requieren decisión**:

| Caso | Unid. | Por qué falla |
|---|---|---|
| `8 ton` / `9 ton` | **29** | No hay clase de 8-9 t. Entre `CAMION_5T` (5 t) y `RABON` (10 t). SEND 26 + GMAX 3 |
| `1 unidad Blindada` | **24** | Describe seguridad, no capacidad. Son Kenworth T300/T370 (≈8 t) |
| Modelo VW en el campo capacidad (SAVEIRO/CADDY/VIRTUS/TIGUAN/POLO) | **8** | TRANSCOR; TIGUAN y POLO ni siquiera son de carga |
| OPTER `T 64A-8`, `50S-0.5`, `57S-0.5`, `71S-0.5` | **4** | Códigos internos de OPTER, indescifrables |
| `45/60 METROS CUBICOS` (D LOERA) | **3** | Expresado en volumen; `TRACTOCAMION_1T`=90 m³, `TORTON`=45 m³ → ambiguo |
| `700 KILOS`, `0.5` | **4** | Bajo la clase mínima `CAMIONETA_1T` (1000 kg) |
| `2.5` (Ford Transit 2500) | **1** | Hueco entre 1.5 t y 3.5 t |
| Vacío (Nissan Versa, GMAX) | **1** | Sin dato |

**Catálogo de negocio vs catálogo BD:** la hoja `CATALOGO DE UNIDADES` define 10 tipos (`MOTOCICLETA, AUTO, 750 KGS, 1.5 TONS, 3.5 TONS, 4.5 TONS, RABON, TORTON, MUDANCERO, TRAILER 48 Y 53 FT`). La BD tiene 12 clases. **No empatan**: al catálogo de CINLAT le falta `SPRINTER` y `CAMION_5T`/`TRACTOCAMION_*`; a la BD le faltan `750 KGS` y `4.5 TONS`. Y el catálogo de CINLAT no cubre las 8/9 t ni "Blindada" que sí aparecen en las hojas de detalle → **el propio catálogo de CINLAT es incompleto respecto de su propia flota.**

### 4.5 Choque con datos existentes en QA

| Tabla | Registros vivos | Del Excel que ya existirían |
|---|---|---|
| Carriers | 31 (+2 soft-deleted) | **7 de 9** hojas ya tienen carrier: OPTER, MARCOPOLO, QUMSA, TRANSCOR, GMAX, SEND, CONTRERAS. **Faltan: DIRZO y D LOERA** |
| Vehicles | 46 (+4) | **0 de 228.** Intersección de placas normalizadas = **cero** |
| Drivers | 31 (+2) | **0 de 205.** Intersección de nombres = **cero** |
| VehicleClasses | 12 | catálogo base; ver 4.4 |

**Los 46 vehículos y 31 conductores actuales son datos demo sembrados**, no reales: placas sintéticas (`BIR-2023`, `10-BJ-23`, `PRE-001-A`) y licencias plantilla (`GMX-LIC-001`, `TCO-LIC-002`). Los 8 carriers reales del Excel ya tienen 3-5 vehículos y 2-3 conductores **falsos** colgando.

**Veredicto de carga: ALTA NUEVA, no merge.** Pero con una condición previa — decidir qué pasa con el demo de esos 8 carriers, porque si se deja, quedan mezcladas 30 unidades ficticias con 228 reales y nadie sabrá cuál es cuál. FK `RESTRICT` en `Vehicles.CarrierId` y `Drivers.CarrierId` impide borrar carriers; el borrado es soft (`IsDeleted`), así que es reversible.

Del `CATALOGO LINEAS` (20 proveedores): **10 ya existen** en `Carriers` (SEND, GMAX, ICASA, UPS, TRANSCOR, CONTRERAS, QUMSA, MARCOPOLO, OPTER, EXPRESS_PL) y **10 faltan** (Halcones custodias, Dirzo, Victor Cortes Rojas, TDL/D Loera, Sonia Ivette Sanchez Trejo, Garseg, Gruloga, Carga y Express, Sistematización…, Transportes Devi). Ninguno de los 31 carriers vivos tiene `ExternalCode` poblado → el `# PROVEEDOR` entra limpio.

---

## 5. El archivo SCT — qué es realmente

**No son movimientos ni entradas/salidas de patio. Es una matriz de integraciones.**

Hoja `Integraciones`: 42 filas `INT-001` … `INT-042`, 13 columnas (`Sistema Origen`, `Sistema Destino`, `Información Intercambiada`, `Tipo de Integración`, `Estatus`, `Qué campos viajan?`, `Validaciones`, `Frecuencia`, `Dirección`, `Reglas de negocio`, `Responsable`, `Observaciones`).

"SCT" aquí = **SCTrafico**, el sistema legacy que Axon reemplaza. "Entradas y salidas" = los flujos de datos que hoy entran y salen de ese sistema y que Axon debe absorber. Encaja con el contexto del repo (`docs/`, memoria `sct-gap-programa-e1e8`).

**Sistemas involucrados:** origen P8 ×8, AXON ×8, TBC ×4 ("to be confirmed"), Portal Transportista, GPS, App Móvil. Destino: AXON ×15, P8 ×4, NetSuite, Dashboard BI.
**Frecuencias:** tiempo real ×11, diario ×6, al cierre del viaje ×2, cada 15 min ×1.

**Grado de avance — está a medio llenar:**

| Columna | Llenas / 42 |
|---|---|
| ID | 42 |
| Información Intercambiada | 39 |
| Tipo de Integración | 29 |
| Sistema Origen / Destino | 23 / 23 |
| Dirección | 22 |
| Responsable | 20 |
| Frecuencia | 20 |
| **Estatus** | **1** |
| **Qué campos viajan?** | **0** |
| **Validaciones** | **0** |
| **Reglas de negocio** | **0** |

Las filas `INT-024` a `INT-039` solo tienen concepto y la palabra `ALONSO` (pendiente de definir por esa persona): cancelación de pedidos, cambios de pedido, cancelación de viajes, replaneación, incidencias, rechazo de entrega, entrega parcial, devoluciones, tracking para clientes, alertas por excepción, cierre y liquidación de viaje, catálogo de zonas, catálogo de operadores logísticos, calendario operativo, festivos. `INT-040/041/042` están completamente vacías.

**Aplica a alguna entidad de Axon?** No directamente. Es **documento de requerimientos de integración**, no dato cargable. Su valor: `INT-006` (Catálogo de Transportes), `INT-007` (Catálogo de Choferes) e `INT-008` (Inventario de unidades) están marcados **`TBC` / "No hay intercambio de datos"** — es decir, **CINLAT confirma por escrito que hoy no existe fuente sistematizada de flota. Estos Excel SON la fuente.** Eso justifica la carga manual y explica por qué los datos vienen así.

---

## 6. Bloqueadores — qué impide cargar hoy

| # | Bloqueador | Alcance | Severidad |
|---|---|---|---|
| **B1** | `Drivers.LicenseNumber` es **NOT NULL + UNIQUE** y **ninguna hoja trae licencia** | 205 conductores | **Bloqueante duro** |
| **B2** | `Drivers.LicenseExpiry` es **NOT NULL** y no hay dato | 205 conductores | **Bloqueante duro** |
| **B3** | `Vehicles` exige 5 numéricos NOT NULL (`LengthM, WidthM, HeightM, CapacityWeightKg, CapacityVolumeM3`) que no vienen | 228 vehículos | Bloqueante, mitigable heredando de `VehicleClasses` |
| **B4** | 74 vehículos (33 %) no mapean a ninguna de las 12 `VehicleClasses` | 74 | Bloqueante parcial (FK RESTRICT) |
| **B5** | Faltan 2 carriers: **DIRZO** y **D LOERA (TDL SA de CV)** | 15 veh + 11 ops | Bloqueante de FK, trivial de resolver |
| **B6** | 104 de 228 vehículos no tienen forma de vincularse a conductor (`DefaultDriverId`) | 104 | No bloquea (nullable), degrada el dato |
| **B7** | Datos demo de los 8 carriers reales conviven con los reales | 30 veh + 23 drv falsos | No bloquea, contamina |
| **B8** | GMAX periodo 2023 y SEND periodo 2025 | 121 veh (53 %) | Riesgo de cargar flota dada de baja |

**Lo que NO bloquea (buenas noticias):** cero placas duplicadas, cero colisiones con la BD, encoding limpio, 0 filas basura parciales.

---

## 7. Plan de carga sugerido

### Fase 0 — Decisiones de negocio (antes de tocar nada)
1. **Licencias**: pedir a CINLAT el listado de licencias federales SCT (número + vigencia) por operador. **Sin esto no hay carga de `Drivers`.** Alternativa temporal: generar `LicenseNumber = 'PEND-{CARRIER}-{NNN}'` y `LicenseExpiry = fecha pasada` para forzar visibilidad del pendiente — **requiere aprobación explícita**, porque mete datos falsos en una columna UNIQUE.
2. **Clases faltantes**: aprobar alta de `CAMION_8T` (o reutilizar `RABON`), `CAMIONETA_2_5T`, `MOTOCARGA_750KG`. Definir si "Blindada" es `BodyType` o clase.
3. **Demo**: confirmar soft-delete de los 30 vehículos y 23 conductores ficticios de los 8 carriers reales.
4. **Vigencia**: pedir refresh de GMAX (2023) y SEND (2025) antes de cargarlos, o cargarlos con `IsActive = false` hasta confirmación.

### Fase 1 — Catálogos (idempotente por clave natural)
```sql
-- 1a) VehicleClasses faltantes (Code es la clave natural, UNIQUE)
INSERT INTO "VehicleClasses" (...) VALUES (...)
ON CONFLICT ("Code") DO UPDATE SET "Name"=EXCLUDED."Name", "UpdatedAt"=now();

-- 1b) Carriers: DIRZO, TDL(D Loera) + los 8 restantes del CATALOGO LINEAS
--     Idempotencia por "Code"; poblar ExternalCode con el # PROVEEDOR de P8
ON CONFLICT ("Code") DO UPDATE SET "ExternalCode"=EXCLUDED."ExternalCode", ...;
```
Ojo: `IX_Carriers_ExternalCode` es UNIQUE parcial (`WHERE ExternalCode IS NOT NULL`) → un `ON CONFLICT ("Code")` que actualice `ExternalCode` puede violar ese índice si dos filas traen el mismo `# PROVEEDOR`. Verificado: **los 16 `# PROVEEDOR` presentes son únicos**, sin riesgo.

### Fase 2 — Normalización en staging (no en la BD final)
Cargar los 228 + 205 registros a tablas temporales y aplicar:
- Placa: `upper(regexp_replace(placa, '[^A-Za-z0-9]', '', 'g'))`
- Marca: diccionario de 29 → 15 (`Freighliner→Freightliner`, `DOGE→Dodge`, `VW→Volkswagen`)
- Año: extraer 4 dígitos de `modelo`; NULL si no aplica (67 filas)
- Capacidad → clase: tabla de mapeo revisada a mano para las 74 excepciones
- Nombres de persona: `initcap`, colapsar espacios
- Fechas de ingreso en texto (20) → parseo manual
**Revisión humana obligatoria del staging antes de promover.**

### Fase 3 — Carga
Orden por FK: `VehicleClasses` → `Carriers` → `Drivers` → `Vehicles` → (update `Vehicles.DefaultDriverId` para los 124 con vínculo).
Idempotencia: `ON CONFLICT ("PlateNumber")` en Vehicles, `ON CONFLICT ("Code")` en Drivers.
Defaults: `OwnershipStrategy='Tercerizada'`, `AvailabilityStatus='Disponible'`, `TrackingMode='CarrierPortal'`, `CanAccessMobileApp=false`, `TrailerCount=0`, dimensiones heredadas de la clase.
**Vía correcta:** hacerlo por el servicio de `Application` (respeta `AuditSaveChangesInterceptor`, `IUnitOfWork` y deja `ActivityLog`), **no por SQL directo** — la regla de oro del proyecto exige auditoría en cambios de estado operativo. Si se hace por SQL habría que poblar `CreatedAt/CreatedBy` a mano y no quedaría rastro en `SystemActivityLogs`.

### Fase 4 — Verificación
228 vehículos vivos + 205 conductores + 0 duplicados de placa + 0 huérfanos de FK + conteo por carrier igual a la tabla de §2.1.

---

## 8. Preguntas abiertas

1. **¿Existe el padrón de licencias federales?** Es el único bloqueador duro. Sin él, `Drivers` no se carga (o se carga con datos inventados en una columna UNIQUE).
2. **¿Qué hacemos con las unidades de 8-9 t (29) y las "Blindadas" (24)?** ¿Clase nueva, `RABON`, o `BodyType`? Afecta cotización y cubicaje.
3. **SEND (periodo 2025) y GMAX (periodo 2023): ¿siguen vigentes esas 121 unidades?** Es el 53 % del padrón con la información más vieja.
4. **Los 104 vehículos sin conductor asignado: ¿es real (pool rotativo) o es omisión de captura?** Determina si `DefaultDriverId` sirve para algo.
5. **CURP/RFC/NSS/fecha de ingreso: ¿los queremos en Axon?** Hoy `Drivers` no tiene esas columnas. Si sí, hay migración; si no, se pierden 31 CURP, 11 RFC y 36 NSS.
6. **`CERTIFICACION` (`RCONTROL`, `ACTIVO SEGURO`, `CAPITAL HUMANO`): ¿qué es?** Parece proveedor de verificación de antecedentes. No hay campo; `BackgroundCheckExpiry` espera fecha, no nombre.
7. **Las 18 personas que no son conductores (directores, gerentes, maniobras, ayudantes): ¿a `Employees`, a un rol de contacto del carrier, o se descartan?**
8. **Las 2 unidades de DIRZO con persona en el campo Marca (`Salome`, `Francisco Gzl`): ¿son subcontratos de terceros?** No hay campo de propietario distinto al carrier.
9. **`# PROVEEDOR` (8228, 10043…): ¿es la llave definitiva de P8?** Si sí, es la clave de idempotencia correcta para futuras recargas y para `INT-006`.
10. **¿Se depura el demo de los 8 carriers reales?** Si no, quedan 30 unidades ficticias mezcladas con 228 reales.
11. **`No. Tarimas` (encabezado vacío en MARCO POLO): ¿lo quieren capturar?** Requeriría migración en `Vehicles`.
12. **Los 11 proveedores del `CATALOGO LINEAS` sin hoja de detalle** (Halcones custodias, ICASA, UPS, Garseg, Gruloga…): ¿son de custodia/paquetería y por eso no traen flota propia, o falta la información?

---

### Anexo — artefactos generados (scratchpad, no versionados)
```
profile.py / profile_out.txt   perfilado estructural de los 3 archivos
dump.py / dump_v1.txt          volcado íntegro celda a celda (V1)
        / dump_sinv1.txt       volcado del duplicado
        / dump_sct.txt         volcado de la matriz de integraciones
diff.py                        comparación hoja a hoja V1 vs sin-V1
extract.py / extracted.json    228 vehículos + 217 filas de personal normalizados
classmap.py                    mapeo capacidad → VehicleClasses
crosscheck.py                  cruce Excel vs BD QA (placas, nombres, catálogo)
```
