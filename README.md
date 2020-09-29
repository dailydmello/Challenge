# How to run
1) Must have cocoapods to run project
2) Git checkout and run  `pod install`
3) Build and run app! :)

# Built Using
- Xcode 11.7

# Pods Used
1) [RxSwift](https://github.com/ReactiveX/RxSwift) for networking
2) [Sd web Image](https://github.com/SDWebImage/SDWebImage) for image caching to prevent making multiple api calls for the same image

# Assumptions made
Given the following [JSON](https://www.reddit.com/r/swift/.json), I assumed the title for articles are generated from the `title` field, the thumbnail is generated from `thumbnail` field, and body is generated from `selftext` field.

# Highlights of code
- Networking layer
- Error Classes
- MVP Architecture 
- Small UI improvements for user, ex. empty view, activity spinner
- Abstracting Presenter and Viewcontroller into protocols that give it certain responsibilities. Ex. `Loadable` `ErrorMessagePresentable` `Presentable` `ViewControllable` protocols, which allows for better scaling.
