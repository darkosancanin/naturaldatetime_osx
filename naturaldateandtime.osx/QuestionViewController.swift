import Cocoa

class QuestionViewController: NSViewController {
    
    @IBOutlet var mainView: NSView!
    
    @IBOutlet weak var test2: NSTextField!
    @IBOutlet var test: NSView!
    override func viewWillAppear() {
        super.viewWillAppear()
        //mainView.wantsLayer = true
        //mainView.layer!.backgroundColor = NSColor(deviceRed: 244, green: 244, blue: 244, alpha: 1.0).CGColor
        
        //test.wantsLayer = true
        //test.layer!.backgroundColor = NSColor(deviceRed: 244, green: 244, blue: 244, alpha: 1.0).CGColor
        
        //test2.wantsLayer = true
        //test2.layer!.backgroundColor = NSColor(deviceRed: 244, green: 244, blue: 244, alpha: 1.0).CGColor
    }
}
