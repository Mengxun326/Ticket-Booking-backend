package com.mengxun.ticketbookingbackend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@SpringBootTest
class TicketBookingBackendApplicationTests {

    @Test
    void degist() throws NoSuchAlgorithmException {
        //2.加密
        String result = DigestUtils.md5DigestAsHex(("abcd"+"mypassword").getBytes());
        System.out.println(result);
    }
    @Test
    void contextLoads() {
    }

}
