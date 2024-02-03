//
//  ImagePicker.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) private var presentationMode
  @Binding var selectedImage: UIImage
  @Binding var didSet: Bool

  let sourceType = UIImagePickerController.SourceType.photoLibrary

  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.navigationBar.tintColor = .clear
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator
    return imagePicker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let control: ImagePicker

    init(_ control: ImagePicker) {
      self.control = control
    }

    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
      if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        control.selectedImage = image
        control.didSet = true
      }
      control.presentationMode.wrappedValue.dismiss()
    }
  }
}
