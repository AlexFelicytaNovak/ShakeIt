//
//  CustomAppearance.swift
//  ShakeIt
//
//  Created by Zosia on 08/05/2023.
//

import SwiftUI

struct ColoredGroupBox : GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
        }
        .padding()
        .background(Colors.Color2)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
