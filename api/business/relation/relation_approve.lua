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
--   `status` tinyint      NOT NULL DEFAULT 1 COMMENT '审核状态 0 未审核， 1 已审核',
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
function business:encode_record_value(product_code, supplier_code)
    local value = "(product_code='" .. product_code .. "' and supplier_code = '" .. supplier_code .. "')"

    return true
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
    local list = tbl.list
    local count = #list

    for i = 1, count do
        if 0 < string.len(values) then
          values = values .. " or "
        end

        values = values .. business:encode_record_value(list[i].product_code, list[i].supplier_code)
    end
    
    local sql = "update t_product_supplier_ref set status =" .. tostring(tbl.status) .. " where " .. values

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

    return true

end


return business