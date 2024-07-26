//
//  Chart1.swift
//  testo2
//
//  Created by Salar Pro on 6/21/24.
//

import Charts
import SwiftUI

struct Chart1: View {

    let dataObj = DDataFormatter(datas: dData)

    let myArray: [DateRange] = [
        .today,
        .thisWeek,
        .past(days: 7),
        .thisMonth,
        .lastMonth,
        .past(days: 30),
        .past(days: 90),
        .monthly,
        .yearly,
        .all,
    ]

    @State var selectedType: DateRange = .today
    @State var days: Float = 1

    var body: some View {
        List {

            Picker("Date Range", selection: $selectedType.animation()) {
                ForEach([
                    DateRange.today,
                    DateRange.thisWeek,
                    .past(days: 7),
                    DateRange.thisMonth,
                ]) { dateRange in
                    Text(dateRange.name).tag(dateRange)
                }
            }
            .pickerStyle(.segmented)
            .padding(0)

            Picker("Date Range", selection: $selectedType.animation()) {
                ForEach([
                    DateRange.lastMonth,
                    DateRange.past(days: 30),
                    DateRange.past(days: 90),
                ]) { dateRange in
                    Text(dateRange.name).tag(dateRange)
                }
            }
            .pickerStyle(.segmented)
            .padding(0)

            Picker("Date Range", selection: $selectedType.animation()) {
                ForEach([
                    DateRange.monthly,
                    DateRange.yearly,
                    DateRange.all,
                ]) { dateRange in
                    Text(dateRange.name).tag(dateRange)
                }
            }
            .pickerStyle(.segmented)
            .padding(0)

            getChart(type: selectedType)

            Slider(value: $days, in: 1...700, step: 1)

            getChart(type: .past(days: Int(days)))

            ForEach(myArray) { dateRange in
                getChart(type: dateRange)
            }

            Section {
                Text("startOfWeek: \(Date().startOfWeek())")
                    .font(.custom("", size: 10))
                Text("firstDayOfMonth: \(Date().firstDayOfMonth())")
                    .font(.custom("", size: 10))
                Text("firstDayOfYear: \(Date().firstDayOfYear())")
                    .font(.custom("", size: 10))
                Text("todayLastSecond: \(Date().todayLastSecond())")
                    .font(.custom("", size: 10))
                Text("todayFirstSecond: \(Date().todayFirstSecond())")
                    .font(.custom("", size: 10))
            }

        }
    }

    func dayCountInRange(startDate: Date?, endDate: Date?) -> Int {
        guard let startDate = startDate, let endDate = endDate else {
            return 0
        }
        let inSeconds =
            abs(startDate.timeIntervalSince1970 - endDate.timeIntervalSince1970)
            / 60 / 60 / 24
        let count = Int(inSeconds) + 1
        return count
    }

    func getChart(type: DateRange) -> some View {
        let filterData = DataFilter().filterData(data: dData, range: type)
        //        var count: [String:Int] = [:]
        //
        //
        //        for data in filterData {
        //            let key:String
        //            if let title = data.title {
        //                key = title
        //            } else {
        //                key = "\(data.date)"
        //            }
        //
        //            if count.keys.contains(key) {
        //                count[key]! += 1
        //            } else {
        //                count[key] = 1
        //            }
        //        }
        //
        //        let maxBarWidth = (UIScreen.main.bounds.width - 64 - 64 - 64 - 64) / CGFloat(count.count)

        let inDays = dayCountInRange(
            startDate: filterData.first?.date, endDate: filterData.last?.date)

        var calendarComponent2: Calendar.Component {
            if inDays <= 1 {
                .hour
            } else if inDays <= 7 {
                .day
            } else if inDays <= 31 {
                .day
            } else if inDays <= 62 {
                .day
            } else if inDays <= 93 {
                .day
            } else if inDays <= 155 {
                .month
            } else if inDays <= 365 {
                .month
            } else if inDays <= 550 {
                .month
            } else {
                .year
            }
        }
        var calendarComponent: Calendar.Component {

            switch type {

            case .today:
                .hour
            case .thisWeek:
                .day
            case .thisMonth:
                .day
            case .lastMonth:
                .day
            case .monthly:
                .month
            case .yearly:
                .year
            case .all:
                .month
            case .past(let days):
                if days <= 7 {
                    .day
                } else if days <= 31 {
                    .day
                } else if days <= 62 {
                    .day
                } else if days <= 93 {
                    .day
                } else if days <= 155 {
                    .month
                } else if days <= 365 {
                    .month
                } else if days <= 550 {
                    .month
                } else {
                    .year
                }
            }
        }

        return Section(
            header: Text(
                "\(type.id), [\(filterData.count)] {\(inDays)} \(calendarComponent2)"
            )
        ) {
            Chart {
                ForEach(filterData) { data in
                    //                    if let title = data.title {
                    //                        BarMark(
                    //                            x: .value("Month", title),
                    //                            y: .value("Amount Spend", data.amount)
                    //                        )
                    //                        .foregroundStyle(by: .value("Name", data.name))
                    //                    } else {

                    BarMark(
                        x: .value(
                            "Date", data.date, unit: calendarComponent2),  //, unit: .day
                        y: .value("Amount Spend", data.amount)
                    )
                    .foregroundStyle(by: .value("Name", data.name))

                    //                    }
                }
            }
            .padding(0)
            .frame(height: 200)

        }
    }
}

#Preview {
    Chart1()
}

struct DData: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var amount: Double
    var date: Date
    var title: String? = nil

    var color: Color {

        switch name {
        case "a1":
            return Color.yellow
        case "a2":
            return Color.red
        case "a3":
            return Color.green
        case "a4":
            return Color.purple
        case "a5":
            return Color.mint
        case "a6":
            return Color.orange
        case "a7":
            return Color.cyan
        case "a8":
            return Color.brown
        default:
            return Color.black
        }
    }
}

var dData: [DData] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateFormatter2 = DateFormatter()
    dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm"

    return [

        //        DData(name: "a1", amount: 25000, date: dateFormatter.date(from: "2024-06-20")!),
        //
        //        DData(name: "a2", amount: 25000, date: dateFormatter.date(from: "2024-06-22")!),
        //
        //        DData(name: "a3", amount: 25000, date: dateFormatter.date(from: "2024-06-21")!),
        //
        //        DData(name: "a4", amount: 25000, date: dateFormatter.date(from: "2024-05-30")!),
        //        DData(name: "a5", amount: 25000, date: dateFormatter.date(from: "2024-04-21")!),
        //

        DData(
            name: "a4", amount: 25000,
            date: dateFormatter.date(from: "2024-04-01")!),
        DData(
            name: "a6", amount: 25000,
            date: dateFormatter.date(from: "2024-04-01")!),
        DData(
            name: "a1", amount: 10000,
            date: dateFormatter.date(from: "2024-04-02")!),
        DData(
            name: "a1", amount: 10000,
            date: dateFormatter.date(from: "2024-04-02")!),
        DData(
            name: "a3", amount: 1000,
            date: dateFormatter.date(from: "2024-04-03")!),
        DData(
            name: "a1", amount: 1000,
            date: dateFormatter.date(from: "2024-04-03")!),
        DData(
            name: "a3", amount: 3000,
            date: dateFormatter.date(from: "2024-04-04")!),
        DData(
            name: "a2", amount: 3000,
            date: dateFormatter.date(from: "2024-04-04")!),
        DData(
            name: "a1", amount: 90000,
            date: dateFormatter.date(from: "2024-04-05")!),
        DData(
            name: "a4", amount: 90000,
            date: dateFormatter.date(from: "2024-04-05")!),
        DData(
            name: "a1", amount: 20000,
            date: dateFormatter.date(from: "2024-04-06")!),
        DData(
            name: "a5", amount: 20000,
            date: dateFormatter.date(from: "2024-04-06")!),
        DData(
            name: "a1", amount: 120000,
            date: dateFormatter.date(from: "2024-04-07")!),
        DData(
            name: "a4", amount: 120000,
            date: dateFormatter.date(from: "2024-04-07")!),
        DData(
            name: "a2", amount: 75300,
            date: dateFormatter.date(from: "2024-04-08")!),
        DData(
            name: "a4", amount: 75300,
            date: dateFormatter.date(from: "2024-04-08")!),
        DData(
            name: "a6", amount: 2000,
            date: dateFormatter.date(from: "2024-04-09")!),
        DData(
            name: "a1", amount: 2000,
            date: dateFormatter.date(from: "2024-04-09")!),
        DData(
            name: "a1", amount: 7000,
            date: dateFormatter.date(from: "2024-04-10")!),
        DData(
            name: "a3", amount: 7000,
            date: dateFormatter.date(from: "2024-04-10")!),
        DData(
            name: "a1", amount: 30000,
            date: dateFormatter.date(from: "2024-04-11")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2024-04-11")!),
        DData(
            name: "a2", amount: 33000,
            date: dateFormatter.date(from: "2024-04-12")!),
        DData(
            name: "a1", amount: 33000,
            date: dateFormatter.date(from: "2024-04-12")!),
        DData(
            name: "a4", amount: 93000,
            date: dateFormatter.date(from: "2024-04-13")!),
        DData(
            name: "a1", amount: 93000,
            date: dateFormatter.date(from: "2024-04-13")!),
        DData(
            name: "a5", amount: 39000,
            date: dateFormatter.date(from: "2024-04-14")!),
        DData(
            name: "a1", amount: 39000,
            date: dateFormatter.date(from: "2024-04-14")!),
        DData(
            name: "a4", amount: 95000,
            date: dateFormatter.date(from: "2024-04-15")!),
        DData(
            name: "a2", amount: 95000,
            date: dateFormatter.date(from: "2024-04-15")!),
        DData(
            name: "a4", amount: 65000,
            date: dateFormatter.date(from: "2024-04-16")!),
        DData(
            name: "a6", amount: 65000,
            date: dateFormatter.date(from: "2024-04-16")!),
        DData(
            name: "a1", amount: 500,
            date: dateFormatter.date(from: "2024-04-17")!),
        DData(
            name: "a1", amount: 500,
            date: dateFormatter.date(from: "2024-04-17")!),
        DData(
            name: "a3", amount: 12000,
            date: dateFormatter.date(from: "2024-04-18")!),
        DData(
            name: "a1", amount: 12000,
            date: dateFormatter.date(from: "2024-04-18")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2024-04-19")!),
        DData(
            name: "a2", amount: 30000,
            date: dateFormatter.date(from: "2024-04-19")!),
        DData(
            name: "a1", amount: 125000,
            date: dateFormatter.date(from: "2024-04-20")!),
        DData(
            name: "a4", amount: 125000,
            date: dateFormatter.date(from: "2024-04-20")!),
        DData(
            name: "a1", amount: 44000,
            date: dateFormatter.date(from: "2024-04-21")!),
        DData(
            name: "a5", amount: 44000,
            date: dateFormatter.date(from: "2024-04-21")!),
        DData(
            name: "a1", amount: 33750,
            date: dateFormatter.date(from: "2024-04-22")!),
        DData(
            name: "a4", amount: 33750,
            date: dateFormatter.date(from: "2024-04-22")!),
        DData(
            name: "a2", amount: 22250,
            date: dateFormatter.date(from: "2024-04-23")!),
        DData(
            name: "a4", amount: 22250,
            date: dateFormatter.date(from: "2024-04-23")!),
        DData(
            name: "a6", amount: 32000,
            date: dateFormatter.date(from: "2024-04-24")!),
        DData(
            name: "a1", amount: 32000,
            date: dateFormatter.date(from: "2024-04-24")!),
        DData(
            name: "a1", amount: 3000,
            date: dateFormatter.date(from: "2024-04-25")!),
        DData(
            name: "a3", amount: 3000,
            date: dateFormatter.date(from: "2024-04-25")!),
        DData(
            name: "a1", amount: 3000,
            date: dateFormatter.date(from: "2024-04-26")!),
        DData(
            name: "a3", amount: 3000,
            date: dateFormatter.date(from: "2024-04-26")!),
        DData(
            name: "a2", amount: 3000,
            date: dateFormatter.date(from: "2024-04-27")!),
        DData(
            name: "a1", amount: 3000,
            date: dateFormatter.date(from: "2024-04-27")!),
        DData(
            name: "a4", amount: 4000,
            date: dateFormatter.date(from: "2024-04-28")!),
        DData(
            name: "a1", amount: 4000,
            date: dateFormatter.date(from: "2024-04-28")!),
        DData(
            name: "a5", amount: 2000,
            date: dateFormatter.date(from: "2024-04-29")!),
        DData(
            name: "a1", amount: 2000,
            date: dateFormatter.date(from: "2024-04-29")!),
        DData(
            name: "a4", amount: 40000,
            date: dateFormatter.date(from: "2024-04-30")!),
        DData(
            name: "a2", amount: 40000,
            date: dateFormatter.date(from: "2024-04-30")!),

        DData(
            name: "a1", amount: 25000,
            date: dateFormatter.date(from: "2024-05-01")!),
        DData(
            name: "a1", amount: 10000,
            date: dateFormatter.date(from: "2024-05-02")!),
        DData(
            name: "a1", amount: 1000,
            date: dateFormatter.date(from: "2024-05-03")!),
        DData(
            name: "a2", amount: 3000,
            date: dateFormatter.date(from: "2024-05-04")!),
        DData(
            name: "a1", amount: 90000,
            date: dateFormatter.date(from: "2024-05-05")!),
        DData(
            name: "a1", amount: 20000,
            date: dateFormatter.date(from: "2024-05-06")!),
        DData(
            name: "a3", amount: 120000,
            date: dateFormatter.date(from: "2024-05-07")!),
        DData(
            name: "a1", amount: 75300,
            date: dateFormatter.date(from: "2024-05-08")!),
        DData(
            name: "a1", amount: 2000,
            date: dateFormatter.date(from: "2024-05-09")!),
        DData(
            name: "a2", amount: 7000,
            date: dateFormatter.date(from: "2024-05-10")!),
        DData(
            name: "a1", amount: 30000,
            date: dateFormatter.date(from: "2024-05-11")!),
        DData(
            name: "a1", amount: 33000,
            date: dateFormatter.date(from: "2024-05-12")!),
        DData(
            name: "a4", amount: 93000,
            date: dateFormatter.date(from: "2024-05-13")!),
        DData(
            name: "a6", amount: 39000,
            date: dateFormatter.date(from: "2024-05-14")!),
        DData(
            name: "a1", amount: 95000,
            date: dateFormatter.date(from: "2024-05-15")!),
        DData(
            name: "a1", amount: 65000,
            date: dateFormatter.date(from: "2024-05-16")!),
        DData(
            name: "a3", amount: 500,
            date: dateFormatter.date(from: "2024-05-17")!),
        DData(
            name: "a1", amount: 12000,
            date: dateFormatter.date(from: "2024-05-18")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2024-05-19")!),
        DData(
            name: "a2", amount: 125000,
            date: dateFormatter.date(from: "2024-05-20")!),
        DData(
            name: "a1", amount: 44000,
            date: dateFormatter.date(from: "2024-05-21")!),
        DData(
            name: "a4", amount: 33750,
            date: dateFormatter.date(from: "2024-05-22")!),
        DData(
            name: "a1", amount: 22250,
            date: dateFormatter.date(from: "2024-05-23")!),
        DData(
            name: "a5", amount: 32000,
            date: dateFormatter.date(from: "2024-05-24")!),
        DData(
            name: "a1", amount: 3000,
            date: dateFormatter.date(from: "2024-05-25")!),
        DData(
            name: "a4", amount: 3000,
            date: dateFormatter.date(from: "2024-05-26")!),
        DData(
            name: "a2", amount: 3000,
            date: dateFormatter.date(from: "2024-05-27")!),
        DData(
            name: "a4", amount: 4000,
            date: dateFormatter.date(from: "2024-05-28")!),
        DData(
            name: "a1", amount: 2000,
            date: dateFormatter.date(from: "2024-05-29")!),
        DData(
            name: "a6", amount: 40000,
            date: dateFormatter.date(from: "2024-05-30")!),
        DData(
            name: "a2", amount: 75000,
            date: dateFormatter.date(from: "2024-05-31")!),

        DData(
            name: "a5", amount: 25000,
            date: dateFormatter.date(from: "2024-06-01")!),
        DData(
            name: "a3", amount: 10000,
            date: dateFormatter.date(from: "2024-06-02")!),
        DData(
            name: "a2", amount: 1000,
            date: dateFormatter.date(from: "2024-06-03")!),
        DData(
            name: "a1", amount: 3000,
            date: dateFormatter.date(from: "2024-06-04")!),
        DData(
            name: "a4", amount: 90000,
            date: dateFormatter.date(from: "2024-06-05")!),
        DData(
            name: "a1", amount: 20000,
            date: dateFormatter.date(from: "2024-06-06")!),
        DData(
            name: "a5", amount: 120000,
            date: dateFormatter.date(from: "2024-06-07")!),
        DData(
            name: "a3", amount: 75300,
            date: dateFormatter.date(from: "2024-06-08")!),
        DData(
            name: "a2", amount: 2000,
            date: dateFormatter.date(from: "2024-06-09")!),
        DData(
            name: "a2", amount: 7000,
            date: dateFormatter.date(from: "2024-06-10")!),
        DData(
            name: "a4", amount: 30000,
            date: dateFormatter.date(from: "2024-06-11")!),
        DData(
            name: "a2", amount: 33000,
            date: dateFormatter.date(from: "2024-06-12")!),
        DData(
            name: "a1", amount: 93000,
            date: dateFormatter.date(from: "2024-06-13")!),
        DData(
            name: "a5", amount: 39000,
            date: dateFormatter.date(from: "2024-06-14")!),
        DData(
            name: "a3", amount: 25000,
            date: dateFormatter.date(from: "2024-06-15")!),
        DData(
            name: "a2", amount: 10000,
            date: dateFormatter.date(from: "2024-06-16")!),
        DData(
            name: "a5", amount: 1000,
            date: dateFormatter.date(from: "2024-06-17")!),
        DData(
            name: "a6", amount: 3000,
            date: dateFormatter.date(from: "2024-06-18")!),
        DData(
            name: "a1", amount: 90000,
            date: dateFormatter.date(from: "2024-06-19")!),
        DData(
            name: "a5", amount: 10000,
            date: dateFormatter.date(from: "2024-06-19")!),
        DData(
            name: "a3", amount: 20000,
            date: dateFormatter.date(from: "2024-06-20")!),
        DData(
            name: "a1", amount: 75300,
            date: dateFormatter.date(from: "2024-06-22")!),
        DData(
            name: "a4", amount: 2000,
            date: dateFormatter2.date(from: "2024-06-23 14:44")!),
        DData(
            name: "a1", amount: 7000,
            date: dateFormatter.date(from: "2024-06-24")!),
        DData(
            name: "a5", amount: 30000,
            date: dateFormatter.date(from: "2024-06-25")!),
        DData(
            name: "a3", amount: 33000,
            date: dateFormatter2.date(from: "2024-06-26 14:22")!),
        DData(
            name: "a2", amount: 93000,
            date: dateFormatter.date(from: "2024-06-27")!),
        DData(
            name: "a2", amount: 39000,
            date: dateFormatter.date(from: "2024-06-28")!),
        DData(
            name: "a4", amount: 95000,
            date: dateFormatter.date(from: "2024-06-29")!),
        DData(
            name: "a2", amount: 65000,
            date: dateFormatter.date(from: "2024-06-30")!),

        DData(
            name: "a5", amount: 500,
            date: dateFormatter.date(from: "2024-06-01")!),
        DData(
            name: "a3", amount: 12000,
            date: dateFormatter.date(from: "2024-06-02")!),
        DData(
            name: "a2", amount: 30000,
            date: dateFormatter.date(from: "2024-06-03")!),
        DData(
            name: "a5", amount: 125000,
            date: dateFormatter.date(from: "2024-06-04")!),
        DData(
            name: "a6", amount: 44000,
            date: dateFormatter.date(from: "2024-06-05")!),
        DData(
            name: "a4", amount: 33750,
            date: dateFormatter.date(from: "2024-06-06")!),
        DData(
            name: "a5", amount: 22250,
            date: dateFormatter.date(from: "2024-06-07")!),
        DData(
            name: "a3", amount: 32000,
            date: dateFormatter.date(from: "2024-06-08")!),
        DData(
            name: "a2", amount: 3000,
            date: dateFormatter.date(from: "2024-06-09")!),
        DData(
            name: "a5", amount: 3000,
            date: dateFormatter.date(from: "2024-06-10")!),
        DData(
            name: "a6", amount: 3000,
            date: dateFormatter.date(from: "2024-06-11")!),
        DData(
            name: "a4", amount: 4000,
            date: dateFormatter.date(from: "2024-06-12")!),
        DData(
            name: "a5", amount: 2000,
            date: dateFormatter.date(from: "2024-06-13")!),
        DData(
            name: "a3", amount: 40000,
            date: dateFormatter.date(from: "2024-06-14")!),
        DData(
            name: "a2", amount: 75000,
            date: dateFormatter.date(from: "2024-06-15")!),
        DData(
            name: "a5", amount: 25000,
            date: dateFormatter.date(from: "2024-06-16")!),
        DData(
            name: "a6", amount: 10000,
            date: dateFormatter.date(from: "2024-06-17")!),
        DData(
            name: "a4", amount: 1000,
            date: dateFormatter.date(from: "2024-06-18")!),
        DData(
            name: "a5", amount: 3000,
            date: dateFormatter.date(from: "2024-06-19")!),
        DData(
            name: "a3", amount: 90000,
            date: dateFormatter.date(from: "2024-06-20")!),
        DData(
            name: "a5", amount: 120000,
            date: dateFormatter.date(from: "2024-06-22")!),
        DData(
            name: "a6", amount: 75300,
            date: dateFormatter.date(from: "2024-06-23")!),
        DData(
            name: "a4", amount: 2000,
            date: dateFormatter.date(from: "2024-06-24")!),
        DData(
            name: "a5", amount: 7000,
            date: dateFormatter.date(from: "2024-06-25")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter2.date(from: "2024-06-26 21:10")!),
        DData(
            name: "a2", amount: 33000,
            date: dateFormatter.date(from: "2024-06-27")!),
        DData(
            name: "a5", amount: 93000,
            date: dateFormatter.date(from: "2024-06-28")!),
        DData(
            name: "a6", amount: 39000,
            date: dateFormatter.date(from: "2024-06-29")!),
        DData(
            name: "a4", amount: 95000,
            date: dateFormatter.date(from: "2024-06-30")!),

        DData(
            name: "a5", amount: 500,
            date: dateFormatter.date(from: "2024-06-01")!),
        DData(
            name: "a3", amount: 12000,
            date: dateFormatter.date(from: "2024-06-02")!),
        DData(
            name: "a2", amount: 30000,
            date: dateFormatter.date(from: "2024-06-03")!),
        DData(
            name: "a2", amount: 125000,
            date: dateFormatter.date(from: "2024-06-04")!),
        DData(
            name: "a4", amount: 44000,
            date: dateFormatter.date(from: "2024-06-05")!),
        DData(
            name: "a2", amount: 33750,
            date: dateFormatter.date(from: "2024-06-06")!),
        DData(
            name: "a1", amount: 22250,
            date: dateFormatter.date(from: "2024-06-07")!),
        DData(
            name: "a5", amount: 32000,
            date: dateFormatter.date(from: "2024-06-08")!),
        DData(
            name: "a3", amount: 3000,
            date: dateFormatter.date(from: "2024-06-09")!),
        DData(
            name: "a5", amount: 3000,
            date: dateFormatter.date(from: "2024-06-10")!),
        DData(
            name: "a3", amount: 3000,
            date: dateFormatter.date(from: "2024-06-11")!),
        DData(
            name: "a2", amount: 4000,
            date: dateFormatter.date(from: "2024-06-12")!),
        DData(
            name: "a2", amount: 2000,
            date: dateFormatter.date(from: "2024-06-13")!),
        DData(
            name: "a4", amount: 40000,
            date: dateFormatter.date(from: "2024-06-14")!),
        DData(
            name: "a2", amount: 75000,
            date: dateFormatter.date(from: "2024-06-15")!),
        DData(
            name: "a1", amount: 25000,
            date: dateFormatter.date(from: "2024-06-16")!),
        DData(
            name: "a5", amount: 10000,
            date: dateFormatter.date(from: "2024-06-17")!),
        DData(
            name: "a3", amount: 1000,
            date: dateFormatter.date(from: "2024-06-18")!),
        DData(
            name: "a5", amount: 3000,
            date: dateFormatter.date(from: "2024-06-19")!),
        DData(
            name: "a3", amount: 90000,
            date: dateFormatter.date(from: "2024-06-20")!),

        DData(
            name: "a1", amount: 20000,
            date: dateFormatter2.date(from: "2024-06-21 10:14")!),
        DData(
            name: "a2", amount: 20000,
            date: dateFormatter2.date(from: "2024-06-21 11:12")!),
        DData(
            name: "a4", amount: 120000,
            date: dateFormatter2.date(from: "2024-06-21 12:32")!),
        DData(
            name: "a3", amount: 20000,
            date: dateFormatter2.date(from: "2024-06-21 13:14")!),
        DData(
            name: "a5", amount: 20000,
            date: dateFormatter2.date(from: "2024-06-21 23:15")!),

        DData(
            name: "a2", amount: 120000,
            date: dateFormatter.date(from: "2024-06-22")!),
        DData(
            name: "a4", amount: 75300,
            date: dateFormatter.date(from: "2024-06-23")!),
        DData(
            name: "a2", amount: 2000,
            date: dateFormatter.date(from: "2024-06-24")!),
        DData(
            name: "a1", amount: 7000,
            date: dateFormatter.date(from: "2024-06-25")!),
        DData(
            name: "a5", amount: 30000,
            date: dateFormatter2.date(from: "2024-06-26 08:10")!),
        DData(
            name: "a3", amount: 33000,
            date: dateFormatter.date(from: "2024-06-27")!),
        DData(
            name: "a5", amount: 93000,
            date: dateFormatter.date(from: "2024-06-28")!),
        DData(
            name: "a3", amount: 39000,
            date: dateFormatter.date(from: "2024-06-29")!),
        DData(
            name: "a2", amount: 95000,
            date: dateFormatter.date(from: "2024-06-30")!),

        DData(
            name: "a1", amount: 500,
            date: dateFormatter.date(from: "2024-07-01")!),
        DData(
            name: "a2", amount: 12000,
            date: dateFormatter.date(from: "2024-07-02")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2024-07-03")!),
        DData(
            name: "a2", amount: 125000,
            date: dateFormatter.date(from: "2024-07-04")!),
        DData(
            name: "a1", amount: 44000,
            date: dateFormatter.date(from: "2024-07-05")!),
        DData(
            name: "a3", amount: 33750,
            date: dateFormatter.date(from: "2024-07-06")!),
        DData(
            name: "a2", amount: 22250,
            date: dateFormatter.date(from: "2024-07-07")!),
        DData(
            name: "a4", amount: 32000,
            date: dateFormatter.date(from: "2024-07-08")!),
        DData(
            name: "a4", amount: 3000,
            date: dateFormatter.date(from: "2024-07-09")!),
        DData(
            name: "a7", amount: 3000,
            date: dateFormatter.date(from: "2024-07-10")!),
        DData(
            name: "a6", amount: 3000,
            date: dateFormatter.date(from: "2024-07-11")!),
        DData(
            name: "a5", amount: 4000,
            date: dateFormatter.date(from: "2024-07-12")!),
        DData(
            name: "a3", amount: 2000,
            date: dateFormatter.date(from: "2024-07-13")!),
        DData(
            name: "a2", amount: 40000,
            date: dateFormatter.date(from: "2024-07-14")!),
        DData(
            name: "a1", amount: 75000,
            date: dateFormatter.date(from: "2024-07-15")!),
        DData(
            name: "a4", amount: 25000,
            date: dateFormatter.date(from: "2024-07-16")!),
        DData(
            name: "a1", amount: 10000,
            date: dateFormatter.date(from: "2024-07-17")!),
        DData(
            name: "a5", amount: 1000,
            date: dateFormatter.date(from: "2024-07-18")!),
        DData(
            name: "a3", amount: 3000,
            date: dateFormatter.date(from: "2024-07-19")!),
        DData(
            name: "a2", amount: 90000,
            date: dateFormatter.date(from: "2024-07-20")!),
        DData(
            name: "a2", amount: 20000,
            date: dateFormatter.date(from: "2024-07-21")!),
        DData(
            name: "a4", amount: 120000,
            date: dateFormatter.date(from: "2024-07-22")!),
        DData(
            name: "a2", amount: 75300,
            date: dateFormatter.date(from: "2024-07-23")!),
        DData(
            name: "a1", amount: 2000,
            date: dateFormatter.date(from: "2024-07-24")!),
        DData(
            name: "a5", amount: 7000,
            date: dateFormatter.date(from: "2024-07-25")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2024-07-26")!),
        DData(
            name: "a2", amount: 33000,
            date: dateFormatter.date(from: "2024-07-27")!),
        DData(
            name: "a5", amount: 93000,
            date: dateFormatter.date(from: "2024-07-28")!),
        DData(
            name: "a6", amount: 39000,
            date: dateFormatter.date(from: "2024-07-29")!),
        DData(
            name: "a1", amount: 95000,
            date: dateFormatter.date(from: "2024-07-30")!),
        DData(
            name: "a7", amount: 65000,
            date: dateFormatter.date(from: "2024-07-31")!),

        DData(
            name: "a1", amount: 500,
            date: dateFormatter.date(from: "2024-08-01")!),
        DData(
            name: "a2", amount: 12000,
            date: dateFormatter.date(from: "2024-08-02")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2024-08-03")!),
        DData(
            name: "a2", amount: 125000,
            date: dateFormatter.date(from: "2024-08-04")!),
        DData(
            name: "a1", amount: 44000,
            date: dateFormatter.date(from: "2024-08-05")!),
        DData(
            name: "a3", amount: 33750,
            date: dateFormatter.date(from: "2024-08-06")!),
        DData(
            name: "a2", amount: 22250,
            date: dateFormatter.date(from: "2024-08-07")!),
        DData(
            name: "a4", amount: 32000,
            date: dateFormatter.date(from: "2024-08-08")!),
        DData(
            name: "a4", amount: 3000,
            date: dateFormatter.date(from: "2024-08-09")!),
        DData(
            name: "a7", amount: 3000,
            date: dateFormatter.date(from: "2024-08-10")!),
        DData(
            name: "a6", amount: 3000,
            date: dateFormatter.date(from: "2024-08-11")!),
        DData(
            name: "a5", amount: 4000,
            date: dateFormatter.date(from: "2024-08-12")!),
        DData(
            name: "a3", amount: 2000,
            date: dateFormatter.date(from: "2024-08-13")!),
        DData(
            name: "a2", amount: 40000,
            date: dateFormatter.date(from: "2024-08-14")!),
        DData(
            name: "a1", amount: 75000,
            date: dateFormatter.date(from: "2024-08-15")!),
        DData(
            name: "a4", amount: 25000,
            date: dateFormatter.date(from: "2024-08-16")!),
        DData(
            name: "a1", amount: 10000,
            date: dateFormatter.date(from: "2024-08-17")!),
        DData(
            name: "a5", amount: 1000,
            date: dateFormatter.date(from: "2024-08-18")!),
        DData(
            name: "a3", amount: 3000,
            date: dateFormatter.date(from: "2024-08-19")!),
        DData(
            name: "a2", amount: 90000,
            date: dateFormatter.date(from: "2024-08-20")!),
        DData(
            name: "a2", amount: 20000,
            date: dateFormatter.date(from: "2024-08-21")!),
        DData(
            name: "a4", amount: 120000,
            date: dateFormatter.date(from: "2024-08-22")!),
        DData(
            name: "a2", amount: 75300,
            date: dateFormatter.date(from: "2024-08-23")!),
        DData(
            name: "a1", amount: 2000,
            date: dateFormatter.date(from: "2024-08-24")!),
        DData(
            name: "a5", amount: 7000,
            date: dateFormatter.date(from: "2024-08-25")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2024-08-26")!),
        DData(
            name: "a2", amount: 33000,
            date: dateFormatter.date(from: "2024-08-27")!),
        DData(
            name: "a5", amount: 93000,
            date: dateFormatter.date(from: "2024-08-28")!),
        DData(
            name: "a6", amount: 39000,
            date: dateFormatter.date(from: "2024-08-29")!),
        DData(
            name: "a1", amount: 95000,
            date: dateFormatter.date(from: "2024-08-30")!),
        DData(
            name: "a7", amount: 65000,
            date: dateFormatter.date(from: "2024-08-31")!),

        ///////////////////
        ///

        DData(
            name: "a4", amount: 25000,
            date: dateFormatter.date(from: "2023-04-01")!),
        DData(
            name: "a6", amount: 25000,
            date: dateFormatter.date(from: "2023-04-01")!),
        DData(
            name: "a1", amount: 10000,
            date: dateFormatter.date(from: "2023-04-02")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2023-04-11")!),
        DData(
            name: "a2", amount: 33000,
            date: dateFormatter.date(from: "2023-04-12")!),
        DData(
            name: "a1", amount: 33000,
            date: dateFormatter.date(from: "2023-04-12")!),
        DData(
            name: "a4", amount: 93000,
            date: dateFormatter.date(from: "2023-04-13")!),
        DData(
            name: "a1", amount: 93000,
            date: dateFormatter.date(from: "2023-04-13")!),
        DData(
            name: "a5", amount: 39000,
            date: dateFormatter.date(from: "2023-04-14")!),
        DData(
            name: "a4", amount: 40000,
            date: dateFormatter.date(from: "2023-04-30")!),
        DData(
            name: "a2", amount: 40000,
            date: dateFormatter.date(from: "2023-04-30")!),

        DData(
            name: "a1", amount: 25000,
            date: dateFormatter.date(from: "2023-05-01")!),
        DData(
            name: "a1", amount: 10000,
            date: dateFormatter.date(from: "2023-05-02")!),
        DData(
            name: "a4", amount: 3000,
            date: dateFormatter.date(from: "2023-05-26")!),
        DData(
            name: "a2", amount: 3000,
            date: dateFormatter.date(from: "2023-05-27")!),
        DData(
            name: "a4", amount: 4000,
            date: dateFormatter.date(from: "2023-05-28")!),
        DData(
            name: "a1", amount: 2000,
            date: dateFormatter.date(from: "2023-05-29")!),
        DData(
            name: "a6", amount: 40000,
            date: dateFormatter.date(from: "2023-05-30")!),
        DData(
            name: "a2", amount: 75000,
            date: dateFormatter.date(from: "2023-05-31")!),

        DData(
            name: "a5", amount: 25000,
            date: dateFormatter.date(from: "2023-06-01")!),
        DData(
            name: "a3", amount: 10000,
            date: dateFormatter.date(from: "2023-06-02")!),
        DData(
            name: "a2", amount: 1000,
            date: dateFormatter.date(from: "2023-06-03")!),
        DData(
            name: "a1", amount: 3000,
            date: dateFormatter.date(from: "2023-06-04")!),
        DData(
            name: "a4", amount: 2000,
            date: dateFormatter.date(from: "2023-06-23")!),
        DData(
            name: "a1", amount: 7000,
            date: dateFormatter.date(from: "2023-06-24")!),
        DData(
            name: "a5", amount: 30000,
            date: dateFormatter.date(from: "2023-06-25")!),
        DData(
            name: "a3", amount: 33000,
            date: dateFormatter.date(from: "2023-06-26")!),
        DData(
            name: "a2", amount: 93000,
            date: dateFormatter.date(from: "2023-06-27")!),
        DData(
            name: "a2", amount: 39000,
            date: dateFormatter.date(from: "2023-06-28")!),
        DData(
            name: "a4", amount: 95000,
            date: dateFormatter.date(from: "2023-06-29")!),
        DData(
            name: "a2", amount: 65000,
            date: dateFormatter.date(from: "2023-06-30")!),

        DData(
            name: "a5", amount: 500,
            date: dateFormatter.date(from: "2023-06-01")!),
        DData(
            name: "a3", amount: 12000,
            date: dateFormatter.date(from: "2023-06-02")!),
        DData(
            name: "a2", amount: 30000,
            date: dateFormatter.date(from: "2023-06-03")!),
        DData(
            name: "a5", amount: 125000,
            date: dateFormatter.date(from: "2023-06-04")!),
        DData(
            name: "a6", amount: 44000,
            date: dateFormatter.date(from: "2023-06-05")!),
        DData(
            name: "a4", amount: 33750,
            date: dateFormatter.date(from: "2023-06-06")!),
        DData(
            name: "a6", amount: 39000,
            date: dateFormatter.date(from: "2023-06-29")!),
        DData(
            name: "a4", amount: 95000,
            date: dateFormatter.date(from: "2023-06-30")!),

        DData(
            name: "a5", amount: 500,
            date: dateFormatter.date(from: "2023-06-01")!),
        DData(
            name: "a3", amount: 12000,
            date: dateFormatter.date(from: "2023-06-02")!),
        DData(
            name: "a2", amount: 30000,
            date: dateFormatter.date(from: "2023-06-03")!),
        DData(
            name: "a2", amount: 125000,
            date: dateFormatter.date(from: "2023-06-04")!),
        DData(
            name: "a4", amount: 44000,
            date: dateFormatter.date(from: "2023-06-05")!),
        DData(
            name: "a2", amount: 33750,
            date: dateFormatter.date(from: "2023-06-06")!),
        DData(
            name: "a2", amount: 120000,
            date: dateFormatter.date(from: "2023-06-22")!),
        DData(
            name: "a4", amount: 75300,
            date: dateFormatter.date(from: "2023-06-23")!),
        DData(
            name: "a2", amount: 2000,
            date: dateFormatter.date(from: "2023-06-24")!),
        DData(
            name: "a1", amount: 7000,
            date: dateFormatter.date(from: "2023-06-25")!),
        DData(
            name: "a5", amount: 30000,
            date: dateFormatter.date(from: "2023-06-26")!),
        DData(
            name: "a3", amount: 33000,
            date: dateFormatter.date(from: "2023-06-27")!),
        DData(
            name: "a5", amount: 93000,
            date: dateFormatter.date(from: "2023-06-28")!),
        DData(
            name: "a3", amount: 39000,
            date: dateFormatter.date(from: "2023-06-29")!),
        DData(
            name: "a2", amount: 95000,
            date: dateFormatter.date(from: "2023-06-30")!),

        DData(
            name: "a1", amount: 500,
            date: dateFormatter.date(from: "2023-07-01")!),
        DData(
            name: "a2", amount: 12000,
            date: dateFormatter.date(from: "2023-07-02")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2023-07-03")!),
        DData(
            name: "a2", amount: 125000,
            date: dateFormatter.date(from: "2023-07-04")!),
        DData(
            name: "a1", amount: 44000,
            date: dateFormatter.date(from: "2023-07-05")!),
        DData(
            name: "a5", amount: 93000,
            date: dateFormatter.date(from: "2023-07-28")!),
        DData(
            name: "a6", amount: 39000,
            date: dateFormatter.date(from: "2023-07-29")!),
        DData(
            name: "a1", amount: 95000,
            date: dateFormatter.date(from: "2023-07-30")!),
        DData(
            name: "a7", amount: 65000,
            date: dateFormatter.date(from: "2023-07-31")!),

        DData(
            name: "a1", amount: 500,
            date: dateFormatter.date(from: "2023-08-01")!),
        DData(
            name: "a2", amount: 12000,
            date: dateFormatter.date(from: "2023-08-02")!),
        DData(
            name: "a3", amount: 30000,
            date: dateFormatter.date(from: "2023-08-03")!),
        DData(
            name: "a2", amount: 125000,
            date: dateFormatter.date(from: "2023-08-04")!),
        DData(
            name: "a1", amount: 44000,
            date: dateFormatter.date(from: "2023-08-05")!),
        DData(
            name: "a3", amount: 33750,
            date: dateFormatter.date(from: "2023-08-06")!),
        DData(
            name: "a2", amount: 22250,
            date: dateFormatter.date(from: "2023-08-07")!),
        DData(
            name: "a4", amount: 32000,
            date: dateFormatter.date(from: "2023-08-08")!),
        DData(
            name: "a1", amount: 95000,
            date: dateFormatter.date(from: "2023-08-30")!),
        DData(
            name: "a7", amount: 65000,
            date: dateFormatter.date(from: "2023-08-31")!),

//        DData(
//            name: "a3", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a1", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a1", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a5", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a3", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-05-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a3", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a1", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a1", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a5", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a3", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-06-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a7", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a6", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a5", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a3", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a1", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-08-1")!),
//        DData(
//            name: "a1", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a5", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a3", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a2", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a4", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a7", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a6", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),
//        DData(
//            name: "a5", amount: 65000,
//            date: dateFormatter.date(from: "2022-07-1")!),

    ]
}

class DDataFormatter {
    var datas: [DData]

    init(datas: [DData]) {
        self.datas = datas
    }

    func get(from type: Calendar.Component) -> [DData] {
        let thisMonth = Calendar.current.component(type, from: Date())

        return datas.filter { dData in
            Calendar.current.component(type, from: dData.date) == thisMonth
        }
    }
}

class DataFilter {

    // Function to filter data by date range
    func filterData(data: [DData], range: DateRange) -> [DData] {
        var filteredData = [DData]()

        switch range {
        case .thisMonth:
            filteredData = filterByMonth(data: data)
        case .today:
            filteredData = filterByDay(data: data)
        case .thisWeek:
            filteredData = filterByWeek(data: data)
        case .yearly:
            filteredData = filterByYear(data: data)
        case .monthly:
            filteredData = filterByMonthly(data: data)
        case .lastMonth:
            filteredData = filterByLastMonth(data: data)
        case .past(let days):
            filteredData = filterByPast(days: days, data: data)

        case .all:
            var mData = data
            let calendar = Calendar.current
            for index in 0..<mData.count {
                mData[index].title =
                    "\(mData[index].date.monthName)/\(calendar.component(.year, from: mData[index].date)-2000)"
            }
            filteredData = mData
        }

        return filteredData.sorted(by: { $0.date < $1.date })
    }

    private func filterByPast(days: Int, data: [DData]) -> [DData] {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(
            TimeInterval(-(days - 1) * 86400))
        return data.filter {
            $0.date.isBetweenDays(start: startDate, end: endDate)
        }
    }

    private func filterByDay(data: [DData]) -> [DData] {
        // Filter data to include only items within the current day
        return data.filter {
            Calendar.current.isDate($0.date, inSameDayAs: Date())
        }
    }

    private func filterByWeek(data: [DData]) -> [DData] {
        let endDate = Date()
        let startDate = endDate.startOfWeek()
        return data.filter {
            $0.date.isBetweenDays(start: startDate, end: endDate)
        }
    }

    private func filterByMonth(data: [DData]) -> [DData] {
        let endDate = Date()
        let startDate = endDate.firstDayOfMonth()
        return data.filter {
            $0.date.isBetweenDays(start: startDate, end: endDate)
        }
    }

    private func filterByLastMonth(data: [DData]) -> [DData] {
        let startDate = Date().firstDayOfPreviousMonth
        let endDate = startDate.lastDayOfMonth
        return data.filter {
            $0.date.isBetweenDays(start: startDate, end: endDate)
        }
    }

    private func filterByMonthly(data: [DData]) -> [DData] {
        return data
    }

    private func filterByYear(data: [DData]) -> [DData] {
        return data
    }
}
// Enum for date range options
enum DateRange: CaseIterable, Identifiable, Hashable {
    static var allCases: [DateRange] = [
        .today, .thisWeek, .thisMonth, .lastMonth,
        .monthly, .yearly, .all,
    ]

    var id: String {
        switch self {
        case .today: return "Today"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        case .lastMonth: return "Last Month"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .all: return "All"
        case .past(let days): return "Past \(days) Days"
        }
    }

    var name: String {
        switch self {
        case .today: return "Today"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        case .lastMonth: return "Last Month"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .all: return "All"
        case .past(let days): return "Past \(days) Days"
        }
    }

    case today
    case thisWeek
    case thisMonth
    case lastMonth
    case monthly
    case yearly
    case all
    case past(days: Int)

    public static func == (a: DateRange, b: DateRange) -> Bool {
        if a.id == b.id {
            return true
        }
        return false
    }

}

extension Double {
    func formattedCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return formattedString
        }

        return "\(self)"
    }

    func formattedCurrencyWithK() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1

        let number = self  // Replace with your actual number

        if number < 1000 {
            return "\(number)"
        } else if number < 1_000_000 {
            let formattedNumber = numberFormatter.string(
                from: NSNumber(value: Double(number) / 1000))!
            return "\(formattedNumber)K"
        } else {
            let formattedNumber = numberFormatter.string(
                from: NSNumber(value: Double(number) / 1_000_000))!
            return "\(formattedNumber)M"
        }
    }
}

extension Date {
    func isBetweenDays(start: Date, end: Date) -> Bool {

        let startT = start.todayFirstSecond()
        let endT = end.todayLastSecond()

        let currentTime = self

        if currentTime >= startT && currentTime <= endT {
            return true
        }
        return false
    }

    func firstDayOfMonth() -> Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: self))!
    }

    func startOfWeek() -> Date {
        let calendar = Calendar.current
        return calendar.dateComponents(
            [.calendar, .yearForWeekOfYear, .weekOfYear], from: self
        ).date!
    }

    func firstDayOfYear() -> Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents([.year], from: self))!
    }

    func lastDayOfYear() -> Date {
        let calendar = Calendar.current

        // Extract year, month, and day components from the input date
        let components = calendar.dateComponents([.year], from: self)

        // Define the new components for 23:59:59
        var lastDayOfTheYear = DateComponents()
        lastDayOfTheYear.year = (components.year ?? 2024) + 1
        lastDayOfTheYear.month = 12
        lastDayOfTheYear.day = 31
        lastDayOfTheYear.hour = 23
        lastDayOfTheYear.minute = 59
        lastDayOfTheYear.second = 59
        lastDayOfTheYear.nanosecond = 999

        // Create the date object for the last second of the day
        let lastSecondDate = calendar.date(from: lastDayOfTheYear)

        return lastSecondDate ?? self
    }

    func todayLastSecond() -> Date {
        let calendar = Calendar.current

        // Extract year, month, and day components from the input date
        let components = calendar.dateComponents(
            [.year, .month, .day], from: self)

        // Define the new components for 23:59:59
        var lastSecondComponents = DateComponents()
        lastSecondComponents.year = components.year
        lastSecondComponents.month = components.month
        lastSecondComponents.day = components.day
        lastSecondComponents.hour = 23
        lastSecondComponents.minute = 59
        lastSecondComponents.second = 59
        lastSecondComponents.nanosecond = 999

        // Create the date object for the last second of the day
        let lastSecondDate = calendar.date(from: lastSecondComponents)

        return lastSecondDate ?? self
    }

    func todayFirstSecond() -> Date {
        let calendar = Calendar.current

        let components = calendar.dateComponents(
            [.year, .month, .day], from: self)

        var firstSecondComponents = DateComponents()
        firstSecondComponents.year = components.year
        firstSecondComponents.month = components.month
        firstSecondComponents.day = components.day
        firstSecondComponents.hour = 0
        firstSecondComponents.minute = 0
        firstSecondComponents.second = 0
        firstSecondComponents.nanosecond = 0

        let firstSecondDate = calendar.date(from: firstSecondComponents)

        return firstSecondDate ?? self
    }

    var monthName: String {
        let dateFormatter = DateFormatter()

        // Set the desired date format to get the full month name
        dateFormatter.dateFormat = "M"  // e.g., "January", "February"

        // Extract the month name from the date
        return dateFormatter.string(from: self)
    }

    var firstDayOfPreviousMonth: Date {
        let calendar = Calendar.current

        // Get the current date components (year and month)
        var components = calendar.dateComponents([.year, .month], from: self)

        // Subtract one month
        components.month = (components.month ?? 1) - 1

        // Adjust year if month becomes less than 1 (i.e., move from January to December of the previous year)
        if components.month == 0 {
            components.month = 12
            components.year = (components.year ?? 1) - 1
        }

        // Set the day to the first
        components.day = 1

        // Return the new date
        return calendar.date(from: components) ?? self
    }

    var lastDayOfMonth: Date {
        let calendar = Calendar.current

        // Get the current date components (year and month)
        var components = calendar.dateComponents([.year, .month], from: self)

        // Set the day to a large number to get the last day of the month
        components.day = calendar.range(of: .day, in: .month, for: self)?.count

        // Return the new date
        return calendar.date(from: components) ?? self
    }

}
