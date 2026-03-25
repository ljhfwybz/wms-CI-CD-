package com.ms.utils;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.ms.entity.CurrentUser;
import com.ms.exception.BusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import java.util.Date;
import java.util.concurrent.TimeUnit;

/**
 * token工具类
 */
@Component
public class TokenUtils {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Value("${warehouse.expire-time}")
    private int expireTime;

    private static final String CLAIM_NAME_USERID = "CLAIM_NAME_USERID";
    private static final String CLAIM_NAME_USERCODE = "CLAIM_NAME_USERCODE";
    private static final String CLAIM_NAME_USERNAME = "CLAIM_NAME_USERNAME";

    private String sign(CurrentUser currentUser, String securityKey){
        String token = JWT.create()
                .withClaim(CLAIM_NAME_USERID, currentUser.getUserId())
                .withClaim(CLAIM_NAME_USERCODE, currentUser.getUserCode())
                .withClaim(CLAIM_NAME_USERNAME, currentUser.getUserName())
                .withIssuedAt(new Date())
                .withExpiresAt(new Date(System.currentTimeMillis() + expireTime *1000))
                .sign(Algorithm.HMAC256(securityKey));
        return token;
    }

    public String loginSign(CurrentUser currentUser, String password){
        String token = sign(currentUser, password);
        stringRedisTemplate.opsForValue().set(token, token, expireTime *2, TimeUnit.SECONDS);
        return token;
    }

    /**
     * 从客户端归还的token中获取用户信息的方法
     */
    public CurrentUser getCurrentUser(String token) {
        if(StringUtils.isEmpty(token)){
            throw new BusinessException("令牌为空，请登录！");
        }
        //对token进行解码,获取解码后的token
        DecodedJWT decodedJWT = null;
        try {
            decodedJWT = JWT.decode(token);
        } catch (JWTDecodeException e) {
            throw new BusinessException("令牌格式错误，请登录！");
        }
        //从解码后的token中获取用户信息并封装到CurrentUser对象中返回
        int userId = decodedJWT.getClaim(CLAIM_NAME_USERID).asInt();//用户账号id
        String userCode = decodedJWT.getClaim(CLAIM_NAME_USERCODE).asString();//用户账号
        String userName = decodedJWT.getClaim(CLAIM_NAME_USERNAME).asString();//用户姓名
        if(StringUtils.isEmpty(userCode) || StringUtils.isEmpty(userName)){
            throw new BusinessException("令牌缺失用户信息，请登录！");
        }
        return new CurrentUser(userId, userCode, userName);
    }

}
