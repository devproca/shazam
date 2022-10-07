package ca.devpro.shazam.dto;

import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDate;
import java.util.UUID;

@Data
@Accessors(chain = true)
public class LogDto {
	private String id;
	private Severity severity;
	private String app;
	private String log;
	private long date;

	public String toJson() {
		return "{\n    \"id\" : \"$id\",\n    \"severity\" : \"$severity\",\n    \"log\" : \"$log\",\n    \"app\" : \"$app\",\n    \"date\" : $date\n}"
				.replace("$id", id)
				.replace("$severity", severity.toString())
				.replace("$log", log)
				.replace("$app", app)
				.replace("$date", Long.toString(date/1000));

	}
}
