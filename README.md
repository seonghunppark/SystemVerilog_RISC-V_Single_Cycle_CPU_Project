# [SystemVerilog] RISC-V Single-Cycle CPU Design Project(1인 Project)
미니프로젝트 : SystemVerilog를 이용하여 RV32I 명령어 기반 Single Cycle CPU 설계 및 검증

PPT link : [PPT 바로보기](https://www.canva.com/design/DAG0UOiyFqQ/s3u1rJ_PSrFhDyJslErOAA/view?utm_content=DAG0UOiyFqQ&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=h1cc924753e)


### 🔹프로젝트 개요
---
현대 CPU 설계의 근간이 되는 RISC Architecture에 대한 깊이 있는 이해를 목표로 프로젝트를 시작했습니다. 특히, License 비용 없이 자유로운 설계와 확장이 가능한 오픈소스 ISA인 RISC-V를 선택하여 CPU의 핵심 동작 원리를 구현하며 컴퓨터 구조의 이론적 지식을 실제 하드웨어 설계로 연결하는 경험을 쌓고자 했습니다. 

본 프로젝트는 Harvard Structure의 RV32I기반의 Single Cycle CPU를 SysytemVerilog를 이용해서  통합 설계하고 시뮬레이션을 통해 총 6가지의 명령어 타입을 검증하는 것으로 목표를 했습니다.


### 🔹프로젝트 목표
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

### 🔹Trouble Shooting 및 배운 점
---

**1. Data Memory 용량 설정**
- 문제상황 : 84번째 명령어에서 ret(JALR)이 되지않고 프로그램 종료 문제
- 문제원인 : Stack Pointer 초기값을 400으로 설정했지만 메모리 공간 설계는 64(Stack)까지 구현했기 때문에 오버플로우 문제
- 해결방안 : 해당 Stack까지 메모리 공간 설계

**2. RISC-V 설계 의도에 대한 이해**
- 의문점 1 : I-Type에 Substract가 없는 이유가 무엇일까?
- 의문점 2 : U-Type에서 AUIPC의 역할이 무엇일까?

- 결론 : RISC-V의 설계의도는 Compiler와 Linker를 통해서 최적화를 하는 것이다.

- 설명 : I-Type에 Sub가 없고 R-Type에는 Sub가 있는 이유는 Compile 시점에 아는 값과 모르는 값의 차이가 있기때문이다. I-type의 경우에는 Imm값을 compile시점에 알고 있기 때문에 음수값을 Add하면 되는데 R-Type은 모르기 때문이다. 

- 또한 U-Type에서 AUIPC는 Instruction Memory PC값과 외부 램의 주소 Imm값을 더해서 내가 원하는 Data가 있는 외부 램의 주소를 나타낼 수 있는지 궁금했다. 이는 결국 Linker가 여러 Object 파일과 Library를 합쳐 하나의 실행파일을 만들이 이를 바탕으로 프로그램 전체에 대한 통합 가상 주소 공간을 설계를 하기 때문에 상대 주소를 알 수 있게 되는 것이다. 

- 이를 통해서 단순히 하드웨어의 동작뿐만 아니라 소프트웨어와 하드웨어가 어떻게 유기적으로 동작하는 지 이해할 수 있었다. 










