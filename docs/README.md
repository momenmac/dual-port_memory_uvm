# Dual Port Memory UVM Verification Environment

A comprehensive UVM-based SystemVerilog testbench for verifying dual-port memory functionality with Register Abstraction Layer (RAL) integration and advanced UVM features.

## 🎯 Overview

This project implements a complete UVM verification environment for a dual-port memory (DPM) design. The testbench follows industry-standard UVM methodology with Register Abstraction Layer (RAL) for register modeling, functional coverage, and systematic verification approach.

### Key Features

- **UVM-Based Architecture**: Complete UVM testbench with standard components
- **Register Abstraction Layer (RAL)**: Full RAL integration with predictor and adapter
- **Dual-Port Memory Design**: Configurable memory with independent read/write ports
- **Comprehensive Test Suite**: Extensible test library with sequences
- **Advanced Features**: Coverage-driven verification and scoreboard checking
- **Modular Design**: Separated components for easy maintenance and extension
- **Subscriber Pattern**: Transaction analysis and monitoring capabilities

## 🏗️ UVM Architecture

### Testbench Hierarchy

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              UVM TEST ENVIRONMENT                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────────┐ │
│  │                            memory_env                                       │ │
│  │  ┌─────────────────────────────┐   ┌─────────────────────────────┐         │ │
│  │  │       memory_agent          │   │     memory_scoreboard       │         │ │
│  │  │  ┌─────────────────────┐    │   │                             │         │ │
│  │  │  │ memory_sequencer    │    │   │                             │         │ │
│  │  │  │                     │    │   │                             │         │ │
│  │  │  │ ┌─────────────────┐ │    │   │                             │         │ │
│  │  │  │ │ memory_driver   │ │    │   │                             │         │ │
│  │  │  │ └─────────────────┘ │    │   │                             │         │ │
│  │  │  │                     │    │   │                             │         │ │
│  │  │  │ ┌─────────────────┐ │    │   │                             │         │ │
│  │  │  │ │ memory_monitor  │ │    │   │                             │         │ │
│  │  │  │ └─────────────────┘ │    │   │                             │         │ │
│  │  │  └─────────────────────┘    │   │                             │         │ │
│  │  └─────────────────────────────┘   └─────────────────────────────┘         │ │
│  │                                                                             │ │
│  │  ┌─────────────────────────────┐   ┌─────────────────────────────┐         │ │
│  │  │     memory_coverage         │   │    memory_subscriber        │         │ │
│  │  │                             │   │                             │         │ │
│  │  └─────────────────────────────┘   └─────────────────────────────┘         │ │
│  │                                                                             │ │
│  │  ┌─────────────────────────────────────────────────────────────────────┐   │ │
│  │  │                         RAL Model                                  │   │ │
│  │  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐    │   │ │
│  │  │  │ memory_ral_model│  │memory_reg_adapter│  │memory_reg_predictor│ │   │ │
│  │  │  └─────────────────┘  └─────────────────┘  └─────────────────┘    │   │ │
│  │  └─────────────────────────────────────────────────────────────────────┘   │ │
│  └─────────────────────────────────────────────────────────────────────────────┘ │
└───────────────────────────┬─────────────────┬───────────────────────────────────┘
                            │                 │
                    ┌───────▼───────┐ ┌───────▼───────┐
                    │memory_interface│ │memory_interface│
                    │   (Port A)     │ │   (Port B)     │
                    └───────┬───────┘ └───────┬───────┘
                            │                 │
                            └────────┬────────┘
                                     │
                            ┌────────▼────────┐
                            │   DUAL PORT     │
                            │     MEMORY      │
                            │ (dual_port_memory)│
                            │                 │
                            │ Port A | Port B │
                            └─────────────────┘
```

## 📁 Project Structure

```
dual-port_memory_uvm/
├── src/                           # Source files
│   ├── dut/
│   │   └── dual_port_memory.sv    # Design Under Test
│   ├── interface/
│   │   └── memory_interface.sv    # SystemVerilog interface
│   ├── package/
│   │   └── memory_pkg.sv          # UVM package definition
│   ├── agent/                     # UVM Agent components
│   │   ├── memory_transaction.sv  # Transaction class
│   │   ├── memory_sequencer.sv    # UVM sequencer
│   │   ├── memory_driver.sv       # UVM driver
│   │   ├── memory_monitor.sv      # UVM monitor
│   │   └── memory_agent.sv        # UVM agent
│   ├── env/                       # Environment components
│   │   ├── memory_config.sv       # Configuration object
│   │   ├── memory_scoreboard.sv   # UVM scoreboard
│   │   ├── memory_subscriber.sv   # Analysis subscriber
│   │   └── memory_env.sv          # UVM environment
│   ├── ral/                       # Register Abstraction Layer
│   │   ├── memory_ral_model.sv    # RAL register model
│   │   ├── memory_reg_adapter.sv  # RAL bus adapter
│   │   └── memory_reg_predictor.sv # RAL predictor
│   ├── sequence_lib/              # UVM Sequences
│   │   ├── memory_base_sequence.sv     # Base sequence
│   │   ├── memory_write_sequence.sv    # Write sequence
│   │   ├── memory_read_sequence.sv     # Read sequence
│   │   └── memory_random_sequence.sv   # Random sequence
│   ├── test_lib/                  # UVM Tests
│   │   ├── memory_base_test.sv    # Base test class
│   │   ├── memory_basic_test.sv   # Basic functionality test
│   │   └── memory_random_test.sv  # Random test
│   └── coverage/
│       └── memory_coverage.sv     # Functional coverage
├── tb/
│   └── memory_tb_top.sv           # Testbench top module
├── scripts/                       # Build scripts
│   ├── compile.do                 # Compilation script
│   ├── run_sim.do                 # Simulation script
│   └── setup/                     # Setup scripts
│       ├── setup_project.ps1      # Project structure setup
│       └── create_files.ps1       # File creation script
├── sim/                           # Simulation workspace
│   └── work/                      # Compiled libraries
└── docs/
    └── README.md                  # This documentation
```

## 🧪 UVM Components

### Core UVM Components

| Component | Description | Location |
|-----------|-------------|----------|
| **memory_transaction** | Transaction class with randomization | `src/agent/` |
| **memory_sequencer** | UVM sequencer for stimulus generation | `src/agent/` |
| **memory_driver** | UVM driver for DUT interface driving | `src/agent/` |
| **memory_monitor** | UVM monitor for protocol checking | `src/agent/` |
| **memory_agent** | UVM agent containing seq/drv/mon | `src/agent/` |
| **memory_env** | Top-level UVM environment | `src/env/` |
| **memory_scoreboard** | Checking component for verification | `src/env/` |

### RAL Components 🆕

| Component | Description | Purpose |
|-----------|-------------|---------|
| **memory_ral_model** | Register model definition | Memory register abstraction |
| **memory_reg_adapter** | Bus protocol adapter | RAL to bus conversion |
| **memory_reg_predictor** | Register predictor | Register value tracking |

### Test Library

| Test Class | Description | Coverage Target |
|------------|-------------|-----------------|
| **memory_base_test** | Base test with common setup | Environment validation |
| **memory_basic_test** | Basic read/write operations | Basic functionality |
| **memory_random_test** | Randomized memory operations | Corner cases |

### Sequence Library

| Sequence | Description | Usage |
|----------|-------------|-------|
| **memory_base_sequence** | Base sequence class | Sequence inheritance |
| **memory_write_sequence** | Memory write operations | Write testing |
| **memory_read_sequence** | Memory read operations | Read testing |
| **memory_random_sequence** | Random memory access | Stress testing |

## 🚀 Getting Started

### Prerequisites

- **UVM Library**: SystemVerilog simulator with UVM support
- **Simulator**: ModelSim/Questa, VCS, Xcelium, or Vivado Simulator
- **SystemVerilog**: IEEE 1800-2012 or later

### Quick Setup

1. **Clone the repository:**
   ```powershell
   git clone <repository-url>
   cd dual-port_memory_uvm
   ```

2. **Setup project structure:**
   ```powershell
   # Run project setup (if not already done)
   .\scripts\setup\setup_project.ps1
   .\scripts\setup\create_files.ps1
   ```

3. **Compile and run:**
   ```powershell
   # Using ModelSim/Questa
   cd sim
   do ..\scripts\compile.do
   do ..\scripts\run_sim.do
   ```

### Running Tests

```bash
# Basic test
vsim -do "run -all" +UVM_TESTNAME=memory_basic_test memory_tb_top

# Random test with verbosity
vsim -do "run -all" +UVM_TESTNAME=memory_random_test +UVM_VERBOSITY=UVM_HIGH memory_tb_top

# With RAL testing
vsim -do "run -all" +UVM_TESTNAME=memory_ral_test memory_tb_top
```

## 🎛️ Configuration

### UVM Configuration

Configure your test environment via `memory_config`:

```systemverilog
// Example configuration
memory_config cfg = memory_config::type_id::create("cfg");
cfg.has_scoreboard = 1;
cfg.has_coverage = 1;
cfg.has_ral = 1;  // Enable RAL
cfg.num_transactions = 100;
uvm_config_db#(memory_config)::set(this, "*", "config", cfg);
```

### Test Parameters

Set test parameters using UVM command line:

```bash
+UVM_TESTNAME=memory_basic_test    # Test selection
+num_transactions=1000             # Transaction count
+coverage_enable=1                 # Enable coverage
+ral_enable=1                      # Enable RAL features
```

## 🔧 UVM Features

### 1. Register Abstraction Layer (RAL)

```systemverilog
// RAL register definition example
class memory_reg extends uvm_reg;
    uvm_reg_field data;
    
    function new(string name = "memory_reg");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
    
    virtual function void build();
        data = uvm_reg_field::type_id::create("data");
        data.configure(this, 32, 0, "RW", 0, 32'h0, 1, 1, 1);
    endfunction
endclass
```

### 2. Transaction Class

```systemverilog
class memory_transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit        we;
    rand bit [1:0]  port_select;
    
    constraint valid_addr_c { addr inside {[0:1023]}; }
    constraint port_c { port_select inside {[0:1]}; }
endclass
```

### 3. Functional Coverage

```systemverilog
covergroup memory_cg;
    address_cp: coverpoint addr {
        bins low    = {[0:255]};
        bins mid    = {[256:767]};
        bins high   = {[768:1023]};
    }
    
    operation_cp: coverpoint we {
        bins read  = {0};
        bins write = {1};
    }
    
    cross_addr_op: cross address_cp, operation_cp;
endgroup
```

## 📊 Verification Strategy

### Coverage Goals

- **Functional Coverage**: 95%+ of defined coverpoints
- **Code Coverage**: 100% line/branch coverage  
- **Cross Coverage**: Address/operation combinations
- **RAL Coverage**: Register access patterns

### Verification Features

- ✅ **Transaction-Level Modeling**: Object-oriented stimulus
- ✅ **Register Abstraction**: RAL integration
- ✅ **Protocol Checking**: Monitor-based verification
- ✅ **Functional Coverage**: Comprehensive coverage collection
- ✅ **Scoreboard Checking**: Automatic result verification
- ✅ **Subscriber Analysis**: Transaction flow analysis

## 🧪 Test Plan

### Implemented Features

| Feature | Status | Description |
|---------|--------|-------------|
| **Basic UVM Structure** | ✅ | Complete UVM testbench hierarchy |
| **RAL Integration** | ✅ | Register model with predictor/adapter |
| **Transaction Classes** | ✅ | Randomized transaction generation |
| **Agent Components** | ✅ | Driver, monitor, sequencer |
| **Environment Setup** | ✅ | Scoreboard and configuration |
| **Coverage Collection** | ✅ | Functional coverage framework |

### Planned Tests

| Test Category | Description | Priority |
|---------------|-------------|----------|
| **Basic Operations** | Read/write single port | High |
| **Dual Port Access** | Concurrent port operations | High |
| **Address Coverage** | Full address space testing | Medium |
| **RAL Tests** | Register model validation | High |
| **Error Scenarios** | Protocol violation testing | Medium |
| **Performance** | Bandwidth and latency testing | Low |

## 🔧 Advanced UVM Features

### Subscriber Pattern

The subscriber component analyzes transaction flow:

```systemverilog
class memory_subscriber extends uvm_subscriber#(memory_transaction);
    // Analysis and reporting functionality
endclass
```

### RAL Predictor

Automatic register tracking:

```systemverilog
class memory_reg_predictor extends uvm_reg_predictor#(memory_transaction);
    // Automatic register value prediction
endclass
```

### Configuration Object

Centralized configuration management:

```systemverilog
class memory_config extends uvm_object;
    bit has_scoreboard = 1;
    bit has_coverage = 1;
    bit has_ral = 1;
    int num_transactions = 100;
endclass
```

## 🚨 Best Practices

### UVM Coding Guidelines

1. **Use factory pattern** for all UVM components
2. **Implement proper phasing** in all components
3. **Use configuration objects** for environment setup
4. **Enable comprehensive logging** with appropriate verbosity
5. **Implement proper error handling** and recovery

### RAL Best Practices

1. **Model all accessible registers** in RAL
2. **Use front-door access** for functional testing
3. **Implement proper adapters** for bus protocols
4. **Enable register prediction** for automatic checking

## 🤝 Contributing

### Adding New Components

1. **Create component files** in appropriate directories
2. **Follow UVM naming conventions**
3. **Add to package file** for compilation
4. **Update test library** if needed
5. **Document new features** in README

### Test Development

1. **Extend base test class** for new tests
2. **Create specific sequences** for test scenarios
3. **Add coverage points** for new features
4. **Update test plan** documentation

## 📝 Documentation

### Generated Documentation

- **Coverage Reports**: Generated after simulation
- **UVM Reports**: Detailed verification reports
- **RAL Documentation**: Register model documentation

### Reference Documentation

- [UVM 1.2 User Guide](https://www.accellera.org/images/downloads/standards/uvm/uvm_users_guide_1.2.pdf)
- [SystemVerilog LRM](https://ieeexplore.ieee.org/document/8299595)
- [RAL User Guide](https://verificationacademy.com/verification-methodology-manual/register-layer)

## 📞 Support & Resources

### Learning Resources

- **UVM Cookbook**: Comprehensive UVM examples
- **Verification Academy**: Online UVM training
- **DVCon Papers**: Industry best practices
- **GitHub Examples**: Open-source UVM projects

### Simulation Tools

- **Mentor Graphics**: ModelSim/Questa
- **Synopsys**: VCS/DVE
- **Cadence**: Xcelium/SimVision
- **Xilinx**: Vivado Simulator

---

**Project Status**: Active Development | **UVM Version**: 1.2 | **SystemVerilog**: IEEE 1800-2012

This UVM testbench provides a complete verification environment for dual-port memory with industry-standard methodology and advanced features including RAL integration.