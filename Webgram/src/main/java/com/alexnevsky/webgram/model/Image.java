package com.alexnevsky.webgram.model;

import java.io.Serializable;

/**
 * Data Transfer Object for the entity
 *
 * Represent the image meta data
 *
 * @author Alex Nevsky
 */
public class Image implements Comparable<Image>, Serializable {

	private static final long serialVersionUID = 1L;

	private long imageId;
	private long ownerId;
	private String url;

	public Image() {
		// Always keep the default constructor alive in a Javabean class.
	}

	public Image(long imageId, long ownerId, String url) {
		this.imageId = imageId;
		this.ownerId = ownerId;
		this.url = url;
	}

	public long getImageId() {
		return imageId;
	}

	public void setImageId(long imageId) {
		this.imageId = imageId;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public long getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(long ownerId) {
		this.ownerId = ownerId;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		Image image = (Image) o;

		if (imageId != image.imageId) return false;
		if (ownerId != image.ownerId) return false;

		return true;
	}

	@Override
	public int hashCode() {
		int result = (int) (imageId ^ (imageId >>> 32));
		result = 31 * result + (int) (ownerId ^ (ownerId >>> 32));
		return result;
	}

	@Override
	public String toString() {
		return "Photo{" +
				"imageId=" + imageId +
				", ownerId=" + ownerId +
				", url='" + url + '\'' +
				'}';
	}

	@Override
	public int compareTo(Image p) {
		return (p.hashCode() - hashCode());
	}
}
