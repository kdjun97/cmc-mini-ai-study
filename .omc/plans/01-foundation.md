# Phase 0 — Foundation (색상·타이포·간격 토큰)

**상태:** pending approval  
**우선순위:** 최초 (모든 컴포넌트의 의존 기반)  
**경로:** `DesignSystem/Foundation/`

---

## 목표

앱 전반에서 사용할 디자인 토큰(색상, 타이포그래피, 간격)을 Swift enum/struct로 정의한다.  
이후 모든 컴포넌트는 하드코딩 대신 이 토큰을 참조한다.

---

## 구현 파일

### `CMCColor.swift`
```swift
// 사용 예: Color.CMC.primary, Color.CMC.background
extension Color {
    enum CMC {
        static let primary = Color("CMCPrimary")       // 주요 강조색 (검정 계열)
        static let background = Color("CMCBackground") // 배경 (흰색)
        static let surface = Color("CMCSurface")       // 카드 배경
        static let textPrimary = Color("CMCTextPrimary")
        static let textSecondary = Color("CMCTextSecondary")
        static let separator = Color("CMCSeparator")
        static let tabActive = Color("CMCTabActive")   // 탭 활성 색상
        static let tabInactive = Color("CMCTabInactive")
    }
}
```

### `CMCTypography.swift`
```swift
// 사용 예: Font.CMC.title, Font.CMC.body
extension Font {
    enum CMC {
        static let title = Font.system(size: 20, weight: .bold)
        static let tabLabel = Font.system(size: 10, weight: .medium)
        static let segmentTab = Font.system(size: 14, weight: .medium)
        static let filterChip = Font.system(size: 13, weight: .regular)
        static let calendarDay = Font.system(size: 12, weight: .regular)
        static let calendarWeekday = Font.system(size: 12, weight: .medium)
    }
}
```

### `CMCSpacing.swift`
```swift
enum CMCSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
}
```

---

## 수락 기준

- [ ] `CMCColor.swift` 파일 생성, Assets.xcassets에 컬러셋 추가
- [ ] `CMCTypography.swift` 파일 생성, Figma 폰트 크기와 일치
- [ ] `CMCSpacing.swift` 파일 생성
- [ ] 세 파일 모두 `DesignSystem/Foundation/` 경로에 위치
- [ ] Xcode 빌드 에러 없음

---

## 리스크

- Figma에서 정확한 색상값을 읽어야 함 → Figma MCP로 추가 노드 확인 필요
- Assets.xcassets 컬러셋은 Xcode에서 직접 추가 필요 (파일로 대체 시 Color(hex:) extension 사용)
