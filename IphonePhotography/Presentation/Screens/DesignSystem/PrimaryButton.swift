//
//  PrimaryButton.swift
//  IphonePhotography
//
//  Created by Bakai on 13/8/23.
//

import SwiftUI

public struct PrimaryButton: View {
    
    private let backgroundColor: PrimaryColor
    private let titleColor: PrimaryColor
    private let buttonTitle: String
    private let fontSize: FontSize
    private let onTap: (() -> Void)
    @Binding private var enabled: Bool
    
    public init(
        backgroundColor: PrimaryColor = PrimaryColor.secondaryGreen,
        titleColor: PrimaryColor = PrimaryColor.primaryWhite,
        buttonTitle: String,
        fontSize: FontSize = .size16,
        enabled: Binding<Bool>,
        onTap: @escaping () -> Void
    ) {
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.buttonTitle = buttonTitle
        self.fontSize = fontSize
        self._enabled = enabled
        self.onTap = onTap
    }
    
    public var body: some View {
        Button(action: onTap) {
            let buttonColor: PrimaryColor = enabled ? backgroundColor : .primaryGrayLight
            let titleColor: PrimaryColor = enabled ? titleColor : .primaryGray
            
            Text(buttonTitle)
                .font(.system(size: fontSize.rawValue, weight: .regular))
                .frame(maxWidth: .infinity, minHeight: 50)
                .padding(.horizontal)
                .foregroundColor(AppColors.getColor(titleColor))
                .background(AppColors.getColor(buttonColor))
                .cornerRadius(CornerRadius.standartCorner)
        }
        .disabled(!enabled)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        
        PrimaryButton(buttonTitle: "Error",
                      enabled: .constant(true),
                      onTap: {})
    }
}
