import SwiftUI

struct CMCFilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(Font.CMC.filterChip)
                .foregroundStyle(isSelected ? Color.white : Color.CMC.textPrimary)
                .padding(.horizontal, CMCSpacing.md)
                .frame(height: 32)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.CMC.chipSelected : Color.CMC.chipUnselected)
                        .overlay(
                            Capsule()
                                .strokeBorder(
                                    isSelected ? Color.clear : Color.CMC.separator,
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: CMCSpacing.sm) {
        CMCFilterChip(title: "점점▼", isSelected: true)  {}
        CMCFilterChip(title: "날짜▼", isSelected: false) {}
        CMCFilterChip(title: "전체 6★", isSelected: false) {}
    }
    .padding()
}
