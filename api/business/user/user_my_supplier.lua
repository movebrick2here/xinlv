-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将记录数据持久化到数据库
-- 函数命名必须为小写字母加下划线区分功能单词 例:do_action

-- 用户表
-- CREATE TABLE `t_user_supplier` (
--   `open_id` varchar(128) NOT NULL DEFAULT '' COMMENT '用户OPEN ID',
--   `app_id` varchar(256) NOT NULL DEFAULT '' COMMENT 'APP ID',
--   `supplier_code` varchar(256) NOT NULL DEFAULT '' COMMENT '用户名',
--   `update_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
--   `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',    
--   PRIMARY KEY (`open_id`, `supplier_code`)
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
-- 函数名: do_action
-- 函数功能: 查询单条记录
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- info: 成功时返回,对象信息
-- #########################################################################################################
function business:do_action(open_id)

    -- 查询记录
    local sql = "select * from v_fans_supplier where open_id='" .. open_id .. "';"

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    -- dao:initial(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD)    

    local cjson = require "cjson"
    local result,info = dao:query(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if false == result then
        ngx.log(ngx.ERR, "query fans open_id:" .. open_id .. " failed")
        return false
    end

    ngx.log(ngx.DEBUG, "query open id:" .. open_id .. " success result:" .. cjson.encode(info))

    local util = require "util"

    if nil == info or true == util.is_empty_table(info) then
        ngx.log(ngx.DEBUG, "query open id:" .. open_id .. " success has no results ")
        return false
    end

    return true, info
end

return business