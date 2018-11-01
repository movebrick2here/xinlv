-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将记录数据持久化到数据库
-- 函数命名必须为小写字母加下划线区分功能单词 例:do_action

-- 表t_similarity_supplier结构
-- CREATE TABLE `t_similarity_supplier` (
--   `supplier_code1`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商CODE',
--   `supplier_code2`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商CODE',
--   `product_list`   text     NOT NULL DEFAULT '' COMMENT '相似产品',
--   `product_count` int NOT NULL DEFAULT 0 COMMENT '相似产品数量',
--   `update_time` bigint NOT NULL DEFAULT 0 COMMENT '更新时间',
--   `create_time` bigint NOT NULL DEFAULT 0 COMMENT '创建时间',
--   PRIMARY KEY (`supplier_code1`, `supplier_code2`)
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
        if ( nil ~= info[i].product_count) then
            info[i]["product_count"] = tonumber(info[i].product_count)
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
        sql = "select count(*) as count from v_similarity_supplier_code"
    else
        sql = "select count(*) as count from v_similarity_supplier_code where " .. where .. ";"
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

    if nil ~= tbl.supplier_code1 then
        if 0 < string.len(where) then
            where = where .. " and "
        end

        where = where .. "supplier_code1 = '" .. tbl.supplier_code1 .. "'"
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
        sql = "select * from v_similarity_supplier_code " .. limit .. ";"
    else
        sql = "select * from v_similarity_supplier_code where " .. where .. limit .. ";"
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

