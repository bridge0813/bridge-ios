## 🙌 소개
- 브릿지는 개발자, 디자이너, 기획자들을 위한 사이드 프로젝트 모집 플랫폼입니다.
- 브릿지를 통해 저희가 사이드 프로젝트를 찾거나 모집하는 과정에서 겪었던 불편함을 해결하고자 했습니다.

</br>

## ✨ 주요 기능
|프로젝트 확인|프로젝트 상세|프로젝트 관리|
|---|---|---|
|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/5301881a-7803-4050-9767-c82e874b98ba">|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/c8918e94-32c0-4b5a-b3c1-056ef9f7d666">|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/92c0b1ba-1390-4f9c-b479-31a891e871f1">

|채팅|채팅방|마이페이지|
|---|---|---|
|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/733551b2-aca1-48e8-ae18-ed28ee073099">|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/8733967d-ddaa-4841-a21d-2c0d40b863cb">|<img height ="500" src="https://github.com/bridge0813/bridge-ios/assets/65343417/bb31a2a3-7ba7-47e3-8937-8aa1ae9437eb">|

</br>

## 🛠️ 기술
- 프레임워크 및 라이브러리: UIKit, RxSwift, FlexLayout, Starscream, SPM, SwiftLint
- 아키텍처: 클린 아키텍처
- 디자인패턴: MVVM-C

</br>

### 클린 아키텍처
<img alt="Clean-architecture" src="https://github.com/bridge0813/bridge-ios/assets/65343417/716863c5-c30d-4785-b7eb-5706775be58d">

#### 사용 이유
- 디자인과 개발을 병렬적으로 진행하기 위해
- MVVM 구조에서 뷰 모델이 비대해지는 것을 피하기 위해
- 유지보수성 및 확장성 높은 소프트웨어 구조를 위해

#### 사용 결과
- 프로토콜을 사용한 의존성 주입을 통해 계층과 관심사를 분리함으로써 UI와 독립적인 코드 작성 가능
- 각 계층이 명확한 책임을 갖게 됨으로써 코드의 유지보수성과 더불어 개발 생산성 향상
- 테스트가 용이해져 mock 리포지토리를 통한 테스트 가능

</br>

### 코디네이터
<img alt="coordinator" src="https://github.com/bridge0813/bridge-ios/assets/65343417/8d1e14e4-6cd3-4054-8278-af6876e1619e">

#### 사용 이유
- 코드 기반의 UI로 작업하다 보니 내비게이션 계층과 플로우를 파악하기 어려워 도입
- 뷰 컨트롤러가 뷰를 보여주는 것 이외에도 내비게이션 및 의존성 주입의 책임을 가짐

#### 사용 결과
- 내비게이션 및 의존성 주입의 책임을 뷰 컨트롤러로부터 분리함으로써 코드의 가독성 및 유지보수성 향상 (SRP 준수)
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

## 🤝 협업
### 🎙️ 의사소통
- 디스코드를 사용해 화상회의 및 의사소통 플랫폼 일원화
- 파트별 채널 분리를 통해 불필요한 의사소통 비용 제거
- 깃허브 웹훅을 사용하여 개발 상황 실시간 공유
<img src="https://github.com/bridge0813/bridge-ios/assets/65343417/f8e49ee1-921c-4767-a6a6-cf3afba68a24">

</br>

### 🗣️ 코드리뷰
- Pn 룰 기반
- 클린 아키텍처 및 SOLID 원칙에 입각한 리뷰
- 리뷰하지 않으면 merge 불가
<img src="https://github.com/bridge0813/bridge-ios/assets/65343417/520d3a0a-bdf1-47b4-b581-1862f3950b40">

</br>

## 🔗 링크
- [스타일 가이드](https://hoyunjung.notion.site/Swift-Style-Guide-e5aba08128de4571a006d84bf3716f2f?pvs=4)
- [커밋, PR, 이슈 컨벤션](https://hoyunjung.notion.site/GitHub-Conventions-bb47b76884c24b21847181c76d562c7d?pvs=4)
- [브랜치 관리 전략](https://hoyunjung.notion.site/3fb05482da58416ab8984ff8420a67d8?pvs=4)

</br>

### 기술 블로그
- [클린 아키텍처](https://velog.io/@stemmmm/클린-아키텍처-도입기)
- [채팅](https://velog.io/@stemmmm/웹소켓과-STOMP를-사용한-채팅-개발#어려웠던-점)
