package com.mengxun.ticketbookingbackend.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.mengxun.ticketbookingbackend.service.UserService;
import com.mengxun.ticketbookingbackend.model.domain.User;
import com.mengxun.ticketbookingbackend.mapper.UserMapper;
import org.springframework.stereotype.Service;

/**
* @author Meng_
* @description 针对表【user(用户表)】的数据库操作Service实现
* @createDate 2025-05-03 06:25:06
*/
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
    implements UserService {

}




