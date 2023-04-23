import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var paymentResult: FlutterResult?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
//        let navigationController: UINavigationController = UINavigationController(rootViewController: controller)
        let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/payment",
                                                  binaryMessenger: controller.binaryMessenger)
        
//        window.rootViewController = navigationController
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
//                navigationController.pushViewController(viewController, animated: true)
                controller.present(viewController, animated: true)
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        batteryChannel.invokeMethod("payFinished", arguments: ["orderID": 123])
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
