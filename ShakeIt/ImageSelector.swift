//
//  ImageSelector.swift
//  ShakeIt
//
//  Created by Aleksandra Novák on 07/05/2023.
//

import Foundation
import SwiftUI

struct ImageSelector: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    
    let imageSource: UIImagePickerController.SourceType

    @Binding var selectedImageData: Data

    
    func makeUIViewController(context: Context) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = false
        imagePicker.sourceType = imageSource
        
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImageSelector

        init(_ parent: ImageSelector) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImageData = image.jpegData(compressionQuality: 1) ?? Data()
            }

            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }

    }
}
