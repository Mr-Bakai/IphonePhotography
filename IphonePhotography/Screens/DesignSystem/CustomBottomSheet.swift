//
//  CustomBottomSheet.swift
//  IphonePhotography
//
//  Created by Bakai on 19/8/23.
//

import SwiftUI

struct CustomBottomSheet<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @Binding var isShowing: Bool
    private var snapRatio: CGFloat { 40 }
    private var grayBackgroundOpacity: Double { isShowing ? 0.4 : 0 }
    private let topBarHeight: CGFloat
    private let topBarCornerRadius: CGFloat = 16.0
    private let contentBackgroundColor: Color
    private let topBarBackgroundColor: Color
    private let showTopIndicator: Bool
    private let isScrollHide: Bool
    private let isCloseTap: Bool
    private let content: Content
    
    public init(
        isShowing: Binding<Bool>,
        topBarHeight: CGFloat = AppSizes.height30,
        topBarBackgroundColor: Color = Color(.systemBackground),
        contentBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool,
        isScrollHide: Bool = true, //если true то можно смахом закрыть иначе не подвижная view
        isCloseTap: Bool = true, //если true то можно тапом закрыть иначе закрывается через слайд или через кнопки от контента
        @ViewBuilder content: () -> Content
    ) {
        self.topBarBackgroundColor = topBarBackgroundColor
        self.contentBackgroundColor = contentBackgroundColor
        self._isShowing = isShowing
        self.topBarHeight = topBarHeight
        self.showTopIndicator = showTopIndicator
        self.isScrollHide = isScrollHide
        self.isCloseTap = isCloseTap
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if isShowing {
                    fullScreenLightGrayOverlay()
                        .allowsHitTesting(isCloseTap)
                    contentView(with: geometry)
                }
            }
            .frame(height: geometry.size.height, alignment: .bottom)
        }
        .ignoresSafeArea(.all)
    }
    
    fileprivate func contentView(with geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            topBar(geometry: geometry)
            content
                .padding(.bottom, AppPadding.padding48)
                .transition(.move(edge: .bottom))
        }
        .background(contentBackgroundColor)
        .cornerRadius(topBarCornerRadius, corners: [.topLeft, .topRight])
        .offset(y: max(translation, 0))
        .frame(width: geometry.size.width, alignment: .bottom)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut)
        .gesture(
            DragGesture()
                .updating(self.$translation) { value, state, _ in
                    if isScrollHide { state = value.translation.height }
                }
                .onEnded({ (value) in
                    if isScrollHide {
                        let offsetY = value.translation.height
                        if offsetY > 100 {
                            self.isShowing = false
                        }
                    }
                })
        )
    }
    
    fileprivate func fullScreenLightGrayOverlay() -> some View {
        Color
            .black
            .opacity(grayBackgroundOpacity)
            .edgesIgnoringSafeArea(.all)
            .animation(.interactiveSpring())
            .onTapGesture { self.isShowing = false }
    }
    
    fileprivate func topBar(geometry: GeometryProxy) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(AppColors.getColor(.primaryGrayDark, opacity: OpacityColor.opacity20))
                .frame(width: AppSizes.width48, height: 3)
                .opacity(showTopIndicator ? 1 : 0)
        }
        .frame(width: geometry.size.width, height: topBarHeight)
        .background(topBarBackgroundColor)
    }
}
