# CMC Mini Hackathon — SwiftUI UI 개발 마스터 플랜

**상태:** pending approval  
**작성일:** 2026-05-30  
**Figma 전체 노드:** [0:1](https://www.figma.com/design/XqqPeEoWsD5tBmil5Z7a50/mini_hack?node-id=0-1)  
**프로젝트 경로:** `cmc-mini-ai-study/CMC-Mini/CMC-Mini/`

---

## 개요

라이브러리(기록/콘텐츠 관리) 앱의 SwiftUI UI를 점진적으로 개발한다.  
공통 컴포넌트를 먼저 `DesignSystem/` 하위에 구축하고, 페이지 단위로 순차 개발한다.

---

## DesignSystem 폴더 구조

```
CMC-Mini/
└── DesignSystem/
    ├── Foundation/
    │   ├── CMCColor.swift          # 앱 색상 토큰
    │   ├── CMCTypography.swift     # 폰트/텍스트 스타일
    │   └── CMCSpacing.swift        # 간격 토큰
    ├── Components/
    │   ├── Navigation/
    │   │   ├── CMCTabBar.swift             # 하단 탭바
    │   │   └── CMCNavigationBar.swift      # 상단 네비게이션
    │   ├── Controls/
    │   │   ├── CMCSegmentedControl.swift   # 탭 세그먼트 (캘린더/평점/타임라인 등)
    │   │   └── CMCFilterChip.swift         # 필터 칩 (전체/공원·자연/책 등)
    │   └── Cards/
    │       └── CMCContentCard.swift        # 콘텐츠 썸네일 카드
    └── Pages/
        └── Library/
            ├── LibraryView.swift           # 라이브러리 루트 뷰
            └── Calendar/
                ├── LibraryCalendarView.swift
                └── CalendarGridView.swift
```

---

## 개발 순서 (Phase)

| Phase | 내용 | 플랜 파일 | 상태 |
|-------|------|-----------|------|
| 0 | Foundation (색상·타이포·간격 토큰) | `01-foundation.md` | 대기 |
| 1 | CMCTabBar (하단 탭바) | `02-tabbar.md` | 대기 |
| 2 | CMCNavigationBar (상단 네비게이션) | `03-navigation-bar.md` | 대기 |
| 3 | CMCSegmentedControl + CMCFilterChip | `04-controls.md` | 대기 |
| 4 | LibraryCalendarView (캘린더 페이지) | `05-library-calendar.md` | 대기 |
| 5+ | 추가 페이지 (리스트·평점·타임라인 등) | 추후 작성 | 미정 |

---

## 전체 페이지 목록 (Figma 확인 기반)

| 페이지 | Figma 노드 | 플랜 |
|--------|-----------|------|
| 라이브러리 — 캘린더 뷰 | `7:2` | `05-library-calendar.md` |
| 라이브러리 — 리스트 뷰 | 추후 확인 | 미정 |
| 라이브러리 — 평점 뷰 | 추후 확인 | 미정 |
| 라이브러리 — 타임라인 뷰 | 추후 확인 | 미정 |
| 라이브러리 — 갤러리 뷰 | 추후 확인 | 미정 |
| 소셜 피드 | 추후 확인 | 미정 |
| 콘텐츠 상세 | 추후 확인 | 미정 |
| 프로필 | 추후 확인 | 미정 |

---

## 공통 규칙

- 모든 컴포넌트는 `DesignSystem/` 하위에 위치
- 네이밍 컨벤션: `CMC` prefix (공통 컴포넌트), 페이지는 기능명 prefix
- Preview Provider를 모든 컴포넌트에 포함
- 하드코딩 색상·폰트 금지 → Foundation 토큰 사용
- SwiftUI 최소 버전: iOS 17+
