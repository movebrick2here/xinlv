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
--   PRIMARY KEY (`product_code`,`supplier_code`)
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

    -- 检查ID是否存在
    local product_check = require "product_check"
    local result,errmsg = product_check:name_is_exists(tbl.product_code)
    if false == result then
        return false, "数据库中CODE:".. tbl.product_code .. "不存在"
    end

    -- 检查ID是否存在
    local supplier_check = require "supplier_check"
    local result,errmsg = supplier_check:name_is_exists(tbl.supplier_code)
    if false == result then
        return false, "数据库中CODE:".. tbl.supplier_code .. "不存在"
    end    

    -- 添加时间戳
    business:add_timestamp(tbl)

    local columns = "(product_code, supplier_code, quality_criterion, packaging, gmp_cn, gmp_eu," ..
                    "FDA, CEP, US_DMF, EU_DMF, TGA, MF,KOSHER, HALAL, others, capacity," ..
                    "update_time,create_time)"

    local value = "(" ..
                   "'" .. tbl.product_code .. "','" .. tbl.supplier_code .. "','" .. tbl.quality_criterion .. "'," .. 
                   "'" .. tbl.packaging .. "','" .. tbl.gmp_cn .. "','" .. tbl.gmp_eu .. "'," .. 
                   "'" .. tbl.FDA .. "','" .. tbl.CEP .. "','" .. tbl.US_DMF .. "'," .. 
                   "'" .. tbl.EU_DMF .. "','" .. tbl.TGA .. "','" .. tbl.MF .. "'," ..
                   "'" .. tbl.KOSHER .. "','" .. tbl.HALAL .. "','" .. tbl.others .. "','" .. tbl.capacity .. "'," ..
                   tbl.update_time .. "," .. tbl.create_time ..
                  ")"
    local sql = "insert into t_product_supplier_ref " .. columns .. " value " .. value .. 
                " ON DUPLICATE KEY UPDATE product_code='" .. tbl.product_code .. "',supplier_code='" ..  tbl.supplier_code .. "'"

    -- 添加记录到数据库
    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql

    ngx.log(ngx.DEBUG, "insert product_supplier_ref sql:" .. sql)
    local result,info = dao:execute(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if not result then
        ngx.log(ngx.ERR, "insert sql:" .. sql .. " failed")
        return false
    end

    return true
end

return business