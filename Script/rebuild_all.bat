@echo off
setlocal
cd /d "%~dp0"

:: Portable defaults (override before calling if needed)
if not defined DIST_DIR set "DIST_DIR=%~dp0dist_package"
if not defined PY32 set "PY32=C:\Py32\python.exe"
if not defined FMU_SRC set "FMU_SRC="

echo [*] Starting CLEAN rebuild (32/64-bit)...
echo [*] DIST_DIR=%DIST_DIR%
echo [*] PY32=%PY32%

echo [+] Updating visible build version...
python update_build_version.py
if errorlevel 1 exit /b 1

:: 0. Clean old build artifacts
echo [+] Cleaning old build artifacts...
if exist "build" rd /s /q "build"
if exist "build32" rd /s /q "build32"
if exist "dist" rd /s /q "dist"
if exist "__pycache__" rd /s /q "__pycache__"

:: Ensure packaging icon name expected by FmuSolver.spec
if not exist "fmusolver_full.ico" if exist "fmusolver.ico" copy /Y "fmusolver.ico" "fmusolver_full.ico" >nul

:: 1. 64-bit Builds (System Python)
echo [+] Building 64-bit Components...
python -m PyInstaller --noconfirm FmuSolver.spec
if errorlevel 1 exit /b 1
python -m PyInstaller --noconfirm --onefile --console --name FmuWorker64 --workpath ./build --distpath ./dist fmu_player.py
if errorlevel 1 exit /b 1
python -m PyInstaller --noconfirm --onefile --console --name OrbitPreCalc64 --workpath ./build --distpath ./dist orbit_pre_runner.py
python -m PyInstaller --noconfirm --onefile --console --name YaoCe_LinkLayer64 --workpath ./build --distpath ./dist yaocetest/main.py
python -m PyInstaller --noconfirm --onefile --windowed --name DataVisualizer64 --workpath ./build --distpath ./dist DataVisualizerPython.py

:: 2. 32-bit Builds (optional — skip if PY32 missing)
if exist "%PY32%" (
  echo [+] Building 32-bit Components with %PY32%...
  "%PY32%" -m PyInstaller --noconfirm --onefile --console --name FmuWorker32 --workpath ./build32 --distpath ./dist fmu_player.py
  "%PY32%" -m PyInstaller --noconfirm --onefile --console --name OrbitPreCalc32 --workpath ./build32 --distpath ./dist orbit_pre_runner.py
  "%PY32%" -m PyInstaller --noconfirm --onefile --console --name YaoCe_LinkLayer32 --workpath ./build32 --distpath ./dist yaocetest/main.py
  "%PY32%" -m PyInstaller --noconfirm --onefile --windowed --name DataVisualizer32 --workpath ./build32 --distpath ./dist DataVisualizerPython.py
) else (
  echo [!] PY32 not found at %PY32% — skipping 32-bit workers. 64-bit FMUs only until you set PY32.
)

:: 3. Packaging layout (exe next to each other — launcher expects workers in APP_DIR)
echo [+] Packaging into %DIST_DIR%...
if not exist "%DIST_DIR%" mkdir "%DIST_DIR%"
if not exist "%DIST_DIR%\Visualizer" mkdir "%DIST_DIR%\Visualizer"

copy /Y ".\dist\FmuSolver.exe" "%DIST_DIR%\" 
copy /Y ".\dist\FmuWorker64.exe" "%DIST_DIR%\" 
if exist ".\dist\FmuWorker32.exe" copy /Y ".\dist\FmuWorker32.exe" "%DIST_DIR%\" 
if exist ".\dist\OrbitPreCalc64.exe" copy /Y ".\dist\OrbitPreCalc64.exe" "%DIST_DIR%\" 
if exist ".\dist\OrbitPreCalc32.exe" copy /Y ".\dist\OrbitPreCalc32.exe" "%DIST_DIR%\" 
if exist ".\dist\YaoCe_LinkLayer64.exe" copy /Y ".\dist\YaoCe_LinkLayer64.exe" "%DIST_DIR%\" 
if exist ".\dist\YaoCe_LinkLayer32.exe" copy /Y ".\dist\YaoCe_LinkLayer32.exe" "%DIST_DIR%\" 
if exist ".\dist\DataVisualizer64.exe" copy /Y ".\dist\DataVisualizer64.exe" "%DIST_DIR%\Visualizer\" 
if exist ".\dist\DataVisualizer32.exe" copy /Y ".\dist\DataVisualizer32.exe" "%DIST_DIR%\Visualizer\" 

copy /Y ".\sync_fields.json" "%DIST_DIR%\" 
if exist ".\fmusolver_full.ico" copy /Y ".\fmusolver_full.ico" "%DIST_DIR%\" 
if exist ".\fmusolver.ico" copy /Y ".\fmusolver.ico" "%DIST_DIR%\" 

:: Optional: copy user FMUs if FMU_SRC set
if defined FMU_SRC (
  if not exist "%DIST_DIR%\FMU" mkdir "%DIST_DIR%\FMU"
  copy /Y "%FMU_SRC%\*.fmu" "%DIST_DIR%\FMU\" 
)

echo [*] Build finished.
echo [*] Launch: "%DIST_DIR%\FmuSolver.exe"  (place your .fmu under FMU\ or browse in GUI)
echo [*] Source-mode alternative: run_fmusolver_dev.bat (no exe required)
pause
