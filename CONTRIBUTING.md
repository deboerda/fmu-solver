# Contributing to FMUSolver (`fmu-solver`)

Thanks for helping improve this **generic FMI 2.0 co-simulation runner**.

## Ground rules

- Prefer changes under `Script/` (source of truth).
- Do **not** commit `.fmu` models, field telemetry dumps, secrets, absolute machine paths, or proprietary datasets.
- Keep PRs focused; update docs when behavior changes.
- English is preferred for public docs; short bilingual notes are OK.

## Setup

```powershell
git clone https://github.com/deboerda/fmu-solver.git
cd fmu-solver
python -m pip install -r requirements.txt
cd Script
python FmuLauncherUniversal.py
```

Bring your own rights-cleared FMI 2.0 `.fmu`. See `Script/examples/`.

Optional: a 32-bit Python (e.g. `C:\Py32`) if you rebuild 32-bit workers — see `docs/ARCHITECTURE.md` and `Script/rebuild_all.bat`.

## Issues & PRs

Use the bug / feature templates. Describe FMU bitness (32/64), Python version, and whether you ran from source.

## Maintainer

**Li Dongchen** ([@deboerda](https://github.com/deboerda)) — core developer / public maintainer.
