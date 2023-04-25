//
//  ShareSheet.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.02.2023.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let urls: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: urls, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
