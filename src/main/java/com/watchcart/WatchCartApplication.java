package com.watchcart;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class WatchCartApplication {

    private static final Logger log = LogManager.getLogger(WatchCartApplication.class);

    public static void main(String[] args) {
        log.info("Starting WatchCart application...");
        SpringApplication.run(WatchCartApplication.class, args);
    }
}
