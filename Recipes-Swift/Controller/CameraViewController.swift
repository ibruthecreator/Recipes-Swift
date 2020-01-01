//
//  ViewController.swift
//  Recipes-Swift
//
//  Created by Mohammed Ibrahim on 2019-12-25.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit
import AVKit

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // AVKit
    private let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

    var bufferSize: CGSize = .zero

    var rootLayer: CALayer! = nil
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil

    @IBOutlet weak private var previewView: UIView!
    
    var currentFrame: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Setup AV Capture
        setupAVCapture()
       
        // Start Session
        startSession()
        
        // Start Timer
        startTimer()
    }

    // MARK: - Setup AVCapture
    // Sets up AV Capture to process and show live video from the camera
    // Also starts the session
    func setupAVCapture() {
        var deviceInput: AVCaptureDeviceInput!
       
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480 // Model image size is smaller.
       
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
       
        session.addInput(deviceInput)
       
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
           
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
       
        let captureConnection = videoDataOutput.connection(with: .video)
       
        // Always process the frames
        captureConnection?.isEnabled = true
       
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
       
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
       
        // Setup camera view live capture
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
    }

    // Start the session
    func startSession() {
        session.startRunning()
    }
    
    // Start Timer
    // Timer is so that the API isn't fired every single frame and to avoid bankruptcy from API fees
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.captureInput()
        }
    }

    // Capture Input From Session
    func captureInput() {}
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Drop Frames")
    }

    // MARK: - Capture Camera Output
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        let temporaryContext = CIContext(options: nil)
        let videoImage = temporaryContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CGFloat(CVPixelBufferGetWidth(pixelBuffer)), height: CGFloat(CVPixelBufferGetHeight(pixelBuffer))))

        var uiImage: UIImage? = nil
        if let videoImage = videoImage {
            uiImage = UIImage(cgImage: videoImage)
        }
        
        currentFrame = uiImage
        
        return
    }

    // Get orientation from device
    func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
       
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
           exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
           exifOrientation = .up
        default:
           exifOrientation = .up
        }
        
        return exifOrientation
    }
}

