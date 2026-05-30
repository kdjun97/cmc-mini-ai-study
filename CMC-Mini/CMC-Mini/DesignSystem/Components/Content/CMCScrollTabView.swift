import SwiftUI

nonisolated enum CMCContentTab: String, CaseIterable, Hashable, Sendable {
    case wishlist  = "위시리스트"
    case calendar  = "캘린더"
    case rating    = "평점"
    case timeline  = "타임라인"
    case gallery   = "갤러리"
}

struct CMCScrollTabView: View {
    @Binding var selectedTab: CMCContentTab

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(CMCContentTab.allCases, id: \.self) { tab in
                    tabButton(tab)
                }
            }
            .padding(.horizontal, CMCSpacing.lg)
        }
    }

    private func tabButton(_ tab: CMCContentTab) -> some View {
        let isSelected = selectedTab == tab
        return Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 0) {
                Text(tab.rawValue)
                    .font(isSelected ? Font.CMC.segmentTabSelected : Font.CMC.segmentTab)
                    .foregroundStyle(isSelected ? Color.CMC.textPrimary : Color.CMC.textSecondary)
                    .padding(.horizontal, CMCSpacing.md)
                    .padding(.vertical, CMCSpacing.sm)

                Rectangle()
                    .fill(isSelected ? Color.CMC.textPrimary : Color.clear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CMCScrollTabView(selectedTab: .constant(.calendar))
}
