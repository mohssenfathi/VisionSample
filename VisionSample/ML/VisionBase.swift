//
//  VisionBase.swift
//  CoreMLTest
//
//  Created by Mohssen Fathi on 6/21/17.
//  Copyright © 2017 Mohssen Fathi. All rights reserved.
//

import Vision
import AVFoundation

protocol VisionBase {
    func perform(request: VNRequest, with sampleBuffer: CMSampleBuffer) throws
}

extension VisionBase {
    
    func perform(request: VNRequest, with sampleBuffer: CMSampleBuffer) throws {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            throw VisionError.invalidSampleBuffer
        }
        
//        var options: [VNImageOption: Any] = [:]
//        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
//            options = [.cameraIntrinsics: cameraIntrinsicData]
//        }
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: 6, options: options)
        let handler = VNSequenceRequestHandler()
        
        do {
//            try handler.perform([request])
            try handler.perform([request], on: pixelBuffer, orientation: 6)
        } catch {
            print(error.localizedDescription)
            throw VisionError.unknown
        }
    }
    
}

enum VisionError: Error {
    case invalidSampleBuffer
    case unknown
}
