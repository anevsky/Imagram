package com.alexnevsky.webgram.model;

import java.io.Serializable;

/**
 * Data Transfer Object for the entity
 *
 * Uses for compare Images by IDs
 *
 * @author Alex Nevsky
 */
public class ImageUID implements Serializable {

	private static final long serialVersionUID = 1L;

	private long ownerId;
	private long imageId;

	public ImageUID() {
		// Always keep the default constructor alive in a Javabean class.
	}

	public ImageUID(long ownerId, long imageId) {
		this.ownerId = ownerId;
		this.imageId = imageId;
	}

	public long getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(long ownerId) {
		this.ownerId = ownerId;
	}

	public long getImageId() {
		return imageId;
	}

	public void setImageId(long imageId) {
		this.imageId = imageId;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		ImageUID imageUID = (ImageUID) o;

		if (imageId != imageUID.imageId) return false;
		if (ownerId != imageUID.ownerId) return false;

		return true;
	}

	@Override
	public int hashCode() {
		int result = (int) (ownerId ^ (ownerId >>> 32));
		result = 31 * result + (int) (imageId ^ (imageId >>> 32));
		return result;
	}

	@Override
	public String toString() {
		return "ImageUID{" +
				"ownerId=" + ownerId +
				", imageId=" + imageId +
				'}';
	}
}
