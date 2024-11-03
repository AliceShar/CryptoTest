//
//  HomeView.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 29.10.2024.
//

import SwiftUI
import AlertToast

struct HomeView: View {
    @EnvironmentObject var providersVM: ProvidersViewModel
    @State private var showDropdown = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ZStack {
                    Color.primaryColor.ignoresSafeArea()
                    
                    if providersVM.providersIsLoading {
                        ProgressView()
                            .tint(Color.accentColor)
                    } else {
                        VStack(spacing: 20) {
                            currencyDropdown(geo: geo)
                            marketDataSection
                            chartingDataSection(geo: geo)
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
        }
        .onAppear {
            providersVM.configureObservers()
            providersVM.getProviders()
            providersVM.connectSocket()
        }
        .onDisappear {
            providersVM.unsubscribeFromObservers()
        }
        .toast(
            isPresenting: $providersVM.alertIsShown,
            duration: 2,
            offsetY: CGFloat(signOf: 0, magnitudeOf: -10)
        ) {
            providersVM.alertToast
        }
    }
}
// MARK: - Subviews

extension HomeView {
    private func currencyDropdown(geo: GeometryProxy) -> some View {
        ZStack {
            PrimaryButton(title: "Retry", action: {
                providersVM.getMarketData()
            }, isLoading: .constant(false))
            .padding(.horizontal, 40)
            
            HStack(spacing: 20) {
                DropDownMenu(
                    options: providersVM.providers ?? [],
                    geo: geo,
                    selectedOption: $providersVM.selectedCurrency,
                    showDropdown: $showDropdown,
                    cannotSelectCurrency: $providersVM.cannotSelectCurrency
                )
                
                Text("Choose currency")
                    .withDefaultTextFormatting(textSixe: .headline, isBold: true)
            }
            .padding(.top, 150)
        }
    }

    private var marketDataSection: some View {
            VStack(spacing: 10) {
                Text("Market data:")
                    .withDefaultTextFormatting(textSixe: .headline, isBold: true)
                    .padding(.horizontal)

                HStack {
                    marketDataItem(title: "Symbol:", value: providersVM.selectedCurrency?.symbol ?? "-")
                    Spacer()
                    marketDataItem(title: "Price:", value: providersVM.marketDataIsLoading ? "loading.." : String(format: "%.3f", providersVM.recievedCurrencyData?.last.price ?? 0))
                    Spacer()
                    marketDataItem(title: "Time:", value: providersVM.marketDataIsLoading ? "loading.." : providersVM.recievedCurrencyData?.last.timestamp.parseToDateString() ?? "-")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.lightGray, lineWidth: 1))
                .padding(.horizontal, 20)
            }
        }
        
        private func marketDataItem(title: String, value: String) -> some View {
            VStack(alignment: .center) {
                Text(title)
                    .withDefaultTextFormatting(textSixe: .subheadline, isBold: false, color: Color.secondaryColor)
                    .frame(width: 80)
                Text(value)
                    .withDefaultTextFormatting(textSixe: .headline, isBold: true)
            }
        }
    
    private func chartingDataSection(geo: GeometryProxy) -> some View {
            VStack {
                Text("Charting data:")
                    .withDefaultTextFormatting(textSixe: .headline, isBold: true)
                    .padding([.horizontal, .bottom])
                
                FinanceChartView(geo: geo)
                    .padding([.horizontal])
                    .padding(.vertical, 30)
            }
        }
}


#Preview {
    HomeView()
}
