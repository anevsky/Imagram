package com.alexnevsky.webgram.utils;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * File Utils Helper
 *
 * @author Alex Nevsky
 */
public class FileUtils {

	private static Logger log = Logger.getLogger(FileUtils.class.getName());

	public static boolean saveFileToPath(MultipartFile file, String path) {
		boolean isSuccess = false;
		if (!file.isEmpty() && path != null && !path.equalsIgnoreCase("")) {
			try {
				org.apache.commons.io.FileUtils.writeByteArrayToFile(new File(path), file.getBytes());
				isSuccess = true;
			} catch (Exception e) {
				log.log(Level.SEVERE, e.toString());
				isSuccess = false;
			}
		}

		return isSuccess;
	}
}
