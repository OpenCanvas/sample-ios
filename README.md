## Description
This is a sample project that demonstrates how to use the [OpenCanvas][0] platform to build a location based iOS app.

## Installation
Sample project is using cocoa pods for dependency management. Current version is dependent on [JSONKit][1] and [MKNetworkKit][2] pods. You need to have cocoa pods installed. More info about cocoa pods installation you may find here: [cocoapods.org][3]

##### Step 1: Clone project locally
Clone the sample OpenCanvas project locally in a folder of your preference. 

##### Step 2: Install pods in project
After successfully cloning the project, run `pod install` from terminal inside the folder of the cloned project (where `Podfile` file resides).

##### Step 3: Open project workspace and run
Open the `RoutesSample.xcworkspace` file in Xcode and click run. Voila!

## Sample
The app contains a single map view. Initially, a request is made to the OpenCanvas server (through OpenCanvas API) and a list of routes (see `Route` class) is downloaded. For testing purposes, first route is selected by default and a second request is made to obtain the list of POIs (see `Place` class) that are related to this route. These places are then presented on a map view.

[0]: http://www.opencanvas.co/
[1]: https://github.com/johnezang/JSONKit
[2]: https://github.com/MugunthKumar/MKNetworkKit
