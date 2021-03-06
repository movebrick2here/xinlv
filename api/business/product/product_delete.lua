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
-- 函数名: array_to_string
-- 函数功能: 数组列表转换为字符串
-- 参数定义:
-- ids: id数组列表
-- 返回值:
-- ids_list: 返回字符串形式的id list,格式为:"1,2,3,4"
-- #########################################################################################################
function business:array_to_string(ids)
    local id_list = ""
    local num = #ids
    for i = 1, num do
        id_list = id_list .. "'" .. tostring(ids[i]) .. "'"
        if i ~= num then
            id_list = id_list .. ","
        end
    end

    return id_list
end

-- #########################################################################################################
-- 函数名: do_action
-- 函数功能: 删除多条记录
-- 参数定义:
-- ids: 删除对象ID List
-- 返回值:
-- result: bool 函数成功或者失败
-- errmsg: 失败是,返回失败描述信息
-- #########################################################################################################
function business:do_action(ids)
    -- 数组转换字符串
    local ids_list = business:array_to_string(ids)

    -- 删除记录
    local sql = "delete from t_product where product_id in (" .. ids_list .. ")"

    local dao = require "mysql_db"
    local configure = require "configure"
    local mysql = configure.mysql
    local cjson = require "cjson"

    ngx.log(ngx.DEBUG, "delete sql:" .. sql)
    local result,info = dao:execute(mysql.HOST, mysql.PORT, mysql.DATABASE, mysql.USER, mysql.PASSWORD, sql)
    if not result then
        ngx.log(ngx.ERR, "delete sql:" .. sql .. " failed")
        return false
    end

    return true
end

return business