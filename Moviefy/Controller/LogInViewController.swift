//
//  LogInViewController.swift
//  Moviefy
//
//  Created by Benjamin Simpson on 5/4/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import UIKit
import AuthenticationServices

class LogInViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        APIClient.shared.createRequestToken { (result) in
            switch result{
            case let .success(token):
                DispatchQueue.main.async {
                    print(token.request_token)
                    self.authorizeRequestToken(from: self, requestToken: token.request_token)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func authorizeRequestToken(from viewController: UIViewController, requestToken: String) {
        // Use the URL and callback scheme specified by the authorization provider.
        guard let authURL = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=moviefy://auth") else { return }
        let scheme = "auth"
        // Initialize the session using the class from AuthenticationServices
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme)
        { callbackURL, error in
            // Handle the callback.
            guard error == nil, let callbackURL = callbackURL else { return }
            
            // The callback URL format depends on the provider.
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
                print(queryItems)
            guard let requestToken = queryItems?.first(where: { $0.name == "request_token" })?.value else { return }
            let approved = (queryItems?.first(where: { $0.name == "approved" })?.value == "true")
            
            print("Request token \(requestToken) \(approved ? "was" : "was NOT") approved")
            
            self.startSession(requestToken: requestToken) { success in
                print("Session started")
            }
        }
        session.presentationContextProvider = self
        session.start()
    }
    
    func startSession(requestToken: String, completion: @escaping (Bool) -> Void) {
        APIClient.shared.createSession(requestToken: requestToken) { (result) in
            switch result{
            case let .success(session):
                DispatchQueue.main.async {
                    print(session.session_id)
                    self.getUserId(sessionId: session.session_id)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getUserId(sessionId: String) {
        APIClient.shared.fetchAccount(sessionId: sessionId) { (result) in
            switch result{
            case let .success(session):
                DispatchQueue.main.async {
                    self.loginLabel.text = "Login As: \(session.username!)"
                }
            case let .failure(error):
                print(error)
            }
        }
    }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            return view.window!
        }
        
    }

