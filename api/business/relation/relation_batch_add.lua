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
-- 函数名: encode_record_value
-- 函数功能: 添加表中更新时间戳和创建时间戳
-- 参数定义:
-- tbl: table对象 记录值,key-value形式对
-- 返回值:
-- 无
-- #########################################################################################################
function business:encode_record_value(line)
    local util = require "util"
    local item_array = util:Split(line, ",")
    local item_count = #item_array

    if 16 ~= item_count then
      return false, "line:" .. line .. " items is invalid"
    end

    local value = "("
    for i = 1, item_count do
      value = value .. "'" .. item_array[i] .. "',"
    end

    local math = require "math"
    local time_obj = require "socket" 
    value = value .. math.ceil(time_obj.gettime()) .. "," .. math.ceil(time_obj.gettime())
    
    value = value .. ")"

    return true, value, item_array[1], item_array[2]
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
    -- 解析记录并组装SQL Values
    local values = ""
    
    local util = require "util"
    local line_array = util:Split(tbl, "\r")

    local product_codes = ""
    local supplier_codes = ""

    for i = 1, #line_array do
        local line = string.gsub(line_array[i], "^%s*(.-)%s*$", "%1")
        ngx.log(ngx.DEBUG, " ##### line:" .. line)
        local ret_web, _ = string.find(line, "------WebKitFormBoundary")
        local ret_content, _ = string.find(line, "Content")
        if nil == ret_web and nil == ret_dis then
            local result, value, product_code, supplier_code = business:encode_record_value(line)
            if false == result then
              return false, value
            end

            if 0 < string.len(product_codes) then
              product_codes = product_codes .. ","
            end
            product_codes = product_codes .. product_code

            if 0 < string.len(supplier_codes) then
              supplier_codes = supplier_codes .. ","
            end
            supplier_codes = supplier_codes .. supplier_code

            if 0 < string.len(values) then
              values = values .. ","
            end
            values = values .. value
        end
    end

    -- 检查名称是否重复
    local check = require "product_check"
    local result,errmsg = check:names_is_exists(product_codes)
    if false == result or #errmsg ~= #line_array then
        local cjson = require "cjson"
        return false, "数据库中有产品CODE: " .. product_codes .. " db:" .. cjson.encode(errmsg) .. "不存在的记录"
    end   

    -- 检查名称是否重复
    local check = require "supplier_check"
    local result,errmsg = check:names_is_exists(supplier_codes)
    if false == result or #errmsg ~= #line_array then
        local cjson = require "cjson"
        return false, "数据库中有供应商CODE: " .. supplier_codes .. " db:" .. cjson.encode(errmsg) .. "不存在的记录"
    end       

    local columns = "(product_code, supplier_code, quality_criterion, packaging, gmp_cn, gmp_eu," ..
                    "FDA, CEP, US_DMF, EU_DMF, TGA, MF,KOSHER, HALAL, others, capacity," ..
                    "update_time,create_time)"

    local sql = "insert into t_product_supplier_ref " .. columns .. " values " .. values

    -- 添加记录到数据库
    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    ngx.log(ngx.DEBUG, "insert product sql:" .. sql)
    local result,info = dao:execute(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if not result then
        ngx.log(ngx.ERR, "insert sql:" .. sql .. " failed")
        return false
    end

    return true

end


return business