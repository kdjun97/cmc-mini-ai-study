# DesignSystem Phase 0~2 구현 요약

## 프로젝트 기본 정보

- **앱 이름:** CMC-Mini
- **플랫폼:** iOS (SwiftUI), iOS 26.2+
- **Xcode 프로젝트 경로:** `cmc-mini-ai-study/CMC-Mini/CMC-Mini.xcodeproj`
- **소스 루트:** `cmc-mini-ai-study/CMC-Mini/CMC-Mini/`
- **파일 관리 방식:** `PBXFileSystemSynchronizedRootGroup` → 폴더에 파일 추가하면 Xcode가 자동 인식, pbxproj 수정 불필요
- **Figma 디자인:** https://www.figma.com/design/XqqPeEoWsD5tBmil5Z7a50/mini_hack
  - 전체 노드: `0:1`
  - 첫 번째 개발 페이지: `7:2` (라이브러리 - 캘린더 뷰)

---

## 구현된 파일 목록

```
CMC-Mini/CMC-Mini/
├── ContentView.swift                  ← 업데이트됨 (NavBar + TabBar 배치)
└── DesignSystem/
    ├── Foundation/
    │   ├── CMCColor.swift             ← Phase 0
    │   ├── CMCTypography.swift        ← Phase 0
    │   └── CMCSpacing.swift           ← Phase 0
    └── Components/
        └── Navigation/
            ├── CMCTabBar.swift        ← Phase 1
            └── CMCNavigationBar.swift ← Phase 2
```

---

## Phase 0 — Foundation

### CMCColor.swift
- `Color(hex:)` 이니셜라이저 추가
- `Color.CMC` 네임스페이스로 토큰 정의
  - `.background` #FFFFFF, `.surface` #F5F5F5
  - `.textPrimary` #000000, `.textSecondary` #8E8E93
  - `.separator` #E5E5EA
  - `.tabActive` #000000, `.tabInactive` #AEAEB2
  - `.chipSelected` #000000, `.chipUnselected` #FFFFFF
  - `.addButton` #000000

### CMCTypography.swift
- `Font.CMC` 네임스페이스로 토큰 정의
  - `.navigationTitle` size 22 bold
  - `.tabLabel` size 10 medium
  - `.segmentTab` size 14 medium
  - `.filterChip` size 13 regular
  - `.calendarWeekday` size 12 medium
  - `.calendarDay` size 12 regular
  - `.body` size 15 regular, `.caption` size 12 regular

### CMCSpacing.swift
- `CMCSpacing` enum으로 간격 상수 정의
  - `xs` 4, `sm` 8, `md` 12, `lg` 16, `xl` 20, `xxl` 24

---

## Phase 1 — CMCTabBar

**파일:** `DesignSystem/Components/Navigation/CMCTabBar.swift`

- `CMCTab` enum: `.social` `.search` `.mySpace` `.profile` (4개, + 버튼은 `onAddTap` 클로저)
- `CMCTabBar(selectedTab: Binding<CMCTab>, onAddTap: () -> Void)`
- **레이아웃:** `[소셜 캡슐]` — `[+ 원형]` — `[내공간 캡슐]` 3분할
  - 좌측 캡슐: `person.2`(`.social`) + `magnifyingglass`(`.search`) 각각 독립 탭, "소셜" 레이블
  - 중앙: 검정 원형(52pt) + 흰 plus, `frame(width: 80)` 고정, `offset(y: -4)`
  - 우측 캡슐: `books.vertical`(`.mySpace`) + 검정 Circle 26pt(`.profile`) 각각 독립 탭, "내 공간" 레이블
- **캡슐 배경:** `Color.white` + 연한 shadow
- **선택된 아이콘:** 해당 아이콘 뒤에 `Color.CMC.surface`(회색) `RoundedRectangle(cornerRadius: 8)` 40×40pt 배경
- **미선택 아이콘:** 배경 `Color.clear`
- Figma 참조 노드: `7:4`

> **수정 이력:**
> 1. `ForEach` 단순 나열 → 3분할 HStack (+ 버튼 중앙 정렬 보장)
> 2. 개별 탭 아이콘 → 좌우 캡슐 그룹으로 변경 (Figma node 7:4 기준)
> 3. 캡슐 내 아이콘 각각 독립 탭으로 분리, 선택 시 회색 배경 표시, 캡슐 배경 white 고정

---

## Phase 2 — CMCNavigationBar

**파일:** `DesignSystem/Components/Navigation/CMCNavigationBar.swift`

제네릭 기반 범용 구조로 재설계 — Figma node `7:23` 전체 케이스 대응.

**타입:** `CMCNavigationBar<Leading: View, Trailing: View>`

**지원 케이스 (Figma node 7:23 기준):**
1. **타이틀(좌) + trailing 버튼** — 라이브러리 + 검색 아이콘
2. **leading + 타이틀(중앙) + trailing** — X 버튼 + 가운데 타이틀 + 편집 버튼
3. **leading + trailing(2개)** — 좌측 버튼 + 우측 2개 버튼 (HStack으로 래핑)

**Initializer 오버로드:**
- `init(title:, centerTitle:, leading:, trailing:)` — 둘 다 Custom View
- `init(title:, centerTitle:, trailing:)` — Leading == EmptyView
- `init(title:, centerTitle:, leading:)` — Trailing == EmptyView
- `init(title:, centerTitle:)` — 버튼 없음

**핵심 특성:**
- `leading` / `trailing` 은 `@ViewBuilder` 클로저로 임의 View 전달
- 미전달 시 `EmptyView()` 기본값 (nil-able 동등)
- `centerTitle: true` 시 ZStack으로 타이틀 진짜 중앙 정렬
- trailing 2개는 호출부에서 `HStack`으로 래핑하여 전달
- 모두 Foundation 토큰 사용

---

## TCA 아키텍처 (추가됨)

**SPM 패키지:** `swift-composable-architecture` v1.0.0+ (upToNextMajorVersion)

**파일 구조:**
```
CMC-Mini/
├── App/
│   ├── AppFeature.swift     ← Root Reducer (@Reducer, BindingReducer + 4개 Scope)
│   └── RootView.swift       ← Root View (탭 전환 + CMCTabBar)
└── Features/
    ├── Social/
    │   ├── SocialFeature.swift
    │   └── SocialView.swift
    ├── Search/
    │   ├── SearchFeature.swift
    │   └── SearchView.swift
    ├── MySpace/
    │   ├── MySpaceFeature.swift
    │   └── MySpaceView.swift   ← 라이브러리 NavBar + ScrollTabView
    └── Profile/
        ├── ProfileFeature.swift
        └── ProfileView.swift
```

**아키텍처 패턴:**
- `AppFeature`: `@ObservableState`, `BindableAction`, 4개 자식 Reducer를 `Scope`로 연결
- `selectedTab: CMCTab`은 `BindingReducer()`로 관리 → `$store.selectedTab` 바인딩으로 `CMCTabBar`에 전달
- 각 탭은 독립 `@Reducer` + `StoreOf<XxxFeature>` scope로 분리
- `CMC_MiniApp`: `Store(initialState: AppFeature.State()) { AppFeature() }` → `RootView`
- `ContentView.swift`: 역할 종료, 주석만 남김

---

## 계획 파일 위치

`.omc/plans/` 하위에 페이지별 계획 파일 존재:
- `00-master-plan.md` — 전체 DesignSystem 구조 및 개발 순서
- `01-foundation.md` — Phase 0 스펙
- `02-tabbar.md` — Phase 1 스펙
- `03-navigation-bar.md` — Phase 2 스펙
- `04-controls.md` — Phase 3 (CMCSegmentedControl + CMCFilterChip) 스펙
- `05-library-calendar.md` — Phase 4 (라이브러리 캘린더 페이지) 스펙

---

## 다음 작업 (Phase 3)

`DesignSystem/Components/Controls/` 하위에 구현 예정:
- `CMCSegmentedControl.swift` — 가로 스크롤 탭 (시리즈트·캘린더·평점·타임라인·갤러리)
- `CMCFilterChip.swift` — 선택/미선택 칩 (점점▼·날짜▼·전체 6·공원/자연·책)

구현 후 Phase 4에서 `LibraryCalendarView`로 전체 조합 예정.
