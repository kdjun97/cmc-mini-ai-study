import SwiftUI

struct CMCNavigationBar<Leading: View, Trailing: View>: View {
    var title: String?
    var centerTitle: Bool
    var leading: Leading
    var trailing: Trailing

    var body: some View {
        ZStack {
            if centerTitle, let title {
                Text(title)
                    .font(Font.CMC.navigationTitle)
                    .foregroundStyle(Color.CMC.textPrimary)
                    .frame(maxWidth: .infinity)
            }

            HStack(spacing: CMCSpacing.sm) {
                leading

                if !centerTitle {
                    if let title {
                        Text(title)
                            .font(Font.CMC.navigationTitle)
                            .foregroundStyle(Color.CMC.textPrimary)
                    }
                    Spacer()
                } else {
                    Spacer()
                }

                trailing
            }
        }
        .padding(.horizontal, CMCSpacing.lg)
        .padding(.vertical, CMCSpacing.md)
        .background(Color.CMC.background)
    }
}

// MARK: - Initializers

extension CMCNavigationBar {
    /// leading + trailing 모두 Custom View로 전달
    init(
        title: String? = nil,
        centerTitle: Bool = false,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.centerTitle = centerTitle
        self.leading = leading()
        self.trailing = trailing()
    }
}

extension CMCNavigationBar where Leading == EmptyView {
    /// trailing만 Custom View로 전달 (leading 없음)
    init(
        title: String? = nil,
        centerTitle: Bool = false,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.centerTitle = centerTitle
        self.leading = EmptyView()
        self.trailing = trailing()
    }
}

extension CMCNavigationBar where Trailing == EmptyView {
    /// leading만 Custom View로 전달 (trailing 없음)
    init(
        title: String? = nil,
        centerTitle: Bool = false,
        @ViewBuilder leading: () -> Leading
    ) {
        self.title = title
        self.centerTitle = centerTitle
        self.leading = leading()
        self.trailing = EmptyView()
    }
}

extension CMCNavigationBar where Leading == EmptyView, Trailing == EmptyView {
    /// 버튼 없이 타이틀만
    init(title: String? = nil, centerTitle: Bool = false) {
        self.title = title
        self.centerTitle = centerTitle
        self.leading = EmptyView()
        self.trailing = EmptyView()
    }
}

// MARK: - Previews

#Preview("Case 1: 라이브러리 + 우측 검색") {
    VStack(spacing: 0) {
        CMCNavigationBar(title: "라이브러리", trailing: {
            Button { } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.CMC.textPrimary)
            }
            .buttonStyle(.plain)
        })
        Divider()
        Spacer()
    }
}

#Preview("Case 2: X + 타이틀(중앙) + 편집") {
    VStack(spacing: 0) {
        CMCNavigationBar(
            title: "제목",
            centerTitle: true,
            leading: {
                Button { } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.CMC.textPrimary)
                }
                .buttonStyle(.plain)
            },
            trailing: {
                Button { } label: {
                    Text("편집")
                        .font(Font.CMC.body)
                        .foregroundStyle(Color.CMC.textPrimary)
                }
                .buttonStyle(.plain)
            }
        )
        Divider()
        Spacer()
    }
}

#Preview("Case 3: leading + 우측 버튼 2개") {
    VStack(spacing: 0) {
        CMCNavigationBar(
            leading: {
                Button { } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.CMC.textPrimary)
                }
                .buttonStyle(.plain)
            },
            trailing: {
                HStack(spacing: CMCSpacing.md) {
                    Button { } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.CMC.textPrimary)
                    }
                    .buttonStyle(.plain)
                    Button { } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.CMC.textPrimary)
                    }
                    .buttonStyle(.plain)
                }
            }
        )
        Divider()
        Spacer()
    }
}
