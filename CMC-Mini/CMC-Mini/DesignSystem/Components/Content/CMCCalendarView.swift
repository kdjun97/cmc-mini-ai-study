import SwiftUI

struct CMCCalendarView: View {
    var onHeaderAction: (CalendarHeaderAction) -> Void = { _ in }

    @State private var currentDate: Date = .now

    private let contents: [Date: [ContentItem]] = ContentItem.dummySample()
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        VStack(spacing: 0) {
            CalendarHeaderView(currentDate: $currentDate, onActionTap: onHeaderAction)

            Divider().background(Color.CMC.separator)

            // 요일 헤더
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { wd in
                    Text(wd)
                        .font(Font.CMC.calendarWeekday)
                        .foregroundStyle(Color.CMC.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, CMCSpacing.sm)
                }
            }

            Divider().background(Color.CMC.separator)

            // 날짜 그리드 — GeometryReader로 남은 height를 행 수만큼 균등 분할
            let rows = calendarRows
            GeometryReader { geo in
                let rowHeight = geo.size.height / CGFloat(rows.count)
                VStack(spacing: 0) {
                    ForEach(rows.indices, id: \.self) { i in
                        HStack(spacing: 0) {
                            ForEach(rows[i]) { cell in
                                CalendarDayCell(
                                    day: cell.day,
                                    isCurrentMonth: cell.isCurrentMonth,
                                    isToday: cell.isToday,
                                    isPast: cell.isPast,
                                    contents: contentsFor(cell)
                                )
                                .frame(height: rowHeight)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Calendar calculation

    private struct CalendarCell: Identifiable {
        let id = UUID()
        let day: Int
        let date: Date?
        let isCurrentMonth: Bool
        let isToday: Bool
        let isPast: Bool
    }

    private var calendarRows: [[CalendarCell]] {
        calendarCells.chunked(into: 7)
    }

    private var calendarCells: [CalendarCell] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        var comps = cal.dateComponents([.year, .month], from: currentDate)
        comps.day = 1
        guard let firstDay = cal.date(from: comps) else { return [] }

        let totalDays = cal.range(of: .day, in: .month, for: firstDay)!.count
        let firstWeekday = cal.component(.weekday, from: firstDay) - 1  // 0=일 … 6=토

        var cells: [CalendarCell] = []

        // 이전 달
        if firstWeekday > 0 {
            let prevFirst = cal.date(byAdding: .month, value: -1, to: firstDay)!
            let prevTotal = cal.range(of: .day, in: .month, for: prevFirst)!.count
            for d in (prevTotal - firstWeekday + 1)...prevTotal {
                cells.append(CalendarCell(day: d, date: nil, isCurrentMonth: false, isToday: false, isPast: true))
            }
        }

        // 현재 달
        for d in 1...totalDays {
            comps.day = d
            let date = cal.date(from: comps)
            let dayStart = date.map { cal.startOfDay(for: $0) }
            let isToday = dayStart.map { $0 == today } ?? false
            let isPast  = dayStart.map { $0 < today }  ?? false
            cells.append(CalendarCell(day: d, date: date, isCurrentMonth: true, isToday: isToday, isPast: isPast))
        }

        // 다음 달
        let remainder = cells.count % 7
        if remainder != 0 {
            for d in 1...(7 - remainder) {
                cells.append(CalendarCell(day: d, date: nil, isCurrentMonth: false, isToday: false, isPast: false))
            }
        }

        return cells
    }

    private func contentsFor(_ cell: CalendarCell) -> [ContentItem] {
        guard cell.isCurrentMonth, let date = cell.date else { return [] }
        return contents[Calendar.current.startOfDay(for: date)] ?? []
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    CMCCalendarView()
        .frame(maxHeight: .infinity)
}
