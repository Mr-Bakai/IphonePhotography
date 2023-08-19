//
//  BottomSheet.swift
//  IphonePhotography
//
//  Created by Bakai on 19/8/23.
//

import SwiftUI

#if !os(macOS)
public extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat = 400,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        contentBackgroundColor: Color = Color(.systemBackground),
        topBarBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool = true,
        isScrollHide: Bool = true,
        isCloseTap: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self.blur(radius: isPresented.wrappedValue ? 8 : 0)
            CustomBottomSheet(
                isShowing: isPresented,
                topBarHeight: topBarHeight,
                topBarBackgroundColor: topBarBackgroundColor,
                contentBackgroundColor: contentBackgroundColor,
                showTopIndicator: showTopIndicator,
                isScrollHide: isScrollHide,
                isCloseTap: isCloseTap,
                content: content
            )
            .ignoresSafeArea(.all)
        }
    }
    
    func bottomSheetWithoutBlur<Content: View>(
        isPresented: Binding<Bool>,
        topBarHeight: CGFloat = 30,
        contentBackgroundColor: Color = Color(.systemBackground),
        topBarBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool = true,
        isScrollHide: Bool = true,
        isCloseTap: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            CustomBottomSheet(
                isShowing: isPresented,
                topBarHeight: topBarHeight,
                topBarBackgroundColor: topBarBackgroundColor,
                contentBackgroundColor: contentBackgroundColor,
                showTopIndicator: showTopIndicator,
                isScrollHide: isScrollHide,
                isCloseTap: isCloseTap,
                content: content
            )
            .ignoresSafeArea(.all)
        }
    }

    func bottomSheet<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        height: CGFloat,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        contentBackgroundColor: Color = Color(.systemBackground),
        topBarBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool = true,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        let isPresented = Binding {
            item.wrappedValue != nil
        } set: { value in
            if !value {
                item.wrappedValue = nil
            }
        }
        
        return bottomSheet(
            isPresented: isPresented,
            height: height,
            topBarHeight: topBarHeight,
            topBarCornerRadius: topBarCornerRadius,
            contentBackgroundColor: contentBackgroundColor,
            topBarBackgroundColor: topBarBackgroundColor,
            showTopIndicator: showTopIndicator
        ) {
            if let unwrapedItem = item.wrappedValue {
                content(unwrapedItem)
            } else {
                EmptyView()
            }
        }
    }

    func disableSwipeBack() -> some View {
            self.background(
                DisableSwipeBackView()
            )
        }

    public func endEditing(_ force: Bool = true) {
        UIApplication.shared.windows.forEach { $0.endEditing(force) }
    }
    
    public func vibrationSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    public func vibrationError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    public func vibrationWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    public func vibrationlight() {
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()
    }

    public func vibrationMedium() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    }

    public func vibrationHeavy() {
        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
        impactHeavy.impactOccurred()
    }

    public func vibrationSelectionFeedbackGenerator() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }

}
#endif
