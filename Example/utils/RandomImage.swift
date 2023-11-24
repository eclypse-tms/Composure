//
//  ComposeForm
//  Copyright © 2022 Eclypse Software, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

// Adapted from https://github.com/wvabrinskas/Avatar under MIT License

import UIKit

typealias Colors = (primary: UIColor, secondary: UIColor, tertiary: UIColor)

open class RandomImage {
    private func getOneRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue =  CGFloat(arc4random_uniform(256)) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private func getThreeRandomColors() -> Colors {
        let colors:Colors = (primary: getOneRandomColor(), secondary: getOneRandomColor(), tertiary: getOneRandomColor())
        return colors
    }
    
    private func generateRandomPixelMapping(length: Int) -> [Int] {
        var map = [Int]()
        
        for _ in 0..<length {
            map.append(Int(arc4random_uniform(3)))
        }
        
        return map
    }
    
    /// creates a random seed to be used as an input to generate an avatar
    open func generateRandomSeed(for size: CGSize, scale: Int?) -> RandomImageSeed {
        let randomColors = getThreeRandomColors()
        let pixelSize = scale ?? 6
        let totalColumns = Int(size.width) / pixelSize
        let totalRows = Int(size.height) / pixelSize
        
        let randomPixelMapping =  generateRandomPixelMapping(length: totalColumns * totalRows)
        return RandomImageSeed(map: randomPixelMapping, colors: randomColors, size: size, scale: pixelSize)
    }
    
    /// generate an image for a given seed
    private func generate(using avatarSeed: RandomImageSeed, complete: @escaping (UIImage?) -> ()) {
        let width = Int(avatarSeed.size.width)
        let height = Int(avatarSeed.size.height)
        
        let pixelSize = avatarSeed.scale
         
        let totalColumns = width / pixelSize
        
        let wRemainder = width % pixelSize
        let hRemainder = height % pixelSize
                
        var x = 0 //columns counter
        var y = 0 //rows counter
        
        UIGraphicsBeginImageContextWithOptions(avatarSeed.size, true, 1)
        let context = UIGraphicsGetCurrentContext()!
        
        for position in 0..<avatarSeed.map.count {
            //context stuff
            let colorIndex = avatarSeed.map[position]
            var color = UIColor.black
            switch colorIndex {
            case 0:
                color = avatarSeed.colors.primary
            case 1:
                color = avatarSeed.colors.secondary
            case 2:
                color = avatarSeed.colors.tertiary
            default:
                color = .black
            }
            
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: CGFloat(x * pixelSize), y:CGFloat(y * pixelSize), width:CGFloat(pixelSize + (pixelSize * wRemainder)), height:CGFloat(pixelSize + (pixelSize * hRemainder))));
            
            x = x + 1
            
            if x == totalColumns {
                x = 0
                y = y + 1
            }
        }
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext()
        
        complete(outputImage)
    }
    
    /// generate a random image for a given size and scale
    public static func generateRandom(for size: CGSize, scale: Int?) -> UIImage? {
        let instance = RandomImage()
        let randomSeed = instance.generateRandomSeed(for: size, scale: scale)
        var outputImage: UIImage?
        
        instance.generate(using: randomSeed) { image in
            outputImage = image
        }
        
        return outputImage
    }
    
    /// given a seed, returns an avatar image
    public static func generate(with seed: RandomImageSeed) -> UIImage? {
        let instance = RandomImage()
        var outputImage: UIImage?
        
        instance.generate(using: seed) { image in
            outputImage = image
        }
        
        return outputImage
    }
}

/// simple data structure used for avatar generation
public struct RandomImageSeed {
    
    /// color mapping - for example in  a 10by10 image, first pixel in the map refers to which color it will use
    let map: [Int]
    
    /// triple of colors, all avatars have 3 colors in them
    let colors: Colors
    
    /// image size
    let size: CGSize
    
    /// pixel scale, similar to pixel density used in iOS devices. if you provide 3, 3by3 pixel will be treated as 1 pixel
    let scale: Int
    
    init(map: [Int], colors: Colors, size: CGSize, scale: Int) {
        self.map = map
        self.colors = colors
        self.size = size
        self.scale = scale
    }
}
