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

### 1. 네이티브 알림 필터링 & 앨범 아트 바이트 전송 최적화
- **Problem:** 
  Android `NotificationListenerService`에서 유튜브 뮤직의 재생 알림이 갱신될 때마다 대용량 앨범 아트 비트맵 바이트 배열이 `EventChannel` 스트림을 통해 Flutter로 지속 전송되었습니다. 이로 인해 동일 곡 내 재생 진행 바 업데이트만으로도 불필요한 직렬화 오버헤드와 GC(가비지 컬렉터) 스파이크가 발생했습니다.
- **Solution:** 
  Java 네이티브 단에서 `NotificationObject` 모델을 구축하고, 이전 프레임과 현재 프레임의 앨범 아트 바이트를 `Arrays.equals()`로 비교하여 이미지가 실제로 변경된 경우에만 플러터로 바이트 스트림을 전송하도록 필터링했습니다. 또한 추출이 끝난 비트맵은 `bitmap.recycle()`을 즉시 호출하여 네이티브 메모리 누수를 원천 차단했습니다.

---

### 2. 1초 주기 시계 갱신과 무거운 애니메이션 UI 리빌드 분리
- **Problem:** 
  스탠드 탁상시계 모드에서 1초마다 시계 텍스트가 갱신될 때, 미디어 컨트롤러의 `flutter_animate` 앨범 아트 회전 애니메이션 및 SVG 테마 위젯까지 전체 트리가 함께 재빌드되면서 프레임 드랍이 발생했습니다.
- **Solution:** 
  상태 관리 범위를 관심사별로 분리했습니다. 1초 주기 타이머는 `TimerProvider`로 격리하고, 미디어 메타데이터는 `AudioProvider`, 앱 전역 테마는 `ThemeProvider`로 3분할했습니다. 위젯 트리 최하단에서 `Consumer`를 사용하여 각 프로바이더의 변경 사항만 국소적으로 구독하도록 리팩터링하여, 1초마다 화면 전체가 리빌드되는 낭비를 제거하고 부드러운 60FPS를 유지했습니다.

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
