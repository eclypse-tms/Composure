//
//  Composure
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

import Foundation
import CoreGraphics

public enum CompositionalLayoutOption {
    /// cell will adjust its width to fit its contents.
    case dynamicWidthFixedHeight(estimatedWidth: CGFloat, fixedHeight: CGFloat)
    
    /// cell will adjust its width and height to fit its content.
    case dynamicWidthDynamicHeight(estimatedWidth: CGFloat, estimatedHeight: CGFloat)
    
    /// cells will have a predetermined size
    case fixedWidthFixedHeight(fixedWidth: CGFloat, fixedHeight: CGFloat)
    
    /// cells will adjust its height to fit its content.
    case fixedWidthDynamicHeight(fixedWidth: CGFloat, estimatedHeight: CGFloat)

    //fractional width
    /// cell will take the provided fraction of the screen.
    case fractionalWidthFixedHeight(widthFraction: CGFloat, fixedHeight: CGFloat)
    
    /// cell will take the provided fraction of the screen while adjusting its height to fit its contents.
    case fractionalWidthDynamicHeight(widthFraction: CGFloat, estimatedHeight: CGFloat)

    /// convenience case. identical to calling fractional width with 1.0
    case fullWidthFixedHeight(fixedHeight: CGFloat)
    
    /// convenience case. identical to calling fractional width with 1.0
    case fullWidthDynamicHeight(estimatedHeight: CGFloat)
    
    /// centers the cell if the available view content size is bigger than the max allowed width.
    /// otherwise takes up the entire width.
    case centeredFixedHeight(maxWidth: CGFloat, fixedHeight: CGFloat)
    
    /// centers the cell if the available view content size is bigger than the max allowed width.
    /// otherwise takes up the entire width.
    case centeredDynamicHeight(maxWidth: CGFloat, estimatedHeight: CGFloat)
    
    /// centers the cell if the available view content size is bigger than the max allowed width.
    /// otherwise takes up the entire width.
    case multipleCenteredFixedHeight(numberOfCells: Int, totalMaxWidthOfAllCells: CGFloat, fixedHeight: CGFloat)
    
    /// fits as many cells as possible centers the cell if the available view content size is bigger than the max allowed width.
    /// otherwise takes up the entire width.
    case multipleCenteredDynamicHeight(numberOfCells: Int, totalMaxWidthOfAllCells: CGFloat, estimatedHeight: CGFloat)

    ///you use flexible width cells depending on the available screen size.
    ///compositional layout will try to fit as many cells as possible in the same row
    case minWidthFixedHeight(minWidth: CGFloat, fixedHeight: CGFloat)
    
    ///you use min width cells depending on the available screen size.
    ///compositional layout will try to fit as many cells as possible in the same row
    case minWidthDynamicHeight(minWidth: CGFloat, estimatedHeight: CGFloat)
    
    public var order: Int {
        switch self {
        case .dynamicWidthFixedHeight(_, _):
            return 0
        case .dynamicWidthDynamicHeight(_, _):
            return 1
        case .fixedWidthFixedHeight(_, _):
            return 2
        case .fixedWidthDynamicHeight(_, _):
            return 3
        case .fractionalWidthFixedHeight(_, _):
            return 4
        case .fractionalWidthDynamicHeight(_, _):
            return 5
        case .fullWidthFixedHeight(_):
            return 6
        case .fullWidthDynamicHeight(_):
            return 7
        case .centeredFixedHeight(_, _):
            return 8
        case .centeredDynamicHeight(_, _):
            return 9
        case .multipleCenteredFixedHeight(_, _, _):
            return 10
        case .multipleCenteredDynamicHeight(_, _, _):
            return 11
        case .minWidthFixedHeight(_, _):
            return 12
        case .minWidthDynamicHeight(_, _):
            return 13
        }
    }
    
    public var title: String {
        switch self {
        case .dynamicWidthFixedHeight(_, _):
            return "Dynamic Width Fixed Height"
        case .dynamicWidthDynamicHeight(_, _):
            return "Dynamic Width Dynamic Height"
        case .fixedWidthFixedHeight(_, _):
            return "Fixed Width Fixed Height"
        case .fixedWidthDynamicHeight(_, _):
            return "Fixed Width Dynamic Height"
        case .fractionalWidthFixedHeight(_, _):
            return "Fractional Width Fixed Height"
        case .fractionalWidthDynamicHeight(_, _):
            return "Fractional Width Dynamic Height"
        case .fullWidthFixedHeight(_):
            return "Full Width Fixed Height"
        case .fullWidthDynamicHeight(_):
            return "Full Width Dynamic Height"
        case .centeredFixedHeight(_, _):
            return "Centered Fixed Height"
        case .centeredDynamicHeight(_, _):
            return "Centered Dynamic Height"
        case .minWidthFixedHeight(_, _):
            return "Min Width Fixed Height"
        case .minWidthDynamicHeight(_, _):
            return "Min Width Dynamic Height"
        case .multipleCenteredFixedHeight(_, _, _):
            return "Centered Multiple Fixed Height"
        case .multipleCenteredDynamicHeight(_, _, _):
            return "Centered Multiple Dynamic Height"
        }
    }
}
