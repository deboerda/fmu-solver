# FMUSolver: FMI 2.0 Co-Simulation Runner

Windows host for **FMI 2.0** Functional Mock-up Units: load a rights-cleared `.fmu`, select a matching **32- or 64-bit sidecar worker**, run real-time co-simulation from a PySide GUI, and optionally map telemetry into model inputs or publish variables over **UDP + Protobuf**.

[`deboerda/fmu-solver`](https://github.com/deboerda/fmu-solver) · Product **FMUSolver** · **MIT** · [**v0.1.0**](https://github.com/deboerda/fmu-solver/releases/tag/v0.1.0)

[![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python)](#requirements)
[![FMI](https://img.shields.io/badge/FMI-2.0%20FMU-orange)](#what-it-does)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/deboerda/fmu-solver?include_prereleases)](https://github.com/deboerda/fmu-solver/releases/tag/v0.1.0)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-0078D4?logo=windows)](#requirements)

Public source edition: no customer models or vendor solver DLLs. Clone-and-run demo: [Reference-FMUs **BouncingBall**](Script/examples/fmus/BouncingBall.fmu) (BSD-2). Prebuilt win64 GUI + worker on [Releases](https://github.com/deboerda/fmu-solver/releases).

> Split from a private field archive (`fmu-cosim-runner`); this repo keeps the reusable runner only.

## Why this exists

Most FMI tooling either stays in Modelica IDEs or assumes one bitness and one vendor stack. FMUSolver is a thin Windows host: **detect bitness → spawn the matching worker → step / pause / inject → optional I/O bridges**. Handy for digital-twin benches, HIL-style loops, and quick FMU smoke tests without dragging a full modeling suite.

## Highlights

| | |
|--|--|
| **Sidecar 32/64** | FMU bitness detection → matching worker process |
| **FMI 2.0 core** | Load, `doStep`, pause/resume/stop, live parameter inject |
| **Telemetry bridge** | Config-driven parse → map → FMU inputs (optional) |
| **UDP + Protobuf** | Fan-out selected variables to viz / peers (`ddm.proto`) |
| **Packaging / CI** | PyInstaller specs, `rebuild_all.bat`, win64 Release artifacts |

Built for simulation and digital-twin engineers who need a **portable FMI 2.0 runner**, not a locked proprietary model package.

## Quick start (Windows, from source)

```powershell
git clone https://github.com/deboerda/fmu-solver.git
cd fmu-solver
python -m pip install -r requirements.txt
cd Script
python FmuLauncherUniversal.py
```

1. Put your FMI 2.0 `.fmu` in a local `FMU/` folder (or browse in the GUI). Demo: [`Script/examples/fmus/BouncingBall.fmu`](Script/examples/fmus/BouncingBall.fmu).  
2. Optionally copy examples from `Script/examples/` into `ParamFilter.xml` / `sync_fields.json`.  
3. Start / pause / stop from the GUI; in source mode the launcher spawns `fmu_player.py` (64-bit = same Python; 32-bit needs `C:\Py32\python.exe`).  
4. To build one-file exes: `Script\rebuild_all.bat` (see [`docs/FROM_SOURCE.md`](docs/FROM_SOURCE.md)).

## Clone-and-demo

Sample FMU (≈213 KiB): [`Script/examples/fmus/BouncingBall.fmu`](Script/examples/fmus/BouncingBall.fmu) — [Reference-FMUs](https://github.com/modelica/Reference-FMUs) v0.0.42, FMI 2.0, **BSD-2-Clause** ([NOTICE](Script/examples/fmus/NOTICE.md)).

```powershell
cd Script
python -m pip install -r ..\requirements.txt
.\demo_bouncing_ball.bat
```

GUI: `run_fmusolver_dev.bat` → open that `.fmu` → stop ≈ 3 s.  
Prebuilt win64 GUI/worker: GitHub Actions workflow `Windows build` (artifact / Release on tags `v*`) — see [`docs/FROM_SOURCE.md`](docs/FROM_SOURCE.md).

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
Script/examples/        # Example configs + BouncingBall.fmu demo
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
