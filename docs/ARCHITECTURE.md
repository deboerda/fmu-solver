# FMUSolver architecture

## Sidecar multi-arch

Industrial FMUs often ship as 32-bit or 64-bit DLLs. One Python process cannot load both. FMUSolver uses:

| Process | Role |
|---------|------|
| `FmuLauncherUniversal.py` → GUI orchestrator (64-bit) | Detect FMU bitness, UI, spawn workers |
| `fmu_player.py` (+ `worker_entry.py`) → `FmuWorker32/64` | FMI load / `doStep` via FMPy |
| Optional `orbit_pre_runner.py` | Offline pre-calc helper |
| Optional `Script/yaocetest/` | Telemetry parse → Protobuf → inject |

IPC: STDOUT logs; UDP + Protobuf (`ddm.proto` / `Script/ddm_pb2.py`) for variable fan-out.

**Source mode:** launcher runs `python fmu_player.py …` (64-bit = same interpreter; 32-bit = `C:\Py32\python.exe`).  
**Frozen mode:** launcher runs `FmuWorker32/64.exe` next to `FmuSolver.exe`.

## Rebuild (Windows)

See [`FROM_SOURCE.md`](FROM_SOURCE.md) and `Script/rebuild_all.bat`. Typical pattern:

- 64-bit Python → `FmuSolver` / `FmuWorker64` / helpers  
- 32-bit Python (`PY32`, default `C:\Py32\python.exe`) → `FmuWorker32` / helpers  

This public repo ships **source only** — no prebuilt `.exe` / vendor `.dll` packages.

## What is out of scope here

- Customer / proprietary `.fmu` files  
- Field deploy packages and vendor solver DLLs  
- Project-specific large telemetry XML dumps  
