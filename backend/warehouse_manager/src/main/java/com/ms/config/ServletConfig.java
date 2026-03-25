package com.ms.config;

import com.ms.filter.LoginCheckFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.StringRedisTemplate;


/*
* 原生Servlet的配置类
* */
@Configuration
public class ServletConfig {

    @Autowired
    private StringRedisTemplate redisTemplate;

    @Bean
    public FilterRegistrationBean filterRegistrationBean() {
        FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean();
        LoginCheckFilter loginCheckFilter = new LoginCheckFilter();
        filterRegistrationBean.setFilter(loginCheckFilter);
        loginCheckFilter.setRedisTemplate(redisTemplate);
        filterRegistrationBean.addUrlPatterns("/*");
        return filterRegistrationBean;
    }
}
