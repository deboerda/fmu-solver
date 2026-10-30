# FMUSolver architecture

## Sidecar multi-arch

Industrial FMUs often ship as 32-bit or 64-bit DLLs. One Python process cannot load both. FMUSolver uses:

| Process | Role |
|---------|------|
| `FmuLauncherUniversal.py` → GUI orchestrator (64-bit) | Detect FMU bitness, UI, spawn workers |
| `worker_entry.py` + `fmu_player.py` → `FmuWorker32/64` | FMI load / `doStep` |
| Optional `orbit_pre_runner.py` | Offline pre-calc helper |
| Optional `Script/yaocetest/` | Telemetry parse → Protobuf → inject |

IPC: STDOUT logs; UDP + Protobuf (`ddm.proto`) for variable fan-out.

## Rebuild (Windows)

See `Script/rebuild_all.bat` and PyInstaller `.spec` files. Typical pattern:

- 64-bit Python → `FmuSolver` / `FmuWorker64`
- 32-bit Python (e.g. `C:\Py32`) → `FmuWorker32` / orbit helpers

This public repo ships **source only** — no prebuilt `.exe` / vendor `.dll` packages.

## What is out of scope here

- Customer / proprietary `.fmu` files
- Field deploy packages and vendor solver DLLs
- Project-specific telemetry XML dumps
