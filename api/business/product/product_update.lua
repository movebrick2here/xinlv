-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将数记录据持久化到数据库
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

    if nil ~= tbl.product_name_cn then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "product_name_cn='" .. tbl.product_name_cn .. "'"
    end

    if nil ~= tbl.product_name_en then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "product_name_en='" .. tbl.product_name_en .. "'"
    end

    if nil ~= tbl.product_cas then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "product_cas='" .. tbl.product_cas .. "'"
    end

    if nil ~= tbl.molecular_formula then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "molecular_formula='" .. tbl.molecular_formula .. "'"
    end

    if nil ~= tbl.molecular_weight then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "molecular_weight='" .. tbl.molecular_weight .. "'"
    end

    if nil ~= tbl.constitutional_formula then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "constitutional_formula='" .. tbl.constitutional_formula .. "'"
    end

    if nil ~= tbl.HS_Code then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "HS_Code='" .. tbl.HS_Code .. "'"
    end

    if nil ~= tbl.category then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "category='" .. tbl.category .. "'"
    end

    if nil ~= tbl.physicochemical_property then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "physicochemical_property='" .. tbl.physicochemical_property .. "'"
    end

    if nil ~= tbl.purpose then
        if 0 < string.len(columns) then
            columns = columns .. ","
        end

        columns = columns .. "purpose='" .. tbl.purpose .. "'"
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
    if nil ~= tbl.product_name_cn then
        -- 检查名称是否重复
        local check = require "product_check"
        local result,errmsg = check:name_is_exists(tbl.product_name_cn)
        if true == result then
            result,errmsg = check:id_name_is_consistent(tbl.product_id, tbl.product_name_cn)
            if false == result then
                return false, "数据库中已有CODE:".. tbl.product_name_cn .. "的记录"
            end
        end
    end

    -- 添加时间戳
    business:add_timestamp(tbl)
    local columns = business:encode_update_columns(tbl)

    local sql = "update t_product set " .. columns .. " where product_id='" .. tbl.product_id .. "'"

    -- 添加记录到数据库
    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    ngx.log(ngx.DEBUG, "update product sql:" .. sql)
    local result,info = dao:execute(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if not result then
        ngx.log(ngx.ERR, "update sql:" .. sql .. " failed")
        return false
    end

    return result, errmsg
end

return business