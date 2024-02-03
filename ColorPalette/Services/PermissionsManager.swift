//
//  PermissionsManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 18.01.2023.
//

import AVFoundation
import Photos

struct PermissionsManager {
  static func checkPhotoLibraryPermission(deniedHandler: @escaping () -> (), authorizedHandler: @escaping () -> ()) {
    DispatchQueue.global(qos: .userInteractive).async {
      let status = PHPhotoLibrary.authorizationStatus()
      switch status {
      case .denied, .restricted: DispatchQueue.main.async { deniedHandler() }
      case .authorized: DispatchQueue.main.async { authorizedHandler() }
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization { status in
          switch status {
          case .authorized: DispatchQueue.main.async { authorizedHandler() }
          case .denied, .restricted:
            DispatchQueue.main.async { deniedHandler() }
          default: return
          }
        }
      default: return
      }
    }
  }
  
  static func checkCameraPermission(deniedHandler: @escaping () -> (), authorizedHandler: @escaping () -> ()) {
    DispatchQueue.global(qos: .userInteractive).async {
      switch AVCaptureDevice.authorizationStatus(for: .video) {
      case .denied, .restricted: DispatchQueue.main.async { deniedHandler() }
      case .authorized:  DispatchQueue.main.async { authorizedHandler() }
      case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { success in
          DispatchQueue.main.async {
            if success {
              authorizedHandler()
            } else {
              deniedHandler()
            }
          }
        }
      default: return
      }
    }
  }
}
