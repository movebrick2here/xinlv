-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将记录数据持久化到数据库
-- 函数命名必须为小写字母加下划线区分功能单词 例:do_action

-- 表t_supplier结构
-- CREATE TABLE `t_supplier` (
--   `supplier_id`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商ID',
--   `supplier_code`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商CODE',
--   `contact_name`   varchar(256)     NOT NULL DEFAULT '' COMMENT '联系人',
--   `position` varchar(256)     NOT NULL DEFAULT '' COMMENT '职位',
--   `telephone` varchar(128)      NOT NULL DEFAULT '' COMMENT '座机',
--   `mobile_number` varchar(128) NOT NULL DEFAULT '' COMMENT '手机',
--   `email` varchar(128) NOT NULL DEFAULT '' COMMENT '邮箱',
--   `manufacturer` varchar(1024) NOT NULL DEFAULT '' COMMENT '生产商',
--   `manufacturer_belongs_area` varchar(128) NOT NULL DEFAULT '' COMMENT '生产商所属地区',
--   `manufacturer_address` varchar(128) NOT NULL DEFAULT '' COMMENT '生产商单位地址',
--   `manufacturer_description` varchar(128) NOT NULL DEFAULT '' COMMENT '生产单位简介',
--   `manufacturer_site` varchar(128) NOT NULL DEFAULT '' COMMENT '生产单位官网',
--   `manufacturer_iso` tinyint NOT NULL DEFAULT 1 COMMENT 'ISO标准',
--   `haccp` tinyint NOT NULL DEFAULT 0 COMMENT 'HACCP',
--   `fsms` tinyint NOT NULL DEFAULT 0 COMMENT 'FSMS',
--   `update_time` bigint NOT NULL DEFAULT 0 COMMENT '更新时间',
--   `create_time` bigint NOT NULL DEFAULT 0 COMMENT '创建时间',
--   PRIMARY KEY (`supplier_id`)
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
function business:name_is_exists(name)
    local sql = "select supplier_id from t_supplier where supplier_code='" .. name .. "'"

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
function business:id_name_is_consistent(id, name)
    local sql = "select supplier_id from t_supplier where supplier_id='" .. id .. "' and supplier_code='" .. name .. "'"

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
    local sql = "select supplier_code from t_supplier where supplier_code in (" .. codes .. ")"

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

