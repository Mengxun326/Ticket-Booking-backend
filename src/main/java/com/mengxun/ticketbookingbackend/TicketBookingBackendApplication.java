package com.mengxun.ticketbookingbackend;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.mengxun.ticketbookingbackend.mapper")
public class TicketBookingBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(TicketBookingBackendApplication.class, args);
    }

}
