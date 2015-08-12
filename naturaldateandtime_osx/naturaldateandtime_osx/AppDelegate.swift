import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PopoverDelegate {

    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            button.image?.setTemplate(true)
            button.action = Selector("togglePopover:")
        }
        
        popover.contentViewController = QuestionViewController(popoverDelegate: self)
        
        eventMonitor = EventMonitor(mask: .LeftMouseDownMask | .RightMouseDownMask) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSMinYEdge)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func resizeToHeight(height: CGFloat){
        popover.contentSize.height = height
    }
}

