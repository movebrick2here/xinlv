-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 文件实现了业务数据的逻辑检查,并调用数据库访问接口,将记录数据持久化到数据库
-- 函数命名必须为小写字母加下划线区分功能单词 例:do_action

-- 用户表
-- CREATE TABLE `t_user_supplier` (
--   `open_id` varchar(128) NOT NULL DEFAULT '' COMMENT '用户OPEN ID',
--   `app_id` varchar(256) NOT NULL DEFAULT '' COMMENT 'APP ID',
--   `supplier_code` varchar(256) NOT NULL DEFAULT '' COMMENT '用户名',
--   `update_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
--   `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',    
--   PRIMARY KEY (`open_id`, `supplier_code`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=10000 AVG_ROW_LENGTH=5000;

-- *********************************************************************************************************

local business = {}

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
function business:do_action()
    return "o-iSb0-zjoztjwlqwjLMCp8WOkhs"
end

return business