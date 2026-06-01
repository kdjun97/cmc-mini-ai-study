import SwiftUI

enum ContentType {
    case music, book, photo, place
}

struct ContentItem: Identifiable {
    let id: UUID
    let date: Date
    let placeholderColor: Color
    let type: ContentType

    static func dummySample() -> [Date: [ContentItem]] {
        let cal = Calendar.current
        var items: [Date: [ContentItem]] = [:]

        func makeDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
            cal.startOfDay(for: cal.date(from: DateComponents(year: year, month: month, day: day))!)
        }

        items[makeDate(2026, 5, 1)]  = [ContentItem(id: UUID(), date: makeDate(2026, 5, 1),  placeholderColor: .blue,   type: .music)]
        items[makeDate(2026, 5, 4)]  = [
            ContentItem(id: UUID(), date: makeDate(2026, 5, 4), placeholderColor: .green,  type: .photo),
            ContentItem(id: UUID(), date: makeDate(2026, 5, 4), placeholderColor: .orange, type: .book)
        ]
        items[makeDate(2026, 5, 12)] = [ContentItem(id: UUID(), date: makeDate(2026, 5, 12), placeholderColor: .purple, type: .book)]
        items[makeDate(2026, 5, 22)] = [ContentItem(id: UUID(), date: makeDate(2026, 5, 22), placeholderColor: .indigo, type: .place)]

        return items
    }
}
