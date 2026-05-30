import SwiftUI

enum CMCTab {
    case social
    case search
    case mySpace
    case profile
}

struct CMCTabBar: View {
    @Binding var selectedTab: CMCTab
    var onAddTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.CMC.separator)

            HStack(spacing: CMCSpacing.lg) {
                // 좌측 캡슐 — 소셜 (사람 + 검색 각각 선택 가능)
                socialCapsule
                    .frame(maxWidth: .infinity)

                // 중앙 + 버튼
                addButton

                // 우측 캡슐 — 내 공간 (책 + 프로필 각각 선택 가능)
                mySpaceCapsule
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, CMCSpacing.lg)
            .padding(.top, CMCSpacing.sm)
            .padding(.bottom, CMCSpacing.xl)
            .background(Color.CMC.background)
        }
    }

    // MARK: - 좌측: 소셜 캡슐

    private var socialCapsule: some View {
        VStack(spacing: CMCSpacing.xs) {
            HStack(spacing: 0) {
                tabIconButton(
                    icon: "person.2",
                    tab: .social
                )
                tabIconButton(
                    icon: "magnifyingglass",
                    selectedIcon: "magnifyingglass",
                    tab: .search
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, CMCSpacing.sm)
            .padding(.vertical, CMCSpacing.xs)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 1)
            )

            Text("소셜")
                .font(Font.CMC.tabLabel)
                .foregroundStyle(Color.CMC.textPrimary)
        }
    }

    // MARK: - 우측: 내 공간 캡슐

    private var mySpaceCapsule: some View {
        VStack(spacing: CMCSpacing.xs) {
            HStack(spacing: 0) {
                tabIconButton(
                    icon: "books.vertical",
                    tab: .mySpace
                )
                // 프로필 — 이미지 없으면 검정 Circle
                Button {
                    selectedTab = .profile
                } label: {
                    Circle()
                        .fill(Color.CMC.addButton)
                        .frame(width: 24, height: 24)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(
                            Capsule()
                                .fill(selectedTab == .profile ? Color.CMC.surface : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, CMCSpacing.sm)
            .padding(.vertical, CMCSpacing.xs)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 1)
            )

            Text("내 공간")
                .font(Font.CMC.tabLabel)
                .foregroundStyle(Color.CMC.textPrimary)
        }
    }

    // MARK: - 중앙: + 버튼

    private var addButton: some View {
        Button(action: onAddTap) {
            Circle()
                .fill(Color.CMC.addButton)
                .frame(width: 52, height: 52)
                .overlay {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.white)
                }
        }
        .buttonStyle(.plain)
        .fixedSize()
        .offset(y: -4)
    }

    // MARK: - 공통 아이콘 버튼

    private func tabIconButton(icon: String, selectedIcon: String? = nil, tab: CMCTab) -> some View {
        let isSelected = selectedTab == tab
        let displayIcon = isSelected ? (selectedIcon ?? (icon + ".fill")) : icon
        return Button {
            selectedTab = tab
        } label: {
            Image(systemName: displayIcon)
                .font(.system(size: 20))
                .foregroundStyle(Color.CMC.tabActive)
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.CMC.surface : Color.clear)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        Spacer()
        CMCTabBar(selectedTab: .constant(.mySpace))
    }
}
