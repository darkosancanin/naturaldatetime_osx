import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        var mainAppIsAlreadyRunning = false
        let runningApplications = NSWorkspace.sharedWorkspace().runningApplications as! [NSRunningApplication]
        for app : NSRunningApplication in runningApplications {
            if app.bundleIdentifier == "com.darkosancanin.naturaldateandtime.osx" {
                mainAppIsAlreadyRunning = true
            }
        }
        
        if(!mainAppIsAlreadyRunning){
            var pathToBundle = NSBundle.mainBundle().bundlePath.pathComponents
            pathToBundle.removeLast()
            pathToBundle.removeLast()
            pathToBundle.removeLast()
            pathToBundle.append("MacOS")
            pathToBundle.append("Natural Date and Time")
            let pathToMainApp = String.pathWithComponents(pathToBundle)
            NSWorkspace.sharedWorkspace().launchApplication(pathToMainApp)
        }
        
		self.killApp()
    }
    
    func killApp(){
        NSApplication.sharedApplication().terminate(self)
    }
}

