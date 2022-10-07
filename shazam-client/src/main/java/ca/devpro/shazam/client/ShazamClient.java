package ca.devpro.shazam.client;

import ca.devpro.shazam.dto.LogDto;
import ca.devpro.shazam.dto.Severity;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.springframework.scheduling.annotation.Async;
import org.springframework.util.StringUtils;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

public class ShazamClient {
	public static final String DEFAULT_BASE_URI = "http://localhost:8080/";
	public static final String DEFAULT_APP = "Untitled";

	private final Client client;
	private String baseUri = DEFAULT_BASE_URI;
	private String app = DEFAULT_APP;

	public ShazamClient(String app) {
		client = ClientBuilder.newBuilder().register("application/json, */*").build();
		this.app = app;
	}

	public ShazamClient(Client client) {
		this.client = client;
	}

	public void setBaseUri(String baseUri) {
		this.baseUri = baseUri;
	}

	public void setApp(String app){
		this.app = app;
	}

	private WebTarget webTarget() {
		return client
				.target(baseUri)
				.path("api")
				.path("v1")
				.path("logs");
	}

	public String getLogs(){
		return webTarget()
				.request(MediaType.APPLICATION_JSON)
				.header("Origin", "http://localhost:8080")
				.header("Host", "localhost:8080")
				.header("Content-Type", "localhost")
				.header("User-Agent", "PostmanRuntime/7.29.2")
				.header("Cookie", "g_state={\"i_l\":0}")
				.get(new GenericType<>() {});
	}

	public void sendTrace(String message) throws IOException {
		LogDto logDto = new LogDto()
				.setApp(app)
				.setDate(System.currentTimeMillis())
				.setSeverity(Severity.INFO)
				.setId(UUID.randomUUID().toString())
				.setLog(message);
		OkHttpClient client = new OkHttpClient().newBuilder()
				.build();
		RequestBody body = RequestBody.create(okhttp3.MediaType.parse(MediaType.APPLICATION_JSON), logDto.toJson());
//				"{\n    \"id\" : \"1\",\n    \"severity\" : \"INFO\",\n    \"log\" : \"Academy\",\n    \"app\" : \"Test\",\n    \"date\" : 1665086933.0\n}");
		Request request = new Request.Builder()
				.url("http://localhost:8080/api/v1/logs/")
				.method("POST", body)
				.addHeader("Content-Type", "application/json")
				.build();
		Response response = client.newCall(request).execute();
	}

	public void sendError(String message) throws IOException {
		LogDto logDto = new LogDto()
				.setApp(app)
				.setDate(System.currentTimeMillis())
				.setSeverity(Severity.ERROR)
				.setId(UUID.randomUUID().toString())
				.setLog(message);
		OkHttpClient client = new OkHttpClient().newBuilder()
				.build();
		RequestBody body = RequestBody.create(okhttp3.MediaType.parse(MediaType.APPLICATION_JSON), logDto.toJson());
		Request request = new Request.Builder()
				.url("http://localhost:8080/api/v1/logs/")
				.method("POST", body)
				.addHeader("Content-Type", "application/json")
				.build();
		Response response = client.newCall(request).execute();
	}

	public void addLog(LogDto logDto) {
		logDto.setApp(app);
		webTarget()
				.request(MediaType.APPLICATION_JSON)
				.header("Origin", "http://localhost:8080")
				.header("Host", "localhost:8080")
				.header("Content-Type", "application/json")
				.header("User-Agent", "PostmanRuntime/7.29.2")
				.header("Cookie", "g_state={\"i_l\":0}")
				.post(Entity.json(logDto), LogDto.class);
	}

	public void addLogs(List<LogDto> logDtos) {

		webTarget()
				.request(MediaType.APPLICATION_JSON)
				.post(Entity.json(logDtos), LogDto.class);
	}
}
