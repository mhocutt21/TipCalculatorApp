//
//  ContentView.swift
//  TipCalculatorAppFancy
//
//  Created by Macie Hocutt on 1/28/26.
//

private struct GuestCheckPaper<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(red: 0.88, green: 0.95, blue: 0.90)) // pale green paper
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color(red: 0.06, green: 0.25, blue: 0.55), lineWidth: 2)
                    )
            )
            .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 7)
    }
}

private struct SmallBox: View {
    let title: String
    let valueText: String

    init(title: String, value: String) {
        self.title = title
        self.valueText = value
    }

    init(title: String, value: Double, currencyCode: String) {
        self.title = title
        self.valueText = value.formatted(.currency(code: currencyCode))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color(red: 0.06, green: 0.25, blue: 0.55))
            Text(valueText)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(8)
        .frame(width: 78, height: 54, alignment: .topLeading)
        .background(Color.white.opacity(0.6))
        .overlay(
            Rectangle().stroke(Color(red: 0.06, green: 0.25, blue: 0.55), lineWidth: 2)
        )
    }
}

private struct DashedTearLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 1)
            .overlay(
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                    .foregroundStyle(Color(red: 0.06, green: 0.25, blue: 0.55))
            )
            .padding(.vertical, 6)
    }
}

private struct RuledArea<Content: View>: View {
    let lines: Int
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                ForEach(0..<lines, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 30)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(Color(red: 0.06, green: 0.25, blue: 0.55).opacity(0.55))
                                .frame(height: 1)
                        }
                }
            }

            // Right column divider vibe
            HStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(Color(red: 0.06, green: 0.25, blue: 0.55).opacity(0.8))
                    .frame(width: 2)
                    .padding(.vertical, 6)
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 60)
            }

            content()
                .padding(.horizontal, 4)
        }
        .padding(.top, 6)
    }
}

private struct LabeledRow<Content: View>: View {
    let label: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color(red: 0.06, green: 0.25, blue: 0.55))
            content()
        }
    }
}

private struct TotalRow: View {
    let label: String
    let value: Double
    let currencyCode: String
    var bold: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: bold ? .bold : .semibold))
                .foregroundStyle(Color(red: 0.06, green: 0.25, blue: 0.55))

            Spacer()

            Text(value, format: .currency(code: currencyCode))
                .font(.system(size: 14, weight: bold ? .bold : .semibold))
        }
    }
}
