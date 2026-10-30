# Run & package from source

Honest status for the **public source-only** repo (`deboerda/fmu-solver`).

## What “complete” means here

| Mode | Complete? | Notes |
|------|-----------|--------|
| **Windows, source GUI + 64-bit FMU** | Yes, with deps + your `.fmu` | Launcher spawns `fmu_player.py` via the same Python (no prebuilt exe). |
| **Windows, 32-bit FMU from source** | Needs 32-bit Python | Default path `C:\Py32\python.exe` (override by installing there or editing spawn path). |
| **Windows, PyInstaller package** | Yes after rebuild | `Script/rebuild_all.bat` → `dist_package\FmuSolver.exe` + workers beside it. |
| **Linux / macOS GUI** | No | `ctypes.windll`, Win mutex, `taskkill`, acrylic — Windows-only UI. Worker library (`fmu_player` + FMPy) can import on Linux but Windows FMU DLLs will not load. |

This repo is a **完整源码工具** (launcher, worker, telemetry bridge, specs). It is **not** a drop-in field package: no `FmuSolver_Package` exes, no vendor solver DLLs, no customer `.fmu`.

## Dependencies

```powershell
python -m pip install -r requirements.txt
```

Required for GUI: **PySide6**. For Data Visualizer: **pyqtgraph** (+ numpy). FMI stepping: **fmpy**. UDP schema: checked-in `Script/ddm_pb2.py` (from root `ddm.proto`).

Optional: 32-bit CPython for `FmuWorker32`; Pillow only if you regenerate `fmusolver_full.ico` via `fix_full.py`.

## Run from source (dev)

```powershell
cd Script
.\run_fmusolver_dev.bat
:: or: python FmuLauncherUniversal.py
```

1. Provide an FMI 2.0 Co-Simulation `.fmu` you are allowed to run (browse in GUI or put under a local `FMU\` folder).  
2. Optional configs: copy `examples/*.example.*` → `ParamFilter.xml` / `sync_fields.json`.  
3. `gui_config.json` is created on first save — not required to start.  
4. Auto-viz uses `DataVisualizerPython.py` when no `Visualizer\*.exe` exists.

### What fails without X

| Missing | Effect |
|---------|--------|
| Not Windows | GUI exits/fails on `ctypes.windll` (single-instance mutex, etc.). |
| No PySide6 | `ModuleNotFoundError` at launcher import. |
| No fmpy / bad FMU | Worker starts then fails on instantiate/`doStep`. |
| No `.fmu` | Nothing to simulate (by design). |
| 32-bit FMU without `C:\Py32\python.exe` | Source-mode 32-bit worker spawn fails. |
| Packaged mode without `FmuWorker64/32.exe` beside GUI | Frozen launcher cannot find workers. |

## Package on Windows

```powershell
cd Script
:: optional: set PY32=C:\Path\To\32bit\python.exe
:: optional: set DIST_DIR=D:\out\FmuSolver_Package
:: optional: set FMU_SRC=D:\my-fmus
.\rebuild_all.bat
```

Produces `dist_package\` (or `%DIST_DIR%`) with `FmuSolver.exe`, `FmuWorker64.exe`, optional 32-bit workers, Orbit/YaoCe/Visualizer exes. **Workers must sit next to the GUI exe** (see spawn logic in `FmuLauncherUniversal.py`).

Specs: `FmuSolver.spec`, `FmuWorker64.spec`, `FmuWorker32.spec`, plus bat one-file builds for orbit / yaoce / visualizer.

## Entrypoints (map)

| Role | Source | Packaged name |
|------|--------|----------------|
| GUI orchestrator | `FmuLauncherUniversal.py` | `FmuSolver.exe` |
| FMI worker | `fmu_player.py` (`worker_entry.py` thin CLI) | `FmuWorker32/64.exe` |
| Orbit helper | `orbit_pre_runner.py` | `OrbitPreCalc32/64.exe` |
| Telemetry bridge | `yaocetest/main.py` | `YaoCe_LinkLayer32/64.exe` |
| Plot UI | `DataVisualizerPython.py` | `Visualizer/DataVisualizer32/64.exe` |

## Smoke checks (any OS)

```bash
python -m compileall -q Script/FmuLauncherUniversal.py Script/fmu_player.py Script/worker_entry.py
python -c "import sys; sys.path.insert(0,'Script'); import ddm_pb2, fmu_player"
```

Do not expect a headless Linux GUI smoke test.
