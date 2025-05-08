package com.mengxun.ticketbookingbackend.model.domain.request;

import lombok.Data;

import java.io.Serializable;

/**
 * 用户注册请求体
 * @author MengXun326
 */
@Data
public class UserRegisterRequest implements Serializable {
    private  static  final long serialVersionUID = 3150077815903889199L;
    private String userAccount;
    private String userPassword;
    private String checkPassword;

}
