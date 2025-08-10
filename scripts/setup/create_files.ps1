~# Create all SystemVerilog files for Dual Port Memory UVM Project
# This script creates empty template files with basic class structure

Write-Host "Creating SystemVerilog files..." -ForegroundColor Green

# Define all files to create
$files = @{
    # DUT
    "src\dut\dual_port_memory.sv" = ""
    
    # Interface
    "src\interface\memory_interface.sv" = ""
    
    # Package
    "src\package\memory_pkg.sv" = ""
    
    # Agent Components
    "src\agent\memory_transaction.sv" = ""
    "src\agent\memory_sequencer.sv" = ""
    "src\agent\memory_driver.sv" = ""
    "src\agent\memory_monitor.sv" = ""
    "src\agent\memory_agent.sv" = ""
    
    # Environment
    "src\env\memory_config.sv" = ""
    "src\env\memory_scoreboard.sv" = ""
    "src\env\memory_subscriber.sv" = ""
    "src\env\memory_env.sv" = ""
    "src\env\memory_virtual_sequencer.sv" = ""
    
    # RAL (Register Abstraction Layer)
    "src\ral\memory_ral_model.sv" = ""
    "src\ral\memory_reg_adapter.sv" = ""
    "src\ral\memory_reg_predictor.sv" = ""
    
    # Sequences
    "src\sequence_lib\memory_base_sequence.sv" = ""
    "src\sequence_lib\memory_write_sequence.sv" = ""
    "src\sequence_lib\memory_read_sequence.sv" = ""
    "src\sequence_lib\memory_random_sequence.sv" = ""
    "src\sequence_lib\memory_virtual_sequence.sv" = ""
    
    # Tests
    "src\test_lib\memory_base_test.sv" = ""
    "src\test_lib\memory_basic_test.sv" = ""
    "src\test_lib\memory_random_test.sv" = ""
    
    # Coverage
    "src\coverage\memory_coverage.sv" = ""
    
    # Testbench Top
    "tb\memory_tb_top.sv" = ""
    
    # Scripts
    "scripts\compile.do" = ""
    "scripts\run_sim.do" = ""
    
    # Documentation
    "docs\README.md" = ""
}

# Create all files
foreach ($file in $files.Keys) {
    $fullPath = Join-Path (Get-Location) $file
    $directory = Split-Path $fullPath -Parent
    
    # Ensure directory exists
    if (!(Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }
    
    # Create empty file
    New-Item -ItemType File -Path $fullPath -Force | Out-Null
    Write-Host "Created: $file" -ForegroundColor Cyan
}

Write-Host "`nAll SystemVerilog files created successfully!" -ForegroundColor Green
Write-Host "Total files created: $($files.Count)" -ForegroundColor Yellow
Write-Host "`nFiles created:" -ForegroundColor White
Write-Host "- DUT: 1 file" -ForegroundColor Gray
Write-Host "- Interface: 1 file" -ForegroundColor Gray
Write-Host "- Package: 1 file" -ForegroundColor Gray
Write-Host "- Agent Components: 5 files (transaction, sequencer, driver, monitor, agent)" -ForegroundColor Gray
Write-Host "- Environment: 4 files (config, scoreboard, subscriber, env)" -ForegroundColor Gray
Write-Host "- RAL Components: 3 files (model, adapter, predictor)" -ForegroundColor Cyan
Write-Host "- Sequences: 4 files (base, write, read, random)" -ForegroundColor Gray
Write-Host "- Tests: 3 files (base, basic, random)" -ForegroundColor Gray
Write-Host "- Coverage: 1 file" -ForegroundColor Gray
Write-Host "- Testbench: 1 file" -ForegroundColor Gray
Write-Host "- Scripts: 2 files" -ForegroundColor Gray
Write-Host "- Documentation: 1 file" -ForegroundColor Gray

Write-Host "`nBasic UVM Structure:" -ForegroundColor Yellow
Write-Host "- Standard UVM testbench components" -ForegroundColor White
Write-Host "- Simple test organization" -ForegroundColor White
Write-Host "- Essential sequences" -ForegroundColor White

Write-Host "`nRAL Components Added:" -ForegroundColor Green
Write-Host "[RAL] Register Abstraction Layer model" -ForegroundColor Cyan
Write-Host "[ADAPT] RAL adapter for bus protocol conversion" -ForegroundColor Cyan
Write-Host "[PRED] RAL predictor for register tracking" -ForegroundColor Cyan
Write-Host "[SUB] Subscriber for transaction analysis" -ForegroundColor Cyan

Write-Host "`nNext Steps:" -ForegroundColor Green
Write-Host "1. Implement the DUT (dual port memory)" -ForegroundColor White
Write-Host "2. Create the memory interface" -ForegroundColor White
Write-Host "3. Set up RAL model for memory registers" -ForegroundColor Cyan
Write-Host "4. Implement basic sequences and tests" -ForegroundColor White
