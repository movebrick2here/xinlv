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
## [6 供应商管理](#supplier_manage)
### [6.1 供应商增加](#supplier_add)
### [6.2 供应商修改](#supplier_update)
### [6.3 供应商查询](#supplier_query)
### [6.4 供应商删除](#supplier_delete)
### [6.5 供应商列表](#supplier_list)
### [6.6 供应商批量添加](#supplier_batch_add)
## [7 关联关系管理](#relation_manage)
### [7.1 产品和供应商关联](#relation_add)
### [7.2 产品和供应商解绑](#relation_delete)
### [7.3 产品和供应商批量关联](#relation_batch_add)
### [7.4 产品和供应商批量删除](#relation_batch_delete)
### [7.5 关联产品供应商列表](#relation_list)
## [8 状态码](#status_code)
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
* 请求URL:http://${DOMAIN}/api/v1/product/add
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
* 请求URL:http://${DOMAIN}/api/v1/product/update
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
* 请求URL:http://${DOMAIN}/api/v1/product/query
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
	    "purpose": "抗高血压"	  
	}
}
```
		
## 8.状态码 <a name="status_code"/> 

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