//
//  BasicViews.swift
//  counterparties-swiftui
//
//  Created by Илья Чуб on 13.01.2022.
//

import SwiftUI

struct ButtonStyleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(Color.black)
            .cornerRadius(40)
            .padding(4)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.black, lineWidth: 3)
            )
    }
}

struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [
            .foregroundColor: titleColor ?? .white
        ]
        coloredAppearance.largeTitleTextAttributes = [
            .foregroundColor: titleColor ?? .white
        ]
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func buttonStyleViewModifier() -> some View {
        modifier(ButtonStyleViewModifier())
    }
    func navigationBarColor(
        backgroundColor: UIColor?,
        titleColor: UIColor?
    ) -> some View {
        self.modifier(
            NavigationBarModifier(
                backgroundColor: backgroundColor,
                titleColor: titleColor)
        )
    }

}

struct BasicTextField: View {
    let textString: String
    @Binding var text: String
    
    var body: some View {
        TextField(textString, text: $text)
            .multilineTextAlignment(.center)
            .padding(15)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .accentColor(.black)
            .lineLimit(1)
            .disableAutocorrection(true)
            .padding([.leading, .trailing])   
    }
}
