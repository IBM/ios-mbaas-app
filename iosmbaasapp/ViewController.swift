//
//  ViewController.swift
//  basicmbaasios
//

import UIKit
import BMSCore
import BMSPush


import IBMCloudAppID




class ViewController: UIViewController {

    // User Identity Token
    var authToken: IdentityToken?
    // AppID Authorization Button
    var authButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        NotificationCenter.default.addObserver(self,
                                                selector: #selector(didBecomeActive),
                                                name: UIApplication.didBecomeActiveNotification,
                                                object: nil)

        // Setup AppID Authorization button
        let loginButton = UIBarButtonItem(title: "Login",
                                       style: .plain,
                                       target: self,
                                       action: #selector(authHandler))
        loginButton.tintColor = .white
        self.authButton = loginButton
        self.navigationItem.setLeftBarButton(loginButton, animated: true)
        
        
        
    }

    @objc func didBecomeActive(_ notification: Notification) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// AppID Authorization Delegate
extension ViewController: AuthorizationDelegate {

    // Executes login and logout logic
    @IBAction func authHandler() {
        DispatchQueue.main.async {
            // If not signed in, then sign in
            if self.authToken == nil {
                AppID.sharedInstance.loginWidget?.launch(delegate: self)
            } else {
                self.logout()
            }
        }
    }

    // Sign out handler
    func logout() {
        /// Delete tokens
        self.authToken = nil

        /// Return to default state
        self.authButton.title = "Login"
        self.navigationItem.title = "Home"
    }

    // Authorization failure handler
    func onAuthorizationFailure(error: AuthorizationError) {
        print("Authorization Failed!")
    }

    // Authorization success handler
    func onAuthorizationSuccess(accessToken: AccessToken?, identityToken: IdentityToken?, refreshToken: RefreshToken?, response: Response?) {
        self.authToken = identityToken

        DispatchQueue.main.async {
            self.navigationItem.title = "Hello " + (identityToken?.name ?? "Authenticated User") + "!"
            self.authButton.title = "Logout"
        }
    }

    // Authorization cancellation handler
    func onAuthorizationCanceled() {
        print("Authorization Cancelled!")
    }
}
