package com.alexnevsky.webgram.service;

import com.alexnevsky.webgram.model.Image;
import com.alexnevsky.webgram.model.Response;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * REST API Interface for CRUD operations on our image bank
 *
 * @author Alex Nevsky
 */
public interface IWebgramService {

	public List<Image> getAll(Long ownerId);
	public Image get(Long ownerId, Long imageId);
	public Response create(Long ownerId, Long imageId, MultipartFile file);
	public Response update(Long ownerId, Long imageId, MultipartFile file);
	public Response delete(Long ownerId, Long imageId);
}
