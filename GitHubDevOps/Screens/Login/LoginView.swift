//
//  Login.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/12/20.
//

import SwiftUI
import AuthenticationServices

class ShimViewController: UIViewController, ASWebAuthenticationPresentationContextProviding
{
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {

         return ASPresentationAnchor()

    }
}

class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}

struct Login: View {
    @EnvironmentObject var viewer: GetViewer
    @State private var webAuthSession: ASWebAuthenticationSession?
    @State var pushActive:Bool = false
    @State var isHidden = false
    @State var client_id: String = ""
    @State var client_secret: String = ""
    @State var redirect_uri: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
//                NavigationLink(destination: HomeView(rootIsActive: self.$pushActive).navigationBarBackButtonHidden(true), isActive: self.$pushActive) {
//                            HStack{
//                                Image("github3")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 64.0, height: 64.0)
//                                Text("Login with GitHub")
//                            }
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(Color.blue)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//
//                //.isDetailLink(false)
                
                NavigationLink(destination: HomeView(rootIsActive: self.$pushActive).navigationBarBackButtonHidden(true), isActive: self.$pushActive) {
                    Button(action: {
                        print("login tapped")
                        checkLoginState()
                    }) {
                        HStack{
                            Image("github3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64.0, height: 64.0)
                            Text("Login with GitHub")
                        }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                }
            }
        }
        .onAppear(perform: {
            //For Testing 
            //UserDefaults.standard.set("", forKey: "Bearer")
            checkLoginState()
        })
    }
    func checkLoginState() {
        if UserDefaults.standard.string(forKey: "Bearer") == nil ||
            UserDefaults.standard.string(forKey: "Bearer") == "" {
            isHidden = true
            getAuthTokenWithWebLogin(context: ShimViewController())
        } else {
            viewer.bearerToken = UserDefaults.standard.string(forKey: "Bearer")!
            print("Bearer \(viewer.bearerToken)")
            viewer.fetchViewer()
            self.pushActive = true
        }
    }
    
    func getAuthTokenWithWebLogin(context: ASWebAuthenticationPresentationContextProviding) {

        var keys: NSDictionary?
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
               keys = NSDictionary(contentsOfFile: path)
           }
        if let dict = keys {
            client_id = (dict["client_id"] as? String) ?? "EMPTY"
            client_secret = (dict["client_secret"] as? String) ?? "EMPTY"
            redirect_uri = (dict["redirect_uri"] as? String) ?? "EMPTY"
        }
        
        let authURLstr  = "https://github.com/login/oauth/authorize?client_id=" + client_id + "&scope=user%20public_repo%20repo%20read:repo_hook%20read:org%20read:public_key%20read:gpg_key"
        
        let authURL = URL(string: authURLstr)
        let callbackUrlScheme = "LoginExample3"

        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in

            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }

            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first

            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken ?? "No OAuth Token")
            
            let accessURLstr = "https://github.com/login/oauth/access_token?client_id=" + client_id + "&redirect_uri=" + redirect_uri + "&client_secret=" + client_secret + "&code=" + (oauthToken?.value)!
            let accessURL = URL(string:accessURLstr)
            var request = URLRequest(url: accessURL!)
            print(request)
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("error: \(error)")
                } else {
                    if let response = response as? HTTPURLResponse {
                        print("statusCode: \(response.statusCode)")
                    }
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("data: \(dataString)")
                        let items = dataString.components(separatedBy: "&").compactMap( {pair -> (String, String) in
                            let keyValue = pair.components(separatedBy: "=")
                            return (keyValue[0], keyValue[1])
                        })
                        items.forEach {
                            if $0.0 == "access_token" {
                                print("Bearer: \($0.1)")
                                UserDefaults.standard.set($0.1, forKey: "Bearer")
                                viewer.bearerToken = UserDefaults.standard.string(forKey: "Bearer")!
                                viewer.fetchViewer()
                                self.pushActive = true
                            }
                        }
                    }
                }
            }
            task.resume()
            
        })
        

        self.webAuthSession?.presentationContextProvider = context
        //For testing
        //self.webAuthSession?.prefersEphemeralWebBrowserSession = true
 
        self.webAuthSession?.start()
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
