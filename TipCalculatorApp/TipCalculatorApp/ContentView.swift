//
//  ContentView.swift
//  TipCalculatorApp
//
//  Created by Macie Hocutt on 1/28/26.
//
import SwiftUI

struct GuestCheckView: View {
    @State private var billAmount: Double = 32
    @State private var tipPercentage: Double = 18
    @State private var numberOfPeople: Double = 2
    @State private var showResults: Bool = true
    @State private var currencyCode: String = "USD"

    private var tipAmount: Double { billAmount * (tipPercentage / 100) }
    private var totalAmount: Double { billAmount + tipAmount }
    private var amountPerPerson: Double {
        let people = max(1, Int(numberOfPeople))
        return totalAmount / Double(people)
    }

    // For the “check number” look
    private var checkNumber: String {
        String(Int.random(in: 100000...999999))
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            GuestCheckPaper {
                VStack(spacing: 10) {

                    // Top row: Date / Amount / Guests / Server + check #
                    HStack(spacing: 8) {
                        //SmallBox(title: "Date", value: formattedDate())
                        //SmallBox(title: "Amount", value: billAmount, currencyCode: currencyCode)
                        //SmallBox(title: "Guests", value: "\(Int(numberOfPeople))")
                        //SmallBox(title: "Server", value: "—")

                        //Spacer(minLength: 3)

                        //Text(checkNumber)
                            //.font(.system(size: 20, weight: .bold, design: .serif))
                            //.foregroundStyle(.red)
                            //.minimumScaleFactor(0.6)
                    }

                    DashedTearLine()

                    // Big title like the check
                    Text("Guest Check")
                        .font(.system(size: 54, weight: .bold, design: .serif))
                        .foregroundStyle(Color(red: 0.06, green: 0.25, blue: 0.55))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 2)

                    // Second row: Date / Table / Guests / Server + check #
                    HStack(spacing: 8) {
                        SmallBox(title: "Date", value: formattedDate(short: true))
                        SmallBox(title: "Table", value: "—")
                        SmallBox(title: "Guests", value: "\(Int(numberOfPeople))")
                        SmallBox(title: "Server", value: "—")

                        Spacer(minLength: 3)

                        //Text(checkNumber)
                            //.font(.system(size: 30, weight: .bold, design: .serif))
                            //.foregroundStyle(.red)
                            //.minimumScaleFactor(0.6)
                    }

                    Text("APPT - SOUP/SAL - ENTREE - VEG/POT - DESSERT - BEV")
                        .font(.system(size: 12, weight: .semibold, design: .default))
                        .foregroundStyle(Color(red: 0.06, green: 0.25, blue: 0.55))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 1)

                    // Ruled writing area
                    RuledArea(lines: 14) {
                        VStack(alignment: .leading, spacing: 40) {

                            // Bill amount: TextField + Slider
                            LabeledRow(label: "AMOUNT") {
                                HStack(spacing: 10) {
                                    TextField("0.00", value: $billAmount, format: .number)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 80, height: 100)

                                    Text(billAmount, format: .currency(code: currencyCode))
                                        .fontWeight(.semibold)

                                    Spacer()

                                    Picker("Currency", selection: $currencyCode) {
                                        Text("$ USD").tag("USD")
                                        Text("€ EUR").tag("EUR")
                                        Text("£ GBP").tag("GBP")
                                        Text("¥ JPY").tag("JPY")
                                    }
                                    .pickerStyle(.menu)
                                    .padding(.trailing, -24)
                                }
                            }

                            LabeledRow(label: "TIP %") {
                                HStack {
                                    Slider(value: $tipPercentage, in: 0...30, step: 1)
                                    Text("\(Int(tipPercentage))%")
                                        .frame(width: 50, alignment: .trailing)
                                        .fontWeight(.semibold)
                                }
                            }

                            LabeledRow(label: "GUESTS") {
                                HStack {
                                    Slider(value: $numberOfPeople, in: 1...20, step: 1)
                                    Text("\(Int(numberOfPeople))")
                                        .frame(width: 49, alignment: .trailing)
                                        .fontWeight(.semibold)
                                }
                            }

                            // Button like a “stamp”
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showResults.toggle()
                                }
                            } label: {
                                Text(showResults ? "HIDE TOTALS" : "CALCULATE")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: 200, maxHeight: 30)
                                    .background(showResults ? Color.red.opacity(0.85) : Color.blue.opacity(0.85))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding(.top, 2)

                            if showResults {
                                VStack(spacing: 8) {
                                    TotalRow(label: "TIP", value: tipAmount, currencyCode: currencyCode)
                                    TotalRow(label: "TAX", value: 0, currencyCode: currencyCode) // optional
                                    TotalRow(label: "TOTAL", value: totalAmount, currencyCode: currencyCode, bold: true)
                                    TotalRow(label: "PER PERSON", value: amountPerPerson, currencyCode: currencyCode, bold: true)
                                }
                                .padding(.top, 6)
                            }

                            Spacer(minLength: 0)
                        }
                        .padding(.top, 4)
                    }

                    Text("Thank You - Please Come Again")
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundStyle(Color(red: 0.06, green: 0.25, blue: 0.55))
                        .padding(.top, 6)
                }
                .padding(14)
            }
            .padding()
        }
    }

    private func formattedDate(short: Bool = false) -> String {
        let df = DateFormatter()
        df.dateFormat = short ? "M/d" : "MM/dd/yyyy"
        return df.string(from: Date())
    }
}

#Preview {
    GuestCheckView()
}


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
