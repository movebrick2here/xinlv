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
function business:do_action(code)
    ngx.log(ngx.DEBUG, "get code:" .. code .. " from weixin .....................")

    local http_util = require "http"

    local str_path = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxdd72b4e828f112ce&secret=7bc6799bf73354a202dbd2d2e8a1d486&code=" .. code .. "&grant_type=authorization_code"

    ngx.log(ngx.DEBUG, "str_path:" .. str_path .. " .....................")

    local zhttp = require "http_util"
    local cjson = require "cjson"

    local httpc = zhttp.new()
    local timeout = 30000
    httpc:set_timeout(timeout)
    local response, err = httpc:request_uri(str_path, {
        ssl_verify = false,
        method = "GET"        
        })

    if nil == response or response.status ~= 200 then
      ngx.log(ngx.DEBUG, "can not get open id from weixin by err: " .. err .. " .....................")
      return
    end

    local success, jsonTbl = pcall(cjson.decode, response.body)
    if not success then
      ngx.log(ngx.DEBUG, "can not get open id from weixin by body: " .. response.body .. " .....................")

      return
    end

    local open_id = jsonTbl["openid"]

    ngx.log(ngx.DEBUG, "get open id:" .. open_id .. " from weixin .....................")

    local ck = require "cookie"
    local cookie = ck:new()
    if not cookie then
        ngx.log(ngx.ERR, "cookie new err:" .. err)
    end
    local configure = require "configure"
    cookie:set({ key = configure.MOBILE.OPEN_ID, value = open_id, path = "/", domain = configure.MOBILE.DOMAIN, expires = ngx.cookie_time(ngx.time() + configure.MOBILE.EXPIRE) })

    return true
end

return business