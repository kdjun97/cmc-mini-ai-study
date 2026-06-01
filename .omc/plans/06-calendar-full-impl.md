# Phase 3~4 통합: FilterChip + 캘린더 전체 구현

**상태:** pending approval  
**Figma 노드:** `7:2` (라이브러리 캘린더 페이지), `7:4` (탭바 기준 참조)  
**결정:** 전체 한 번에 구현, 썸네일 = Color placeholder

---

## 구현 파일 목록

```
DesignSystem/Components/Controls/
└── CMCFilterChip.swift              ← 신규 (Phase 3a)

DesignSystem/Components/Content/
├── CMCCalendarView.swift            ← 기존 stub → 완전 구현 (Phase 4d)
├── CalendarHeaderView.swift         ← 신규 (Phase 4b)
└── CalendarDayCell.swift            ← 신규 (Phase 4c)

Model/
└── ContentItem.swift                ← 신규 (Phase 4a, 더미 모델)

Features/MySpace/
└── MySpaceView.swift                ← FilterChip 행 추가 (Phase 4e)
```

---

## 컴포넌트별 스펙

### 1. ContentItem.swift (모델)

```swift
enum ContentType { case music, book, photo, place }

struct ContentItem: Identifiable {
    let id: UUID
    let date: Date
    let placeholderColor: Color   // 더미 썸네일 색상
    let type: ContentType
}
```

---

### 2. CMCFilterChip.swift

**Figma 케이스:** `점점▼` | `날짜▼` | `전체 6★` | `공원/자연 1` | `책 1`

```swift
struct CMCFilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
}
```

| 속성 | 선택 | 미선택 |
|------|------|--------|
| 배경 | `Color.CMC.chipSelected` (#000) | `Color.CMC.chipUnselected` (#FFF) |
| 텍스트 | `.white` | `Color.CMC.textPrimary` |
| 테두리 | 없음 | 1pt `Color.CMC.separator` |
| 폰트 | `Font.CMC.filterChip` | `Font.CMC.filterChip` |
| 높이 | 32pt | 32pt |
| cornerRadius | 16pt (pill) | 16pt (pill) |
| padding H | `CMCSpacing.md` (12pt) | `CMCSpacing.md` (12pt) |

**MySpaceView 통합:**  
필터 칩 목록을 가로 스크롤 `ScrollView(.horizontal)` 안의 `HStack`으로 배치.  
`NavigationBar` ↔ `ScrollTabView` 사이에 위치.

---

### 3. CalendarHeaderView.swift

**Figma 레이아웃:**
```
[◀]  [2026.05.]  [▶]  ─────────  [2:3] [★] [↑] [⚙]
```

#### 날짜 버튼 (중앙) — Apple 1st-party DatePicker sheet

- `"2026.05."` 텍스트는 **탭 가능한 버튼**
- 탭 시 `.sheet` 로 Apple 기본 `DatePicker` 표시
  ```swift
  DatePicker("", selection: $currentDate, displayedComponents: .date)
      .datePickerStyle(.graphical)   // Apple 1st-party 달력 UI
      .labelsHidden()
  ```
- sheet dismiss 시 선택한 날짜로 `currentDate` 업데이트 → 캘린더 그리드 자동 갱신
- `@State private var isDatePickerPresented: Bool = false` 로 sheet 제어

#### 우측 4개 아이콘 버튼 — TCA Action 연결 + TODO

| 아이콘 | SF Symbol | TCA Action | 구현 |
|--------|-----------|------------|------|
| 비율 | `rectangle.ratio.3.to.4.fill` | `.aspectRatioTapped` | TODO |
| 즐겨찾기 | `star` | `.favoriteTapped` | TODO |
| 공유 | `square.and.arrow.up` | `.shareTapped` | TODO |
| 설정 | `gearshape` | `.settingsTapped` | TODO |

- 각 버튼은 `store.send(.aspectRatioTapped)` 형태로 TCA Action 디스패치
- Reducer에서 해당 Action은 `return .none` 처리 (TODO 주석 포함)
- `CalendarHeaderView`는 `store: StoreOf<MySpaceFeature>` 를 받아 Action 전달

```swift
struct CalendarHeaderView: View {
    @Binding var currentDate: Date
    let store: StoreOf<MySpaceFeature>
    @State private var isDatePickerPresented = false
    // height: 44pt, padding H: CMCSpacing.lg
}
```

---

### 4. CalendarDayCell.swift

**렌더링 규칙 (Figma 기준):**

| 조건 | 렌더링 |
|------|--------|
| contents 0개 | 날짜 숫자 상단 중앙, 배경 없음 |
| contents 1개 | Color block이 셀 채움, 날짜 좌상단 오버레이 (white, 10pt) |
| contents 2개+ | Color block + 우하단 +N 검정 원형 뱃지 (white 텍스트) |
| 다른 달 날짜 | `Color.CMC.textSecondary` 텍스트, 썸네일 없음 |
| 오늘 날짜 | `Color.CMC.textPrimary` 원(24pt) + white 텍스트 |

**셀 크기:**
```swift
// GeometryReader 없이 GridItem(.flexible()) 사용
// aspect ratio ≈ 1:1 (정사각형)
// cornerRadius: CMCSpacing.xs (4pt)
```

---

### 5. CMCCalendarView.swift (stub → 완전 구현)

```swift
struct CMCCalendarView: View {
    @State private var currentDate: Date = .now
    
    // 더미 콘텐츠 데이터 (Preview + 실사용 겸용)
    private let contents: [Date: [ContentItem]] = ContentItem.dummySample()
    
    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(currentDate: $currentDate)
            weekdayHeader        // 일 월 화 수 목 금 토
            calendarGrid
        }
    }
}
```

**날짜 계산 로직:**
```swift
// 해당 월 첫 날 요일 offset (0=일, 6=토)
func firstWeekdayOffset(date: Date) -> Int
// 해당 월 총 일수
func daysInMonth(date: Date) -> Int
// 전월 마지막 날짜들로 앞 공백 채우기
// 후월 첫 날짜들로 뒷 공백 채우기
```

**그리드:**
```swift
let columns = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
LazyVGrid(columns: columns, spacing: 1) {
    ForEach(cells) { cell in CalendarDayCell(cell: cell) }
}
```

---

---

### 6. MySpaceFeature.swift 수정 — TCA Action 추가

현재 `Action`에 캘린더 헤더 버튼 액션 추가:

```swift
enum Action {
    case onAppear
    // 캘린더 헤더
    case calendar(CalendarAction)
    
    enum CalendarAction {
        case aspectRatioTapped   // TODO
        case favoriteTapped      // TODO
        case shareTapped         // TODO
        case settingsTapped      // TODO
    }
}
```

Reducer에서 각 Action은 `return .none` + `// TODO: implement` 주석 처리.

> `CalendarHeaderView`는 `store.scope(state: \.self, action: \.calendar)` 형태로 child store 전달하거나, 단순히 `send` 클로저로 전달하는 방식 중 후자 선택 (뷰 의존성 최소화).
> 즉, `let onActionTap: (MySpaceFeature.Action.CalendarAction) -> Void` 클로저로 전달.

---

## 수락 기준

- [ ] `CMCFilterChip` 선택/미선택 상태 토글 정상 동작
- [ ] FilterChip 가로 스크롤, NavBar-탭 사이 배치
- [ ] 캘린더 7열 그리드 렌더링 (2026.05 기준 수요일 시작 확인)
- [ ] 이전/다음 달 날짜 회색 표시
- [ ] 오늘 날짜 강조 (검정 원)
- [ ] contents 0/1/2+ 케이스 셀 렌더링 구분
- [ ] ◀▶ 버튼으로 월 이동 동작
- [ ] `#Preview` 더미 데이터로 전체 화면 렌더링

---

## 리스크 및 대응

| 리스크 | 대응 |
|--------|------|
| 월별 첫 요일 offset 오계산 | `Calendar.current.component(.weekday, from:)` - 1 로 일요일=0 통일 |
| 셀 크기 불균등 | `GridItem(.flexible(), spacing: 1)` + `aspectRatio(1, contentMode: .fit)` |
| FilterChip 과다 시 잘림 | `ScrollView(.horizontal, showsIndicators: false)` |
| 이전/다음 달 날짜 수 계산 | 전월은 `daysInPrevMonth - offset + 1`부터, 후월은 1부터 |
