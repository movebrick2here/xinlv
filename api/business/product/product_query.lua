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
-- 函数名: do_action
-- 函数功能: 查询单条记录
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- info: 成功时返回,对象信息
-- #########################################################################################################
function business:do_action(product_id)

    -- 查询记录
    local sql = "select * from t_product where product_id='" .. product_id .. "';"

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    -- dao:initial(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD)    

    local cjson = require "cjson"
    local result,info = dao:query(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if false == result then
        ngx.log(ngx.ERR, "query product id:" .. product_id .. " failed")
        return false
    end

    ngx.log(ngx.DEBUG, "query product id:" .. product_id .. " success result:" .. cjson.encode(info))

    local util = require "util"

    if nil == info or true == util.is_empty_table(info) then
        ngx.log(ngx.DEBUG, "query product id:" .. product_id .. " success has no results ")
        return false
    end

    business:results_string_to_number(info)

    return true, info
end

return business