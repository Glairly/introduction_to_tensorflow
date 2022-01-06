package com.example.frontend;

import org.springframework.stereotype.Controller;
import org.springframework.web.client.RestTemplate;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.*;
import java.util.*;
// Use Lombok to inject Slf4J logger
import lombok.extern.slf4j.Slf4j;

@Controller
@SessionAttributes("name")
// Add Slf4j
@Slf4j
public class FrontendController {
	@Autowired
	private GuestbookMessagesClient client;
	
	@Value("${greeting:Hello}")
	private String greeting;
	
	@GetMapping("/")
	public String index(Model model) {
		if (model.containsAttribute("name")) {
			String name = (String) model.asMap().get("name");
			model.addAttribute("greeting", String.format("%s %s", greeting, name));
		}
		model.addAttribute("messages", client.getMessages().getContent());
		return "index";
	}
	
	@PostMapping("/post")
	public String post(@RequestParam String name, @RequestParam String message, Model model) {
		model.addAttribute("name", name);
		if (message != null && !message.trim().isEmpty()) {
            // Add a log message at the beginning
			log.info("Saving message");

			// Post the message to the backend service
			GuestbookMessage payload = new GuestbookMessage();
			payload.setName(name);
			payload.setMessage(message);
			client.add(payload);

            // Add a log message at the end.
			log.info("Saving message");
		}
		return "redirect:/";
  }
}

