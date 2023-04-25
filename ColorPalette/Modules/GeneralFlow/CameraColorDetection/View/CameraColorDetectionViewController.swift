//
//  CameraColorDetectionViewController.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import UIKit
import SnapKit
import AVFoundation

final class CameraColorDetectionViewController: UIViewController {
    private let captureSession = AVCaptureSession() // Audio and video capture session
    private var backFacingCamera: AVCaptureDevice?  // Rear camera
    private var currentDevice: AVCaptureDevice?     // Devices currently in use
    private let queue = DispatchQueue(label: "com.camera.video.queue")  // Camera data frame receiving queue
    
    private var viewModel: CameraColorDetectionViewModel?
    
    // Coloring position
    private var center: CGPoint = CGPoint(x: Consts.Constraints.screenWidth / 2 - 15, y: Consts.Constraints.screenWidth / 2 - 15)
    
    private let previewLayer = CALayer()
    private let lineShape = CAShapeLayer()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton(
            frame: .zero,
            primaryAction: UIAction(handler: { [weak self] _ in
                self?.viewModel?.input.closeTap.send()
            })
        )
        btn.setImage(UIImage(systemName: "multiply"), for: .normal)
        btn.backgroundColor = .black
        btn.tintColor = .white
        return btn
    }()
    private lazy var addButton: UIButton = {
        let btn = UIButton(
            frame: .zero,
            primaryAction: UIAction(handler: { [weak self] _ in
                guard let hex = self?.view.backgroundColor?.hexValue,
                      let alpha = self?.view.backgroundColor?.cgColor.alpha else { return }
                self?.viewModel?.input.addTap.send((hex, alpha))
            })
        )
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.backgroundColor = .black
        btn.tintColor = .white
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.isHidden = true
        PermissionsManager
            .checkCameraPermission(
                deniedHandler: { [weak self] in self?.presentCameraSettings() },
                authorizedHandler: { [weak self] in self?.fetchDevice() }
            )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
        addButton.layer.cornerRadius = addButton.frame.width / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.isHidden = false
    }
    
    func injectViewModel(_ viewModel: CameraColorDetectionViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupUI() {
        configureLayers()
        configureViews()
    }
}

private extension CameraColorDetectionViewController {
    func configureLayers() {
        configurePreviewLayer()
        configureLoopLayer()
        configureDotsLayer()
    }
    
    func configurePreviewLayer() {
        previewLayer.bounds = CGRect(x: 0, y: 0,
                                     width: Consts.Constraints.screenWidth - 80,
                                     height: Consts.Constraints.screenWidth - 80)
        previewLayer.position = view.center
        previewLayer.cornerRadius = 10
        previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
        previewLayer.masksToBounds = true
        previewLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)))
        
        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    // Loop
    func configureLoopLayer() {
        let linePath = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        
        lineShape.frame = CGRect.init(x: Consts.Constraints.screenWidth / 2 - 20,
                                      y: Consts.Constraints.screenHeight / 2 - 20,
                                      width: 40, height: 40)
        lineShape.lineWidth = 5
        lineShape.strokeColor = UIColor.red.cgColor
        lineShape.path = linePath.cgPath
        lineShape.fillColor = UIColor.clear.cgColor
        
        view.layer.insertSublayer(lineShape, at: 1)
    }
    
    // Dots
    func configureDotsLayer() {
        let linePath1 = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 8, height: 8))
        let lineShape1 = CAShapeLayer()
        lineShape1.frame = CGRect.init(x: Consts.Constraints.screenWidth / 2 - 4,
                                       y: Consts.Constraints.screenHeight / 2 - 4,
                                       width: 8, height: 8)
        lineShape1.path = linePath1.cgPath
        lineShape1.fillColor = UIColor.init(white: 0.7, alpha: 0.5).cgColor
        
        view.layer.insertSublayer(lineShape1, at: 1)
    }
}

private extension CameraColorDetectionViewController {
    func configureViews() {
        configureButtons()
    }
    
    func configureButtons() {
        view.addSubview(closeButton)
        view.addSubview(addButton)
        
        closeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Consts.Constraints.bottom + 50)
            $0.leading.equalToSuperview().inset(40)
            $0.size.equalTo(50)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(Consts.Constraints.bottom + 50)
            $0.trailing.equalToSuperview().inset(40)
            $0.size.equalTo(50)
        }
    }
}

private extension CameraColorDetectionViewController {
    //MARK: - Get the device and create a custom view
    func fetchDevice() {
        // Obtain the device
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualWideCamera], mediaType: .video, position: .back)
        backFacingCamera = discoverySession.devices.first
        
        // Set the current device as a front-facing camera
        currentDevice = backFacingCamera
        
        do {
            // Current device input
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCMPixelFormat_32BGRA)] as? [String : Any]
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error)
            return
        }
        
        // Start Audio and Video Capture Session
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
}

extension CameraColorDetectionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        
        guard let baseAddr = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0) else { return }
        
        let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
        let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bimapInfo: CGBitmapInfo = [
            .byteOrder32Little,
            CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        ]
        
        guard let content = CGContext(data: baseAddr,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bimapInfo.rawValue
        ) else { return }
        
        guard let cgImage = content.makeImage() else { return }
        
        DispatchQueue.main.async {
            self.previewLayer.contents = cgImage
            let color = self.previewLayer.pickColor(at: self.center)
            self.view.backgroundColor = color
            self.lineShape.strokeColor = color?.cgColor
        }
    }
}

private extension CameraColorDetectionViewController {
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                      message: "Camera access is denied",
                                      preferredStyle: .alert)
        alertController
            .addAction(UIAlertAction(title: "Cancel", style: .default) { [weak self] _ in self?.viewModel?.input.closeTap.send()
            })
        alertController
            .addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        // Handle
                    })
                }
            })

        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}
