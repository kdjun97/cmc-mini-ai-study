import SwiftUI

enum CalendarHeaderAction {
    case aspectRatio
    case favorite
    case share
    case settings
}

struct CalendarHeaderView: View {
    @Binding var currentDate: Date
    let onActionTap: (CalendarHeaderAction) -> Void

    @State private var isDatePickerPresented = false

    private var monthTitle: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy.MM."
        return fmt.string(from: currentDate)
    }

    var body: some View {
        HStack(spacing: 0) {
            // 이전 달
            Button {
                currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.CMC.textPrimary)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)

            // 월 선택 → Apple DatePicker sheet
            Button {
                isDatePickerPresented = true
            } label: {
                Text(monthTitle)
                    .font(Font.CMC.navigationTitle)
                    .foregroundStyle(Color.CMC.textPrimary)
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $isDatePickerPresented) {
                VStack(spacing: 0) {
                    DatePicker(
                        "",
                        selection: $currentDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding(.horizontal)

                    Button("완료") { isDatePickerPresented = false }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.CMC.textPrimary)
                        .padding(.bottom, CMCSpacing.xxl)
                }
                .presentationDetents([.medium])
            }

            // 다음 달
            Button {
                currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.CMC.textPrimary)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)

            Spacer()

            // 우측 액션 버튼 4개 (TODO: 각 기능 미구현)
            HStack(spacing: CMCSpacing.xs) {
                actionButton("rectangle.ratio.3.to.4.fill", action: .aspectRatio)
                actionButton("star",                        action: .favorite)
                actionButton("square.and.arrow.up",         action: .share)
                actionButton("gearshape",                   action: .settings)
            }
        }
        .padding(.horizontal, CMCSpacing.lg)
        .frame(height: 44)
    }

    private func actionButton(_ icon: String, action: CalendarHeaderAction) -> some View {
        Button { onActionTap(action) } label: {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(Color.CMC.textPrimary)
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CalendarHeaderView(currentDate: .constant(Date()), onActionTap: { _ in })
}
