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

@IBDesignable
class BorderedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBInspectable var borderWidth: CGFloat = CGFloat(0) {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.systemBackground {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = CGFloat() {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var roundTopRightCorner: Bool = true
    @IBInspectable var roundBottomRightCorner: Bool = true
    @IBInspectable var roundBottomLeftCorner: Bool = true
    @IBInspectable var roundTopLeftCorner: Bool = true
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        var maskedCorners = [CACornerMask]()
        if roundTopRightCorner {
            maskedCorners.append(CACornerMask.layerMaxXMinYCorner)
        }
        if roundBottomRightCorner {
            maskedCorners.append(CACornerMask.layerMaxXMaxYCorner)
        }
        if roundBottomLeftCorner {
            maskedCorners.append(CACornerMask.layerMinXMaxYCorner)
        }
        if roundTopLeftCorner {
            maskedCorners.append(CACornerMask.layerMinXMinYCorner)
        }
        layer.maskedCorners = CACornerMask.init(maskedCorners)
        layer.masksToBounds = true
        layer.cornerRadius = self.cornerRadius
        layer.borderColor = self.borderColor.cgColor
        layer.borderWidth = self.borderWidth
        clipsToBounds = true
    }
}
