-- *********************************************************************************************************
-- author: zhouchangyue
-- QQ:   23199412
-- 配置文件定义
-- DBService 配置Database Proxy Service地址
-- *********************************************************************************************************

local Configure = {}

Configure.mysql = {}
Configure.mysql.HOST = "127.0.0.1"
Configure.mysql.PORT = "3306"
Configure.mysql.DATABASE = "db_lvfang"
Configure.mysql.USER = "root"
Configure.mysql.PASSWORD = "suxin@2017"

Configure.MOBILE = {}
Configure.MOBILE.OPEN_ID = "wx_open_id"
Configure.MOBILE.DOMAIN = "192.168.56.101"
Configure.MOBILE.EXPIRE = 3600 * 24 * 7

Configure.PC = {}
Configure.PC.USER_ID = "user_name"
Configure.PC.ACCESS_TOKEN = "access_token"
Configure.PC.DOMAIN = "192.168.56.101"
Configure.PC.EXPIRE = 3600 * 24 * 365

return Configure