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
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .denied, .restricted : deniedHandler()
            case .authorized: authorizedHandler()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                        case .authorized: authorizedHandler()
                        case .denied, .restricted: deniedHandler()
                        default: return
                    }
                }
            default: return
        }
    }
    
    static func checkCameraPermission(deniedHandler: @escaping () -> (), authorizedHandler: @escaping () -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied, .restricted: deniedHandler()
            case .authorized: authorizedHandler()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        authorizedHandler()
                    } else {
                        deniedHandler()
                    }
                }
            default: return
        }
    }
}
