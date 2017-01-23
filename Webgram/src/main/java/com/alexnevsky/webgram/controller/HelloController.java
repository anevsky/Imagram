package com.alexnevsky.webgram.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Hello World Controller to cover default URL path
 *
 * Nothing special
 *
 * @author Alex Nevsky
 *
 */
@Controller
@RequestMapping("/")
public class HelloController {

	@RequestMapping(method = RequestMethod.GET)
	public String printWelcome(ModelMap model) {
		model.addAttribute("message", "Hello, World!");
		return "hello";
	}
}