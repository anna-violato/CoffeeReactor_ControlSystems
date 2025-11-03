# Coffee Reactor — Control Systems (PID & MPC)

Control design and simulation for a **continuous bioreactor** with two inflows (coffee and water) and one output (coffee concentration).  
The project includes:
- PID control
- Nonlinear model derivation and linearization
- MPC on linear and nonlinear models
- MPC with integral (velocity-form) action and look-ahead

---

## 🎯 Objectives
- Settling time ≤ 10 minutes  
- Overshoot ≤ 5%  
- Digital sampling time: 10 s  
- Inflow constraints: 0 ≤ u1, u2 ≤ 66 ml/min  

---

## 📁 Structure
```
CoffeeReactor_ControlSystems/
├─ README.md
├─ LICENSE
├─ .gitignore
├─ data/
│  └─ params.json
├─ simulink/
│  └─ (see models list below)
├─ src/
│  ├─ task1_pid/
│  ├─ task2_model/
│  ├─ task3_mpc_linear/
│  ├─ task3_mpc_nonlinear/
│  └─ task4_mpc_integral/
├─ figures/
└─ report/
   └─ (project PDF files)
```

---

## 🧠 Simulink Models
{models_section}

---

## ⚙️ How to Run
1. Open MATLAB in the project root:
   ```matlab
   addpath(genpath('src'));
   ```
2. Open any Simulink model in `/simulink/` and run the simulation.
3. When MATLAB `.m` scripts are available, run the appropriate task script, e.g.:
   ```matlab
   cd('src/task1_pid'); run_task1
   ```

---

## 📈 Expected Results (high level)
- **PID:** good tracking for increasing references, limited for decreasing (no dilution).  
- **MPC (linear):** offset-free tracking; coffee and water inflows act as expected.  
- **MPC (nonlinear):** offset can appear with constant disturbance.  
- **MPC (integral):** offset removed, overshoot reduced with reference look-ahead.

---

## 🧩 Tools Required
- MATLAB (R2021b or later)
- Control System Toolbox
- Optimization Toolbox
- Model Predictive Control Toolbox
- Simulink


