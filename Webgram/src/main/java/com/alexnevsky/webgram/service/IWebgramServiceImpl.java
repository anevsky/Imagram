package com.alexnevsky.webgram.service;

import com.alexnevsky.webgram.model.Image;
import com.alexnevsky.webgram.model.ImageUID;
import com.alexnevsky.webgram.model.Response;
import com.alexnevsky.webgram.storage.Base;
import com.alexnevsky.webgram.storage.ImageBank;
import com.alexnevsky.webgram.utils.GlobalConstants;
import com.alexnevsky.webgram.utils.LruCache;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * REST API Interface Implementation for CRUD operations on our image bank
 *
 * @author Alex Nevsky
 */
public class IWebgramServiceImpl implements IWebgramService {

	private static Logger log = Logger.getLogger(IWebgramServiceImpl.class.getName());

	public static int ALL_IMAGES_RESPONSE_CACHE_SIZE = 128;
	public static int IMAGE_RESPONSE_CACHE_SIZE = 128;

	private final Map<Long, List<Image>> allImagesResponseCache = Collections.synchronizedMap(new LruCache<Long, List<Image>>(ALL_IMAGES_RESPONSE_CACHE_SIZE));
	private final Map<ImageUID, Image> imageResponseCache = Collections.synchronizedMap(new LruCache<ImageUID, Image>(IMAGE_RESPONSE_CACHE_SIZE));

	@Override
	public List<Image> getAll(Long ownerId) {
		List<Image> response = allImagesResponseCache.get(ownerId);

		if (response == null) {
			try {
				response = Base.getInstance().getImageBankForUserById(ownerId).getAll();
				allImagesResponseCache.put(ownerId, response);
			} catch (Exception e) {
				return Collections.emptyList();
			}
		}

		return response;
	}

	@Override
	public Image get(Long ownerId, Long imageId) {
		ImageUID imageUID = new ImageUID(ownerId, imageId);
		Image response = imageResponseCache.get(imageUID);

		if (response == null) {
			try {
				response = Base.getInstance().getImageBankForUserById(ownerId).get(imageId);
				imageResponseCache.put(imageUID, response);
			} catch (Exception e) {
				return new Image();
			}
		}

		return response;
	}

	@Override
	public Response create(Long ownerId, Long imageId, MultipartFile file) {
		try {
			ImageBank bank = Base.getInstance().getImageBankForUserById(ownerId);
			if (!bank.containsKey(imageId)) {
				return loadImage(ownerId, imageId, file);
			} else {
				return new Response(-1, "File already exists");
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, e.toString());
			return new Response(-1, e.toString());
		}
	}

	@Override
	public Response update(Long ownerId, Long imageId, MultipartFile file) {
		return loadImage(ownerId, imageId, file);
	}

	@Override
	public Response delete(Long ownerId, Long imageId) {
		try {
			ImageBank bank = Base.getInstance().getImageBankForUserById(ownerId);
			if (bank.containsKey(imageId)) {
				String imagePath = bank.get(imageId).getUrl().replace(GlobalConstants.SERVER_APP_URL, "");

				bank.delete(imageId);
				invalidateCache(ownerId, imageId);

				boolean isSuccess = new File(imagePath).delete();

				return new Response(imageId, "Deleted: " + isSuccess);
			} else {
				return new Response(-1, "No such image");
			}
		} catch (Exception e) {
			return new Response(-1, e.toString());
		}
	}

	private Response loadImage(Long ownerId, Long imageId, MultipartFile file) {
		if (!file.isEmpty()) {
			try {
				String postfix = ownerId + "/" + imageId + file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));

				String pathToSave = GlobalConstants.IMAGE_SAVE_PATH + postfix;
				boolean isSuccess = com.alexnevsky.webgram.utils.FileUtils.saveFileToPath(file, pathToSave);

				if (isSuccess) {
					Image image = new Image(imageId, ownerId, GlobalConstants.SERVER_APP_URL + postfix);
					Base.getInstance().getImageBankForUserById(ownerId).put(imageId, image);
					invalidateCache(ownerId, imageId);
					return new Response(imageId, image.getUrl());
				} else {
					log.log(Level.SEVERE, "!!! Can't write file on server to dir");
					return new Response(-1, "Error: !!! Can't write file on server to dir");
				}
			} catch (Exception e) {
				log.log(Level.SEVERE, e.toString());
				return new Response(-1, e.toString());
			}
		} else {
			return new Response(-1, "File was empty");
		}
	}

	private void invalidateCache(Long ownerId, Long imageId) {
		allImagesResponseCache.remove(ownerId);
		imageResponseCache.remove(new ImageUID(ownerId, imageId));
	}
}