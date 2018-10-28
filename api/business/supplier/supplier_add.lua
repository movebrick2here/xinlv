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
-- 函数名: add_timestamp
-- 函数功能: 添加表中更新时间戳和创建时间戳
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- 无
-- #########################################################################################################
function business:add_timestamp(tbl)
    local math = require "math"
    local time_obj = require "socket"
    tbl.update_time = math.ceil(time_obj.gettime())
    tbl.create_time = math.ceil(time_obj.gettime())

    local uuid = require "uuid"
    local time_obj = require "socket"
    uuid.seed(time_obj.gettime()*10000)
    tbl.supplier_id = "P".. string.upper(uuid())
end

-- #########################################################################################################
-- 函数名: do_action
-- 函数功能: 添加记录到数据库
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- #########################################################################################################
function business:do_action(tbl)

    -- 检查名称是否重复
    -- local check = require "supplier_check"
    -- local result,errmsg = check:name_is_exists(tbl.contact_name)
    -- if true == result then
    --    return false, "数据库中已有Code:".. tbl.contact_name .. "的记录"
    -- end

    -- 添加时间戳
    business:add_timestamp(tbl)

    local columns = "(supplier_id, contact_name, position, telephone, mobile_number," ..
                    "email, manufacturer, manufacturer_belongs_area, manufacturer_address, manufacturer_description, manufacturer_site," ..
                    "manufacturer_iso,haccp,fsms," ..
                    "update_time,create_time)"
    local value = "(" ..
                   "'" .. tbl.supplier_id .. "','" .. tbl.contact_name .. "'," .. 
                   "'" .. tbl.position .. "','" .. tbl.telephone .. "','" .. tbl.mobile_number .. "'," .. 
                   "'" .. tbl.email .. "','" .. tbl.manufacturer .. "','" .. tbl.manufacturer_belongs_area .. "'," .. 
                   "'" .. tbl.manufacturer_address .. "','" .. tbl.manufacturer_description .. "','" .. tbl.manufacturer_site .. "'," ..
                   "'" .. tbl.manufacturer_iso .. "','" .. tbl.haccp .. "','" .. tbl.fsms .. "'," ..
                   tbl.update_time .. "," .. tbl.create_time ..
                  ")"
    local sql = "insert into t_supplier " .. columns .. " value " .. value

    -- 添加记录到数据库
    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    ngx.log(ngx.DEBUG, "insert supplier sql:" .. sql)
    local result,info = dao:execute(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if not result then
        ngx.log(ngx.ERR, "insert sql:" .. sql .. " failed")
        return false
    end

    return true, tbl.supplier_id
end

return business