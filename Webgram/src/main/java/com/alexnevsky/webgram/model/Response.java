package com.alexnevsky.webgram.model;

import java.io.Serializable;

/**
 * Data Transfer Object for the entity
 *
 * Simple Response with ID and Message
 *
 * @author Alex Nevsky
 */
public class Response implements Serializable {

	private static final long serialVersionUID = 1L;

	private long id;
	private String content;

	public Response() {
		// Always keep the default constructor alive in a Javabean class.
	}

	public Response(long id, String content) {
		this.id = id;
		this.content = content;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		Response response = (Response) o;

		if (id != response.id) return false;
		if (content != null ? !content.equals(response.content) : response.content != null) return false;

		return true;
	}

	@Override
	public int hashCode() {
		int result = (int) (id ^ (id >>> 32));
		result = 31 * result + (content != null ? content.hashCode() : 0);
		return result;
	}

	@Override
	public String toString() {
		return "Response{" +
				"id=" + id +
				", content='" + content + '\'' +
				'}';
	}
}
