//
//  DropDownMenu.swift
//  CryptoAppTest
//
//  Created by Alice Sharova on 31.10.2024.
//

import SwiftUI

struct DropDownMenu: View {
    
    var options: [Instrument]
    let geo: GeometryProxy

    var buttonHeight: CGFloat = 50
    var maxItemDisplayed: Int = 3
    
    @Binding var selectedOption: Instrument?
    @Binding var showDropdown: Bool
    @Binding var cannotSelectCurrency: Bool
    
    @State private var scrollPosition: Int?
    
    var body: some View {
           VStack {
               VStack(spacing: 0) {
                   if showDropdown {
                       let scrollViewHeight: CGFloat = options.count > maxItemDisplayed ? (buttonHeight * CGFloat(maxItemDisplayed)) : (buttonHeight * CGFloat(options.count))
                       ScrollView {
                           LazyVStack(spacing: 0) {
                               ForEach(0..<options.count, id: \.self) { index in
                                   Button(action: {
                                       guard showDropdown && !cannotSelectCurrency else { return }
                                       withAnimation {
                                               selectedOption = options[index]
                                               showDropdown = false
                                         }
                                   }, label: {
                                       HStack {
                                           Text(options[index].symbol)
                                           Spacer()
                                           if options[index].id == selectedOption?.id {
                                               Image(systemName: "checkmark.circle.fill")
                                           }
                                       }
                                   })
                                   .padding(.horizontal, 20)
                                   .frame(width: geo.size.width / 2, height: buttonHeight, alignment: .leading)
                               }
                           }
                           .scrollTargetLayout()
                       }
                       .scrollPosition(id: $scrollPosition)
                       .scrollDisabled(options.count <= maxItemDisplayed)
                       .frame(height: scrollViewHeight)
                       .onAppear {
                           if let selectedIndex = options.firstIndex(where: { $0.id == selectedOption?.id }) {
                               scrollPosition = selectedIndex
                           }
                       }
                   }
                   
                   // Selected item
                   Button(action: {
                       withAnimation {
                           showDropdown.toggle()
                       }
                   }, label: {
                       HStack(spacing: nil) {
                           Text(selectedOption?.symbol ?? "Select an option")
                               .withDefaultTextFormatting(textSixe: .headline, isBold: false)// Placeholder text if nil
                           Spacer()
                           Image(systemName: "chevron.up")
                               .rotationEffect(.degrees(showDropdown ? -180 : 0))
                       }
                   })
                   .disabled(cannotSelectCurrency)
                   .padding(.horizontal, 20)
                   .frame(width: geo.size.width / 2, height: buttonHeight, alignment: .leading)
               }
               .foregroundStyle(Color.accentColor)
               .background(RoundedRectangle(cornerRadius: 16).fill(Color.primaryColor))

           }
           .frame(width: geo.size.width / 2, height: buttonHeight, alignment: .bottom)
           .zIndex(100)
       }
}
//#Preview {
//    DropDownMenu(options: [], geo: .frame(<#T##self: GeometryProxy##GeometryProxy#>), selectedOption: .constant(Instrument(id: "", symbol: "")), showDropdown: .constant(true), cannotSelectCurrency: .constant(false))
//}
