#  开发人员API参考手册
-------------------
## [1 关于文档](#about_doc)
## [2 背景知识](#background)
## [3 API请求](#api_request)
## [4 API响应](#api_response)
## [5 产品管理](#product_manage)
### [5.1 产品增加](#product_add)
### [5.2 产品修改](#product_update)
### [5.3 产品查询](#product_query)
### [5.4 产品删除](#product_delete)
### [5.5 产品列表](#product_list)
### [5.6 产品批量添加](#product_batch_add)
### [5.7 产品批量删除](#product_batch_delete)
## [6 供应商管理](#supplier_manage)
### [6.1 供应商增加](#supplier_add)
### [6.2 供应商修改](#supplier_update)
### [6.3 供应商查询](#supplier_query)
### [6.4 供应商删除](#supplier_delete)
### [6.5 供应商列表](#supplier_list)
### [6.6 供应商批量添加](#supplier_batch_add)
### [6.7 供应商批量删除](#supplier_batch_delete)
## [7 关联关系管理](#relation_manage)
### [7.1 产品和供应商关联](#relation_add)
### [7.2 产品和供应商解绑](#relation_delete)
### [7.3 产品和供应商批量关联](#relation_batch_add)
### [7.4 产品和供应商批量删除](#relation_batch_delete)
### [7.5 关联产品供应商列表](#relation_list)
### [7.6 产品相似供应商列表](#similarity_list)
## [8 用户管理](#user_manage)
### [8.1 用户登录](#user_signin)
### [8.2 我的供应商](#my_suppliers)
### [8.3 保存供应商](#save_suppliers)
### [8.4 用户登录状态](#user_sign_status)
## [9 状态码](#status_code)
-------------------
## 1. 关于文档 <a name="about_doc"/>
   本文档作为管理系统与前端WEB UI进行联调的指引文档。主要包括以下几个个部分：
   管理端 API：阅读对象为产品和WEB UI开发人员,以及相关测试人员。该部分详细描述了管理系统相关的接口

## 2. 背景知识 <a name="background"/>
   本API文档所涉及接口均遵循HTTP和HTTPS协议，请求和响应数据格式如无特殊说明均为JSON，您可以使用任何支持HTTP和HTTPS协议和JSON格式的编程
   语言开发应用程序。有关标准HTTP和HTTPS协议，可参考RFC2616和RFC2818或维基百科-HTTP,HTTPS相关介绍。有关JSON数据格式，可参考JSON.ORG
   或维基百科–JSON相关介绍

## 3. API请求 <a name="api_request"/>
   HTTP Method
   调用方应设置HTTP Method为POST。
   HTTP Header
   调用方应遵循HTTP协议设置相应的Header，目前支持的Header有：Content-Type，Content-Type用于指定数据格式。本章节中Content-Type应为
   application/json

## 4. API响应 <a name="api_response"/>
* HTTP状态码，支持HTTP标准状态码，具体如下：

| 状态码  | 名称 | 描述 |
| :--------| ----:| :--- |
| 200 |  成功或者失败  |  当API 请求被正确处理，且能按设计获取结果时，返回该状态码；亦适用于批量接口返回部分结果，如果失败，亦包括失败信息 |

* HTTP Body响应的JSON数据中包含三部分内容，分别为返回码、返回信息和数据，如下表所示：

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 |  返回码：见状态码的定义  |
| msg |  string  | 是 |  返回信息：若有错误，此字段为详细的错误信息 |
| data |  json array 或json object | 否 |  返回结果：针对批量接口，若无特殊说明，结果将按请求数组的顺序全量返回  |

## 5. 产品管理 <a name="product_manage"/>
### 5.1 产品增加 <a name="product_add"/>
* 请求URL:http://${DOMAIN}/interface/product/add
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_code | string | 是 | 产品代码 |
| product_name_cn | string | 是 | 产品中文名称 |
| product_name_en | string | 是 | 产品英文名称 |
| product_cas | string | 是 | 产品CAS号 |
| molecular_formula | string | 是 | 产品分子式 |
| molecular_weight | string | 是 | 产品分子量 |
| constitutional_formula | string | 是 | 产品结构式 |
| HS_Code | string | 是 | 海关编码 |
| category | string | 是 | 所属类别 |
| physicochemical_property | string | 是 | 理化性质 |
| purpose | string | 是 | 用途 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id |  string  | 是 | 产品ID |
| product_name_cn |  string  | 否 | 产品中文名称 |

* 请求示例
```
{
	"product_code": "P1",
	"product_name_cn": "马来酸氨氯地平",
	"product_name_en": "Amlodipine Maleate",
	"product_cas": "88150-47-4",
	"molecular_formula": "C24H29ClN2O9",
	"molecular_weight": "524.9481",
	"constitutional_formula": "http://store.system.com/img/cf.png",
	"HS_Code": "2942000000",
	"category": "原料药",
	"physicochemical_property": "类白色或淡黄色结晶粉",
	"purpose": "抗高血压"
}
```
* 应答示例
```
{
	"msg": "",
	"code": 0,
	"data": {
	    "product_id": "P1f18348f32c9a4694f16426798937ae2",
	    "product_name_cn": "马来酸氨氯地平"
	}
}
```
### 5.2 产品修改 <a name="product_update"/>
* 请求URL:http://${DOMAIN}/interface/product/update
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id | string | 是 | 产品ID |
| product_code | string | 否 | 产品代码 |
| product_name_cn | string | 否 | 产品中文名称 |
| product_name_en | string | 否 | 产品英文名称 |
| product_cas | string | 否 | 产品CAS号 |
| molecular_formula | string | 否 | 产品分子式 |
| molecular_weight | string | 否 | 产品分子量 |
| constitutional_formula | string | 否 | 产品结构式 |
| HS_Code | string | 否 | 海关编码 |
| category | string | 否 | 所属类别 |
| physicochemical_property | string | 否 | 理化性质 |
| purpose | string | 否 | 用途 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |


* 请求示例
```
{
    "product_id": "P1f18348f32c9a4694f16426798937ae2",
	"product_code": "P1",
	"product_name_cn": "马来酸氨氯地平",
	"product_name_en": "Amlodipine Maleate",
	"product_cas": "88150-47-4",
	"molecular_formula": "C24H29ClN2O9",
	"molecular_weight": "524.9481",
	"constitutional_formula": "http://store.system.com/img/cf.png",
	"HS_Code": "2942000000",
	"category": "原料药",
	"physicochemical_property": "类白色或淡黄色结晶粉",
	"purpose": "抗高血压"
}
```
* 应答示例
```
{
	"msg": "",
	"code": 0
}
```		
### 5.3 产品查询 <a name="product_query"/>
* 请求URL:http://${DOMAIN}/interface/product/query
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id | string | 是 | 产品ID |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id | string | 是 | 产品ID |
| product_code | string | 是 | 产品代码 |
| product_name_cn | string | 是 | 产品中文名称 |
| product_name_en | string | 是 | 产品英文名称 |
| product_cas | string | 是 | 产品CAS号 |
| molecular_formula | string | 是 | 产品分子式 |
| molecular_weight | string | 是 | 产品分子量 |
| constitutional_formula | string | 是 | 产品结构式 |
| HS_Code | string | 是 | 海关编码 |
| category | string | 是 | 所属类别 |
| physicochemical_property | string | 是 | 理化性质 |
| purpose | string | 是 | 用途 |
| update_time | int | 是 | 更新时间 |
| create_time | int | 是 | 创建时间 |

* 请求示例
```
{
    "product_id": "P1f18348f32c9a4694f16426798937ae2"
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0,
	"data": {
        "product_id": "P1f18348f32c9a4694f16426798937ae2",
	    "product_code": "P1",
	    "product_name_cn": "马来酸氨氯地平",
	    "product_name_en": "Amlodipine Maleate",
	    "product_cas": "88150-47-4",
	    "molecular_formula": "C24H29ClN2O9",
	    "molecular_weight": "524.9481",
	    "constitutional_formula": "http://store.system.com/img/cf.png",
	    "HS_Code": "2942000000",
	    "category": "原料药",
	    "physicochemical_property": "类白色或淡黄色结晶粉",
	    "purpose": "抗高血压"	,
	    "update_time": 1533112230,
	    "create_time": 1533112230  
	}
}
```

### 5.4 产品删除 <a name="product_delete"/>
* 请求URL:http://${DOMAIN}/interface/product/delete
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_ids | string array | 是 | 产品ID |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |

* 请求示例
```
{
    "product_ids": ["P1f18348f32c9a4694f16426798937ae2"]
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0
}
```

### 5.5 产品列表 <a name="product_list"/>
* 请求URL:http://${DOMAIN}/interface/product/list
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id | string | 是 | 产品ID |
| product_code | string | 是 | 产品代码 |
| product_name_cn | string | 是 | 产品中文名称 |
| product_name_en | string | 是 | 产品英文名称 |
| product_cas | string | 是 | 产品CAS号 |
| purpose | string | 是 | 用途 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id | string | 是 | 产品ID |
| product_code | string | 是 | 产品代码 |
| product_name_cn | string | 是 | 产品中文名称 |
| product_name_en | string | 是 | 产品英文名称 |
| product_cas | string | 是 | 产品CAS号 |
| molecular_formula | string | 是 | 产品分子式 |
| molecular_weight | string | 是 | 产品分子量 |
| constitutional_formula | string | 是 | 产品结构式 |
| HS_Code | string | 是 | 海关编码 |
| category | string | 是 | 所属类别 |
| physicochemical_property | string | 是 | 理化性质 |
| purpose | string | 是 | 用途 |
| update_time | int | 是 | 更新时间 |
| create_time | int | 是 | 创建时间 |

* 请求示例
```
{
    "product_id": "P1f18348f32c9a4694f16426798937ae2",
	"product_code": "P1",
	"product_name_cn": "马来酸氨氯地平",
	"product_name_en": "Amlodipine Maleate",
	"product_cas": "88150-47-4",
	"molecular_formula": "C24H29ClN2O9",
	"molecular_weight": "524.9481",
	"HS_Code": "2942000000",
	"category": "原料药",
	"purpose": "抗高血压"    
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0,
	"data": {
	  "page_number": 1,
	  "page_size": 10,
	  "total_number": 30,
	  "list": [
	    {
            "product_id": "P1f18348f32c9a4694f16426798937ae2",
	        "product_code": "P1",
	        "product_name_cn": "马来酸氨氯地平",
	        "product_name_en": "Amlodipine Maleate",
	        "product_cas": "88150-47-4",
	        "molecular_formula": "C24H29ClN2O9",
	        "molecular_weight": "524.9481",
	        "constitutional_formula": "http://store.system.com/img/cf.png",
	        "HS_Code": "2942000000",
	        "category": "原料药",
	        "physicochemical_property": "类白色或淡黄色结晶粉",
	        "purpose": "抗高血压"	,
	        "update_time": 1533112230,
	        "create_time": 1533112230
	    }  
	  ]
	}	
}
```

### 5.6 产品批量增加 <a name="product_batch_add"/>
* 请求URL:http://${DOMAIN}/interface/product/batch_add
* 请求字段无:

```
# Http请求中content为csv文件内容, 文件大小约定为不超过2M
```

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |


* 应答示例
```
{
	"msg": "",
	"code": 0
}
```

## 6. 供应商管理 <a name="supplier_manage"/>
### 6.1 供应商增加 <a name="supplier_add"/>
* 请求URL:http://${DOMAIN}/interface/supplier/add
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_code | string | 是 | 供应商代码 |
| contact_name | string | 是 | 联系人 |
| position | string | 是 | 职位 |
| telephone | string | 是 | 座机 |
| mobile_number | string | 是 | 手机 |
| email | string | 是 | 邮箱 |
| manufacturer | string | 是 | 生产商 |
| manufacturer_belongs_area | string | 是 | 生产商所属地区 |
| manufacturer_address | string | 是 | 生产商单位地址 |
| manufacturer_description | string | 是 | 生产单位简介 |
| manufacturer_site | string | 是 | 生产单位官网 |
| manufacturer_iso | bool | 是 | ISO标准 |
| haccp | bool | 是 | HACCP |
| fsms | bool | 是 | FSMS |
  
* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code |  string  | 否 | 供应商代码 |

* 请求示例
```
{
	"supplier_code": "S1",
	"contact_name": "张经理",
	"position": "销售经理",
	"telephone": "021-11111111",
	"mobile_number": "13811111111",
	"email": "111111@111.com",
	"manufacturer": "上海朝晖药业有限公司",
	"manufacturer_belongs_area": "中国上海",
	"manufacturer_address": "上海市宝山区抚远路2151号",
	"manufacturer_description": "上海朝晖是一家...年产能...",
	"manufacturer_site": "http://www.zhpharma.cn/",
	"manufacturer_iso": true,
	"haccp": false,
	"fsms": false
}
```
  
* 应答示例
```
{
	"msg": "",
	"code": 0,
	"data": {
	    "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	    "supplier_code": "S1"
	}
}
```

### 6.2 供应商修改 <a name="supplier_update"/>
* 请求URL:http://${DOMAIN}/interface/supplier/update
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code | string | 否 | 供应商代码 |
| contact_name | string | 否 | 联系人 |
| sales_manager | string | 否 | 销售经理 |
| telephone | string | 否 | 座机 |
| mobile_number | string | 否 | 手机 |
| email | string | 否 | 邮箱 |
| manufacturer | string | 否 | 生产商 |
| manufacturer_belongs_area | string | 否 | 生产商所属地区 |
| manufacturer_address | string | 否 | 生产商单位地址 |
| manufacturer_description | string | 否 | 生产单位简介 |
| manufacturer_site | string | 否 | 生产单位官网 |
| manufacturer_iso | bool | 否 | ISO标准 |
| haccp | bool | 否 | HACCP |
| fsms | bool | 否 | FSMS |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code |  string  | 否 | 供应商代码 |

* 请求示例
```
{
    "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	"supplier_code": "S1",
	"contact_name": "张经理",
	"position": "销售经理",
	"telephone": "021-11111111",
	"mobile_number": "13811111111",
	"email": "111111@111.com",
	"manufacturer": "上海朝晖药业有限公司",
	"manufacturer_belongs_area": "中国上海",
	"manufacturer_address": "上海市宝山区抚远路2151号",
	"manufacturer_description": "上海朝晖是一家...年产能...",
	"manufacturer_site": "http://www.zhpharma.cn/",
	"manufacturer_iso": true,
	"haccp": false,
	"fsms": false
}
```

* 应答示例

```
{
	"msg": "",
	"code": 0
}
```

### 6.3 供应商查询 <a name="supplier_query"/>
* 请求URL:http://${DOMAIN}/interface/supplier/query
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |


* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code | string | 是 | 供应商代码 |
| contact_name | string | 是 | 联系人 |
| position | string | 是 | 职位 |
| telephone | string | 是 | 座机 |
| mobile_number | string | 是 | 手机 |
| email | string | 是 | 邮箱 |
| manufacturer | string | 是 | 生产商 |
| manufacturer_belongs_area | string | 是 | 生产商所属地区 |
| manufacturer_address | string | 是 | 生产商单位地址 |
| manufacturer_description | string | 是 | 生产单位简介 |
| manufacturer_site | string | 是 | 生产单位官网 |
| manufacturer_iso | bool | 是 | ISO标准 |
| haccp | bool | 是 | HACCP |
| fsms | bool | 是 | FSMS |
| update_time | int | 是 | 更新时间 |
| create_time | int | 是 | 创建时间 |

* 请求示例
```
{
    "supplier_id": "S1f18348f32c9a4694f16426798937ae2"
}
```

* 应答示例

```
{
	"msg": "",
	"code": 0,
	"data": {
        "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	    "supplier_code": "S1",
	    "contact_name": "张经理",
	    "position": "销售经理",
	    "telephone": "021-11111111",
	    "mobile_number": "13811111111",
	    "email": "111111@111.com",
	    "manufacturer": "上海朝晖药业有限公司",
	    "manufacturer_belongs_area": "中国上海",
	    "manufacturer_address": "上海市宝山区抚远路2151号",
	    "manufacturer_description": "上海朝晖是一家...年产能...",
	    "manufacturer_site": "http://www.zhpharma.cn/",
	    "manufacturer_iso": true,
	    "haccp": false,
	    "fsms": false,
	    "update_time": 1533112230,
	    "create_time": 1533112230	    
	}
}
```

### 6.4 供应商删除 <a name="supplier_delete"/>
* 请求URL:http://${DOMAIN}/interface/supplier/delete
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_ids |  string array  | 是 | 供应商ID |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |


* 请求示例
```
{
    "supplier_ids": ["S1f18348f32c9a4694f16426798937ae2"]
}
```

* 应答示例

```
{
	"msg": "",
	"code": 0
}
```

### 6.5 供应商列表 <a name="supplier_list"/>
* 请求URL:http://${DOMAIN}/interface/supplier/list
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code | string | 是 | 供应商代码 |
| contact_name | string | 是 | 联系人 |
| telephone | string | 是 | 座机 |
| mobile_number | string | 是 | 手机 |
| email | string | 是 | 邮箱 |
| manufacturer | string | 是 | 生产商 |
| manufacturer_belongs_area | string | 是 | 生产商所属地区 |
| manufacturer_address | string | 是 | 生产商单位地址 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object array  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code | string | 是 | 供应商代码 |
| contact_name | string | 是 | 联系人 |
| position | string | 是 | 职位 |
| telephone | string | 是 | 座机 |
| mobile_number | string | 是 | 手机 |
| email | string | 是 | 邮箱 |
| manufacturer | string | 是 | 生产商 |
| manufacturer_belongs_area | string | 是 | 生产商所属地区 |
| manufacturer_address | string | 是 | 生产商单位地址 |
| manufacturer_description | string | 是 | 生产单位简介 |
| manufacturer_site | string | 是 | 生产单位官网 |
| manufacturer_iso | bool | 是 | ISO标准 |
| haccp | bool | 是 | HACCP |
| fsms | bool | 是 | FSMS |
| update_time | int | 是 | 更新时间 |
| create_time | int | 是 | 创建时间 |

* 请求示例
```
{
    "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	"contact_name": "张经理",
	"position": "销售经理",
	"telephone": "021-11111111",
	"mobile_number": "13811111111",
	"email": "111111@111.com",
	"manufacturer": "上海朝晖药业有限公司",
	"manufacturer_belongs_area": "中国上海",
	"manufacturer_address": "上海市宝山区抚远路2151号"  
}
```

* 应答示例

```
{
	"msg": "",
	"code": 0,
	"data": {
	  "page_number": 1,
	  "page_size": 10,
	  "total_number": 30,
	  "list": [{	
           "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	       "supplier_code": "S1",
	       "contact_name": "张经理",
	       "position": "销售经理",
	       "telephone": "021-11111111",
	       "mobile_number": "13811111111",
	       "email": "111111@111.com",
	       "manufacturer": "上海朝晖药业有限公司",
	       "manufacturer_belongs_area": "中国上海",
	       "manufacturer_address": "上海市宝山区抚远路2151号",
	       "manufacturer_description": "上海朝晖是一家...年产能...",
	       "manufacturer_site": "http://www.zhpharma.cn/",
	       "manufacturer_iso": true,
	       "haccp": false,
	       "fsms": false,
	       "update_time": 1533112230,
	       "create_time": 1533112230	    
	   }]
	}
}
```

### 6.6 供应商批量增加 <a name="supplier_batch_add"/>
* 请求URL:http://${DOMAIN}/interface/supplier/batch_add
* 请求字段无:

```
# Http请求中content为csv文件内容, 文件大小约定为不超过2M
```

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |


* 应答示例
```
{
	"msg": "",
	"code": 0
}
```

## 7. 关联关系管理 <a name="relation_manage"/>
### 7.1 产品和供应商关联 <a name="relation_add"/>
* 请求URL:http://${DOMAIN}/interface/relation/add
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_code | string | 是 | 产品CODE |
| supplier_code | string | 是 | 供应商CODE |
| quality_criterion | string | 是 | 质量标准 |
| packaging | string | 是 | 包装 |
| gmp_cn | int | 是 | 中国GMP |
| gmp_eu | int | 是 | 欧洲GMP |
| FDA | int | 是 | FDA |
| CEP | int | 是 | CEP |
| US_DMF | int | 是 | US_DMF |
| EU_DMF | int | 是 | EU_DMF |
| TGA | int | 是 | TGA |
| MF | int | 是 | MF |
| KOSHER | int | 是 | KOSHER |
| HALAL | int | 是 | HALAL |
| others | bool | 否 | 其他资质 |
| capacity | int | 是 | 年产能,单位吨 |


* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code |  string  | 否 | 供应商代码 |

* 请求示例
```
{
	"product_code": "P1f18348f32c9a4694f16426798937ae2",
	"supplier_code": "S1f18348f32c9a4694f16426798937ae2",
	"quality_criterion": "CP2010",
	"packaging": "25公斤桶",
	"gmp_cn": 1,
	"gmp_eu": 0,
	"FDA": 0,
	"CEP": 0,
	"US_DMF": 0,
	"EU_DMF": 0,
	"TGA": 0,
	"MF": 0,
	"KOSHER": 0,
	"HALAL": 0,
	"others": "",
	"capacity": 200000
}
```
  
* 应答示例
```
{
	"msg": "",
	"code": 0
}
```

### 7.2 产品和供应商解绑 <a name="relation_delete"/>
* 请求URL:http://${DOMAIN}/interface/relation/delete
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_code | string | 是 | 产品CODE |
| supplier_code | string | 是 | 供应商CODE |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |

* 请求示例
```
{
	"product_code": "P1f18348f32c9a4694f16426798937ae2",
	"supplier_code": "S1f18348f32c9a4694f16426798937ae2"
}
```
  
* 应答示例
```
{
	"msg": "",
	"code": 0
}
```

### 7.3 产品和供应商批量关联 <a name="relation_batch_add"/>
* 请求URL:http://${DOMAIN}/interface/relation/batch_add
* 请求字段无:

```
# Http请求中content为csv文件内容, 文件大小约定为不超过2M
```

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |


* 应答示例
```
{
	"msg": "",
	"code": 0
}
```


### 7.4 产品和供应商批量删除 <a name="relation_batch_delete"/>

* 请求URL:http://${DOMAIN}/interface/relation/batch_delete
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| list |  object array | 是 | 关系组 |

* list item 字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_code |  string  | 是 | 产品ID |
| supplier_code |  string  | 否 | 供应商ID |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |

* 请求示例
```
{
    "list": [
        {
            "product_code": "P1f18348f32c9a4694f16426798937ae2",
            "supplier_code": "S1f18348f32c9a4694f16426798937ae2"
        }
    ]
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0
}
```

### 7.5 关联产品供应商列表 <a name="relation_list"/>

* 请求URL:http://${DOMAIN}/interface/relation/list
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id | string | 是 | 产品ID |
| product_code | string | 是 | 产品代码 |
| product_name_cn | string | 是 | 产品中文名称 |
| product_name_en | string | 是 | 产品英文名称 |
| product_cas | string | 是 | 产品CAS号 |
| purpose | string | 是 | 用途 |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code | string | 是 | 供应商代码 |
| contact_name | string | 是 | 联系人 |
| telephone | string | 是 | 座机 |
| mobile_number | string | 是 | 手机 |
| email | string | 是 | 邮箱 |
| manufacturer | string | 是 | 生产商 |
| manufacturer_belongs_area | string | 是 | 生产商所属地区 |
| manufacturer_address | string | 是 | 生产商单位地址 |


* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object array  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id | string | 是 | 产品ID |
| product_code | string | 是 | 产品代码 |
| product_name_cn | string | 是 | 产品中文名称 |
| product_name_en | string | 是 | 产品英文名称 |
| product_cas | string | 是 | 产品CAS号 |
| molecular_formula | string | 是 | 产品分子式 |
| molecular_weight | string | 是 | 产品分子量 |
| constitutional_formula | string | 是 | 产品结构式 |
| HS_Code | string | 是 | 海关编码 |
| category | string | 是 | 所属类别 |
| physicochemical_property | string | 是 | 理化性质 |
| purpose | string | 是 | 用途 |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code | string | 是 | 供应商代码 |
| contact_name | string | 是 | 联系人 |
| position | string | 是 | 职位 |
| telephone | string | 是 | 座机 |
| mobile_number | string | 是 | 手机 |
| email | string | 是 | 邮箱 |
| manufacturer | string | 是 | 生产商 |
| manufacturer_belongs_area | string | 是 | 生产商所属地区 |
| manufacturer_address | string | 是 | 生产商单位地址 |
| manufacturer_description | string | 是 | 生产单位简介 |
| manufacturer_site | string | 是 | 生产单位官网 |
| manufacturer_iso | bool | 是 | ISO标准 |
| haccp | bool | 是 | HACCP |
| fsms | bool | 是 | FSMS |
| quality_criterion | string | 是 | 质量标准 |
| packaging | string | 是 | 包装 |
| gmp_cn | int | 是 | 中国GMP |
| gmp_eu | int | 是 | 欧洲GMP |
| FDA | int | 是 | FDA |
| CEP | int | 是 | CEP |
| US_DMF | int | 是 | US_DMF |
| EU_DMF | int | 是 | EU_DMF |
| TGA | int | 是 | TGA |
| MF | int | 是 | MF |
| KOSHER | int | 是 | KOSHER |
| HALAL | int | 是 | HALAL |
| others | string | 否 | 其他资质 |
| capacity | int | 是 | 年产能,单位吨 |
| update_time | int | 是 | 更新时间 |
| create_time | int | 是 | 创建时间 |

* 请求示例
```
{
    "product_id": "P1f18348f32c9a4694f16426798937ae2",
	"product_code": "P1",
	"product_name_cn": "马来酸氨氯地平",
	"product_name_en": "Amlodipine Maleate",
	"product_cas": "88150-47-4",
	"molecular_formula": "C24H29ClN2O9",
	"molecular_weight": "524.9481",
	"HS_Code": "2942000000",
	"category": "原料药",
	"purpose": "抗高血压",
    "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	"contact_name": "张经理",
	"position": "销售经理",
	"telephone": "021-11111111",
	"mobile_number": "13811111111",
	"email": "111111@111.com",
	"manufacturer": "上海朝晖药业有限公司",
	"manufacturer_belongs_area": "中国上海",
	"manufacturer_address": "上海市宝山区抚远路2151号" 	   
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0,
	"data": {
	  "page_number": 1,
	  "page_size": 10,
	  "total_number": 30,
	  "list": [
	    {
            "product_id": "P1f18348f32c9a4694f16426798937ae2",
	        "product_code": "P1",
	        "product_name_cn": "马来酸氨氯地平",
	        "product_name_en": "Amlodipine Maleate",
	        "product_cas": "88150-47-4",
	        "molecular_formula": "C24H29ClN2O9",
	        "molecular_weight": "524.9481",
	        "constitutional_formula": "http://store.system.com/img/cf.png",
	        "HS_Code": "2942000000",
	        "category": "原料药",
	        "physicochemical_property": "类白色或淡黄色结晶粉",
	        "purpose": "抗高血压"	,
            "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	        "supplier_code": "S1",
	        "contact_name": "张经理",
	        "position": "销售经理",
	        "telephone": "021-11111111",
	        "mobile_number": "13811111111",
	        "email": "111111@111.com",
	        "manufacturer": "上海朝晖药业有限公司",
	        "manufacturer_belongs_area": "中国上海",
	        "manufacturer_address": "上海市宝山区抚远路2151号",
	        "manufacturer_description": "上海朝晖是一家...年产能...",
	        "manufacturer_site": "http://www.zhpharma.cn/",
	        "manufacturer_iso": true,
	        "haccp": false,
	        "fsms": false,	 
					"quality_criterion": "CP2010",
					"packaging": "25公斤桶",
					"gmp_cn": 1,
					"gmp_eu": 0,
					"FDA": 0,
					"CEP": 0,
					"US_DMF": 0,
					"EU_DMF": 0,
					"TGA": 0,
					"MF": 0,
					"KOSHER": 0,
					"HALAL": 0,
					"others": ["http://www.system.com/picture/1.jpg","http://www.system.com/picture/2.jpg"],
					"capacity": 200000	               
	        "update_time": 1533112230,
	        "create_time": 1533112230
	    }  
	  ]
	}	
}
```

### 7.6 产品相似供应商列表 <a name="similarity_list"/>

* 请求URL:http://${DOMAIN}/interface/relation/list
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_codes | string array | 是 | 产品代码 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object array  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| product_id | string | 是 | 产品ID |
| product_code | string | 是 | 产品代码 |
| product_name_cn | string | 是 | 产品中文名称 |
| product_name_en | string | 是 | 产品英文名称 |
| product_cas | string | 是 | 产品CAS号 |
| molecular_formula | string | 是 | 产品分子式 |
| molecular_weight | string | 是 | 产品分子量 |
| constitutional_formula | string | 是 | 产品结构式 |
| HS_Code | string | 是 | 海关编码 |
| category | string | 是 | 所属类别 |
| physicochemical_property | string | 是 | 理化性质 |
| purpose | string | 是 | 用途 |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code | string | 是 | 供应商代码 |
| contact_name | string | 是 | 联系人 |
| position | string | 是 | 职位 |
| telephone | string | 是 | 座机 |
| mobile_number | string | 是 | 手机 |
| email | string | 是 | 邮箱 |
| manufacturer | string | 是 | 生产商 |
| manufacturer_belongs_area | string | 是 | 生产商所属地区 |
| manufacturer_address | string | 是 | 生产商单位地址 |
| manufacturer_description | string | 是 | 生产单位简介 |
| manufacturer_site | string | 是 | 生产单位官网 |
| manufacturer_iso | bool | 是 | ISO标准 |
| haccp | bool | 是 | HACCP |
| fsms | bool | 是 | FSMS |
| quality_criterion | string | 是 | 质量标准 |
| packaging | string | 是 | 包装 |
| gmp_cn | int | 是 | 中国GMP |
| gmp_eu | int | 是 | 欧洲GMP |
| FDA | int | 是 | FDA |
| CEP | int | 是 | CEP |
| US_DMF | int | 是 | US_DMF |
| EU_DMF | int | 是 | EU_DMF |
| TGA | int | 是 | TGA |
| MF | int | 是 | MF |
| KOSHER | int | 是 | KOSHER |
| HALAL | int | 是 | HALAL |
| others | string | 否 | 其他资质 |
| capacity | int | 是 | 年产能,单位吨 |
| update_time | int | 是 | 更新时间 |
| create_time | int | 是 | 创建时间 |

* 请求示例
```
{
	"product_codes": ["P1"]   
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0,
	"data": {
	  "page_number": 1,
	  "page_size": 10,
	  "total_number": 30,
	  "list": [
	    {
            "product_id": "P1f18348f32c9a4694f16426798937ae2",
	        "product_code": "P1",
	        "product_name_cn": "马来酸氨氯地平",
	        "product_name_en": "Amlodipine Maleate",
	        "product_cas": "88150-47-4",
	        "molecular_formula": "C24H29ClN2O9",
	        "molecular_weight": "524.9481",
	        "constitutional_formula": "http://store.system.com/img/cf.png",
	        "HS_Code": "2942000000",
	        "category": "原料药",
	        "physicochemical_property": "类白色或淡黄色结晶粉",
	        "purpose": "抗高血压"	,
            "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	        "supplier_code": "S1",
	        "contact_name": "张经理",
	        "position": "销售经理",
	        "telephone": "021-11111111",
	        "mobile_number": "13811111111",
	        "email": "111111@111.com",
	        "manufacturer": "上海朝晖药业有限公司",
	        "manufacturer_belongs_area": "中国上海",
	        "manufacturer_address": "上海市宝山区抚远路2151号",
	        "manufacturer_description": "上海朝晖是一家...年产能...",
	        "manufacturer_site": "http://www.zhpharma.cn/",
	        "manufacturer_iso": true,
	        "haccp": false,
	        "fsms": false,	 
					"quality_criterion": "CP2010",
					"packaging": "25公斤桶",
					"gmp_cn": 1,
					"gmp_eu": 0,
					"FDA": 0,
					"CEP": 0,
					"US_DMF": 0,
					"EU_DMF": 0,
					"TGA": 0,
					"MF": 0,
					"KOSHER": 0,
					"HALAL": 0,
					"others": ["http://www.system.com/picture/1.jpg","http://www.system.com/picture/2.jpg"],
					"capacity": 200000	               
	        "update_time": 1533112230,
	        "create_time": 1533112230
	    }  
	  ]
	}	
}
```

## 8 用户管理 <a name="user_manage"/>
### 8.1 用户登录 <a name="user_signin"/>

* 请求URL:http://${DOMAIN}/interface/user/signin
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| user_name | string | 是 | 用户名 |
| password | string | 是 | 用户密码 |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |

* 请求示例
```
{
    "user_name": "admin",
    "password": "123456"
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0
}
```
### 8.2 我的供应商 <a name="my_suppliers"/>
* 请求URL:http://${DOMAIN}/interface/user/my_supplier
* 请求字段: 无

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |
| data |  json object array  | 是 | 对象 |

* 应答data字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_id |  string  | 是 | 供应商ID |
| supplier_code | string | 是 | 供应商代码 |
| contact_name | string | 是 | 联系人 |
| position | string | 是 | 职位 |
| telephone | string | 是 | 座机 |
| mobile_number | string | 是 | 手机 |
| email | string | 是 | 邮箱 |
| manufacturer | string | 是 | 生产商 |
| manufacturer_belongs_area | string | 是 | 生产商所属地区 |
| manufacturer_address | string | 是 | 生产商单位地址 |
| manufacturer_description | string | 是 | 生产单位简介 |
| manufacturer_site | string | 是 | 生产单位官网 |
| manufacturer_iso | bool | 是 | ISO标准 |
| haccp | bool | 是 | HACCP |
| fsms | bool | 是 | FSMS |
| update_time | int | 是 | 更新时间 |
| create_time | int | 是 | 创建时间 |

* 请求示例
```
{}
```

* 应答示例

```
{
	"msg": "",
	"code": 0,
	"data": {
	  "page_number": 1,
	  "page_size": 10,
	  "total_number": 30,
	  "list": [{	
           "supplier_id": "S1f18348f32c9a4694f16426798937ae2",
	       "supplier_code": "S1",
	       "contact_name": "张经理",
	       "position": "销售经理",
	       "telephone": "021-11111111",
	       "mobile_number": "13811111111",
	       "email": "111111@111.com",
	       "manufacturer": "上海朝晖药业有限公司",
	       "manufacturer_belongs_area": "中国上海",
	       "manufacturer_address": "上海市宝山区抚远路2151号",
	       "manufacturer_description": "上海朝晖是一家...年产能...",
	       "manufacturer_site": "http://www.zhpharma.cn/",
	       "manufacturer_iso": true,
	       "haccp": false,
	       "fsms": false,
	       "update_time": 1533112230,
	       "create_time": 1533112230	    
	   }]
	}
}
```

### 8.3 保存供应商 <a name="save_suppliers"/>
* 请求URL:http://${DOMAIN}/interface/user/save_supplier
* 请求字段:

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| supplier_codes | string array | 是 | 供应商CODE |

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |

* 请求示例
```
{
    "supplier_codes": ["S1", "S2"]
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0
}
```

### 8.4 用户登录状态 <a name="user_sign_status"/>

* 请求URL:http://${DOMAIN}/interface/user/sign_status
* 请求字段:无

* 应答字段

| 名称  | 类型 | 必填 | 描述 |
| :--------| ----:| ----:| :--- |
| code |  int  | 是 | 状态码 |
| msg |  string  | 否 | 失败时的提示信息 |

* 请求示例
```
{
}
```

* 应答示例
```
{
	"msg": "",
	"code": 0
}
```

## 9.状态码 <a name="status_code"/> 

| 值  | 描述 |
| :--------| ----:|
| -100100 |  用户输入错误  |
| -100200 |  用户输入逻辑错误  |
| -100300 |  服务后台错误  |
| -100301 |  系统错误  |
| -100400 |  数据库读写错误  |
| -100401 |  数据库逻辑错误  |
| -100500 |  认证失败  |
| -100600 |  系统繁忙  |	