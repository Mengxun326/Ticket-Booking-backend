package com.mengxun.ticketbookingbackend.service;

import com.mengxun.ticketbookingbackend.model.domain.User;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * 用户服务
* @author MengXun326
* @description 针对表【user(用户表)】的数据库操作Service
* @createDate 2025-05-03 06:25:06
*/
public interface UserService extends IService<User> {
    /**
     * 用户注释
     * @param userAccount 用户账号
     * @param userPassword 用户密码
     * @param checkPassword 校验密码
     * @return 新用户id
     */
    long userRegister(String userAccount,String userPassword,String checkPassword);
}
