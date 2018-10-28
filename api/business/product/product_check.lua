-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将记录数据持久化到数据库
-- 函数命名必须为小写字母加下划线区分功能单词 例:do_action

-- 表t_product结构
-- CREATE TABLE `t_product` (
--   `product_id`     varchar(128)      NOT NULL DEFAULT '' COMMENT '产品ID',
--   `product_code`   varchar(256)     NOT NULL DEFAULT '' COMMENT '产品代码',
--   `product_name_cn`   varchar(256)     NOT NULL DEFAULT '' COMMENT '产品中文名称',
--   `product_name_en` varchar(256)     NOT NULL DEFAULT '' COMMENT '产品英文名称',
--   `product_cas` varchar(128)      NOT NULL DEFAULT '' COMMENT '产品CAS号',
--   `molecular_formula` varchar(128) NOT NULL DEFAULT '' COMMENT '产品分子式',
--   `molecular_weight` varchar(128) NOT NULL DEFAULT '' COMMENT '产品分子量',
--   `constitutional_formula` varchar(1024) NOT NULL DEFAULT '' COMMENT '产品结构式',
--   `HS_Code` varchar(128) NOT NULL DEFAULT '' COMMENT '海关编码',
--   `category` varchar(128) NOT NULL DEFAULT '' COMMENT '所属类别',
--   `physicochemical_property` varchar(128) NOT NULL DEFAULT '' COMMENT '理化性质',
--   `purpose` varchar(128) NOT NULL DEFAULT '' COMMENT '用途',
--   `update_time` bigint NOT NULL DEFAULT 0 COMMENT '更新时间',
--   `create_time` bigint NOT NULL DEFAULT 0 COMMENT '创建时间',
--   PRIMARY KEY (`product_id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 MAX_ROWS=200000 AVG_ROW_LENGTH=3000;
-- *********************************************************************************************************

local business = {}

-- #########################################################################################################
-- 函数名: name_is_exists
-- 函数功能: 查询名称是否存在
-- 参数定义:
-- name: 名称
-- 返回值:
-- result: bool true存在,false不存在
-- #########################################################################################################
function business:name_is_exists(code)
    local sql = "select product_id from t_product where product_name_cn='" .. code .. "'"

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
-- 函数名: code_is_exists
-- 函数功能: 查询名称是否存在
-- 参数定义:
-- name: 名称
-- 返回值:
-- result: bool true存在,false不存在
-- #########################################################################################################
function business:code_is_exists(code)
    local sql = "select product_id from t_product where product_code='" .. code .. "'"

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
-- 函数名: id_name_is_consistent
-- 函数功能: 查询名称和ID是否对应
-- 参数定义:
-- name: 名称
-- 返回值:
-- result: bool true 对应,false不对应
-- #########################################################################################################
function business:id_name_is_consistent(id, code)
    local sql = "select product_id from t_product where product_id='" .. id .. "' and product_name_cn='" .. code .. "'"

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
-- 函数名: names_is_exists
-- 函数功能: 查询名称是否存在
-- 参数定义:
-- name: 名称
-- 返回值:
-- result: bool true存在,false不存在
-- #########################################################################################################
function business:names_is_exists(codes)
    local sql = "select product_code from t_product where product_name_cn in (" .. codes .. ")"

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

    return true, info
end

-- #########################################################################################################
-- 函数名: codes_is_exists
-- 函数功能: 查询名称是否存在
-- 参数定义:
-- name: 名称
-- 返回值:
-- result: bool true存在,false不存在
-- #########################################################################################################
function business:codes_is_exists(codes)
    local sql = "select product_code from t_product where product_code in (" .. codes .. ")"

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

    return true, info
end

return business

