# AppRouter

Apps need to handle launch of different Features / Submodules in below scenarios -

1. In App Routing - Routing based on various events in App
2. Universal URLs / URL Schemes - WebPages / SMS (Messages) / Browser / Notes etc
3. Push Notifications
4. Shortcuts / Quick Actions
5. Maintaining User Auth Flow, if user has not logged in



## Universal Links / URL Schemes - 

#### App should be launched from any url, which is adhered by app, and open up required feature screen to perform quick actions.

URLs can be from SMS, Email, Chat Messages, Safari browser etc. - when user tap on any link - then app will be launched

There are two ways to support this -

- URL Schemes
  - These are specific to OS viz iOS or Android.
  - If app is not installed then link will land in browser with 404 - not found.
  - No backend required.
  - Link will show popup to confirm whether user wants to launch app

- Universal Links
  - These are universal to OS viz iOS or Android.
  - SSL verified backend needed.
  - If app is not installed then link can be configured to have fallback page which can have links to install app. 
  - Link clicks will directly launch apps.
  - Link can be copied and used in device browser directly. Webpage will show banner that this link can be opened in app.



## Push Notifications

APNS / FCM notifications enabled in app, should redirect user to required screen when user tap them to view details / perform action.

Notifications have two scenarios - 

- Notification when app is in background or inactive
  - This scenario is handled by OS itself and notifications are always shown in Notification Curtain
  - User have default options to cancel or view 
- Notification when app is in foreground
  - In this scenario app has the control whether app should show notficiation in pop-up to confirm from user whether he wants to cancel/ view or directly take user to that required action.



## Shortcuts / Quick Actions

- Both iOS and Android provides support for shortcuts / quick actions from device home / menu screen.
- When user long presses (3d-touch) any app icon then it shows configured shortcuts of that app. 
- Users can select any of that shortcut option to reach that screen with minimum events.



## Maintaining User Auth

In few apps - its mandatory for us to make sure that user is authenticated before taking user to required Deep Link / Push / Shortcut option.



## App Router

### AppRouter - Registeration

Declare constants for path, which will be unique for each flow

> **static** **let** rechargeHostPath = "/recharge"

To register Route, Use AppRouter.Builder -

> AppRouter.Builder(path: Router.rechargeHostPath) { (**_**) **in**
>
> ​	 // Navigate to Rechrage Screen - Your own implementation goes here
>
> ​      RechargeRouter.sharedInstance().initialize(navCont: Router.sharedInstance.getNavigationStack())
>
> ​    }.build()



### AppRouter - Routing

Now for Any Event, just pass path to AppRouter -



**In App Routing** - 

> AppRouter.sharedInstance.route(urlPath: Router.rechargeHostPath)

**Universal URLs / URL Schemes** -

> **func** application(**_** app: UIApplication, open url: URL,
>
> ​           options: [UIApplication.OpenURLOptionsKey: **Any**] = [:]) -> Bool {
>
> ​    AppRouter.sharedInstance.route(urlPath: url.description)
>
> ​    **return** **true**
>
>   }

**Push Notifications**

> **func** application(**_** application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: **Any**], fetchCompletionHandler completionHandler: **@escaping**(UIBackgroundFetchResult) -> Void) {
>
> ​    **if** **let** aps = userInfo["aps"] **as**? [AnyHashable: **Any**], **let** target = aps["path"] **as**? String {
>
> ​       AppRouter.sharedInstance.route(urlPath: target, payload: aps)
>
> ​     }
>
>   }



### AppRouter - Maintaining User Auth

Whenever User Logs In Succefully - Just add below line -

> AppRouter.sharedInstance.isAuthenticated = **true**



In this case, if any pending route is there - then user will be taken to that flow.



For any particular Route - Auth is by default enabled, to override this, it can be done as per below -

> AppRouter.Builder(path: Router.cashInHostPath) { (**_**) **in**
>
> ​      // Navigate to Rechrage Screen - Your own implementation goes here
>
> ​      RechargeRouter.sharedInstance().initialize(navCont: Router.sharedInstance.getNavigationStack())
>
> ​      }
>
> ​    .isAuthRequired(isRequired: **false**)
>
> ​    .build()