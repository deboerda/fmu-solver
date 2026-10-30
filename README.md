# FMUSolver — FMI 2.0 Co-Simulation Runner

> **Product:** FMUSolver · **Public repo:** [`deboerda/fmu-solver`](https://github.com/deboerda/fmu-solver)  
> Load **FMI 2.0 FMUs**, run real-time co-simulation, optionally bridge telemetry into model inputs, and stream selected variables over **UDP + Protobuf**.

[![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python)](#requirements)
[![FMI](https://img.shields.io/badge/FMI-2.0%20FMU-orange)](#what-it-does)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-0078D4?logo=windows)](#requirements)

**Source-only public edition** — no field binaries, no customer models. Bring your own rights-cleared `.fmu` (see [`Script/examples/`](Script/examples/)).

> Earlier monolith with packaged deploy artifacts lived at `fmu-cosim-runner` (now private archive).

## Project highlights（项目亮点）

| Highlight | Detail |
|-----------|--------|
| **Sidecar multi-arch** | Detect FMU bitness → spawn 32- or 64-bit worker |
| **FMI 2.0 core** | Load, step, pause/resume/stop, hot parameter inject |
| **Optional telemetry bridge** | Parse → map → FMU inputs (config-driven examples) |
| **UDP + Protobuf fan-out** | Stream variables to viz / peers (`ddm.proto`) |
| **Rebuild scripts** | PyInstaller specs + `rebuild_all.bat` |

**Role:** core developer — sidecar architecture, simulation control, telemetry mapping, packaging tooling.

## Who it's for

Simulation / digital-twin engineers who need a **Windows FMI 2.0 runner** with dual bitness and optional telemetry glue — not locked to a single proprietary model.

## Quick start (Windows, from source)

```powershell
git clone https://github.com/deboerda/fmu-solver.git
cd fmu-solver
python -m pip install -r requirements.txt
cd Script
python FmuLauncherUniversal.py
```

1. Put your FMI 2.0 `.fmu` in a local `FMU/` folder (or browse in the GUI). **No `.fmu` is bundled.**  
2. Optionally copy examples from `Script/examples/` into `ParamFilter.xml` / `sync_fields.json`.  
3. Start / pause / stop from the GUI; in source mode the launcher spawns `fmu_player.py` (64-bit = same Python; 32-bit needs `C:\Py32\python.exe`).  
4. To build one-file exes: `Script\rebuild_all.bat` (see [`docs/FROM_SOURCE.md`](docs/FROM_SOURCE.md)).

**Not a Linux GUI app** — Windows APIs in the launcher. FMPy worker code may import elsewhere, but Win32/Win64 FMU binaries need Windows.

More: [`docs/FROM_SOURCE.md`](docs/FROM_SOURCE.md) · [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) · [`Script/README_Scripts.md`](Script/README_Scripts.md)

## Architecture

```
FmuSolver GUI (64-bit)     ← Script/FmuLauncherUniversal.py
   │  detects FMU bitness
   ├─► FmuWorker32  ─┐
   └─► FmuWorker64  ─┴─ FMI doStep   ← fmu_player.py + worker_entry.py
                              │
                              ▼  UDP / Protobuf
                     viewers · peers · optional telemetry bridge
```

## Repository layout

```
Script/                 # Source of truth (launcher, workers, tools, specs)
Script/examples/        # Example configs — no .fmu bundled
Script/yaocetest/       # Optional telemetry bridge sources
docs/ARCHITECTURE.md    # Sidecar notes
docs/FROM_SOURCE.md     # Run / package from source (honest limits)
ddm.proto               # Protobuf schema
```

## Requirements

- **Windows 10/11** (GUI / packaging)  
- Python 3.x **64-bit** + packages in `requirements.txt` (**includes PySide6**)  
- Optional **32-bit** Python (default `C:\Py32`) for 32-bit FMUs / workers  
- An FMI 2.0 Co-Simulation `.fmu` you are allowed to run  
- Packaging: PyInstaller via `Script/rebuild_all.bat` (outputs go next to each other under `dist_package\`)

## Roadmap

- [ ] Minimal public CI (import / syntax smoke, no private models)  
- [ ] Clearer split: core FMI runner vs optional telemetry/orbit helpers  
- [ ] Contributor-facing rebuild matrix (32/64) docs  
- [ ] Release tags for source snapshots  

## License

[MIT](LICENSE) © 2026 Li Dongchen (`deboerda`).

Third-party FMUs and vendor libraries remain under their own terms. This repository licenses the **runner / bridge / tooling source** published here.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

*Generic FMI 2.0 co-simulation runner for industrial digital-twin workflows. 通用 FMU 协同仿真运行器。*
