# Examples

## Sample FMU (redistributable)

See [`fmus/`](fmus/) — **BouncingBall.fmu** from [modelica/Reference-FMUs](https://github.com/modelica/Reference-FMUs) v0.0.42 (FMI 2.0, **BSD-2-Clause**).

### One-click CLI demo (Windows)

```powershell
cd Script
python -m pip install -r ..\requirements.txt
.\demo_bouncing_ball.bat
```

### GUI demo (Windows)

```powershell
cd Script
copy examples\sync_fields.BouncingBall.json sync_fields.json
.\run_fmusolver_dev.bat
```

In the GUI: browse to `examples\fmus\BouncingBall.fmu`, set stop time ≈ `3`, step ≈ `0.01`, then Start.

## Config templates

| File | Purpose |
|------|---------|
| `ParamFilter.example.xml` | Optional telemetry ID whitelist |
| `sync_fields.example.json` | Generic time-field sync template |
| `sync_fields.BouncingBall.json` | Sync `h` / `v` for the sample FMU |

No customer models are shipped here.
