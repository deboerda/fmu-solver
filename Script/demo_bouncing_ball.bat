@echo off
setlocal
cd /d "%~dp0"
set "FMU=%~dp0examples\fmus\BouncingBall.fmu"
if not exist "%FMU%" (
  echo [!] Missing %FMU%
  exit /b 1
)
echo [*] Demo: FMI 2.0 BouncingBall via fmu_player.py (source mode)
echo [*] FMU=%FMU%
python -c "import PySide6,fmpy; print('deps OK', fmpy.__version__)" 2>nul
if errorlevel 1 (
  echo [!] Install deps first: python -m pip install -r ..\requirements.txt
  exit /b 1
)
copy /Y "%~dp0examples\sync_fields.BouncingBall.json" "%~dp0sync_fields.json" >nul
python fmu_player.py "%FMU%" --step 0.01 --rate 0 --freq 10 --time 3 --sync_vars "%~dp0sync_fields.json" --ip 127.0.0.1 --port 22345
echo [*] Done. For GUI: run_fmusolver_dev.bat then browse to examples\fmus\BouncingBall.fmu
