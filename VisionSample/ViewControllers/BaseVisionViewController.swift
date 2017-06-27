//
//  BaseVisionViewController.swift
//  CoreMLTest
//
//  Created by Mohssen Fathi on 6/26/17.
//  Copyright © 2017 Mohssen Fathi. All rights reserved.
//

import UIKit
import AVFoundation

class BaseVisionViewController: UIViewController {
    
    let camera = Camera()
    var annotations = [CAShapeLayer]()
    var annotationContainer: UIView!
    var annotationCount: Int { return 0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAnnotations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        annotationContainer.frame = camera.previewLayer.frame
    }
    
    func flip() {
        camera.flip()
    }
    
    func didOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer) {
        // Subclass
    }
    
    private func setupView() {
        
        // Camera
        camera.previewLayer.frame = view.bounds
        view.layer.insertSublayer(camera.previewLayer, at: 0)
        camera.position = .front
        camera.sampleBufferDelegate = self
        
        // Annotations
        annotationContainer = UIView(frame: camera.previewLayer.frame)
        annotationContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(annotationContainer)
    }
    
    private func setupAnnotations() {

        for annotation in annotations { annotation.removeFromSuperlayer() }
        
        for _ in 0 ..< annotationCount {
            let layer = CAShapeLayer()
            layer.frame = annotationContainer.bounds
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = UIColor.red.cgColor
            layer.lineWidth = 2.0
            annotations.append(layer)
            annotationContainer.layer.addSublayer(layer)
        }
    }
}

extension BaseVisionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        didOutput(output, didOutput: sampleBuffer)
    }
    
}
