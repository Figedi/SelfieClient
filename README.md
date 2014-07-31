Selfie App for CMK-Project 2014
=====

Selfie app for a Project at University of Lübeck. Basically it's a small Cordova-App which can take selfie pictures and then uploads them to a server, pretty standard stuff. :-)


Installation
-----

For Installation, you need the following:
  * Cordova ~> 3.5.0
  * Working ADT/iOS environment
  * node ~> 0.10 + npm
  * gulp, coffeeify, browserify (`npm i -g gulp coffeeify browserify)
  * Third-party libraries for dev/client, run from project root directory:
    * `bower install`
    * `npm install`
  * Build sourcefiles from scratch: `gulp build` 

Usage
-----
This project utilizes a gulp workflow, for starters in devmode, use `gulp` from Command-Line for a browser-sync server, sass, coffee, jade build process.


Building
-----

This project is just the HTML-Base for the App. For Platform specific builds, refer to the repositories containing this repo as a submodule. Currently there are two builds: IOS and Android.
For Local Testing, we are using browser-sync:
  * Cordova Development App with live-refresh (i.e. `gulp`, then follow instructions of browser-sync)

Android-Repository: https://github.com/Figedi/SelfieClient-Android
IOS-Repository: https://github.com/Figedi/SelfieClient-IOS

Please refer to the cordova docs for further building instructions, this is pretty straight forward (i.e. `cordova build android` and `cordova run android`)

Contribute
----

If you want to contribute, feel free to fork & do some pull-requests :)

