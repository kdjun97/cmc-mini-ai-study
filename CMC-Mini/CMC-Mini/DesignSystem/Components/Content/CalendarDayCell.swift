import SwiftUI

struct CalendarDayCell: View {
    let day: Int
    let isCurrentMonth: Bool
    let isToday: Bool
    let isPast: Bool
    let contents: [ContentItem]

    private var hasContent: Bool { !contents.isEmpty }

    var body: some View {
        ZStack {
            if isToday && !hasContent {
                // 오늘 + 빈 셀: 검정 border + + 아이콘
                todayEmptyCell
            } else if hasContent {
                // 콘텐츠 있는 셀: 컬러 블록, 날짜 텍스트 없음
                contentCell
            } else {
                // 과거/미래/다른달 빈 셀: 날짜 텍스트만
                dayText
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Sub views

    /// 오늘 + 빈 셀: 검정 테두리 + 플러스 아이콘
    private var todayEmptyCell: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CMCSpacing.sm)
                .strokeBorder(Color.CMC.textPrimary, lineWidth: 1.5)
                .padding(3)
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(Color.CMC.textPrimary)
        }
    }

    /// 콘텐츠 있는 셀: 컬러 블록 + 선택적 우측 상단 뱃지
    private var contentCell: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: CMCSpacing.sm)
                .fill(contents.first!.placeholderColor.opacity(0.8))
                .padding(2)

            if contents.count >= 2 {
                ZStack {
                    Circle()
                        .fill(Color.CMC.textPrimary)
                        .frame(width: 18, height: 18)
                    Text("\(contents.count)")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.top, 5)
                .padding(.trailing, 5)
            }
        }
    }

    private var dayText: some View {
        Text("\(day)")
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(isCurrentMonth ? Color.CMC.textSecondary : Color.CMC.tabInactive)
    }
}

#Preview {
    HStack(spacing: 0) {
        // 과거 빈 셀
        CalendarDayCell(day: 5,  isCurrentMonth: true,  isToday: false, isPast: true,  contents: [])
            .frame(height: 80)
        // 오늘 빈 셀 → 검정 border + +
        CalendarDayCell(day: 30, isCurrentMonth: true,  isToday: true,  isPast: false, contents: [])
            .frame(height: 80)
        // 다른 달
        CalendarDayCell(day: 1,  isCurrentMonth: false, isToday: false, isPast: false, contents: [])
            .frame(height: 80)
        // 콘텐츠 1개
        CalendarDayCell(day: 12, isCurrentMonth: true,  isToday: false, isPast: true, contents: [
            ContentItem(id: UUID(), date: .now, placeholderColor: .purple, type: .book)
        ])
        .frame(height: 80)
        // 콘텐츠 2개 → 우측 상단 뱃지
        CalendarDayCell(day: 4,  isCurrentMonth: true,  isToday: false, isPast: true, contents: [
            ContentItem(id: UUID(), date: .now, placeholderColor: .green, type: .photo),
            ContentItem(id: UUID(), date: .now, placeholderColor: .orange, type: .book)
        ])
        .frame(height: 80)
    }
}
