//
//  PayViewController.swift
//  Runner
//
//  Created by DanielWu on 2023/4/23.
//

import UIKit
import TPDirect

protocol PayViewControllerDelegate: AnyObject {
    func payViewController(_ viewController: PayViewController, paymentSuccess: Bool, orderID: Int)
}

class PayViewController: UIViewController {
    @IBOutlet var orderIDTitle: UILabel!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var tappayContainer: UIView!
    let orderID: Int
    var tpdForm: TPDForm!
    var tpdCard: TPDCard!

    weak var delegate: PayViewControllerDelegate?

    init(orderID: Int) {
        self.orderID = orderID

        super.init(nibName: "PayViewController", bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initVariable()
        initLayout()
    }

    private func initVariable() {
        setupTapPay()
    }

    private func initLayout() {
        orderIDTitle.text = "Order ID: \(orderID)"
        payButton.layer.cornerRadius = 5
        payButton.setTitleColor(.black, for: .normal)
    }

    private func setupTapPay() {
        // 1. Setup TPDForm With Your Customized CardView(260, 70)
        self.tpdForm = TPDForm.setup(withContainer: tappayContainer)
        self.tpdCard = TPDCard.setup(self.tpdForm)

        self.tpdForm.setErrorColor(UIColor.red)

        // 2. Use callback Get Status
        self.tpdForm.onFormUpdated { status in
            self.payButton.isEnabled = status.isCanGetPrime()
            self.payButton.alpha = (status.isCanGetPrime()) ? 1.0 : 0.25
        }
        self.payButton.isEnabled = false
        self.payButton.alpha = 0.25
    }

    @IBAction func clickedPay(_ sender: UIButton) {
        // Example Card
        // Number : 4242 4242 4242 4242
        // DueMonth : 01
        // DueYear : 23
        // CCV : 123
        tpdCard.onSuccessCallback { [weak self] prime, cardInfo, _, _ in
            guard let self else { return }
            print("Prime : \(prime!), LastFour : \(cardInfo!.lastFour!)")
            print("Bincode : \(cardInfo!.bincode!), Issuer : \(cardInfo!.issuer!), cardType : \(cardInfo!.cardType), funding : \(cardInfo!.funding) ,country : \(cardInfo!.country!) , countryCode : \(cardInfo!.countryCode!) , level : \(cardInfo!.level!)")
            DispatchQueue.main.async {
                self.delegate?.payViewController(self, paymentSuccess: true, orderID: self.orderID)
            }
        }.onFailureCallback { status, message in

            print("status : \(status) , Message : \(message)")
            DispatchQueue.main.async {
                self.delegate?.payViewController(self, paymentSuccess: false, orderID: self.orderID)
            }
        }.getPrime()
    }
}
