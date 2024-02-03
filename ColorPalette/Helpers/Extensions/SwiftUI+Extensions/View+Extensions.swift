//
//  View+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import SwiftUI

extension View {
  func eraseToAnyView() -> AnyView {
    AnyView(self)
  }
}

extension View {
  func setCustomNavigationBarAppearance() -> some View {
    modifier(CustomNavigationBarAppearance())
  }

  func setCustomNavigationBarTitleAppearance(font: Font = .headline, isBold: Bool = true, opacity: Double = 1) -> some View {
    modifier(CustomNavigationBarTitleAppearance(font: font, isBold: isBold, opacity: opacity))
  }
}

extension View {
  func exportPDF<Content: View>(
    @ViewBuilder content: @escaping () -> Content,
    completion: @escaping (Bool, URL?) -> ()
  ) {
    let documentDerictory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    let outputFileURL = documentDerictory.appendingPathComponent("\(UUID().uuidString).pdf")

    let pdfView = convertToUIView {
      content()
    }

    pdfView.tag = 1009
    pdfView.frame = CGRect(x: 0, y: 0, width: Consts.Constraints.screenWidth, height: Consts.Constraints.screenHeight)

    let size = pdfView.frame.size

    getRootController().view.insertSubview(pdfView, at: 0)

    let render = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height))

    do {
      try render.writePDF(to: outputFileURL, withActions: { context in
        context.beginPage()
        pdfView.layer.render(in: context.cgContext)
      })

      completion(true, outputFileURL)
    }
    catch {
      completion(false, nil)
      print(error.localizedDescription)
    }

    getRootController().view.subviews.forEach { view in
      if view.tag == 1009 {
        view.removeFromSuperview()
      }
    }
  }

  private func convertToUIView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> UIView {
    let uiView = UIView()
    let hostingController = UIHostingController(rootView: content()).view!
    hostingController.translatesAutoresizingMaskIntoConstraints = false

    let constraints = [
      hostingController.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
      hostingController.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
      hostingController.topAnchor.constraint(equalTo: uiView.topAnchor),
      hostingController.bottomAnchor.constraint(equalTo: uiView.bottomAnchor)
    ]

    uiView.addSubview(hostingController)
    uiView.addConstraints(constraints)
    uiView.layoutIfNeeded()

    return uiView
  }

  private func getRootController() -> UIViewController {
    guard
      let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let root = screen.windows.first?.rootViewController else {
      return .init()
    }

    return root
  }
}
