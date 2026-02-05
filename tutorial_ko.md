# 📦 CodeContextPacker(CCP) 단계별 사용 가이드

## Step 1. 메인 화면 (Initial Dashboard)
<img width="704" height="562" alt="1_init" src="https://github.com/user-attachments/assets/49bc4e44-750f-4e1c-b468-103592cefafe" />

앱을 실행했을 때의 기본 상태입니다. 프로젝트를 로드하기 전의 깨끗한 대시보드를 확인하실 수 있습니다.


## Step 2. 프로젝트 오픈 아이콘 (Open Project Icon)
<img width="704" height="562" alt="2_pointOpenFolderIcon" src="https://github.com/user-attachments/assets/5821cf87-10e5-4f8d-ae95-bc4402b93335" />

상단 혹은 사이드바의 폴더 모양 아이콘을 클릭하여 프로젝트 로드 프로세스를 시작합니다.


## Step 3. 프로젝트 루트 폴더 선택 (Select Project Root)
<img width="787" height="560" alt="3_chooseProjectRoot" src="https://github.com/user-attachments/assets/751419a7-9bc1-4155-85e4-f45e04b9d1b2" />

AI에게 전달할 프로젝트의 최상위 폴더(Xcode, React, Spring 등)를 선택해 주세요.


## Step 4. 프로젝트 로드 완료 (Project Loaded View)
<img width="704" height="562" alt="4_loadProject" src="https://github.com/user-attachments/assets/8513ffbb-6a60-4e0c-800b-205c1217d007" />

프로젝트가 성공적으로 로드된 화면입니다. 왼쪽 사이드바에서는 Finder와 같은 파일 구조를, 오른쪽 메인 화면에서는 선택된 파일들이 하나의 텍스트로 합쳐진 결과물을 볼 수 있습니다.


## Step 5. 패킹할 파일 선별 (Selective File Packing)
<img width="704" height="562" alt="5_selectTargetFiles" src="https://github.com/user-attachments/assets/ce36bc07-f006-4f31-89d6-f35963ebc653" />

모든 파일을 선택할 필요는 없습니다. 체크박스를 통해 AI에게 전달할 핵심 소스 코드만 선택하세요. 불필요한 라이브러리나 설정 파일은 제외하여 토큰을 절약할 수 있습니다.


## Step 6. 변경사항 최신화 / 새로고침 (Refresh Changes)
<img width="704" height="562" alt="6_refreshChanges" src="https://github.com/user-attachments/assets/db89c072-09b0-4fec-a862-0089be102bf5" />

Xcode나 VSCode 등 외부 IDE에서 코드를 수정했다면, 새로고침(Refresh) 버튼을 누르세요. 수정된 내용이 즉시 오른쪽 패킹 텍스트에 반영됩니다.


## Step 7. 패킹된 결과물 복사 (Copy Packed Context)
<img width="704" height="562" alt="7_copyButton" src="https://github.com/user-attachments/assets/c395efff-7436-4705-9dda-0c8036279cc9" />

복사(Copy) 아이콘을 클릭하면 패킹된 전체 텍스트가 클립보드에 저장됩니다. 이제 AI 채팅창에 바로 붙여넣어 질문을 시작하세요.


## Tip. 단축키 안내 툴팁 (Keyboard Shortcuts Tooltip)
<img width="704" height="562" alt="8_tooltip" src="https://github.com/user-attachments/assets/f61e87ce-acae-4a47-b86e-e8a58de3c2fa" />

'?' 버튼을 클릭하면 효율적인 작업을 돕는 CCP 전용 단축키 내역을 확인할 수 있습니다.
