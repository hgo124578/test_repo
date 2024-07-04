# アーキ
```mermaid
flowchart LR

subgraph L Jenkins
  JOB(Calclator)
end

subgraph Google sheet
  sheet1[(TC measure\n list)]
  sheet2[(EP list)]
  sheet3[(T list)]
end

subgraph Github
  LIM[(LIM)]
end

subgraph Data
  DB1[(LTele)]
end

LIM -.-> JOB
DB1 --> JOB
JOB --> sheet3
sheet1 --> JOB
sheet2 --> JOB

classDef GS fill:#46d,color:#fff,stroke:#fff
class sheet1,sheet2,sheet3 GS

classDef DO fill:#493,color:#fff,stroke:#fff
class DB1 DO

classDef CP fill:#e83,color:#fff,stroke:none
class JOB CP

classDef GHR fill:#aaa,color:#fff,stroke:#fff
class LIM GHR

```
# Specification
以下の仕様のjenkins job. codeはgitに持つ。

Input
- build parametor
- Google sheet
    - TC
    - EP
- Data

Output
- Google sheet
    - T list
- Build artifact


# Data schema
## TC
- app name
- TCname
- TCID
- Priority
- Conditions

## EP
- app name
- Conditions
