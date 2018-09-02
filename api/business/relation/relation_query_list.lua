-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将记录数据持久化到数据库
-- 函数命名必须为小写字母加下划线区分功能单词 例:do_action

-- 表t_product_supplier_ref结构
-- CREATE TABLE `t_product_supplier_ref` (
--   `product_code`     varchar(128)      NOT NULL DEFAULT '' COMMENT '产品ID',
--   `supplier_code`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商ID',
--   `quality_criterion`   varchar(256)     NOT NULL DEFAULT '' COMMENT '质量标准',
--   `packaging` varchar(256)     NOT NULL DEFAULT '' COMMENT '包装',
--   `gmp_cn` tinyint      NOT NULL DEFAULT 1 COMMENT '中国GMP',
--   `gmp_eu` tinyint NOT NULL DEFAULT 0 COMMENT '欧洲GMP',
--   `FDA` tinyint NOT NULL DEFAULT 0 COMMENT 'FDA',
--   `CEP` tinyint NOT NULL DEFAULT 0 COMMENT 'CEP',
--   `US_DMF` tinyint NOT NULL DEFAULT 0 COMMENT 'US_DMF',
--   `EU_DMF` tinyint NOT NULL DEFAULT 0 COMMENT 'EU_DMF',
--   `TGA` tinyint NOT NULL DEFAULT 0 COMMENT 'TGA',
--   `MF` tinyint NOT NULL DEFAULT 0 COMMENT 'MF',
--   `KOSHER` tinyint NOT NULL DEFAULT 0 COMMENT 'KOSHER',
--   `HALAL` tinyint NOT NULL DEFAULT 0 COMMENT 'HALAL',
--   `others` varchar(2048) NOT NULL DEFAULT 0 COMMENT '其他资质',
--   `capacity` int NOT NULL DEFAULT 0 COMMENT '该产品年产能',
--   `update_time` bigint NOT NULL DEFAULT 0 COMMENT '更新时间',
--   `create_time` bigint NOT NULL DEFAULT 0 COMMENT '创建时间',
--   PRIMARY KEY (`product_supplier_ref_id`,`supplier_id`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 MAX_ROWS=200000 AVG_ROW_LENGTH=3000;
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
        if ( nil == info[i].others) or "" == info[i].others then
            info[i]["others"] = {}
        end        
    end
end

-- #########################################################################################################
-- 函数名: get_total_records
-- 函数功能: 记录中字符字段转换为整型字段
-- 参数定义:
-- info: 查询对象信息
-- 返回值:
-- 无
-- #########################################################################################################
function business:get_total_records(where)
    -- 查询记录
    local sql = ""
    if 0 >= string.len(where) then
        sql = "select count(*) as count from v_product_supplier"
    else
        sql = "select count(*) as count from v_product_supplier where " .. where .. ";"
    end

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    -- dao:initial(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD)    

    local cjson = require "cjson"
    local result,info = dao:query(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if false == result then
        ngx.log(ngx.ERR, "query count sql:" .. sql .. " failed")
        return true, 0
    end

    ngx.log(ngx.DEBUG, "query count sql:" .. sql .. " success result:" .. cjson.encode(info))

    local util = require "util"

    if nil == info or true == util.is_empty_table(info) then
        ngx.log(ngx.DEBUG, "query count sql:" .. sql .. " success has no results ")
        return true, 0
    end

    return true, tonumber(info[1].count)    
end


-- #########################################################################################################
-- 函数名: encode_sql_where
-- 函数功能: 记录中字符字段转换为整型字段
-- 参数定义:
-- info: 查询对象信息
-- 返回值:
-- 无
-- #########################################################################################################
function business:encode_sql_where(tbl)
    local where = ""

    if nil ~= tbl.product_id then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "product_id='" .. tbl.product_id .. "'"
    end

    if nil ~= tbl.product_code then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "product_code like '%" .. tbl.product_code .. "%'"
    end

    if nil ~= tbl.product_name_cn then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "product_name_cn like '%" .. tbl.product_name_cn .. "%'"
    end

    if nil ~= tbl.product_name_en then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "product_name_en like '%" .. tbl.product_name_en .. "%'"
    end

    if nil ~= tbl.product_cas then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "product_cas like '%" .. tbl.product_cas .. "%'"
    end

    if nil ~= tbl.purpose then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "purpose like '%" .. tbl.purpose .. "%'"
    end

    if nil ~= tbl.supplier_id then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "supplier_id like '%" .. tbl.supplier_id .. "%'"
    end

    if nil ~= tbl.supplier_code then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "supplier_code like '%" .. tbl.supplier_code .. "%'"
    end

    if nil ~= tbl.contact_name then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "contact_name like '%" .. tbl.contact_name .. "%'"
    end

    if nil ~= tbl.mobile_number then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "mobile_number like '%" .. tbl.mobile_number .. "%'"
    end

    if nil ~= tbl.email then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "email like '%" .. tbl.email .. "%'"
    end

    if nil ~= tbl.manufacturer then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "manufacturer like '%" .. tbl.manufacturer .. "%'"
    end

    if nil ~= tbl.manufacturer_belongs_area then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "manufacturer_belongs_area like '%" .. tbl.manufacturer_belongs_area .. "%'"
    end

     if nil ~= tbl.manufacturer_address then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "manufacturer_address like '%" .. tbl.manufacturer_address .. "%'"
    end       
    return where    
end

-- #########################################################################################################
-- 函数名: encode_sql_start_end
-- 函数功能: 记录中字符字段转换为整型字段
-- 参数定义:
-- info: 查询对象信息
-- 返回值:
-- 无
-- #########################################################################################################
function business:encode_sql_start_end(tbl)
    local result_start = (tbl.page_number - 1)*tbl.page_size
    local result_end = result_start + tbl.page_size

    local limit = " limit " .. tostring(result_start) .. "," .. tostring(result_end)
    return limit
end

-- #########################################################################################################
-- 函数名: do_action
-- 函数功能: 查询列表信息
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- info: 成功时返回,对象信息
-- #########################################################################################################
function business:do_action(tbl)
    local where = business:encode_sql_where(tbl)

    local limit = business:encode_sql_start_end(tbl)

    local info = {}
    info.page_number = tbl.page_number
    info.page_size = tbl.page_size

    local result, count = business:get_total_records(where)
    info.total_number = count

    if 0 >= info.total_number then
        info.list = {}
        return true, info
    end

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql
    local cjson = require "cjson"

    -- 查询记录
    local sql = ""

    if 0 >= string.len(where) then
        sql = "select * from v_product_supplier " .. limit .. ";"
    else
        sql = "select * from v_product_supplier where " .. where .. limit .. ";"
    end    

    -- dao:initial(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD)    

    local result,query_res = dao:query(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if false == result then
        ngx.log(ngx.ERR, "query list sql:" .. sql .. " failed")
        return false
    end

    ngx.log(ngx.DEBUG, "query list sql:" .. sql .. " success result:" .. cjson.encode(query_res))

    business:results_string_to_number(query_res)

    info.list = query_res

    return true, info
end

return business

