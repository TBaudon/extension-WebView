OpenFLWebView
=============

Display a web page in your openfl game.

##Use

add OpenFLWebView in your haxelib.
Then :

  ```haxe
  var mWebView = new WebView("http://wwww.myWebSite.net", 800,800,true);// true specifies that we want to add a close button to the view.
  mWebView.x = 200;
  mWebView.y = 100;
  addChild(mWebView);
  mWebView.addEventlistener(ProgressEvent.PROGRESS, onProgress);
  mWebView.addEventlistener(Event.COMPLETE, onLoadComplete);
  mWebView.addEventlistener(ErrorEvent.ERROR, onLoadError);
  mWebView.addEventlistener(‘close’, onClosed);
  //later
  mWebView.loadUrl("newUrl");
  //remove
  removeChild(mWebView);
  // destroy
  mWebView.dispose();
  mWebView = null;
  ```
Please note that event if it looks like it's a displayObject, it won't respect the display hierarchy as it's basicaly a WebView on top of the game mainView. 
So it will always appear on top of your game, whatever you do.

  
##RoadMap
###Android
* Move the webview // done 
* Add the webview // done
* Remove the webView // done
* Destroy the webView // done
* Event for error, page not found, page loaded ect. // done
* handle orientation change.

###iOS
* Move the webView // done
* Add the webview // done
* Remove the webview // done
* Destroy
* Events
* handle screen landscape orientation // done
* orientation change. // done
