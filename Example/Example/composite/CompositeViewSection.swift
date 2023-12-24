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

enum CompositeViewSection: Int, CaseIterable, DefinesCompositionalLayout {    
    case section1
    case section2
    
    func layoutInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption {
        switch self {
        case .section1:
            return .fullWidthDynamicHeight(estimatedHeight: 75)
        case .section2:
            return .dynamicWidthFixedHeight(estimatedWidth: 150, fixedHeight: 150)
        }
    }
    
    func sectionInsets(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSDirectionalEdgeInsets {
        switch self {
        case .section1:
            return NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        case .section2:
            return NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        }
    }
    
    func headerInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> CompositionalLayoutOption? {
        switch self {
        case .section1:
            return .fullWidthFixedHeight(fixedHeight: 30)
        case .section2:
            return .fullWidthFixedHeight(fixedHeight: 55)
        }
    }
    
    var interItemSpacing: CGFloat {
        return 12
    }
    
    var interGroupSpacing: CGFloat {
        return 12
    }
}
