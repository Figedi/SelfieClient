Selfie App for CMK-Project 2014
=====

Selfie app for a Project at University of Lübeck. Basically its a small phonegap-App which can take selfie pictures and then uploads them to a server, pretty standard stuff. :-)


Installation
-----

For Installation, you need the following:
  * Phonegap ~> 3.4.0
  * Working ADT/iOS environment
  * node ~> 0.10 + npm
  * compass gem (`gem install compass`)
  * gulp, coffeeify, browserify (`npm i -g gulp coffeeify browserify)
  * Third-party libraries for dev/client, run from project root directory:
    * `bower install`
    * `npm install`

Usage
-----
This project utilizes a gulp workflow, for starters in devmode, use `gulp` from Command-Line for a live-reload) server, compass, coffee, jade build process. (Livereload plugin required)


Building
-----
Currently two plattforms are installed: Android and iOS. For other platforms, follow the plattform guide of phonegap.
All src/ files are copied to www during the `gulp build` task, so a phonegap build always gets the latest source files. For plattform building/debugging on devices, you can either use:
  * Phonegap Development App with live-refresh (i.e. `phonegap serve`)
  * Android USB Debugging/iOS USB Installation

Please refer to the phonegap docs for further building instructions, this is pretty straight forward (i.e. `phonegap build android` and `phonegap run android`)

Contribute
----

If you want to contribute, feel free to fork & do some pull-requests :)

