//
//  CaptureController.swift
//  advImProcessing
//
// A Swift example of using AVCaptureSession in iOS 10,
// which has been simplified from AVCam-iOS Apple sample.

import UIKit
import AVFoundation
import Photos

class CaptureController: UIViewController, AssetDataSource {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var capturedButton: UIButton!
    
    let session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let sessionQueue = DispatchQueue(label: "session queue",
                                     attributes: [],
                                     target: nil)
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var videoDeviceInput: AVCaptureDeviceInput!
    var setupResult: SessionSetupResult = .success
    
    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }

    var asset: PHAsset!
    var createdId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoButton.backgroundColor = .red
        photoButton.setTitleColor(.white, for: .normal)
        photoButton.layer.cornerRadius = photoButton.bounds.width / 2
        photoButton.layer.borderColor = UIColor.white.cgColor
        photoButton.layer.borderWidth = 1
        
        checkAuthorization()
        /*
         Setup the capture session.
         In general it is not safe to mutate an AVCaptureSession or any of its
         inputs, outputs, or connections from multiple threads at the same time.
         
         Why not do all of this on the main queue?
         Because AVCaptureSession.startRunning() is a blocking call which can
         take a long time. We dispatch session setup to the sessionQueue so
         that the main queue isn't blocked, which keeps the UI responsive.
         */
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue)
        guard segue.identifier == "unwindCaptureToPhoto",
            let image = capturedButton.backgroundImage(for: .normal)
            else { return }
        
        // Add it to the photo library.
        PHPhotoLibrary.shared().performChanges({
            [unowned self] in
            let created = PHAssetChangeRequest.creationRequestForAsset(from: image)
            self.createdId = created.placeholderForCreatedAsset?.localIdentifier
        }, completionHandler: {
            [unowned self] (success, error) in
            guard success else {
                print("error creating asset: \(String(describing: error))")
                return
            }
            self.asset = PHAsset.fetchAssets(withLocalIdentifiers: [self.createdId!], options: nil).object(at: 0)
        })
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindCaptureToPhoto" &&
            capturedButton.backgroundImage(for: .normal) == nil {
            return false
        }
        return true
    }
    
    @IBAction private func capturePhoto(_ sender: UIButton) {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        
        if self.videoDeviceInput.device.isFlashAvailable {
            photoSettings.flashMode = .auto
        }
        
        if !photoSettings.availablePreviewPhotoPixelFormatTypes.isEmpty {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
        }
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                // Only start the session running if setup succeeded.
                DispatchQueue.main.async { [unowned self] in
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    self.previewLayer.frame = self.previewView.bounds
                    self.previewView.layer.addSublayer(self.previewLayer)
                    self.session.startRunning()
                }
                
            case .notAuthorized:
                DispatchQueue.main.async { [unowned self] in
                    let changePrivacySetting = "AVCam doesn't have permission to use the camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                            style: .`default`,
                                                            handler: { _ in
                                                                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .configurationFailed:
                DispatchQueue.main.async { [unowned self] in
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel) {
                        [unowned self] _ in
                        if let nav = self.navigationController,
                            nav.topViewController === self {
                            nav.popViewController(animated: true)
                        } else {
                            self.dismiss(animated: true)
                        }
                    }
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.async { [unowned self] in
            if self.setupResult == .success {
                self.session.stopRunning()
            }
        }
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: Session Management
    
    func checkAuthorization() {
        /*
         Check video authorization status. Video access is required and audio
         access is optional. If audio access is denied, audio is not recorded
         during movie recording.
         */
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
            
        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. We suspend the session queue to delay session
             setup until the access request has completed.
             
             Note that audio access will be implicitly requested when we
             create an AVCaptureDeviceInput for audio during session setup.
             */
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
            
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }
    }
    
    private func configureSession() {
        if setupResult != .success {
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        // Add video input.
        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            // Choose the back dual camera if available, otherwise default to a wide angle camera.
            if let dualCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInDualCamera, for: AVMediaType.video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                // If the back dual camera is not available, default to the back wide angle camera.
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                /*
                 In some cases where users break their phones, the back wide angle camera is not available.
                 In this case, we should default to the front wide angle camera.
                 */
                defaultVideoDevice = frontCameraDevice
            } else {
                throw NSError(domain: "No_Camera", code: 404, userInfo: [:])
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
            } else {
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("Could not create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        // Add photo output.
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
        } else {
            print("Could not add photo output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
    }
    
}

extension CaptureController: AVCapturePhotoCaptureDelegate {

    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        //print(photo.metadata)

        if let imageData = photo.fileDataRepresentation(), /*
                withReplacementMetadata: ["Orientation" : 0], // rotate image
                replacementEmbeddedThumbnailPhotoFormat: nil,
                replacementEmbeddedThumbnailPixelBuff: nil,
                replacementDepthData: nil),*/
            let image = UIImage(data: imageData) {
            self.capturedButton.setBackgroundImage(image, for: .normal)
        }
    }
}

