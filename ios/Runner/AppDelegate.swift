import UIKit
import Flutter
import TPDirect

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var paymentResult: FlutterResult?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupTapPay()
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/payment",
                                                  binaryMessenger: controller.binaryMessenger)
        
        batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self else { result(FlutterMethodNotImplemented); return }
            // This method is invoked on the UI thread.
            switch call.method {
            case "getPayResult":
                guard let parameters = call.arguments as? [Int], let orderID = parameters.first else {
                    fallthrough
                }
                
                self.paymentResult = result
                
                let viewController: PayViewController = PayViewController(orderID: orderID)
                viewController.delegate = self
                controller.present(viewController, animated: true)
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        batteryChannel.invokeMethod("payFinished", arguments: ["orderID": 123])
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func setupTapPay() {
        //TapPat setup
        let appID: Int32 = 12348
        let appKey: String = "app_pa1pQcKoY22IlnSXq5m5WP5jFKzoRG58VEXpT7wU62ud7mMbDOGzCYIlzzLF"
        TPDSetup.setWithAppId(appID, withAppKey: appKey, with: TPDServerType.sandBox)
    }
}

extension AppDelegate: PayViewControllerDelegate {
    func payViewController(_ viewController: PayViewController, paymentSuccess: Bool, orderID: Int) {
        if paymentSuccess {
            paymentResult?(orderID)
        }
        else {
            paymentResult?(FlutterError(code: "PaymentError",
                                        message: "Payment not success",
                                        details: nil))
        }
        
        viewController.dismiss(animated: true)
    }
}
