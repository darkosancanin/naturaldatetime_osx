import Cocoa

class QuestionViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var questionTextField: NSTextField!
    @IBOutlet weak var outerQuestionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerTextField: NSTextField!
    @IBOutlet weak var notesTextField: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.questionTextField.delegate = self
    }
    
    @IBAction func clearQuestionButtonPressed(sender: AnyObject) {
        self.questionTextField.stringValue = ""
        self.resizeQuestionTextField()
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        self.resizeQuestionTextField()
    }
    
    func resizeQuestionTextField(){
        self.outerQuestionTextHeightConstraint.constant = self.questionTextField.intrinsicContentSize.height + 20
    }
}