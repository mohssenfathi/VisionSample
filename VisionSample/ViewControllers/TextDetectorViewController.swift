//
//  TextDetectorViewController.swift
//  VisionSample
//
//  Created by Mohssen Fathi on 6/27/17.
//  Copyright © 2017 mohssenfathi. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class TextDetectorViewController: BaseVisionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera.position = .back
    }
    
    override func didOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer) {
        super.didOutput(output, didOutput: sampleBuffer)
        
        TextDetector.detectText(in: sampleBuffer) { results in
            DispatchQueue.main.async {
                
                let paths = results.map { observation -> UIBezierPath in
                    
//                    var boundingBox = observation.boundingBox
//                    boundingBox.origin.y = 1.0 - boundingBox.origin.y
                    
                    let imageRect = self.camera.previewLayer.frame
                    let w = observation.boundingBox.size.width * imageRect.width
                    let h = observation.boundingBox.size.height * imageRect.height
                    let x = observation.boundingBox.origin.x * imageRect.width + imageRect.origin.x
                    let y = imageRect.maxY - (observation.boundingBox.origin.y * imageRect.height) - h
                    
                    return UIBezierPath(rect: CGRect(x: x, y: y, width: w, height: h))
                }
                
                
                if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                    
                    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                    let size = CGSize(width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
                    
                    if let observation = results.first?.characterBoxes?.first {
                        let rect = observation.boundingBox * size
                        let newImage = ciImage.cropping(to: rect)
                        
                        TextClassifier.classify(image: newImage, completion: { (results) in
                            
                        })
                    }
                }
                
                self.updateAnnotations(with: paths)
            }
        }
    }
    
}
