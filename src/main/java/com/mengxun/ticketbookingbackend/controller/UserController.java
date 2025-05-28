package com.mengxun.ticketbookingbackend.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.mengxun.ticketbookingbackend.model.domain.User;
import com.mengxun.ticketbookingbackend.model.domain.request.UserLoginRequest;
import com.mengxun.ticketbookingbackend.model.domain.request.UserRegisterRequest;
import com.mengxun.ticketbookingbackend.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.mengxun.ticketbookingbackend.constant.UserConstant.ADMIN_ROLE;
import static com.mengxun.ticketbookingbackend.constant.UserConstant.USER_LOGIN_STATE;

/**
 * 用户接口
 * @author MengXun326
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;
    @PostMapping("/reqister")
    public Long userRegister(@RequestBody UserRegisterRequest userRegisterRequest){
        if(userRegisterRequest == null)
        {
            return null;
        }
        String userAccount = userRegisterRequest.getUserAccount();
        String userPassword = userRegisterRequest.getUserPassword();
        String checkPassword = userRegisterRequest.getCheckPassword();
        if(StringUtils.isAnyBlank(userAccount,userPassword,checkPassword))
        {
            return null;
        }
        return userService.userRegister(userAccount, userPassword, checkPassword);
    }

    @PostMapping("/login")
    public User userLogin(@RequestBody UserLoginRequest userRegisterRequest, HttpServletRequest request){
        if(userRegisterRequest == null)
        {
            return null;
        }
        String userAccount = userRegisterRequest.getUserAccount();
        String userPassword = userRegisterRequest.getUserPassword();
        if(StringUtils.isAnyBlank(userAccount,userPassword))
        {
            return null;
        }
        return userService.userLogin(userAccount, userPassword,request);
    }

    @GetMapping("/search")
    public List<User> searchUsers(String username,HttpServletRequest request){
        //仅管理员可查询
        if(!isAdmin(request))
        {
            return new ArrayList<>();
        }
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        if(StringUtils.isNotBlank(username))
        {
            queryWrapper.like("username",username);
        }
        List<User> userlist = userService.list(queryWrapper);
        return userlist.stream().map(user -> userService.getSafetyUser(user)).collect(Collectors.toList());
    }

    @PostMapping("/delete")
    public boolean deleteUser(@RequestBody long id,HttpServletRequest request){
        //仅管理员可删除
        if(!isAdmin(request))
        {
            return false;
        }
        if(id<=0)
        {
            return false;
        }
        return userService.removeById(id);
    }

    /**
     * 是否为管理员
     * @param request
     * @return
     */
    private  boolean isAdmin(HttpServletRequest request)
    {
        Object userObj = request.getSession().getAttribute(USER_LOGIN_STATE);
        User user = (User) userObj;
        return user != null && user.getUserrole() == ADMIN_ROLE;
    }

}
