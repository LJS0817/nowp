<div align="center">
  
# 🕒 Desk Clock & NowPlaying

**탁상시계와 실시간 음악 재생 컨트롤(YouTube Music)을 결합한 Flutter 유틸리티 앱**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com/)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com/)

</div>

---

## 📌 Project Overview
**NowPlaying**은 스마트폰을 탁상시계로 활용함과 동시에, 현재 백그라운드에서 재생 중인 음악(YouTube Music) 정보를 실시간으로 띄워주고 컨트롤할 수 있는 앱입니다.
외부 라이브러리에 의존하지 않고 **Android Native(Java)와 Flutter 간의 통신(MethodChannel / EventChannel)**을 직접 구현하여, 스마트폰의 알림(Notification) 데이터를 파싱하는 구조를 성공적으로 구축했습니다.

### 🔗 Links
- **개발 블로그 포스팅 (Tistory):** [Notification Listener 및 Native 통신 구현 과정](https://lifetostring.tistory.com/21)

---

## 📅 Development Period
**2024. 12. 15 ~ 2024. 12. 20**

---

## 🛠 Tech Stack
- **Framework:** Flutter
- **Native Platform:** Android (Java)
- **State Management:** Provider
- **Native Communication:** `MethodChannel`, `EventChannel`
- **UI & Features:** `flutter_animate`, `flutter_svg`, `wakelock_plus`

---

## ✨ Key Features
- **실시간 미디어 연동:** YouTube Music 등 미디어 플레이어의 알림을 감지하여 앨범 커버, 곡명, 아티스트 정보를 실시간으로 화면에 렌더링합니다.
- **미디어 컨트롤러 내장:** 앱 내에서 직접 이전곡, 재생/일시정지, 다음곡 버튼을 조작하여 백그라운드 음악을 제어할 수 있습니다.
- **탁상시계 모드:** `wakelock_plus`를 적용하여 화면 꺼짐 없이 항상 시간을 확인할 수 있는 스탠드 모드 기능을 제공합니다.
- **Native 통신 최적화:** 기성 패키지를 사용하지 않고 Java 코드를 직접 작성하여 `NotificationListenerService` 기반의 커스텀 백그라운드 브릿지를 개발했습니다.

---

## 🔥 Challenge & Solution (Troubleshooting)

### 🚨 Android Notification 데이터 파싱 및 백그라운드 스트리밍
- **Problem:** 
  AI 도구나 기존 패키지의 도움 없이 오롯이 혼자 Native 통신을 구현하다 보니, 안드로이드 시스템의 무수히 많은 Notification(알림) 데이터 더미 속에서 **음악 재생에 필요한 핵심 메타데이터(곡명, 아티스트, 앨범 아트)만 정확하게 식별하고 추출**해 내는 과정이 매우 까다로웠습니다. 

- **Solution:** 
  Android 공식 문서와 개발 커뮤니티(StackOverflow 등)를 끈질기게 탐구하며 `NotificationListenerService`의 메커니즘을 파악했습니다. Media Session에서 발생한 알림인지 판별하는 로직을 Java 단에 구현하고, Bundle에서 필요한 데이터만 선별적으로 추출하여 **`EventChannel` 스트림을 통해 Flutter UI로 실시간 전송(Streaming)**하는 매우 안정적인 브릿지 로직을 완성했습니다.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Version)
- Android 디바이스 (Notification Listener 권한 허용 필수)

### Installation
1. Repository를 클론합니다.
```bash
git clone https://github.com/LJS0817/nowp.git
```
2. 패키지를 다운로드합니다.
```bash
flutter pub get
```
3. 앱을 실행하고, 안드로이드 설정에서 앱의 **알림 접근 허용(Notification Access)** 권한을 켭니다.
```bash
flutter run
```

<br>

<div align="center">
  <i>Developed by <b>LJS0817</b></i>
</div>
