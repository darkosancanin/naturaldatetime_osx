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
        //self.outerQuestionTextHeightConstraint.constant = self.questionTextField.intrinsicContentSize.height + 20
    }
    
    @IBAction func questionTextFieldEnterPressed(sender: AnyObject) {
        
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
        //self.notesTextView.hidden = true
    }
}