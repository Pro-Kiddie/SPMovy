package dto;

public class Movie {
	
	private int movieID;
	private String movieTitle;
	private String actorList; //["actor1","actor2","actor3" ...]
	private String releaseDate; //E.g 01 MAY 2018 [Note: Ensure date submitted in YYYY-MM-DD format. Can use <select> or JQuery]
	private String synopsis;
	private int duration;
	private String status; //can only be "showing" or "coming" or "over" [Note: make sure HTML form value submitted is only 1 of the 3] 
	//String image url
	
	public int getMovieID() {
		return movieID;
	}
	public void setMovieID(int movieID) {
		this.movieID = movieID;
	}
	public String getMovieTitle() {
		return movieTitle;
	}
	public void setMovieTitle(String movieTitle) {
		this.movieTitle = movieTitle;
	}
	public String getActorList() {
		return actorList;
	}
	public void setActorList(String actorList) {
		this.actorList = actorList;
	}
	public String getReleaseDate() {
		return releaseDate;
	}
	public void setReleaseDate(String releaseDate) {
		this.releaseDate = releaseDate;
	}
	public String getSynopsis() {
		return synopsis;
	}
	public void setSynopsis(String synopsis) {
		this.synopsis = synopsis;
	}
	public int getDuration() {
		return duration;
	}
	public void setDuration(int duration) {
		this.duration = duration;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	

}
