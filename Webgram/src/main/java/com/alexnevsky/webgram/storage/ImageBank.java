package com.alexnevsky.webgram.storage;

import com.alexnevsky.webgram.model.Image;
import com.alexnevsky.webgram.utils.LruCache;

import java.util.*;

/**
 * Simple Memory Base for image meta objects
 *
 * @author Alex Nevsky
 */
public class ImageBank {

	public static int CACHE_SIZE = 1024;

	private final Map<Long, Image> imageBank = Collections.synchronizedMap(new LruCache<Long, Image>(CACHE_SIZE));

	public ImageBank() {
	}

	public void put(Long id, Image image) {
		imageBank.put(id, image);
	}

	public Image get(Long id) {
		 return imageBank.get(id);
	}

	public List<Image> getAll() {
		return new ArrayList<Image>(new TreeSet<Image>(imageBank.values()));
	}

	public boolean containsKey(Long id) {
		return imageBank.containsKey(id);
	}

	public boolean delete(Long id) {
		Image image = imageBank.remove(id);
		if (image != null) {
			return true;
		} else {
			return false;
		}
	}
}