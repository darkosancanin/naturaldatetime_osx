import Cocoa
import ServiceManagement

class QuestionViewController: NSViewController, NSTextFieldDelegate {
    
    var popoverDelegate : PopoverDelegate?
    @IBOutlet var mainView: NSView!
    @IBOutlet weak var questionTextField: NSTextField!
    @IBOutlet weak var outerQuestionTextField: NSTextField!
    @IBOutlet weak var outerQuestionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerTextField: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet var notesTextView: NSTextView!
    @IBOutlet weak var notesTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerNotesView: NSScrollView!
    @IBOutlet weak var footerTextField: NSTextField!
    @IBOutlet weak var launchAtLoginMenuItem: NSMenuItem!
    @IBOutlet weak var titleImage: NSImageView!
    var questionTextColor = NSColor.blackColor()
    var standardTextColor : NSColor? = NSColor.whiteColor()
	
    override init!(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(popoverDelegate: PopoverDelegate) {
        self.init(nibName: "QuestionView", bundle: nil)
        self.popoverDelegate = popoverDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpQuestionTextField()
        self.setUpNoteTextView()
        self.setUpLaunchAtLoginMenuItem()
        self.standardTextColor = self.answerTextField.textColor
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        self.hideAll()
        self.showPlaceholderExampleQuestion()
        self.updatePopoverHeight()
        self.changeMenuBarModeSpecificElements()
    }
    
    func changeMenuBarModeSpecificElements(){
        let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
        if appearance == "Light" {
            self.questionTextColor = NSColor.blackColor()
            self.questionTextField.textColor = questionTextColor
            self.answerTextField.textColor = standardTextColor
            self.titleImage.image = NSImage(named: "Title")
            self.footerTextField.textColor = standardTextColor
        }
        else {
            self.questionTextColor = NSColor.whiteColor()
            self.questionTextField.textColor = questionTextColor
            self.answerTextField.textColor = NSColor.whiteColor()
            self.titleImage.image = NSImage(named: "TitleDarkMode")
            self.footerTextField.textColor = NSColor.whiteColor()
        }
    }
    
    func setUpQuestionTextField() {
        self.questionTextField.delegate = self
    }
    
    func setUpNoteTextView() {
        self.notesTextView.textContainerInset = NSSize(width: 8, height: 8)
    }
    
    func setUpLaunchAtLoginMenuItem(){
        let applicationWasLaunchedAtLogin = NSUserDefaults.standardUserDefaults().boolForKey("launchAtLogin")
		if applicationWasLaunchedAtLogin == true {
            self.launchAtLoginMenuItem.state = NSOnState
        }
    }
    
    @IBAction func launchAtLoginPressed(sender: AnyObject) {
        if(self.launchAtLoginMenuItem.state == NSOffState){
            if SMLoginItemSetEnabled("com.darkosancanin.naturaldateandtime.osx.helper", Boolean(1)) != 0 {
                self.launchAtLoginMenuItem.state = NSOnState
				NSUserDefaults.standardUserDefaults().setBool(true, forKey: "launchAtLogin")
            }
            else{
                let aboutPopup: NSAlert = NSAlert()
                aboutPopup.messageText = "An Error Ocurred"
                aboutPopup.informativeText = "Unable to add application to login item list."
                aboutPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
                aboutPopup.addButtonWithTitle("OK")
                aboutPopup.runModal()
            }
        }
        else {
            if SMLoginItemSetEnabled("com.darkosancanin.naturaldateandtime.osx.helper", Boolean(0)) != 0 {
                self.launchAtLoginMenuItem.state = NSOffState
				NSUserDefaults.standardUserDefaults().setBool(false, forKey: "launchAtLogin")
            }
            else{
                let aboutPopup: NSAlert = NSAlert()
                aboutPopup.messageText = "An Error Ocurred"
                aboutPopup.informativeText = "Unable to remove application from login item list."
                aboutPopup.alertStyle = NSAlertStyle.CriticalAlertStyle
                aboutPopup.addButtonWithTitle("OK")
                aboutPopup.runModal()
            }
        }
    }
    
    @IBAction func aboutMenuItemPressed(sender: AnyObject) {
        let aboutPopup: NSAlert = NSAlert()
        aboutPopup.messageText = "Natural Date and Time"
        aboutPopup.informativeText = "Version 1.0\n2015 Darko Sancanin"
        aboutPopup.alertStyle = NSAlertStyle.InformationalAlertStyle
        aboutPopup.addButtonWithTitle("OK")
        aboutPopup.runModal()
    }
    
    @IBAction func quitMenuItemPressed(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)
    }
    
    @IBAction func clearQuestionButtonPressed(sender: AnyObject) {
        self.hideAll()
        self.showPlaceholderExampleQuestion()
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        self.hideAll()
        self.questionTextField.textColor = self.questionTextColor
        self.resizeQuestionTextField()
    }
 
    func resizeQuestionTextField(){
        let constraint = CGSize(width: self.questionTextField.frame.width, height: CGFloat.max)
        var textToSize = self.questionTextField.stringValue
        if self.questionTextField.stringValue.isEmpty {
            if let text = self.questionTextField.placeholderString {
                textToSize = text
            }
        }
        let size = NSString(string: textToSize as NSString).boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.questionTextField.font!])
        self.outerQuestionTextHeightConstraint.constant = size.height + 20
        self.questionTextHeightConstraint.constant = size.height
        self.updatePopoverHeight()
    }
    
    func resizeNotesTextView(){
        let constraint = CGSize(width: self.outerNotesView.frame.width, height: CGFloat.max)
        let size = NSString(string: self.notesTextView.string! as NSString).boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.questionTextField.font!])
        self.notesTextViewHeightConstraint.constant = size.height
    }
    
    @IBAction func questionTextFieldEnterPressed(sender: AnyObject) {
        if self.questionTextField.stringValue.isEmpty == false {
            self.askQuestion()
        }
    }
    
    override func doCommandBySelector(aSelector: Selector) {
        if aSelector == "cancelOperation:" {
            self.popoverDelegate?.closePopover(self)
        }
    }
    
    func updatePopoverHeight(){
        var height: CGFloat = 25
        if self.progressIndicator.hidden == false {
            height += self.progressIndicator.frame.height + 25
        }
        if self.answerTextField.hidden == false {
            let constraint = CGSize(width: self.answerTextField.frame.width, height: CGFloat.max)
            let answerHeight = NSString(string: self.answerTextField.stringValue as NSString).boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.answerTextField.font!]).height
            height += answerHeight + 25
        }
        if self.outerNotesView.hidden == false {
            height += self.outerNotesView.frame.height + 25
        }
        self.popoverDelegate?.resizeToHeight(height + self.questionTextHeightConstraint.constant  + 180)
    }
    
    func showPlaceholderExampleQuestion() {
        self.questionTextField.stringValue = ""
        self.questionTextField.placeholderString = "e.g. " + ExampleQuestions.sharedInstance.getRandomQuestion()
        self.resizeQuestionTextField()
    }
    
    func hideAll() {
        self.answerTextField.hidden = true
        self.progressIndicator.hidden = true
        self.progressIndicator.stopAnimation(self)
        self.outerNotesView.hidden = true
    }
    
    func askQuestion() {
        self.hideAll()
        self.questionTextField.resignFirstResponder()
        self.progressIndicator.hidden = false
        self.progressIndicator.startAnimation(self)
        self.updatePopoverHeight()
        var urlRequest = NSMutableURLRequest(URL: NSURL(string: "http://www.naturaldateandtime.com/api/question")!)
        var urlSession = NSURLSession.sharedSession()
        urlRequest.HTTPMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        var postParameters = "client=osx&client_version=1.0&question=" + self.questionTextField.stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        urlRequest.HTTPBody = postParameters.dataUsingEncoding(NSUTF8StringEncoding)
        
        var dataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: {data, response, error -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                self.hideAll()
            })
            if let unwrappedError = error {
                self.showError(unwrappedError)
                return
            }
            var jsonError: NSError?
            var jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &jsonError) as? NSDictionary
            
            if let unwrappedError = jsonError {
                self.showError(unwrappedError)
                return
            }
            
            if let parsedJSON = jsonObject {
                let answerText = parsedJSON["AnswerText"] as? String
                let note = parsedJSON["Note"] as? String
                let understoodQuestion = parsedJSON["UnderstoodQuestion"] as! Bool
                if understoodQuestion {
                    self.showAnswer(answerText, note:note)
                } else {
                    self.showAnswer("Im sorry I could not understand your question. Please rephrase your question.", note: nil)
                }
            }
            else {
                self.showAnswer("Oops. Something went wrong. Please try again.", note:nil)
            }
        })
        
        dataTask.resume()
    }
    
    func showAnswer(answer: String?, note: String?){
        dispatch_async(dispatch_get_main_queue(),{
            if let answerText = answer {
                self.answerTextField.stringValue = answerText
                self.answerTextField.hidden = false
            }
            
            if let noteText = note {
                self.notesTextView.string = noteText
                self.resizeNotesTextView()
                self.outerNotesView.hidden = false
            }
            self.updatePopoverHeight()
        })
    }
    
    func showError(error: NSError){
        println(error.localizedDescription)
        var friendlyError = "Oops. Something went wrong. Please try again."
        if error.code == -1009 {
            friendlyError = "Oops. No connection available. Please check your internet connection."
        }
        self.showAnswer(friendlyError, note:nil)
    }
}