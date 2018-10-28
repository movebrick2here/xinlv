-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将数记录据持久化到数据库
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
-- 函数功能: 添加表中更新时间戳
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- 无
-- #########################################################################################################
function business:add_timestamp(tbl)
    local math = require "math"
    local time_obj = require "socket"
    tbl.update_time = math.ceil(time_obj.gettime())
end

-- #########################################################################################################
-- 函数名: encode_update_columns
-- 函数功能: 添加表中更新时间戳
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- 无
-- #########################################################################################################
function business:encode_update_columns(tbl)
    local columns = ""

    -- if nil ~= tbl.supplier_code then
    --    if 0 < string.len(columns) then
    --        columns = columns .. ","
    --    end

    --    columns = columns .. "supplier_code='" .. tbl.supplier_code .. "'"
    --end

    if nil ~= tbl.contact_name then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "contact_name='" .. tbl.contact_name .. "'"
    end

    if nil ~= tbl.position then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "position='" .. tbl.position .. "'"
    end

    if nil ~= tbl.telephone then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "telephone='" .. tbl.telephone .. "'"
    end

    if nil ~= tbl.mobile_number then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "mobile_number='" .. tbl.mobile_number .. "'"
    end

    if nil ~= tbl.email then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "email='" .. tbl.email .. "'"
    end

    if nil ~= tbl.manufacturer then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "manufacturer='" .. tbl.manufacturer .. "'"
    end

    if nil ~= tbl.manufacturer_belongs_area then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "manufacturer_belongs_area='" .. tbl.manufacturer_belongs_area .. "'"
    end

    if nil ~= tbl.manufacturer_address then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "manufacturer_address='" .. tbl.manufacturer_address .. "'"
    end

    if nil ~= tbl.manufacturer_description then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "manufacturer_description='" .. tbl.manufacturer_description .. "'"
    end

    if nil ~= tbl.manufacturer_site then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "manufacturer_site='" .. tbl.manufacturer_site .. "'"
    end

    if nil ~= tbl.manufacturer_iso then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "manufacturer_iso='" .. tbl.manufacturer_iso .. "'"
    end

    if nil ~= tbl.haccp then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "haccp='" .. tbl.haccp .. "'"
    end

    if nil ~= tbl.fsms then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "fsms='" .. tbl.fsms .. "'"
    end        

    if nil ~= tbl.update_time then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "update_time=" .. tbl.update_time
    end

    return columns
end

-- #########################################################################################################
-- 函数名: do_action
-- 函数功能: 修改记录
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- #########################################################################################################
function business:do_action(tbl)
    -- if nil ~= tbl.supplier_code then
        -- 检查名称是否重复
    --    local check = require "supplier_check"
    --    local result,errmsg = check:name_is_exists(tbl.supplier_code)
    --    if true == result then
    --        result,errmsg = check:id_name_is_consistent(tbl.supplier_id, tbl.supplier_code)
    --        if false == result then
    --            return false, "数据库中已有CODE:".. tbl.supplier_code .. "的记录"
    --        end
    --    end
    -- end

    -- 添加时间戳
    business:add_timestamp(tbl)
    local columns = business:encode_update_columns(tbl)

    local sql = "update t_supplier set " .. columns .. " where supplier_id='" .. tbl.supplier_id .. "'"

    -- 添加记录到数据库
    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    ngx.log(ngx.DEBUG, "update supplier sql:" .. sql)
    local result,info = dao:execute(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if not result then
        ngx.log(ngx.ERR, "update sql:" .. sql .. " failed")
        return false
    end

    return result, errmsg
end

return business