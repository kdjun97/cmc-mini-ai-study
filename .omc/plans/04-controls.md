# Phase 3 — CMCSegmentedControl + CMCFilterChip

**상태:** pending approval  
**Figma 참조:** node `7:2` 탭 세그먼트 + 필터 영역  
**경로:** `DesignSystem/Components/Controls/`  
**의존:** Phase 0 (Foundation)

---

## Figma 분석

node 7:2에서 확인된 구성:

### 탭 세그먼트 (가로 스크롤)
- 항목: 시리즈트 · 캘린더 · 평점 · 타임라인 · 갤러리 · (추가)
- 활성 탭: 밑줄(underline) 강조
- 스크롤 가능한 가로 배열

### 필터 칩 (가로 스크롤)
- 항목: 점점 ▼ · 날짜 ▼ · **전체 6** (강조) · 공원 / 자연 1 · 책 1
- 선택된 칩: 검정 배경 + 흰 텍스트
- 미선택 칩: 흰 배경 + 검정 테두리 + 검정 텍스트

---

## 구현 사양

### `CMCSegmentedControl.swift`
```swift
struct CMCSegmentedControl: View {
    let tabs: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(tabs.indices, id: \.self) { index in
                    CMCSegmentTab(
                        title: tabs[index],
                        isSelected: selectedIndex == index
                    )
                    .onTapGesture { selectedIndex = index }
                }
            }
        }
    }
}

struct CMCSegmentTab: View {
    let title: String
    let isSelected: Bool
    // 활성: 검정 텍스트 + 하단 2pt 검정 밑줄
    // 비활성: 회색 텍스트, 밑줄 없음
}
```

### `CMCFilterChip.swift`
```swift
struct CMCFilterChip: View {
    let label: String
    let isSelected: Bool
    var hasDropdown: Bool = false   // ▼ 아이콘 표시 여부
    var onTap: () -> Void

    var body: some View {
        // 선택: 검정 배경, 흰 텍스트, 둥근 모서리
        // 미선택: 흰 배경, 검정 테두리, 검정 텍스트
    }
}
```

---

## 수락 기준

**CMCSegmentedControl**
- [ ] `CMCSegmentedControl.swift` 생성
- [ ] 탭 목록 가로 스크롤
- [ ] 선택된 탭 밑줄 애니메이션 (withAnimation)
- [ ] `@Binding var selectedIndex` 상태 연동

**CMCFilterChip**
- [ ] `CMCFilterChip.swift` 생성
- [ ] 선택/미선택 스타일 토글
- [ ] ▼ 드롭다운 아이콘 옵션 지원
- [ ] 가로 ScrollView 안에서 사용 가능

**공통**
- [ ] Foundation 토큰 사용 (하드코딩 색상 없음)
- [ ] `#Preview` 포함
- [ ] Xcode 빌드 에러 없음

---

## 검증 방법

1. Preview에서 전체 탭 목록 렌더링 확인
2. 탭 선택 시 밑줄 이동 확인
3. 필터 칩 선택/해제 토글 확인
4. Figma node 7:2 세그먼트 + 필터 영역과 육안 비교
