# SystemVerilog_RISC-V_Single_Cycle_CPU_Project
미니프로젝트 : SystemVerilog를 이용하여 RV32I 명령어 기반 Single Cycle CPU 설계 및 검증

PPT link : ![PPT 바로보기]([https://www.canva.com/design/DAG0UOiyFqQ/s3u1rJ_PSrFhDyJslErOAA/viewutm_content=DAG0UOiyFqQ&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=h1cc924753e](https://www.canva.com/design/DAG0UOiyFqQ/s3u1rJ_PSrFhDyJslErOAA/view?utm_content=DAG0UOiyFqQ&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=h1cc924753e))


## 🔹프로젝트 개요

---
현대 CPU 설계의 근간이 되는 RISC Architecture에 대한 깊이 있는 이해를 목표로 프로젝트를 시작했습니다. 특히, License 비용 없이 자유로운 설계와 확장이 가능한 오픈소스 ISA인 RISC-V를 선택하여 CPU의 핵심 동작 원리를 구현하며 컴퓨터 구조의 이론적 지식을 실제 하드웨어 설계로 연결하는 경험을 쌓고자 했습니다. 

본 프로젝트는 Harvard Structure의 RV32I기반의 Single Cycle CPU를 SysytemVerilog를 이용해서  통합 설계하고 시뮬레이션을 통해 총 6가지의 명령어 타입을 검증하는 것으로 목표를 했습니다.


## 🔹프로젝트 목표

---

**What?** 🎯

- **32-bit Single Cycle RISC-V CPU Core 설계 : SystemVerilog를 이용하여 CPU 설계**
- **Base Instruction Set 구현 :** RISC-V의 기본 정수 명령어 세트(RV32I)의 핵심인 R, I, S, B, U, J-Type 6가지 명령어 포맷 구현
- **시뮬레이션을 통한 기능 검증** : 작성된 각 명령어 타입이 의도대로 동작하는지 기능 검증
- **컴퓨터 핵심 구조 구현** : Instruction Memory와 Data Memory가 분리된 Harvard Structure 구현 및 DataPath와 Control Unit을 설계하며 데이터 흐름과 제어 신호를 이해
### 🔹System Architecture

---

🔸System Level Block Diagram

![hard](https://github.com/seonghunppark/SystemVerilog_RISC-V_Single_Cycle_CPU_Project/blob/f1bb16b9237d79be8ba893a36aacb0ad9e15a030/Total%20Block%20Diagram.png)
##
## 🔹주요 성과 및 배운 점 (Outcome & Lessons Learned)

---

1.
