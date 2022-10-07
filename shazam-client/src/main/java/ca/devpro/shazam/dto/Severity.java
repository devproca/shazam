package ca.devpro.shazam.dto;

public enum Severity {
	INFO("info"),
	WARN("warn"),
	ERROR("error"),
	OTHER("other");

	private final String label;

	Severity(String label) {
		this.label = label;
	}
}
