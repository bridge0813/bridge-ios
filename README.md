## 🙌 소개
- 브릿지는 개발자, 디자이너, 기획자들을 위한 사이드 프로젝트 모집 플랫폼입니다.
- 저희는 실제로 프로젝트를 모집하거나 구하며 느꼈던 불편함들을 해소하고 싶었기에 이 프로젝트를 시작하게 되었습니다.
- 사용 기술: UIKit, RxSwift, FlexLayout, Starscream, SPM, SwiftLint
</br>

## ✨ 주요 기능
|프로젝트 확인|프로젝트 상세|프로젝트 관리|
|---|---|---|
|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/5301881a-7803-4050-9767-c82e874b98ba">|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/c8918e94-32c0-4b5a-b3c1-056ef9f7d666">|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/92c0b1ba-1390-4f9c-b479-31a891e871f1">

|채팅|채팅방|마이페이지|
|---|---|---|
|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/27926690-f08d-4070-a27c-2e460764e5e3">|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/8733967d-ddaa-4841-a21d-2c0d40b863cb">|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/bb31a2a3-7ba7-47e3-8937-8aa1ae9437eb">|
</br>

## 🛠️ 기술
### 클린 아키텍처
<img alt="Clean-architecture" src="https://github.com/bridge0813/bridge-ios/assets/65343417/716863c5-c30d-4785-b7eb-5706775be58d">

#### 사용 이유
- 디자인과 개발을 병렬적으로 진행하기 위해
- MVVM 구조에서 뷰 모델이 비대해지는 것을 피하기 위해
- 유지보수성 및 확장성 높은 소프트웨어 구조를 위해

#### 사용 결과
- 프로토콜을 사용한 의존성 주입을 통해 계층과 관심사를 분리함으로써 UI에 독립적인 코드 작성 가능
- 각 계층이 명확한 책임을 가지므로 코드의 가독성과 유지보수성이 향상되어 효율적인 협업 가능
- 테스트가 용이해져 mock 리포지토리를 통한 테스트 가능
</br>

### 코디네이터
<img alt="coordinator" src="https://github.com/bridge0813/bridge-ios/assets/65343417/8d1e14e4-6cd3-4054-8278-af6876e1619e">

#### 사용 이유
- 코드 베이스 UI는 스토리보드에 비해 뷰들의 계층과 플로우를 파악하기 어려움
- 뷰 컨트롤러가 뷰를 보여주는 것 이외에도 내비게이션 로직 및 의존성 주입의 책임을 가짐

#### 사용 결과
- 내비게이션 로직 및 의존성 주입의 책임을 뷰 컨트롤러로부터 분리함으로써 코드의 가독성 및 유지보수성 향상 (단일 책임 원칙 준수)
- 인스턴스의 불필요한 중복 생성을 방지함으로써 메모리 사용 효율 증가   
</br>

### RxSwift
#### 사용 이유
- 비동기 네트워킹 및 UI 관련 작업에 대한 쓰레드 관리를 간편하게 하기 위해
- 중첩된 콜백으로 인한 가독성 저하 문제
- 복잡한 유저 인풋을 처리하기 어려움

#### 사용 결과
- Traits나 operator를 활용해 비동기 네트워킹 및 UI 관련 작업에 대한 쓰레드 관리를 간편하게 할 수 있음
- 중첩 콜백 대신 Observable을 사용해 비동기 작업과 반응형 프로그래밍을 간결하고 이해하기 쉬운 방식으로 처리 가능
- Operator를 사용해 복잡한 유저 인풋 및 비동기 이벤트를 효율적으로 처리 가능
</br>

## 👏 소감
### 정호윤
#### 어려웠던점
#### 느낀점
#### 배운점
</br>

### 엄지호
#### 어려웠던점
#### 느낀점
#### 배운점
</br>

## 🤝 협업
- [스타일 가이드](https://hoyunjung.notion.site/Swift-Style-Guide-e5aba08128de4571a006d84bf3716f2f?pvs=4)
- [커밋, PR, 이슈 컨벤션](https://hoyunjung.notion.site/GitHub-Conventions-bb47b76884c24b21847181c76d562c7d?pvs=4)
- [브랜치 관리 전략](https://hoyunjung.notion.site/3fb05482da58416ab8984ff8420a67d8?pvs=4)
- [코드 리뷰](https://hoyunjung.notion.site/e7fb35cf50de454ca4ea6646d7c41095?pvs=4)
</br>

### 🎙️ 의사소통
- 디스코드를 사용해 화상회의 및 의사소통 플랫폼 통일
- 파트별 채널 분리를 통해 불필요한 의사소통 비용 제거
- 깃허브 웹훅을 사용하여 개발 상황 실시간 공유
<img src="https://github.com/bridge0813/bridge-ios/assets/65343417/85d2baa8-0693-431a-8eae-014352cbd75f">
