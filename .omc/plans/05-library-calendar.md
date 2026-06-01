# Phase 4 — LibraryCalendarView (라이브러리 캘린더 페이지)

**상태:** pending approval  
**Figma 노드:** [`7:2`](https://www.figma.com/design/XqqPeEoWsD5tBmil5Z7a50/mini_hack?node-id=7-2)  
**경로:** `DesignSystem/Pages/Library/Calendar/`  
**의존:** Phase 0, 1, 2, 3 완료 후 진행

---

## Figma 분석 (node 7:2)

```
[상태바]
[CMCNavigationBar: "라이브러리" + 검색 아이콘]
[CMCSegmentedControl: 시리즈트 | 캘린더* | 평점 | 타임라인 | 갤러리]
[CMCFilterChip: 점점▼ | 날짜▼ | 전체 6★ | 공원/자연 1 | 책 1]
─────────────────────────────────────────────────
[캘린더 헤더: ◀ 2026.05. ▶  [2:3] ★ ↑ ⚙]
[요일 헤더: 일 월 화 수 목 금 토]
[달력 그리드 — 각 셀에 콘텐츠 썸네일 표시]
  26 27 28 29 30  1[음악] 2
   3  4[이미지2] 7  8  9
  10 11 12[책] 13 14 15[사진]
  17[+] 18 19 20 21 22 23
  24 25 26 27 28 29 30
─────────────────────────────────────────────────
[CMCTabBar: 소셜 | 검색 | + | 내공간★ | 프로필]
```

---

## 파일 구성

### `LibraryCalendarView.swift`
- 전체 페이지 조합 뷰
- `CMCNavigationBar` + `CMCSegmentedControl` + `CMCFilterChip` + `CalendarGridView` + `CMCTabBar`
- `@State` 관리: selectedSegment, selectedFilters, currentMonth

### `CalendarGridView.swift`
- 월간 캘린더 그리드 렌더링
- 날짜별 콘텐츠 썸네일 표시
- 헤더: 월 이동 버튼 + 비율/즐겨찾기/공유/설정 버튼

### `CalendarDayCell.swift`
- 개별 날짜 셀
- 빈 셀 / 날짜만 / 썸네일 1개 / 썸네일 2개 + 카운트 뱃지
- 오늘 날짜 강조 (현재 달 기준)

---

## 구현 사양

```swift
// CalendarGridView.swift
struct CalendarGridView: View {
    @Binding var currentDate: Date
    let contents: [Date: [ContentItem]]  // 날짜별 콘텐츠

    // 7열 그리드 (일~토)
    // 해당 월의 첫 요일 offset 계산
    // 이전/다음 달 날짜는 회색으로 표시
}

// CalendarDayCell.swift
struct CalendarDayCell: View {
    let day: Int
    let isCurrentMonth: Bool
    let contents: [ContentItem]   // 0~N개

    // contents.count == 0: 날짜 숫자만
    // contents.count == 1: 썸네일 1개
    // contents.count >= 2: 썸네일 겹치기 + 카운트 뱃지
}

// ContentItem (모델)
struct ContentItem: Identifiable {
    let id: UUID
    let date: Date
    let thumbnailURL: String?
    let type: ContentType  // .music, .book, .photo, .place
}
```

### 캘린더 헤더
```swift
struct CalendarHeaderView: View {
    @Binding var currentDate: Date
    // ◀ 이전달 / 2026.05. 타이틀 / ▶ 다음달
    // 우측: 비율버튼(2:3), 즐겨찾기(★), 공유(↑), 설정(⚙)
}
```

---

## 수락 기준

**CalendarGridView**
- [ ] 7열 LazyVGrid로 월간 달력 렌더링
- [ ] 첫 요일 offset 정확히 계산 (2026년 5월 → 금요일 시작)
- [ ] 이전/다음 달 날짜 회색 표시
- [ ] 월 이동(◀▶) 버튼 동작

**CalendarDayCell**
- [ ] 썸네일 없음 / 1개 / 2개+ 케이스 모두 처리
- [ ] 2개 이상일 때 뱃지(숫자) 표시
- [ ] 셀 크기: 화면 너비 ÷ 7 (균등 분할)

**LibraryCalendarView (페이지 조합)**
- [ ] 모든 공통 컴포넌트 조합 정상 동작
- [ ] 세그먼트 탭 전환 시 "캘린더" 선택 상태 유지
- [ ] 필터 칩 선택 상태 반영
- [ ] 스크롤 시 네비게이션/탭바 고정
- [ ] `#Preview` 더미 데이터로 전체 화면 확인

---

## 검증 방법

1. Xcode Preview에서 2026년 5월 달력 렌더링 확인
2. 시뮬레이터에서 월 이동(◀▶) 동작 확인
3. 탭바 "내 공간" 탭 선택 상태 확인
4. Figma node 7:2 전체 화면과 육안 비교

---

## 리스크 및 대응

| 리스크 | 대응 |
|--------|------|
| 캘린더 그리드 날짜 계산 복잡 | Calendar API(`DateComponents`) 활용, 별도 DateHelper 유틸 작성 |
| 썸네일 이미지 로딩 | 초기엔 SF Symbol / Color placeholder 사용, 추후 AsyncImage 교체 |
| 셀 크기 균등 분할 | `GeometryReader` + `LazyVGrid` columns 동적 계산 |
| 이전/다음 달 날짜 표시 정책 | Figma 기준 회색 텍스트, 썸네일 없음 |
