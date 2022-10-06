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

import UIKit
import Composure

enum SimpleViewSection: Int, CaseIterable, DefinesCompositionalLayout {
    case section0
    case section1
    case section2
    case section3
    case section4
    case section5
    case section6
    case section7
    case section8
    case section9
    case section10
    case section11
    
    
    func layoutInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption {
        switch self {
        case .section0:
            return .dynamicWidthFixedHeight(estimatedWidth: 240, fixedHeight: 54)
        case .section1:
            return .dynamicWidthDynamicHeight(estimatedWidth: 280, estimatedHeight: 95)
        case .section2:
            return .fixedWidthFixedHeight(fixedWidth: 150, fixedHeight: 150)
        case .section3:
            return .fixedWidthDynamicHeight(fixedWidth: 140, estimatedHeight: 120)
        case .section4:
            return .fractionalWidthFixedHeight(widthFraction: 0.5, fixedHeight: 210)
        case .section5:
            return .fractionalWidthDynamicHeight(widthFraction: 0.333333, estimatedHeight: 120)
        case .section6:
            return .fullWidthFixedHeight(fixedHeight: 140)
        case .section7:
            return .fullWidthDynamicHeight(estimatedHeight: 180)
        case .section8:
            return .centeredFixedHeight(maxWidth: 280, fixedHeight: 105)
        case .section9:
            return .centeredDynamicHeight(maxWidth: 240, estimatedHeight: 75)
        case .section10:
            return .minWidthFixedHeight(minWidth: 210, fixedHeight: 150)
        case .section11:
            return .minWidthDynamicHeight(minWidth: 300, estimatedHeight: 210)
        }
    }
    
    func sectionInsets(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 0, trailing: 12)
    }
    
    var interItemSpacing: CGFloat {
        return 12
    }
    
    var interGroupSpacing: CGFloat {
        return 12
    }
}
