import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        var mainAppIsAlreadyRunning = false
        let runningApplications = NSWorkspace.sharedWorkspace().runningApplications as! [NSRunningApplication]
        for app : NSRunningApplication in runningApplications {
            if app.bundleIdentifier == "com.darkosancanin.naturaldateandtime-osx" {
                mainAppIsAlreadyRunning = true
            }
        }
        
        if(mainAppIsAlreadyRunning){
            self.killApp()
        }
        else{
            NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: Selector("killApp:"), name: "naturaldateandtime.terminate.helper", object: "com.darkosancanin.naturaldateandtime-osx")
            
            var pathToBundle = NSBundle.mainBundle().bundlePath.pathComponents
            pathToBundle.removeLast()
            pathToBundle.removeLast()
            pathToBundle.removeLast()
            pathToBundle.append("MacOS")
            pathToBundle.append("naturaldateandtime_osx")
            let pathToMainApp = String.pathWithComponents(pathToBundle)
            NSWorkspace.sharedWorkspace().launchApplication(pathToMainApp)
        }
    }
    
    func killApp(){
        NSApplication.sharedApplication().terminate(self)
    }
    
    func killApp(notification:NSNotification) {
        self.killApp()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        
    }
}

