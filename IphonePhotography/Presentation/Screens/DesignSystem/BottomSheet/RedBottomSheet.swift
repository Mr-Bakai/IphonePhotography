//
//  CustomBottomSheet.swift
//  IphonePhotography
//
//  Created by Bakai on 13/8/23.
//

import SwiftUI

public struct RedBottomSheet<Content: View>: View {
    private let title: String?
    private let description: String?
    private let primaryTitle: String
    private let secondaryTitle: String?

    private let content: () -> Content
    private let onPrimaryTap: () -> Void
    private let onSecondaryTap: (() -> Void)?

    public init(
        title: String? = nil,
        description: String,
        primaryTitle: String,
        secondaryTitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content,
        onPrimaryTap: @escaping () -> Void,
        onSecondaryTap: (() -> Void)? = nil
    ) {
        self.onPrimaryTap = onPrimaryTap
        self.onSecondaryTap = onSecondaryTap
        self.title = title
        self.description = description
        self.primaryTitle = primaryTitle
        self.secondaryTitle = secondaryTitle
        self.content = content
    }

    public var body: some View {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    if let title = title {
                        Text(title)
                            .foregroundColor(AppColors.getColor(.primaryBlack))
                            .font(.system(size: 24,weight: .bold))
                        .multilineTextAlignment(.center)
                    }
                    
                    if let description = description {
                        Text(description)
                            .foregroundColor(AppColors.getColor(.primaryBlack))
                            .font(.system(size: 18, weight: .regular))
                        .multilineTextAlignment(.center)
                    }
                }

                VStack(spacing: 12) {
                    PrimaryButton(
                        backgroundColor: .primaryRed,
                        buttonTitle: primaryTitle,
                        enabled: .constant(true),
                        onTap: onPrimaryTap
                    )

                    if
                        let onSecondaryTap = onSecondaryTap,
                        let secondaryTitle = secondaryTitle {
                        PrimaryButton(
                            backgroundColor: .primaryWhite,
                            titleColor: .primaryBlack,
                            buttonTitle: secondaryTitle,
                            enabled: .constant(true),
                            onTap: onSecondaryTap
                        )
                    }
                }
            }
            .padding(.all, 16)
    }
}

extension RedBottomSheet where Content == EmptyView {
    public init(
        title: String? = nil,
        description: String,
        primaryTitle: String,
        secondaryTitle: String? = nil,
        onPrimaryTap: @escaping () -> Void,
        onSecondaryTap: (() -> Void)? = nil
    ) {
        self.init(
            title: title,
            description: description,
            primaryTitle: primaryTitle,
            secondaryTitle: secondaryTitle,
            content: { EmptyView() },
            onPrimaryTap: onPrimaryTap,
            onSecondaryTap: onSecondaryTap
        )
    }
}

struct CustomBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        RedBottomSheet(
            description: "description",
            primaryTitle: "Try Again",
            onPrimaryTap: {}
        )
    }
}
