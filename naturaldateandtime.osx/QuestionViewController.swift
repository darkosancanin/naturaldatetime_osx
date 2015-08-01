import Cocoa

class QuestionViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet var mainView: NSView!
    @IBOutlet weak var questionTextField: NSTextField!
    @IBOutlet weak var outerQuestionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerTextField: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet var notesTextView: NSTextView!
    @IBOutlet weak var notesTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var outerNotesView: NSScrollView!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setUpQuestionTextView()
        self.setUpNoteView()
        self.showPlaceholderExampleQuestion()
        self.hideAll()
    }
    
    func setUpQuestionTextView() {
        self.questionTextField.delegate = self
    }
    
    func setUpNoteView() {
        self.notesTextView.textContainerInset = NSSize(width: 8,height: 8)
    }
    
    @IBAction func clearQuestionButtonPressed(sender: AnyObject) {
        self.hideAll()
        self.showPlaceholderExampleQuestion()
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        self.hideAll()
        self.questionTextField.textColor = NSColor.blackColor()
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
    }
    
    func resizeNotesTextView(){
        let constraint = CGSize(width: self.notesTextView.frame.width, height: CGFloat.max)
        let size = NSString(string: self.notesTextView.string! as NSString).boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.questionTextField.font!])
        self.notesTextViewHeightConstraint.constant = size.height
    }
    
    @IBAction func questionTextFieldEnterPressed(sender: AnyObject) {
        if self.questionTextField.stringValue.isEmpty == false {
            self.askQuestion()
        }
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
                    self.showAnswer("Im sorry I could not understand your question. Please try and rephrase your question or tap on the examples link above to see what questions I do understand.", note: nil)
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
        })
    }
    
    func showError(error: NSError){
        println(error.localizedDescription)
        var friendlyError = "Oops. Something went wrong. Please try again."
        if error.localizedDescription.lowercaseString.rangeOfString("connection appears to be offline") != nil {
            friendlyError = "Oops. No connection available. Please check your internet connection."
        }
        self.showAnswer(friendlyError, note:nil)
    }
}