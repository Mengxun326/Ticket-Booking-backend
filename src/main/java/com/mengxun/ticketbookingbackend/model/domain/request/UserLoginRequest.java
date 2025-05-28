package com.mengxun.ticketbookingbackend.model.domain.request;

import lombok.Data;

import java.io.Serializable;

/**
 * 用户登陆请求体
 * @author MengXun326
 */
@Data
public class UserLoginRequest implements Serializable {
    private  static  final long serialVersionUID = 3150077815903889199L;
    private String userAccount;
    private String userPassword;

}
