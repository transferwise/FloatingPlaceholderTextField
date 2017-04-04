//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = ViewController(nibName: nil, bundle: nil)
        w.makeKeyAndVisible()
        window = w
        return true
    }
}
