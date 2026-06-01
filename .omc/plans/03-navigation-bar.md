# Phase 2 — CMCNavigationBar (상단 네비게이션)

**상태:** pending approval  
**Figma 참조:** node `7:2` 상단 영역  
**경로:** `DesignSystem/Components/Navigation/CMCNavigationBar.swift`  
**의존:** Phase 0 (Foundation)

---

## Figma 분석

node 7:2 상단 구성:
- 시스템 상태바 (3:49, 신호, 배터리)
- 타이틀: "라이브러리" (좌측 정렬, bold)
- 우측: 검색 아이콘 (돋보기)
- 배경: 흰색

---

## 구현 사양

```swift
// CMCNavigationBar.swift
struct CMCNavigationBar: View {
    let title: String
    var trailingIcon: String? = nil        // SF Symbol name
    var onTrailingTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(Font.CMC.title)
                .foregroundColor(Color.CMC.textPrimary)
            Spacer()
            if let icon = trailingIcon {
                Button(action: { onTrailingTap?() }) {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(Color.CMC.textPrimary)
                }
            }
        }
        .padding(.horizontal, CMCSpacing.lg)
        .padding(.vertical, CMCSpacing.md)
        .background(Color.CMC.background)
    }
}
```

---

## 수락 기준

- [ ] `CMCNavigationBar.swift` 생성 (`DesignSystem/Components/Navigation/`)
- [ ] 타이틀 좌측 정렬, 우측 아이콘 버튼 지원
- [ ] Foundation 토큰(색상·폰트·간격) 사용
- [ ] trailing 아이콘 없는 경우도 정상 렌더링
- [ ] `#Preview` 포함
- [ ] Xcode 빌드 에러 없음
- [ ] `LibraryView`에서 상단에 배치하여 스크롤 시 고정 확인

---

## 검증 방법

1. Preview에서 타이틀 + 검색 아이콘 렌더링 확인
2. 시뮬레이터에서 검색 버튼 탭 반응 확인
3. Figma node 7:2 상단과 육안 비교

---

## 참고

- SwiftUI 기본 `.navigationTitle`은 사용하지 않음 (커스텀 뷰로 구현)
- 추후 뒤로가기 버튼(leading) 지원을 위해 `leadingIcon` 파라미터 확장 가능
