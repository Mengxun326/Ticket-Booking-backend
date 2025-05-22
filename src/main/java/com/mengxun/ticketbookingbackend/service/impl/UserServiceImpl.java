package com.mengxun.ticketbookingbackend.service.impl;
import java.util.Date;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.mengxun.ticketbookingbackend.service.UserService;
import com.mengxun.ticketbookingbackend.model.domain.User;
import com.mengxun.ticketbookingbackend.mapper.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.security.MessageDigest;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 用户服务实现类
* @author MengXun326
* @description 针对表【user(用户表)】的数据库操作Service实现
* @createDate 2025-05-03 06:25:06
*/
@Service
@Slf4j
public class UserServiceImpl extends ServiceImpl<UserMapper, User>
    implements UserService {
    /**
     * 盐值，混淆密码
     */
    private static final String SALT = "meng";
    /**
     * 用户登陆态键
     */
    private static final String USER_LOGIN_STATE  = "userLoginState";
    @Resource
    private  UserMapper userMapper;

    @Override
    public long userRegister(String userAccount, String userPassword, String checkPassword) {
        //1.校验
        // 不能为空
        if(StringUtils.isAnyBlank(userAccount,userPassword,checkPassword))
        {
            //todo 修改成自定义异常
            return -1;
        }
        //账户不小于4位
        if(userAccount.length()<4)
        {
            return -1;
        }
        //密码不小于8位
        if(userPassword.length()<8 || checkPassword.length()<8)
        {
            return -1;
        }
        //账户不能包含特殊字符
        String validPattern = "[`~!#\\$%^&*()+=|{}'Aa:;',\\\\[\\\\].<>/?~！@#￥%……&*（）9——+|{}【】\\\"‘；：”“’。，、？ ]";
        Matcher matcher = Pattern.compile(validPattern).matcher(userAccount);
        if(matcher.find())
        {
            return -1;
        }
        //密码和校验密码相同
        if(!userPassword.equals(checkPassword))
        {
            return -1;
        }
        //账户不能重复
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userAccount",userAccount);
        long count = userMapper.selectCount(queryWrapper);
        if(count>0)
        {
            return -1;
        }
        //2.加密
        String encrypPassword = DigestUtils.md5DigestAsHex((SALT+userPassword).getBytes());
        //3.插入数据
        User user = new User();
        user.setUseraccount(userAccount);
        user.setUserpassword(encrypPassword);
        boolean saveResult = this.save(user);
        if(!saveResult){
            return -1;
        }
        return user.getId();
    }

    @Override
    public User doLogin(String userAccount, String userPassword, HttpServletRequest request) {
        //1.校验
        // 不能为空
        if(StringUtils.isAnyBlank(userAccount,userPassword))
        {
            return null;
        }
        //账户不小于4位
        if(userAccount.length()<4)
        {
            return null;
        }
        //密码不小于8位
        if(userPassword.length()<8 )
        {
            return null;
        }
        //账户不能包含特殊字符
        String validPattern = "[`~!#\\$%^&*()+=|{}'Aa:;',\\\\[\\\\].<>/?~！@#￥%……&*（）9——+|{}【】\\\"‘；：”“’。，、？ ]";
        Matcher matcher = Pattern.compile(validPattern).matcher(userAccount);
        if(matcher.find())
        {
            return null;
        }
        //2.加密
        String encrypPassword = DigestUtils.md5DigestAsHex((SALT+userPassword).getBytes());
        //查询账户是否存在
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userAccount",userAccount);
        queryWrapper.eq("userPassword",encrypPassword);
        User user = userMapper.selectOne(queryWrapper);
        //用户不存在
        if(user == null)
        {
            log.info("user login failed, userAccount cannot match userPassword");
            return null;
        }
        //3.用户脱敏
        User safetyUser = new User();
        safetyUser.setId(user.getId());
        safetyUser.setUsername(user.getUsername());
        safetyUser.setUseraccount(user.getUseraccount());
        safetyUser.setAvatar(user.getAvatar());
        safetyUser.setGender(user.getGender());
        safetyUser.setPhone(user.getPhone());
        safetyUser.setEmail(user.getEmail());
        safetyUser.setUserstatus(user.getUserstatus());
        safetyUser.setCreatetime(user.getCreatetime());
        //4.记录用户的登录态
        request.getSession().setAttribute(USER_LOGIN_STATE,user);
        return safetyUser;
    }
}




