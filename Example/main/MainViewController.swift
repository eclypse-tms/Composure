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

class MainViewController: UIViewController {

    @IBOutlet private weak var mainTableView: UITableView!
    
    private let cellReuseIdentifier = "main_compose_form_id"
    private var intToLayoutConverter: IntToLayoutConverter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        intToLayoutConverter = IntToLayoutConverter()
        
        self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        mainTableView.tableFooterView = UIView()
        mainTableView.rowHeight = 45
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Layout Options"
        default:
            return "Multi-section Layout Example"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = SimpleViewController()
            vc.register(layoutOption: intToLayoutConverter.convert(intValue: indexPath.row))
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = CompositeViewController()
            //vc.register(layoutOption: CompositionalLayoutOption(rawValue: indexPath.item)!)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return intToLayoutConverter.allCases.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let recycledCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) {
            cell = recycledCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        var content = cell.defaultContentConfiguration()
        
        
        switch indexPath.section {
        case 0:
            let layoutOption = intToLayoutConverter.convert(intValue: indexPath.row)
            content.text = "\(layoutOption.order). \(layoutOption.title)"
        default:
            content.text = "1. Full-width + Dynamic height"
        }
        
        cell.contentConfiguration = content;
        
        return cell;
    }
}
