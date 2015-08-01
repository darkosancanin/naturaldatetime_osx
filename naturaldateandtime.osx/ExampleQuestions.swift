import Foundation

class ExampleQuestionsSection {
    var sectionTitle: String
	var questions: [String]
	
	init(sectionTitle: String, questions: [String]) {
        self.sectionTitle = sectionTitle
        self.questions = questions
    }
}

class ExampleQuestions {
    static let sharedInstance = ExampleQuestions()
	
	var exampleQuestionsSections: [ExampleQuestionsSection] = []
	
	init() {
		self.exampleQuestionsSections.append(ExampleQuestionsSection(sectionTitle: "Current time in a city", questions: ["What is the time in New York", "Time in Belgrade"]))
		self.exampleQuestionsSections.append(ExampleQuestionsSection(sectionTitle: "Time conversions between cities in different timezones", questions: ["What is the time in Kathmandu, Nepal when it is 7pm in New York, USA", "If its 4pm in London what is the time in Boston"]))
		self.exampleQuestionsSections.append(ExampleQuestionsSection(sectionTitle: "Time conversions between cities in different timezones on a particular date", questions: ["What is the time in Sao Paolo when it is 2:30pm on the 2nd of June in Detroit", "What time is it in Paris when it is 5-April-2015 in Sydney at 2am"]))
		self.exampleQuestionsSections.append(ExampleQuestionsSection(sectionTitle: "Daylight saving information for a city", questions: ["When does daylight saving time begin in Auckland"]))
		self.exampleQuestionsSections.append(ExampleQuestionsSection(sectionTitle: "Daylight saving information for a city for a specific year", questions: ["When does daylight saving time begin in New York in 2016"]))
    }
	
	func getExampleQuestionsSections() -> [ExampleQuestionsSection] {
        return exampleQuestionsSections
    }
	
	func getRandomQuestion() -> String {
        var randomSectionIndex = Int(arc4random_uniform(UInt32(exampleQuestionsSections.count)))
        var randomQuestionIndex = Int(arc4random_uniform(UInt32(exampleQuestionsSections[randomSectionIndex].questions.count)))
        return exampleQuestionsSections[randomSectionIndex].questions[randomQuestionIndex]
	}
}
