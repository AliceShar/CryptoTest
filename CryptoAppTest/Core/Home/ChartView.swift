//
//  ChartView.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 29.10.2024.
//

import SwiftUI
import Charts

struct FinanceChartView: View {
    
    @EnvironmentObject var providersVM: ProvidersViewModel
    @State private var selectedX: Date? = nil

    let geo: GeometryProxy
    
    var body: some View {
        ZStack {
            Color.primaryColor.ignoresSafeArea()
            
            if providersVM.pricesIsLoading {
                
                ProgressView()
                    .tint(Color.accentColor)
                
            } else if let firstDate = providersVM.historicalPricesOfObject.first?.date,
                      let lastDate = providersVM.historicalPricesOfObject.last?.date {
                VStack {
                    chart
                        .chartXAxis { chartXAxis }
                        .chartXScale(domain: firstDate...lastDate)
                        .chartYAxis { chartYAxis }
                        .chartYScale(
                            domain: (providersVM.historicalPricesOfObject.map { $0.low }.min() ?? 0)...(providersVM.historicalPricesOfObject.map { $0.high }.max() ?? 1)
                        )
                        .chartPlotStyle { chartPlotStyle($0) }
                        .chartOverlay { proxy in
                            GeometryReader { gProxy in
                                Rectangle()
                                    .fill(Color.clear)
                                    .contentShape(Rectangle())
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                onChangeDrag(value: value, chartProxy: proxy, geometryProxy: gProxy)
                                            }
                                            .onEnded { _ in
                                                self.selectedX = nil
                                            }
                                    )
                            }
                        }
                }
            } else {
                Text("No data available")
                    .foregroundColor(.gray)
            }
        }
        .frame(width: geo.size.width, height: geo.size.height / 3)
  }

    private var chart: some View {
        Chart {
            ForEach(providersVM.historicalPricesOfObject) { item in
                // Candle body
                RectangleMark(
                    x: .value("Date", item.date!),
                    yStart: .value("Open", item.open),
                    yEnd: .value("Close", item.close)
                )
                .foregroundStyle(item.close >= item.open ? Color.greenColor : Color.redColor)
                // High and Low lines
                LineMark(
                    x: .value("Date", item.date!),
                    y: .value("High", item.high)
                )
                .foregroundStyle(Color.accentColor)
                .lineStyle(.init(lineWidth: 1))

                LineMark(
                    x: .value("Date", item.date!),
                    y: .value("Low", item.low)
                )
                .foregroundStyle(Color.accentColor)
                .lineStyle(.init(lineWidth: 1))
                
                // Selected X line and annotation
                if let selectedX = selectedX, Calendar.current.isDate(selectedX, inSameDayAs: item.date!)  {
                    RuleMark(x: .value("Selected timestamp", item.date!))
                        .lineStyle(.init(lineWidth: 1))
                        .annotation(position: annotationPosition(for: item.date!, firstDate: providersVM.historicalPricesOfObject.first!.date!, lastDate: providersVM.historicalPricesOfObject.last!.date!)){
                            VStack {
                                Text("\(item.close, specifier: "%.3f")")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.accentColor)
                                
                                if let date = item.date {
                                    Text("\(date.fromParametersFormattedString())")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.lightGray)
                                }
                            }
                        }
                        .foregroundStyle(Color.lightGray)
                }
            }
        }
    }

    private var chartXAxis: some AxisContent {
        AxisMarks(values: .stride(by: .day)) { value in
            AxisGridLine(stroke: .init(lineWidth: 0.3))
            AxisTick(stroke: .init(lineWidth: 0.3))
            AxisValueLabel(collisionResolution: .greedy()) {
                if let date = value.as(Date.self) {
                    Text(date, format: .dateTime.day().month().year())
                        .foregroundColor(.gray)
                        .font(.caption.bold())
                }
            }
        }
    }

    private var chartYAxis: some AxisContent {
        let minY = providersVM.historicalPricesOfObject.map { $0.low }.min() ?? 0
            let maxY = providersVM.historicalPricesOfObject.map { $0.high }.max() ?? 1
            
            let midY1 = (minY + maxY) / 2
            let midY2 = (minY + midY1) / 2
            let midY3 = (maxY + midY1) / 2

            return AxisMarks(values: [minY, midY2, midY1, midY3, maxY]) { value in
                AxisGridLine(stroke: .init(lineWidth: 0.3))
                AxisTick(stroke: .init(lineWidth: 0.3))
                AxisValueLabel(anchor: .topLeading, collisionResolution: .greedy) {
                    Text("\(value.as(Double.self) ?? 0, specifier: "%.3f")")
                        .foregroundColor(Color.lightGray)
                        .font(.caption.bold())
                }
            }
    }

    private func chartPlotStyle(_ plotContent: ChartPlotContent) -> some View {
        plotContent
            .frame(height: geo.size.height / 3)
            .overlay {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.5))
                    .mask(ZStack {
                        VStack {
                            Spacer()
                            Rectangle().frame(height: 1)
                        }
                        
                        HStack {
                            Spacer()
                            Rectangle().frame(width: 0.3)
                        }
                    })
            }
    }

    private func onChangeDrag(value: DragGesture.Value, chartProxy: ChartProxy, geometryProxy: GeometryProxy) {
        let plotAreaOriginX = geometryProxy[chartProxy.plotFrame!].origin.x
              let xCurrent = value.location.x - plotAreaOriginX

              if let date: Date = chartProxy.value(atX: xCurrent) {
                  print("Selected date: \(date)")
                  self.selectedX = date
              } else {
                  print("No date found at xCurrent: \(xCurrent)")
              }
    }
    
    private func annotationPosition(for selectedDate: Date, firstDate: Date, lastDate: Date) -> AnnotationPosition {
        let totalDuration = lastDate.timeIntervalSince(firstDate)
        let selectedDuration = selectedDate.timeIntervalSince(firstDate)
        let position = selectedDuration / totalDuration
        switch position {
        case ..<0.3:
            return .topTrailing
        case 0.3..<0.7:
            return .top
        default:
            return .topLeading 
        }
    }
}


#Preview {
    GeometryReader { geo in
        FinanceChartView(geo: geo)
            .environmentObject(ProvidersViewModel(providersManager: ProvidersManager(), socketClient: SocketClient()))
    }
}


