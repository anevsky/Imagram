package com.alexnevsky.webgram.storage;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Simple Memory Base for association with user and image bank
 *
 * @author Alex Nevsky
 */
public class Base {

	private static Base instance = new Base();

	private static Map<String, ImageBank> userImageBank = new ConcurrentHashMap<String, ImageBank>(16);

	static {
		userImageBank.put("Alex", new ImageBank());
		userImageBank.put("Sergey", new ImageBank());
		userImageBank.put("Andrei", new ImageBank());
	}

	public static Base getInstance() {
		return instance;
	}

	public String getUserNameById(Long id) throws Exception {
		if (id == 1) {
			return "Alex";
		} else if (id == 2) {
			return "Sergey";
		} else if (id == 3) {
			return "Andrei";
		} else {
			throw new Exception("User with id = " + id + " not found!");
		}
	}

	public ImageBank getImageBankForUserById(Long id) throws Exception {
		return getImageBankForUser(getUserNameById(id));
	}

	private ImageBank getImageBankForUser(String user) {
		return userImageBank.get(user);
	}
}
