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
        sql = "select count(*) as count from t_product"
    else
        sql = "select count(*) as count from t_product where " .. where .. ";"
    end

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    -- dao:initial(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD)    

    local cjson = require "cjson"
    local result,info = dao:query(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if false == result then
        ngx.log(ngx.ERR, "query count sql:" .. sql .. " failed")
        return 0
    end

    ngx.log(ngx.DEBUG, "query count sql:" .. sql .. " success result:" .. cjson.encode(info))

    local util = require "util"

    if nil == info or true == util.is_empty_table(info) then
        ngx.log(ngx.DEBUG, "query count sql:" .. sql .. " success has no results ")
        return 0
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

        where = where .. "product_code = '" .. tbl.product_code .. "'"
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
        sql = "select * from t_product " .. limit .. ";"
    else
        sql = "select * from t_product where " .. where .. limit .. ";"
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

