import Cocoa

class QuestionViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var questionTextField: NSTextField!
    @IBOutlet weak var outerQuestionTextHeightConstraint: NSLayoutConstraint!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.questionTextField.delegate = self
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        println("---")
        println(self.questionTextField.intrinsicContentSize)
        println((obj.object as! NSTextField).frame.height)
        self.outerQuestionTextHeightConstraint.constant = self.questionTextField.intrinsicContentSize.height + 20;
    }
}
