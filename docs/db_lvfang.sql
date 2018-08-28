CREATE DATABASE db_lvfang default character set utf8mb4;
USE db_lvfang;

-- 用户表
CREATE TABLE `t_user` (
  `user_id` varchar(128) NOT NULL DEFAULT '' COMMENT '用户ID',
  `user_password` varchar(256) NOT NULL DEFAULT '' COMMENT '用户密码',
  `user_name` varchar(256) NOT NULL DEFAULT '' COMMENT '用户名',
  `contact` varchar(64) NOT NULL DEFAULT '' COMMENT '联系人',
  `mobile_phone` varchar(64) NOT NULL DEFAULT '' COMMENT '移动电话',
  `update_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',    
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=10000 AVG_ROW_LENGTH=5000;


CREATE TABLE `t_product` (
  `product_id`     varchar(128)      NOT NULL DEFAULT '' COMMENT '产品ID',
  `product_code`   varchar(256)     NOT NULL DEFAULT '' COMMENT '产品代码',
  `product_name_cn`   varchar(256)     NOT NULL DEFAULT '' COMMENT '产品中文名称',
  `product_name_en` varchar(256)     NOT NULL DEFAULT '' COMMENT '产品英文名称',
  `product_cas` varchar(128)      NOT NULL DEFAULT '' COMMENT '产品CAS号',
  `molecular_formula` varchar(128) NOT NULL DEFAULT '' COMMENT '产品分子式',
  `molecular_weight` varchar(128) NOT NULL DEFAULT '' COMMENT '产品分子量',
  `constitutional_formula` varchar(1024) NOT NULL DEFAULT '' COMMENT '产品结构式',
  `HS_Code` varchar(128) NOT NULL DEFAULT '' COMMENT '海关编码',
  `category` varchar(128) NOT NULL DEFAULT '' COMMENT '所属类别',
  `physicochemical_property` varchar(128) NOT NULL DEFAULT '' COMMENT '理化性质',
  `purpose` varchar(128) NOT NULL DEFAULT '' COMMENT '用途',
  `update_time` bigint NOT NULL DEFAULT 0 COMMENT '更新时间',
  `create_time` bigint NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 MAX_ROWS=200000 AVG_ROW_LENGTH=3000;

CREATE TABLE `t_supplier` (
  `supplier_id`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商ID',
  `supplier_code`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商CODE',
  `contact_name`   varchar(256)     NOT NULL DEFAULT '' COMMENT '联系人',
  `position` varchar(256)     NOT NULL DEFAULT '' COMMENT '职位',
  `telephone` varchar(128)      NOT NULL DEFAULT '' COMMENT '座机',
  `mobile_number` varchar(128) NOT NULL DEFAULT '' COMMENT '手机',
  `email` varchar(128) NOT NULL DEFAULT '' COMMENT '邮箱',
  `manufacturer` varchar(1024) NOT NULL DEFAULT '' COMMENT '生产商',
  `manufacturer_belongs_area` varchar(128) NOT NULL DEFAULT '' COMMENT '生产商所属地区',
  `manufacturer_address` varchar(128) NOT NULL DEFAULT '' COMMENT '生产商单位地址',
  `manufacturer_description` varchar(128) NOT NULL DEFAULT '' COMMENT '生产单位简介',
  `manufacturer_site` varchar(128) NOT NULL DEFAULT '' COMMENT '生产单位官网',
  `manufacturer_iso` tinyint NOT NULL DEFAULT 1 COMMENT 'ISO标准',
  `haccp` tinyint NOT NULL DEFAULT 0 COMMENT 'HACCP',
  `fsms` tinyint NOT NULL DEFAULT 0 COMMENT 'FSMS',
  `update_time` bigint NOT NULL DEFAULT 0 COMMENT '更新时间',
  `create_time` bigint NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 MAX_ROWS=200000 AVG_ROW_LENGTH=3000;

CREATE TABLE `t_product_supplier_ref` (
  `product_code`     varchar(128)      NOT NULL DEFAULT '' COMMENT '产品ID',
  `supplier_code`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商ID',
  `quality_criterion`   varchar(256)     NOT NULL DEFAULT '' COMMENT '质量标准',
  `packaging` varchar(256)     NOT NULL DEFAULT '' COMMENT '包装',
  `gmp_cn` tinyint      NOT NULL DEFAULT 1 COMMENT '中国GMP',
  `gmp_eu` tinyint NOT NULL DEFAULT 0 COMMENT '欧洲GMP',
  `FDA` tinyint NOT NULL DEFAULT 0 COMMENT 'FDA',
  `CEP` tinyint NOT NULL DEFAULT 0 COMMENT 'CEP',
  `US_DMF` tinyint NOT NULL DEFAULT 0 COMMENT 'US_DMF',
  `EU_DMF` tinyint NOT NULL DEFAULT 0 COMMENT 'EU_DMF',
  `TGA` tinyint NOT NULL DEFAULT 0 COMMENT 'TGA',
  `MF` tinyint NOT NULL DEFAULT 0 COMMENT 'MF',
  `KOSHER` tinyint NOT NULL DEFAULT 0 COMMENT 'KOSHER',
  `HALAL` tinyint NOT NULL DEFAULT 0 COMMENT 'HALAL',
  `others` varchar(2048) NOT NULL DEFAULT 0 COMMENT '其他资质',
  `capacity` int NOT NULL DEFAULT 0 COMMENT '该产品年产能',
  `update_time` bigint NOT NULL DEFAULT 0 COMMENT '更新时间',
  `create_time` bigint NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`product_code`,`supplier_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 MAX_ROWS=200000 AVG_ROW_LENGTH=3000;

DELIMITER &&
CREATE VIEW `v_product_supplier` AS SELECT  a.product_id as product_id, a.product_code as product_code,
                                    a.product_name_cn as product_name_cn, a.product_name_en as product_name_en,
                                    a.product_cas as product_cas, a.molecular_formula as molecular_formula,
                                    a.molecular_weight as molecular_weight, a.constitutional_formula as constitutional_formula,
                                    a.HS_Code as HS_Code, a.category as category,
                                    a.physicochemical_property as physicochemical_property, a.purpose as purpose,
                                    b.supplier_id as supplier_id, b.supplier_code as supplier_code,
                                    b.contact_name as contact_name, b.position as position,
                                    b.telephone as telephone, b.mobile_number as mobile_number,
                                    b.email as email, b.manufacturer as manufacturer,
                                    b.manufacturer_belongs_area as manufacturer_belongs_area, b.manufacturer_address as manufacturer_address,
                                    b.manufacturer_description as manufacturer_description, b.manufacturer_site as manufacturer_site,
                                    b.manufacturer_iso as manufacturer_iso, b.haccp as haccp, b.fsms as fsms,
                                    c.quality_criterion as quality_criterion, c.packaging as packaging,
                                    c.gmp_cn as gmp_cn, c.gmp_eu as gmp_eu, c.FDA as FDA, c.CEP as CEP, c.US_DMF as US_DMF,
                                    c.EU_DMF as EU_DMF, c.TGA as TGA, c.MF as MF, c.KOSHER as KOSHER, c.HALAL as HALAL,
                                    c.others as others, c.capacity as capacity, c.update_time as update_time, c.create_time as create_time
                          FROM t_product_supplier_ref c, t_product a, t_supplier b
                          WHERE c.product_code = a.product_code
                                and c.supplier_code = b.supplier_code
&&
DELIMITER ;

# insert into t_product value('96e79218965eb72c92a549dd5a330112', 'P1', '马来酸氨氯地平', 'Amlodipine Maleate', '88150-47-4', 'C24H29ClN2O9', '524.9481', '', '2942000000', '原料药', '类白色或淡黄色结晶粉', '抗高血压', 1533982299, 1533982299);
# insert into t_supplier value('96e79218965eb72c92a549dd5a330112', 'S1', '张经理', '销售经理', '021-11111111', '13811111111', '111111@111.com', '上海朝晖药业有限公司', '中国上海', '上海市宝山区抚远路2151号', '上海朝晖是一家。。。年产能。。。', 'http://www.zhpharma.cn/', '1', '0', '0', 1533982299, 1533982299);




