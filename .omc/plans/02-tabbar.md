# Phase 1 — CMCTabBar (하단 탭바)

**상태:** pending approval  
**Figma 참조:** node `7:2` 하단 영역  
**경로:** `DesignSystem/Components/Navigation/CMCTabBar.swift`  
**의존:** Phase 0 (Foundation)

---

## Figma 분석

node 7:2 하단 탭바 구성:
- 탭 5개: 소셜(사람 아이콘), 검색(돋보기), 추가(+ 원형 검정), 내 공간(책 아이콘), 프로필(원형 이미지)
- 활성 탭: "내 공간" — 아이콘 강조
- 가운데 + 버튼은 크고 검정 원형으로 차별화
- 탭 레이블: 소셜, 검색, (없음), 내 공간, (없음)
- 배경: 흰색, 상단 구분선

---

## 구현 사양

```swift
// CMCTabBar.swift
enum CMCTab: CaseIterable {
    case social      // 소셜
    case search      // 검색
    case add         // + (중앙 액션)
    case mySpace     // 내 공간
    case profile     // 프로필
}

struct CMCTabBar: View {
    @Binding var selectedTab: CMCTab
    var onAddTap: () -> Void
    // ...
}
```

### 탭 아이템 스펙
| 탭 | SF Symbol | 레이블 | 특이사항 |
|---|---|---|---|
| 소셜 | `person.2` | 소셜 | - |
| 검색 | `magnifyingglass` | 검색 | - |
| 추가 | `plus` | - | 검정 원형 배경, 크기 56pt |
| 내 공간 | `books.vertical` | 내 공간 | - |
| 프로필 | `person.circle` | - | 원형 이미지 (추후 실제 이미지) |

---

## 수락 기준

- [ ] `CMCTabBar.swift` 생성 (`DesignSystem/Components/Navigation/`)
- [ ] 5개 탭 아이콘 + 레이블 렌더링
- [ ] 가운데 + 버튼 검정 원형 디자인 구현
- [ ] 선택된 탭 강조 (활성/비활성 색상 토큰 사용)
- [ ] `@Binding var selectedTab` 상태 연동
- [ ] `#Preview` 포함 및 Xcode 빌드 에러 없음
- [ ] `ContentView.swift`에서 `CMCTabBar` 연동하여 실제 탭 전환 확인

---

## 검증 방법

1. Xcode 빌드 성공
2. Preview에서 탭바 렌더링 확인
3. 시뮬레이터에서 탭 선택 전환 동작 확인
4. Figma 디자인과 육안 비교

---

## 리스크

- 프로필 탭 이미지는 초기에 placeholder 사용
- + 버튼 액션은 추후 기능 연결 (지금은 빈 클로저)
