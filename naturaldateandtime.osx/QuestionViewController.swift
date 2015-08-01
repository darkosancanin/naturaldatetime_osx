import Cocoa

class QuestionViewController: NSViewController, NSTextFieldDelegate {
    
    var isShowingSampleQuestion = true
    @IBOutlet var mainView: NSView!
    @IBOutlet weak var questionTextField: NSTextField!
    @IBOutlet weak var outerQuestionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerTextField: NSTextField!
    @IBOutlet weak var notesTextField: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.questionTextField.delegate = self
        self.showPlaceholderExampleQuestion()
    }
    
    @IBAction func clearQuestionButtonPressed(sender: AnyObject) {
        self.hideAll()
        self.showPlaceholderExampleQuestion()
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        self.hideAll()
        self.questionTextField.textColor = NSColor.blackColor()
        //if self.isShowingSampleQuestion {
        //    self.isShowingSampleQuestion = false
        //    self.questionTextField.stringValue = ""
        //}
        //else if self.questionTextField.stringValue.isEmpty {
        //    self.showRandomQuestion()
        //}
        //if self.questionTextField.stringValue.isEmpty {
        //    self.showRandomQuestion()
        //}
        self.resizeQuestionTextField()
    }
 
    func resizeQuestionTextField(){
        let constraint = CGSize(width: self.questionTextField.frame.width, height: CGFloat.max)
        var textToSize = self.questionTextField.stringValue
        if self.questionTextField.stringValue.isEmpty {
            if let text = self.questionTextField.placeholderString {
                textToSize = text
                println("using placeholder text")
            }
        }
        let size = NSString(string: textToSize as NSString).boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.questionTextField.font!])
        self.outerQuestionTextHeightConstraint.constant = size.height + 20
        self.questionTextHeightConstraint.constant = size.height
        //self.outerQuestionTextHeightConstraint.constant = self.questionTextField.intrinsicContentSize.height + 20
    }
    
    @IBAction func questionTextFieldEnterPressed(sender: AnyObject) {
        println("enter pressed")
    }
    
    func showPlaceholderExampleQuestion() {
        self.questionTextField.stringValue = ""
        self.questionTextField.placeholderString = "e.g. " + ExampleQuestions.sharedInstance.getRandomQuestion()
        //self.isShowingSampleQuestion = true
        //self.questionTextField.selectText(self)
        //self.questionTextField.currentEditor()!.moveToBeginningOfDocument(nil)
        self.resizeQuestionTextField()
    }
    
    func hideAll() {
        self.answerTextField.hidden = true
        self.progressIndicator.hidden = true
        self.progressIndicator.stopAnimation(self)
        self.notesTextField.hidden = true
    }
}