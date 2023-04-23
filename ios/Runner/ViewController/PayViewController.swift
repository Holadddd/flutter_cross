//
//  PayViewController.swift
//  Runner
//
//  Created by DanielWu on 2023/4/23.
//

import UIKit

protocol PayViewControllerDelegate: AnyObject {
    func payViewController(_ viewController: PayViewController, paymentSuccess: Bool, orderID: Int)
}

class PayViewController: UIViewController {
    @IBOutlet var orderIDTitle: UILabel!
    @IBOutlet var payButton: UIButton!
    
    let orderID: Int
    
    weak var delegate: PayViewControllerDelegate?
    
    init(orderID: Int) {
        self.orderID = orderID
        
        super.init(nibName: "PayViewController", bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderIDTitle.text = "Order ID: \(orderID)"
        payButton.layer.cornerRadius = 5
        navigationController?.title = "Checkout"
    }
    
    @IBAction func clickedPay(_ sender: UIButton) {
        delegate?.payViewController(self, paymentSuccess: true, orderID: orderID)
    }
}
