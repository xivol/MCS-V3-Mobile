//
//  EdgeGlowFilter.swift
//  advImProcessing
//
//  Created by Илья Лошкарёв on 28.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//
import CoreImage

class EdgeGlowFilter: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else { return nil }
        
        let edgesImage = inputImage
            .applyingFilter(
                "CIEdges",
                parameters: [
                    kCIInputIntensityKey: 10])
        
        let glowingImage = CIFilter(
            name: "CIColorControls",
            withInputParameters: [
                kCIInputImageKey: edgesImage,
                kCIInputSaturationKey: 1.75])?
            .outputImage?.applyingFilter(
                "CIBloom",
                parameters: [
                    kCIInputRadiusKey: 2.5,
                    kCIInputIntensityKey: 1.25])
            .cropped(to: inputImage.extent)
        
        let darkImage = inputImage
            .applyingFilter(
                "CIPhotoEffectNoir",
                parameters: [:])
            .applyingFilter(
                "CIExposureAdjust",
                parameters: [
                    "inputEV": -1.5])
        
        let finalComposite = glowingImage!
            .applyingFilter(
                "CIAdditionCompositing",
                parameters: [
                    kCIInputBackgroundImageKey: darkImage])
        
        return finalComposite
    }
}
