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

extension NSCollectionLayoutSize {
    public convenience init(with layoutInfo: CompositionalLayoutOption) {
        switch layoutInfo {
        case .dynamicWidthFixedHeight(let estimatedWidth, let fixedHeight):
            self.init(
                widthDimension: .estimated(estimatedWidth),
                heightDimension: .absolute(fixedHeight)
            )
        case .dynamicWidthDynamicHeight(let estimatedWidth, let estimatedHeight):
            self.init(
                widthDimension: .estimated(estimatedWidth),
                heightDimension: .estimated(estimatedHeight)
            )
        case .fixedWidthFixedHeight(let fixedWidth, let fixedHeight):
            self.init(
                widthDimension: .absolute(fixedWidth),
                heightDimension: .absolute(fixedHeight)
            )
        case .fixedWidthDynamicHeight(let fixedWidth, let estimatedHeight):
            self.init(
                widthDimension: .absolute(fixedWidth),
                heightDimension: .estimated(estimatedHeight)
            )
        case .fullWidthDynamicHeight(let dynamicHeight):
            self.init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(dynamicHeight)
            )
        case .fullWidthFixedHeight(let fixedHeight):
            self.init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(fixedHeight)
            )
        case .centeredFixedHeight(_, let fixedHeight):
            self.init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(fixedHeight)
            )
        case .centeredDynamicHeight(_, let dynamicHeight):
            self.init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(dynamicHeight)
            )
        case .fractionalWidthFixedHeight(let fractionalWidth, let fixedHeight):
            self.init(
                widthDimension: .fractionalWidth(fractionalWidth),
                heightDimension: .absolute(fixedHeight)
            )
        case .fractionalWidthDynamicHeight(let fractionalWidth, let dynamicHeight):
            self.init(
                widthDimension: .fractionalWidth(fractionalWidth),
                heightDimension: .estimated(dynamicHeight)
            )
        case .minWidthFixedHeight, .minWidthDynamicHeight:
            self.init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(1)
            )
        }
    }
}
