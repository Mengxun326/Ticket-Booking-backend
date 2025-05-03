package com.mengxun.ticketbookingbackend.service.impl;
import java.util.Date;

import com.mengxun.ticketbookingbackend.model.domain.User;
import com.mengxun.ticketbookingbackend.service.UserService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import javax.annotation.Resource;

import static org.junit.jupiter.api.Assertions.*;
/**
 * 用户服务测试
 *
 * @author MengXun326
 */
@SpringBootTest
public class UserServiceImplTest {

    @Resource
    private UserService userService;
    @Test
    public void testAddUser(){
        User user = new User();
        user.setUsername("tes2t");
        user.setUserAccount("test2");
        user.setAvatar("https://meng-xun-image-host.oss-cn-shanghai.aliyuncs.com/img/android-chrome-192x192.png");
        user.setGender(0);
        user.setUserPassword("test2");
        user.setPhone("123");
        user.setEmail("123@test.com");
        boolean result = userService.save(user);
        System.out.println(user.getId());
        assertTrue(result);

    }
}