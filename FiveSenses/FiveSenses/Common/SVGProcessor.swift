//
//  SVGProcessor.swift
//
//  Created by Paolo Musolino on 21/03/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Kingfisher
import PocketSVG

struct SVGProcessor: ImageProcessor {
    let imgSize: CGSize?
    
    init(size: CGSize? = CGSize(width:250, height:250)) {
        imgSize = size
    }
    
    // `identifier` should be the same for processors with same properties/functionality
    // It will be used when storing and retrieving the image to/from cache.
    let identifier = "my.app.svg"
    
    // Convert input data/image to target image and return it.
    func process(item: ImageProcessItem, options: Kingfisher.KingfisherParsedOptionsInfo) -> Kingfisher.KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            //already an image
            return image
        case .data(let data):
            return generateSVGImage(data: data, width: imgSize?.width ?? 0) ?? DefaultImageProcessor().process(item: item, options: options)
        }
    }
}

struct SVGCacheSerializer: CacheSerializer {
    func data(with image: Kingfisher.KFCrossPlatformImage, original: Data?) -> Data? {
        return original
    }
    
    func image(with data: Data, options: Kingfisher.KingfisherParsedOptionsInfo) -> Kingfisher.KFCrossPlatformImage? {
        return generateSVGImage(data: data) ?? image(with: data, options: options)
    }
}

func generateSVGImage(data: Data, width: CGFloat = 250) -> UIImage? {
    if let svgString = String(data: data, encoding: .utf8) {
        let svgLayer = SVGLayer()
        svgLayer.paths = SVGBezierPath.paths(fromSVGString: svgString)
        let originRect = SVGBoundingRectForPaths(svgLayer.paths)
        svgLayer.frame = CGRect(x: 0, y: 0, width: width, height: width * originRect.height / originRect.width)
        return snapshotImage(for: svgLayer)
    }
    return nil
}

func snapshotImage(for layer: CALayer) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
