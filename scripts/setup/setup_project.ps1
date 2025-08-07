# Dual Port Memory UVM Project Setup Script
# This script creates a complete UVM testbench structure for dual port memory verification

Write-Host "Setting up Dual Port Memory UVM Project..." -ForegroundColor Green

# Create main directory structure
$directories = @(
    "src",
    "src\dut",
    "src\interface",
    "src\package",
    "src\agent",
    "src\env",
    "src\sequence_lib",
    "src\test_lib",
    "src\coverage",
    "src\ral",
    "tb",
    "scripts",
    "docs",
    "sim",
    "sim\work"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path (Get-Location) $dir
    if (!(Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force
        Write-Host "Created directory: $dir" -ForegroundColor Cyan
    }
}

Write-Host "Project structure created successfully!" -ForegroundColor Green
Write-Host "`nDirectory Structure Created:" -ForegroundColor Yellow
Write-Host "[DIR] src/" -ForegroundColor White
Write-Host "  |-- dut/               - Design Under Test" -ForegroundColor Gray
Write-Host "  |-- interface/         - SystemVerilog interfaces" -ForegroundColor Gray
Write-Host "  |-- package/           - UVM packages" -ForegroundColor Gray
Write-Host "  |-- agent/             - UVM agent components" -ForegroundColor Gray
Write-Host "  |-- env/               - UVM environment" -ForegroundColor Gray
Write-Host "  |-- sequence_lib/      - UVM sequences" -ForegroundColor Gray
Write-Host "  |-- test_lib/          - UVM tests" -ForegroundColor Gray
Write-Host "  |-- coverage/          - Functional coverage" -ForegroundColor Gray
Write-Host "  |-- ral/               - Register Abstraction Layer" -ForegroundColor Cyan
Write-Host "[DIR] tb/                  - Testbench top" -ForegroundColor White
Write-Host "[DIR] scripts/             - Build scripts" -ForegroundColor White
Write-Host "[DIR] docs/                - Documentation" -ForegroundColor White
Write-Host "[DIR] sim/                 - Simulation workspace" -ForegroundColor White
Write-Host "  |-- work/              - Compiled libraries" -ForegroundColor Gray

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Run create_files.ps1 to generate SystemVerilog files" -ForegroundColor White
Write-Host "2. Implement basic UVM testbench components" -ForegroundColor White
Write-Host "3. Configure RAL model with predictor and adapter" -ForegroundColor Cyan
Write-Host "4. Add functional coverage" -ForegroundColor White
Write-Host "5. Run simulation" -ForegroundColor White

Write-Host "`nCore UVM Components:" -ForegroundColor Green
Write-Host "[BASIC] Standard UVM Testbench" -ForegroundColor White
Write-Host "[RAL] Register Abstraction Layer" -ForegroundColor Cyan
Write-Host "[PRED] RAL Predictor" -ForegroundColor Cyan
Write-Host "[ADAPT] RAL Adapter" -ForegroundColor Cyan
