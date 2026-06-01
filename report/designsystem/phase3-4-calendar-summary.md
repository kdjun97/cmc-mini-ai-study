# DesignSystem Phase 3~4 구현 요약 — FilterChip + 캘린더

## 프로젝트 기본 정보

- **앱 이름:** CMC-Mini (SwiftUI + TCA)
- **Figma 참조:** `7:2` (라이브러리 캘린더 페이지)
- **구현 날짜:** 2026-05-30

---

## 구현 파일 목록

```
CMC-Mini/CMC-Mini/
├── Model/
│   └── ContentItem.swift                          ← 신규 (Phase 4a)
├── DesignSystem/
│   └── Components/
│       ├── Controls/
│       │   └── CMCFilterChip.swift                ← 신규 (Phase 3a)
│       └── Content/
│           ├── CalendarHeaderView.swift            ← 신규 (Phase 4b)
│           ├── CalendarDayCell.swift               ← 신규 (Phase 4c)
│           ├── CMCCalendarView.swift               ← stub → 완전 구현 (Phase 4d)
│           └── CMCScrollTabView.swift              ← onCalendarHeaderAction 파라미터 추가
└── Features/
    └── MySpace/
        ├── MySpaceFeature.swift                   ← CalendarAction 추가
        └── MySpaceView.swift                      ← FilterChip 행 + store 연결
```

---

## Phase 3a — CMCFilterChip

**파일:** `DesignSystem/Components/Controls/CMCFilterChip.swift`

- `CMCFilterChip(title: String, isSelected: Bool, onTap: () -> Void)`
- **선택:** `Color.CMC.chipSelected` (#000) 배경 + 흰 텍스트
- **미선택:** `Color.CMC.chipUnselected` (#FFF) 배경 + 검정 텍스트 + 1pt `Color.CMC.separator` 테두리
- 높이 32pt, `cornerRadius` 16pt (pill), `Font.CMC.filterChip`
- `MySpaceView`에서 `@State private var selectedFilters: Set<String>`으로 다중 선택 관리
- 가로 스크롤 `ScrollView(.horizontal)` 안 `HStack`으로 배치 (NavBar ↔ 세그먼트 탭 사이)

---

## Phase 4a — ContentItem (모델)

**파일:** `Model/ContentItem.swift`

```swift
enum ContentType { case music, book, photo, place }

struct ContentItem: Identifiable {
    let id: UUID
    let date: Date
    let placeholderColor: Color   // 더미 썸네일 Color block
    let type: ContentType

    static func dummySample() -> [Date: [ContentItem]]
    // key: Calendar.current.startOfDay(for:) 기준 Date
}
```

더미 샘플 날짜: 2026.05 기준 1일(1개), 4일(2개), 12일(1개), 15일(1개), 17일(3개), 22일(1개)

---

## Phase 4b — CalendarHeaderView

**파일:** `DesignSystem/Components/Content/CalendarHeaderView.swift`

- `enum CalendarHeaderAction { case aspectRatio, favorite, share, settings }` 정의
- `CalendarHeaderView(@Binding currentDate: Date, onActionTap: (CalendarHeaderAction) -> Void)`

**레이아웃:** `[◀] [2026.05.] [▶] ──── [비율] [★] [↑] [⚙]`

| 영역 | 구현 |
|------|------|
| `◀ ▶` 버튼 | `Calendar.current.date(byAdding: .month, value: ±1)` |
| `2026.05.` 버튼 | `@State isDatePickerPresented` → `.sheet` 로 `DatePicker(.graphical)` 표시 |
| 우측 4개 버튼 | `onActionTap(action)` 호출, 기능 TODO |

- sheet: `presentationDetents([.medium])`, 완료 버튼으로 dismiss
- 높이 44pt, `padding(.horizontal, CMCSpacing.lg)`

---

## Phase 4c — CalendarDayCell

**파일:** `DesignSystem/Components/Content/CalendarDayCell.swift`

- `CalendarDayCell(day: Int, isCurrentMonth: Bool, isToday: Bool, contents: [ContentItem])`
- `aspectRatio(1, contentMode: .fit)` — 정사각형 셀

| 케이스 | 렌더링 |
|--------|--------|
| `contents` 0개 | 날짜 숫자 중앙, `Color.CMC.textPrimary` |
| `contents` 1개 | `placeholderColor` 블록 + 좌상단 흰 날짜 숫자 |
| `contents` 2개+ | 블록 + 우하단 `+N` 검정 원형 뱃지(18pt) |
| 다른 달 날짜 | `Color.CMC.textSecondary`, 썸네일 없음 |
| 오늘 날짜 | 검정 원(22pt) + 흰 텍스트 |

---

## Phase 4d — CMCCalendarView (완전 구현)

**파일:** `DesignSystem/Components/Content/CMCCalendarView.swift`

- `CMCCalendarView(onHeaderAction: (CalendarHeaderAction) -> Void = { _ in })`
- `@State private var currentDate: Date = .now`
- `private let contents: [Date: [ContentItem]] = ContentItem.dummySample()`

**날짜 계산:**
```swift
// 첫 날 요일 offset = Calendar.component(.weekday, from: firstDay) - 1  (0=일, 6=토)
// 이전 달 trailing cells로 앞 공백 채움
// 다음 달 leading cells로 6행 유지 (remainder != 0 처리)
// contents key 조회: Calendar.current.startOfDay(for: date)
```

**그리드:** `LazyVGrid(columns: 7 × GridItem(.flexible(), spacing: 1), spacing: 1)`

---

## TCA 연결

**MySpaceFeature.Action 추가:**
```swift
case calendar(CalendarAction)

enum CalendarAction {
    case aspectRatioTapped  // TODO
    case favoriteTapped     // TODO
    case shareTapped        // TODO
    case settingsTapped     // TODO
}
```

**데이터 흐름:**
```
MySpaceView
  └─ CMCScrollTabView(onCalendarHeaderAction:)
       └─ CMCCalendarView(onHeaderAction:)
            └─ CalendarHeaderView(onActionTap:)
                 └─ onActionTap(.aspectRatio) → store.send(.calendar(.aspectRatioTapped))
```

DesignSystem 컴포넌트는 `MySpaceFeature`를 직접 참조하지 않음. `CalendarHeaderAction` enum으로 분리.

---

## 현재 상태

| 기능 | 상태 |
|------|------|
| CMCFilterChip 렌더링 | ✅ 완료 |
| 필터 칩 가로 스크롤 (MySpaceView) | ✅ 완료 |
| 캘린더 7열 그리드 | ✅ 완료 |
| 이전/다음 달 날짜 회색 표시 | ✅ 완료 |
| 오늘 날짜 강조 | ✅ 완료 |
| 썸네일 Color placeholder | ✅ 완료 |
| +N 뱃지 (2개 이상) | ✅ 완료 |
| 월 이동 ◀▶ | ✅ 완료 |
| DatePicker sheet (Apple 1st-party) | ✅ 완료 |
| 헤더 우측 4개 버튼 TCA 연결 | ✅ 완료 (기능 TODO) |

---

## 다음 작업

- 헤더 우측 4개 버튼 실제 기능 구현 (aspectRatio, favorite, share, settings)
- `ContentItem`에 실제 이미지 URL 지원 (`AsyncImage` 교체)
- 날짜 탭 시 상세 뷰 이동 (TCA navigation)
- 필터 칩 선택에 따른 캘린더 콘텐츠 필터링
