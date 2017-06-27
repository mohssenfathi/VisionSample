//
//  TextDetector.swift
//  VisionSample
//
//  Created by Mohssen Fathi on 6/27/17.
//  Copyright © 2017 mohssenfathi. All rights reserved.
//

import AVFoundation
import Vision

struct TextDetector: VisionBase {
    
    private static var shared = TextDetector()
    
    static func detectText(in sampleBuffer: CMSampleBuffer, completion: @escaping ([VNTextObservation]) -> ()) {
        
        let request = VNDetectTextRectanglesRequest { (request, error) in
            guard error == nil, let results = request.results as? [VNTextObservation] else {
                    completion([])
                    return
            }
            
            completion(results)
        }
        request.reportCharacterBoxes = true
        
        do {
            try shared.perform(request: request, with: sampleBuffer)
        }
        catch {
            completion([])
        }
        
        
    }
    
}

struct TextClassifier: VisionBase {
    
    private static var shared = TextClassifier()
    private var model: VNCoreMLModel?
    
    init() {
        model = try? VNCoreMLModel(for: mnist().model)
    }
    
    static func classify(image: CIImage, completion: @escaping ([(String, Float)]) -> ()) {
        
        guard let model = shared.model else {
            completion([])
            return
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard error == nil else {
                completion([])
                return
            }
            
//            guard let observations = request.results as? [VNClassificationObservation] else {
//                fatalError("unexpected result type from VNCoreMLRequest")
//            }
//            let results = observations[0 ... 10].filter({
//                $0.confidence > 0.05
//            }).map {
//                return ($0.identifier, $0.confidence)
//            }
            
//            DispatchQueue.main.async {
//                completion(results)
//            }
            
        }
        
        request.imageCropAndScaleOption = VNImageCropAndScaleOptionCenterCrop
        
        do {
            try shared.perform(request: request, with: image)
        }
        catch {
            completion([])
        }
        
    }
    
}
