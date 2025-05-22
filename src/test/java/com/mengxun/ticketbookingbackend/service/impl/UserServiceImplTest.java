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
        user.setUseraccount("test2");
        user.setAvatar("https://meng-xun-image-host.oss-cn-shanghai.aliyuncs.com/img/android-chrome-192x192.png");
        user.setGender(0);
        user.setUserpassword("test2");
        user.setPhone("");
        user.setEmail("");
        user.setUserstatus(0);
        user.setUserrole(0);
        user.setCreatetime(new Date());
        user.setUpdatetime(new Date());
        user.setIsdelete(0);
        boolean result = userService.save(user);
        System.out.println(user.getId());
        assertTrue(result);

    }

    @Test
    void userRegister() {
        String userAccount = "Meng";
        String userPassword = "";
        String checkPassword = "123456";
        long result = userService.userRegister(userAccount,userPassword,checkPassword);
        Assertions.assertEquals(-1,result);
        userAccount = "Me";
        userPassword = "";
        result = userService.userRegister(userAccount,userPassword,checkPassword);
        Assertions.assertEquals(-1,result);
        userAccount = "Meng";
        userPassword = "123456";
        result = userService.userRegister(userAccount,userPassword,checkPassword);
        Assertions.assertEquals(-1,result);
        userAccount = "Me ng";
        userPassword = "12345678";
        result = userService.userRegister(userAccount,userPassword,checkPassword);
        Assertions.assertEquals(-1,result);
        userAccount = "Meng";
        userPassword = "12345678";
        checkPassword = "123456789";
        result = userService.userRegister(userAccount,userPassword,checkPassword);
        Assertions.assertEquals(-1,result);
        userAccount = "test2";
        userPassword = "12345678";
        checkPassword = "12345678";
        result = userService.userRegister(userAccount,userPassword,checkPassword);
        Assertions.assertEquals(-1,result);
        userAccount = "Meng";
        userPassword = "12345678";
        checkPassword = "12345678";
        result = userService.userRegister(userAccount,userPassword,checkPassword);
        Assertions.assertTrue(result>0);
    }
}