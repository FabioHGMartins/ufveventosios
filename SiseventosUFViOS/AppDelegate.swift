//
//  AppDelegate.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 31/08/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications
import Firebase
import GoogleSignIn
import KYDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        
        GMSServices.provideAPIKey(GMS_KEY)
        
        let splashScreenView = SplashScreen(nibName: "SplashScreen", bundle: nil)
        
        self.window!.rootViewController = splashScreenView
        self.window!.makeKeyAndVisible()
        
        //Configurando a instância do GIDSignIn para fazer o login com Google
        GIDSignIn.sharedInstance().clientID = "953311697524-7ec4ku2ebd4u3kkgse1ss7rth25rump0.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

        
        // Registra o aplicativo no serviço de notificações
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        
        return true
    }
    
    //Firebase Messaging
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {        
        UsuarioSingleton.shared.token = fcmToken
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // Google Sign In
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation!]
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    // Função de sign in com Google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let nome = user.profile.givenName + " " + user.profile.familyName
            let email = user.profile.email
            let googleId = user.userID
            var requester = UsuarioRequester()
            requester.loginComGoogle(nome: nome, email: email!, googleId: googleId!, handleFinish: { (ready,success) in
                if(ready) {
                    if(success) {
                        let principalView = PrincipalView(nibName:"PrincipalView", bundle: nil)
                        let menuView = MenuView(nibName:"MenuView", bundle: nil)
                        let drawerKYController     = KYDrawerController(drawerDirection: .left, drawerWidth: 280)
                        drawerKYController.mainViewController = UINavigationController(
                            rootViewController: principalView
                        )
                        drawerKYController.drawerViewController = menuView
                        AppDelegate.sharedInstance().window?.rootViewController = drawerKYController
                    } else {
                        Alerta.alerta("Usuário inválido", msg: "O email indicado já foi cadastrado. Por favor, insira um novo email.", view: (AppDelegate.sharedInstance().window?.rootViewController)!)
                    }
                }
            })
        }
    }
    

    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    class func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }

}
