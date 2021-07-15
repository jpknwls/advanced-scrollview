//
//  AdvancedScrollView.swift
//
//
//  Created by Dmytro Anokhin on 23/06/2021.
//

import SwiftUI


@available(macOS 10.15, iOS 13.0, *)
public struct AdvancedScrollView<Content: View>: View {

    public let magnification: Magnification

    public let isScrollIndicatorVisible: Bool

    let content: Content

    public init(magnification: Magnification = Magnification(range: 1.0...4.0, initialValue: 1.0, isRelative: true),
                isScrollIndicatorVisible: Bool = true,
                @ViewBuilder content: (_ proxy: AdvancedScrollViewProxy) -> Content) {

        let proxy = AdvancedScrollViewProxy(delegate: proxyDelegate)

        self.magnification = magnification
        self.isScrollIndicatorVisible = isScrollIndicatorVisible
        self.content = content(proxy)
    }

    public var body: some View {
        #if os(macOS)
        NSScrollViewRepresentable(magnification: magnification,
                            hasScrollers: isScrollIndicatorVisible,
                            proxyDelegate: proxyDelegate,
                            proxyGesturesDelegate: gesturesDelegate,
                            content: {
                                content
                            })
        #else
        UIScrollViewControllerRepresentable(magnification: magnification,
                            isScrollIndicatorVisible: isScrollIndicatorVisible,
                            proxyDelegate: proxyDelegate,
                            content: {
                                content
                            })
        #endif
    }

    let gesturesDelegate = AdvancedScrollViewProxy.GesturesDelegate.shared

    private let proxyDelegate = AdvancedScrollViewProxy.Delegate.shared
}
