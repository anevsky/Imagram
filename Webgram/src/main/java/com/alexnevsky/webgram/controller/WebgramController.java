package com.alexnevsky.webgram.controller;

import com.alexnevsky.webgram.model.Response;
import com.alexnevsky.webgram.model.Image;
import com.alexnevsky.webgram.service.IWebgramService;
import com.alexnevsky.webgram.storage.Base;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

/**
 * REST API Controller for CRUD operations on our image bank
 *
 * GET gets the list of entities
 * GET retrieves an entity with specified Id
 * POST creates an entity
 * PUT  updates an entity
 * DELETE deletes an entity with the specified id
 *
 * @author Alex Nevsky
 *
 */
@RestController
@RequestMapping("/rest")
public class WebgramController {

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();

	@Autowired
	IWebgramService service;

	@RequestMapping(method=RequestMethod.GET)
	public String hello() {
		return "Hello, World!";
	}

	@RequestMapping(value = "/greeting/{id}", method = RequestMethod.GET)
	public Response greeting(@PathVariable("id") Long id) {
		try {
			return new Response(counter.incrementAndGet(), String.format(template, Base.getInstance().getUserNameById(id)));
		} catch (Exception e) {
			return new Response(counter.incrementAndGet(), String.format(template, "World"));
		}
	}

	@RequestMapping(value = "/owner/{ownerId}", method = RequestMethod.GET)
	public List<Image> getAll(@PathVariable("ownerId") Long ownerID){
		return service.getAll(ownerID);
	}

	@RequestMapping(value = "/owner/{ownerId}/image/{imageId}", method = RequestMethod.GET)
	public Image get(@PathVariable("ownerId") Long ownerId, @PathVariable("imageId") Long imageId) {
		return service.get(ownerId, imageId);
	}

	@RequestMapping(method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.CREATED)
	public Response create(@RequestParam("ownerId") Long ownerId, @RequestParam("imageId") Long imageId, @RequestParam("file") MultipartFile file) {
		return service.create(ownerId, imageId, file);
	}

	@RequestMapping(value = "/owner/{ownerId}/image/{imageId}", method = RequestMethod.PUT)
	@ResponseStatus(HttpStatus.OK)
	public Response update(@PathVariable("ownerId") Long ownerId, @PathVariable("imageId") Long imageId, @RequestBody MultipartFile file) {
		return service.update(ownerId, imageId, file);
	}

	@RequestMapping(value = "/owner/{ownerId}/image/{imageId}", method = RequestMethod.DELETE)
	@ResponseStatus(HttpStatus.OK )
	public Response delete(@PathVariable("ownerId") Long ownerId, @PathVariable("imageId") Long imageId) {
		return service.delete(ownerId, imageId);
	}
}
