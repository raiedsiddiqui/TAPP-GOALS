package org.tapestry.objects;

public class DisplayedSurveyResult {
	private String questionId;
	private String questionAnswer;
	private String observerNotes;
	private String title;
	private String date;
	
	public DisplayedSurveyResult(){
		
	}
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getQuestionId() {
		return questionId;
	}
	public void setQuestionId(String questionId) {
		this.questionId = questionId;
	}
	public String getQuestionAnswer() {
		return questionAnswer;
	}
	public void setQuestionAnswer(String questionAnswer) {
		this.questionAnswer = questionAnswer;
	}
	public String getObserverNotes() {
		return observerNotes;
	}
	public void setObserverNotes(String observerNotes) {
		this.observerNotes = observerNotes;
	}
	
	

}
