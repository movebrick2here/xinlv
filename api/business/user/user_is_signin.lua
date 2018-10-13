-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将记录数据持久化到数据库
-- 函数命名必须为小写字母加下划线区分功能单词 例:do_action

-- 表t_product结构
-- CREATE TABLE `t_user` (
--   `user_id` varchar(128) NOT NULL DEFAULT '' COMMENT '用户ID',
--   `user_password` varchar(256) NOT NULL DEFAULT '' COMMENT '用户密码',
--   `user_name` varchar(256) NOT NULL DEFAULT '' COMMENT '用户名',
--   `contact` varchar(64) NOT NULL DEFAULT '' COMMENT '联系人',
--   `mobile_phone` varchar(64) NOT NULL DEFAULT '' COMMENT '移动电话',
--   `update_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
--   `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',    
--   PRIMARY KEY (`user_id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=10000 AVG_ROW_LENGTH=5000;
-- *********************************************************************************************************

local business = {}

-- #########################################################################################################
-- 函数名: results_string_to_number
-- 函数功能: 记录中字符字段转换为整型字段
-- 参数定义:
-- info: 查询对象信息
-- 返回值:
-- 无
-- #########################################################################################################
function business:results_string_to_number(info)
    if nil == info then
        return
    end
    local num = #info
    for i = 1, num do
        if ( nil ~= info[i].create_time) then
            info[i]["create_time"] = tonumber(info[i].create_time)
        end
        if ( nil ~= info[i].update_time) then
            info[i]["update_time"] = tonumber(info[i].update_time)
        end
    end
end

-- #########################################################################################################
-- 函数名: user_name_is_exists
-- 函数功能: 查询名称是否存在
-- 参数定义:
-- name: 名称
-- 返回值:
-- result: bool true存在,false不存在
-- #########################################################################################################
function business:user_name_is_exists(user_name)
    local sql = "select user_id from t_session where user_id='" .. user_name .. "'"

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql
    local cjson = require "cjson"

    ngx.log(ngx.DEBUG, "check sql:" .. sql)
    local result,info = dao:query(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if false == result then
        return false, info
    end

    local util = require "util"

    if nil == info or true == util.is_empty_table(info) then
        return false
    end

    return true
end

-- #########################################################################################################
-- 函数名: do_action
-- 函数功能: 查询单条记录
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- info: 成功时返回,对象信息
-- #########################################################################################################
function business:do_action()
    local ck = require "cookie"
    local configure = require "configure"

    local cookie, err = ck:new()
    if not cookie then
        ngx.log(ngx.ERR, "cookie new err:" .. err)
    end

    local user_id = cookie:get(configure.PC.USER_ID)
    if (nil == user_id) or "" == user_id then
        ngx.log(ngx.DEBUG, "get user id:" .. configure.PC.USER_ID .. " from cookie failed")
        return false
    end

    local access_token = cookie:get(configure.PC.ACCESS_TOKEN)
    if (nil == access_token) or "" == access_token then
        ngx.log(ngx.DEBUG, "get access_token " .. configure.PC.ACCESS_TOKEN .. " from cookie failed")
        return false
    end

    ngx.log(ngx.DEBUG, "get user name:" .. user_id .. " access_token:" .. access_token .. " from cookie success")

    local math = require "math"
    local time_obj = require "socket"

    -- 查询记录
    local sql = "select user_id from t_session where user_id='" .. user_id .. "' and access_token='" 
                .. access_token .. "' and access_token_expire >= " .. math.ceil(time_obj.gettime()) .. ";"

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    -- dao:initial(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD)    

    local cjson = require "cjson"
    local result,info = dao:query(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if false == result then
        ngx.log(ngx.ERR, "query user name:" .. user_id .. " access_token:" .. access_token .. " failed")
        return false
    end

    ngx.log(ngx.DEBUG, "query user name:" .. user_id .. " access_token:" .. access_token .. " success result:" .. cjson.encode(info))

    local util = require "util"

    if nil == info or true == util.is_empty_table(info) then
        ngx.log(ngx.DEBUG, "query user name:" .. user_id .. " access_token:" .. access_token .. " success has no results ")
        return false
    end

    local update = require "user_signin"
    local result = update:update_session(user_id, access_token)

    return true
end

-- #########################################################################################################
-- 函数名: do_exit
-- 函数功能: 查询单条记录
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- info: 成功时返回,对象信息
-- #########################################################################################################
function business:do_exit()
    local ck = require "cookie"
    local configure = require "configure"

    local cookie, err = ck:new()
    if not cookie then
        ngx.log(ngx.ERR, "cookie new err:" .. err)
    end

    local user_id = cookie:get(configure.PC.USER_ID)
    if (nil == user_id) or "" == user_id then
        ngx.log(ngx.DEBUG, "get user id:" .. configure.PC.USER_ID .. " from cookie failed")
        return true
    end

    local access_token = cookie:get(configure.PC.ACCESS_TOKEN)
    if (nil == access_token) or "" == access_token then
        ngx.log(ngx.DEBUG, "get access_token " .. configure.PC.ACCESS_TOKEN .. " from cookie failed")
        return true
    end

    ngx.log(ngx.DEBUG, "get user name:" .. user_id .. " access_token:" .. access_token .. " from cookie success")

    local math = require "math"
    local time_obj = require "socket"

    -- 查询记录
    local sql = "update t_session set access_token='1' where access_token='" 
                .. access_token .. "';"

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    -- dao:initial(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD)    

    local cjson = require "cjson"
    local result,info = dao:query(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if false == result then
        ngx.log(ngx.ERR, "exit user name:" .. user_id .. " access_token:" .. access_token .. " failed")
        return false
    end

    return true
end

return business