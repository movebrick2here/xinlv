CREATE DATABASE db_lvfang default character set utf8mb4;
USE db_lvfang;

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
  `product_id`     varchar(128)      NOT NULL DEFAULT '' COMMENT '产品ID',
  `supplier_id`     varchar(128)      NOT NULL DEFAULT '' COMMENT '供应商ID',
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
  PRIMARY KEY (`product_id`,`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 MAX_ROWS=200000 AVG_ROW_LENGTH=3000;