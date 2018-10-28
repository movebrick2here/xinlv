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

    if 14 ~= item_count then
      return false, "line:" .. line .. " items is invalid"
    end

    local uuid = require "uuid"
    local time_obj = require "socket"
    uuid.seed(time_obj.gettime()*10000)
    local supplier_id = "P".. string.upper(uuid())

    local value = "("
    value = value .. "'" .. supplier_id .. "',"
    for i = 1, item_count do
      value = value .. "'" .. item_array[i] .. "',"
    end

    local math = require "math"
    local time_obj = require "socket" 
    value = value .. math.ceil(time_obj.gettime()) .. "," .. math.ceil(time_obj.gettime())

    value = value .. ")"

    return true, value, item_array[1]
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

    local supplier_codes = ""
    for i = 1, #line_array do
        local line = string.gsub(line_array[i], "^%s*(.-)%s*$", "%1")
        ngx.log(ngx.DEBUG, " ##### line:" .. line)
        local ret_web, _ = string.find(line, "------WebKitFormBoundary")
        local ret_content, _ = string.find(line, "Content")
        if nil == ret_web and nil == ret_dis then
            local result, value, supplier_code = business:encode_record_value(line)
            if false == result then
              return false, value
            end

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
    -- local check = require "supplier_check"
    -- local result,errmsg = check:names_is_exists(supplier_codes)
    -- if true == result then
    --     local cjson = require "cjson"
    --    return false, "数据库中已有CODE:".. cjson.encode(errmsg) .. "的记录"
    -- end

    local columns = "(supplier_id, contact_name, position, telephone, mobile_number," ..
                    "email, manufacturer, manufacturer_belongs_area, manufacturer_address, manufacturer_description, manufacturer_site," ..
                    "manufacturer_iso,haccp,fsms," ..
                    "update_time,create_time)"

    local sql = "insert into t_supplier " .. columns .. " values " .. values

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

    return true
end


return business