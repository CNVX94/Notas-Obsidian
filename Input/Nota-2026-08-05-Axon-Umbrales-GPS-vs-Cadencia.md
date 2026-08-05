---
fecha: 2026-08-05
tipo: nota
proyecto: CINLAT iTMS Axon
tags: [axon, tracking, gps, alertas, configuracion, pendiente-daily]
---

#Apunte #axon

# Umbrales de salud GPS vs cadencia de tracking — hallazgo de la demo Viajes (05-ago)

> Destapado durante la demo del rediseño Viajes ILUMINA (viaje QA `TRP-000025`).
> Relacionado: [[Plan-2026-08-04-Reparto-Redisenos-iTMS]].

## Síntesis (el problema en 3 líneas)

La salud de señal GPS (En vivo / Demorado / Fuera de línea) usa umbrales **fijos**: 60s y 180s
(`Application/Trips/GpsSignalQualityRules.cs`), calibrados a la cadencia de demo (~5s por ping).
La cadencia real es **configurable** (`Tracking/IntervalSeconds` en Configuración→Monitoreo; el plan
de campo es 300s). Con 300s, una unidad **sana** cicla En vivo→Demorado→Fuera de línea entre cada
par de pings: se vería "caída" ~40% del tiempo. Los avisos mentirían desde el día uno.

## Qué hacer para evitar el problema

1. **Derivar los umbrales de la cadencia configurada** (propuesta: Demorado = 2× intervalo,
   Fuera de línea = 4× intervalo, con piso 60/180 para no degradar la demo). Cambio acotado:
   `GpsSignalQualityRules.cs` + leer `Tracking/IntervalSeconds` + ajustar 4 tests de umbral exacto
   (`TripControlTowerTelemetryFlowTests`). El front solo pinta lo que manda el backend — no se toca.
   *Ya hay tarea preparada (chip en la sesión de Claude del 05-ago).*
2. **Para probar tracking/alertas fácil en local**: no hace falta tocar código — bajar
   `Tracking/IntervalSeconds` en Configuración→Monitoreo (config en caliente, la PWA la obedece
   en su siguiente lectura). Con el fix del punto 1, los umbrales seguirían la misma perilla.

## Preguntas para el daily

- ¿Confirmamos la regla 2×/4× con piso, o negocio quiere otros factores?
- ¿Quién lo lleva? (es Application/core de tracking, colinda con Torre de Control).
- El monitoreo intensivo por tramo de riesgo (`RiskSegmentSeason`, docs/22) ¿sigue en backlog o
  conviene meterlo junto con este cambio? El "boost por observador" NO existe ni en diseño —
  sería regla nueva a cerrar con negocio.

## Referencias

- `CINLAT.iTMS.Axon.Application/Trips/GpsSignalQualityRules.cs` (umbrales 60/180)
- `Api/Controllers/DriverAppController.cs` L104-120 (lectura de `Tracking/IntervalSeconds` con fallback)
- `docs/FLUJO_OBJETIVO_ZONAS_RUTAS.md` ("subir IntervalSeconds a 300 antes de liberar a campo")
- `docs/22_REDISENO_UX_OPERATIVO.md` (sub-diseño MonitoreoIntensivo por tramo)
