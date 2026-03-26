-- 1. 创建数据库（统一为 wms）
CREATE DATABASE IF NOT EXISTS wms DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. 切换到 wms 数据库
USE wms;

-- 用户表
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info` (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `user_code` varchar(50) DEFAULT NULL COMMENT '账号',
  `user_name` varchar(100) DEFAULT NULL COMMENT '用户名',
  `user_pwd` varchar(100) DEFAULT NULL COMMENT '用户密码',
  `user_type` varchar(10) DEFAULT NULL COMMENT '用户类型',
  `user_state` varchar(10) DEFAULT NULL COMMENT '用户状态',
  `is_delete` varchar(10) DEFAULT '0' COMMENT '删除状态',
  `create_by` int DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` int DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_user_code` (`user_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 角色表
DROP TABLE IF EXISTS `role_info`;
CREATE TABLE `role_info` (
  `role_id` int NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `role_name` varchar(50) DEFAULT NULL COMMENT '角色名称',
  `role_desc` varchar(200) DEFAULT NULL COMMENT '角色描述',
  `role_code` varchar(50) DEFAULT NULL COMMENT '角色编码',
  `role_state` varchar(10) DEFAULT '1' COMMENT '1启用 0禁用',
  `create_by` int DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` int DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 权限表
DROP TABLE IF EXISTS `auth_info`;
CREATE TABLE `auth_info` (
  `auth_id` int NOT NULL AUTO_INCREMENT COMMENT '权限id',
  `parent_id` int DEFAULT 0 COMMENT '父级权限id',
  `auth_name` varchar(50) DEFAULT NULL COMMENT '权限名称',
  `auth_desc` varchar(200) DEFAULT NULL COMMENT '权限描述',
  `auth_grade` int DEFAULT 0 COMMENT '权限等级',
  `auth_type` varchar(10) DEFAULT NULL COMMENT '权限类型',
  `auth_url` varchar(200) DEFAULT NULL COMMENT '权限路径',
  `auth_code` varchar(100) DEFAULT NULL COMMENT '权限编码',
  `auth_order` int DEFAULT 0 COMMENT '权限排序',
  `auth_state` varchar(10) DEFAULT '1' COMMENT '1启用 0禁用',
  `create_by` int DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` int DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`auth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 用户角色关系表
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `user_role_id` int NOT NULL AUTO_INCREMENT COMMENT '用户角色id',
  `role_id` int DEFAULT NULL COMMENT '角色id',
  `user_id` int DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`user_role_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关系表';

-- 角色权限关系表
DROP TABLE IF EXISTS `role_auth`;
CREATE TABLE `role_auth` (
  `role_auth_id` int NOT NULL AUTO_INCREMENT COMMENT '角色权限id',
  `role_id` int DEFAULT NULL COMMENT '角色id',
  `auth_id` int DEFAULT NULL COMMENT '权限id',
  PRIMARY KEY (`role_auth_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_auth_id` (`auth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关系表';

-- 仓库表
DROP TABLE IF EXISTS `store_info`;
CREATE TABLE `store_info` (
  `store_id` int NOT NULL AUTO_INCREMENT COMMENT '仓库id',
  `store_name` varchar(100) DEFAULT NULL COMMENT '仓库名称',
  `store_num` varchar(50) DEFAULT NULL COMMENT '仓库编号',
  `store_address` varchar(200) DEFAULT NULL COMMENT '仓库地址',
  `concat` varchar(50) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  PRIMARY KEY (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库表';

-- 商品分类表
DROP TABLE IF EXISTS `product_type`;
CREATE TABLE `product_type` (
  `type_id` int NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `parent_id` int DEFAULT 0 COMMENT '父级分类id',
  `type_code` varchar(50) DEFAULT NULL COMMENT '分类编码',
  `type_name` varchar(50) DEFAULT NULL COMMENT '分类名称',
  `type_desc` varchar(200) DEFAULT NULL COMMENT '分类描述',
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- 品牌表
DROP TABLE IF EXISTS `brand_info`;
CREATE TABLE `brand_info` (
  `brand_id` int NOT NULL AUTO_INCREMENT COMMENT '品牌id',
  `brand_name` varchar(50) DEFAULT NULL COMMENT '品牌名称',
  `brand_leter` varchar(10) DEFAULT NULL COMMENT '品牌首字母',
  `brand_desc` varchar(200) DEFAULT NULL COMMENT '品牌描述',
  PRIMARY KEY (`brand_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='品牌表';

-- 供应商表
DROP TABLE IF EXISTS `supply_info`;
CREATE TABLE `supply_info` (
  `supply_id` int NOT NULL AUTO_INCREMENT COMMENT '供应商id',
  `supply_num` varchar(50) DEFAULT NULL COMMENT '供应商编号',
  `supply_name` varchar(100) DEFAULT NULL COMMENT '供应商名称',
  `supply_introduce` varchar(500) DEFAULT NULL COMMENT '供应商介绍',
  `concat` varchar(50) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `address` varchar(200) DEFAULT NULL COMMENT '地址',
  `is_delete` varchar(10) DEFAULT '0' COMMENT '0可用 1不可用',
  PRIMARY KEY (`supply_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';

-- 产地表
DROP TABLE IF EXISTS `place_info`;
CREATE TABLE `place_info` (
  `place_id` int NOT NULL AUTO_INCREMENT COMMENT '产地id',
  `place_name` varchar(50) DEFAULT NULL COMMENT '产地名称',
  `place_num` varchar(50) DEFAULT NULL COMMENT '产地编号',
  `introduce` varchar(200) DEFAULT NULL COMMENT '产地介绍',
  `is_delete` varchar(10) DEFAULT '0' COMMENT '0可用 1不可用',
  PRIMARY KEY (`place_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产地表';

-- 规格单位表
DROP TABLE IF EXISTS `unit_info`;
CREATE TABLE `unit_info` (
  `unit_id` int NOT NULL AUTO_INCREMENT COMMENT '单位id',
  `unit_name` varchar(50) DEFAULT NULL COMMENT '单位名称',
  `unit_desc` varchar(200) DEFAULT NULL COMMENT '单位描述',
  PRIMARY KEY (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='规格单位表';

-- 商品表
DROP TABLE IF EXISTS `product_info`;
CREATE TABLE `product_info` (
  `product_id` int NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `store_id` int DEFAULT NULL COMMENT '仓库id',
  `brand_id` int DEFAULT NULL COMMENT '品牌id',
  `product_name` varchar(100) DEFAULT NULL COMMENT '商品名称',
  `product_num` varchar(50) DEFAULT NULL COMMENT '商品编号',
  `product_invent` int DEFAULT 0 COMMENT '商品库存',
  `type_id` int DEFAULT NULL COMMENT '分类id',
  `supply_id` int DEFAULT NULL COMMENT '供应商id',
  `place_id` int DEFAULT NULL COMMENT '产地id',
  `unit_id` int DEFAULT NULL COMMENT '单位id',
  `introduce` varchar(500) DEFAULT NULL COMMENT '商品介绍',
  `up_down_state` varchar(10) DEFAULT '1' COMMENT '0下架 1上架',
  `in_price` decimal(10,2) DEFAULT NULL COMMENT '进货价',
  `sale_price` decimal(10,2) DEFAULT NULL COMMENT '销售价',
  `mem_price` decimal(10,2) DEFAULT NULL COMMENT '会员价',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_by` int DEFAULT NULL COMMENT '创建人',
  `update_by` int DEFAULT NULL COMMENT '修改人',
  `imgs` varchar(500) DEFAULT NULL COMMENT '商品图片',
  `product_date` date DEFAULT NULL COMMENT '生产日期',
  `supp_date` date DEFAULT NULL COMMENT '保质期至',
  PRIMARY KEY (`product_id`),
  KEY `idx_store_id` (`store_id`),
  KEY `idx_brand_id` (`brand_id`),
  KEY `idx_type_id` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 采购单表
DROP TABLE IF EXISTS `purchase_info`;
CREATE TABLE `purchase_info` (
  `buy_id` int NOT NULL AUTO_INCREMENT COMMENT '采购单id',
  `product_id` int DEFAULT NULL COMMENT '商品id',
  `store_id` int DEFAULT NULL COMMENT '仓库id',
  `buy_num` int DEFAULT NULL COMMENT '采购数量',
  `fact_buy_num` int DEFAULT NULL COMMENT '实际采购数量',
  `buy_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '采购时间',
  `supply_id` int DEFAULT NULL COMMENT '供应商id',
  `place_id` int DEFAULT NULL COMMENT '产地id',
  `buy_user` varchar(50) DEFAULT NULL COMMENT '采购人',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `is_in` varchar(10) DEFAULT '0' COMMENT '0否 1是',
  PRIMARY KEY (`buy_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购单表';

-- 入库单表
DROP TABLE IF EXISTS `in_store_info`;
CREATE TABLE `in_store_info` (
  `ins_id` int NOT NULL AUTO_INCREMENT COMMENT '入库单id',
  `store_id` int DEFAULT NULL COMMENT '仓库id',
  `product_id` int DEFAULT NULL COMMENT '商品id',
  `in_num` int DEFAULT NULL COMMENT '入库数量',
  `create_by` int DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_in` varchar(10) DEFAULT '0' COMMENT '0否 1是',
  PRIMARY KEY (`ins_id`),
  KEY `idx_store_id` (`store_id`),
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='入库单表';

-- 出库单表
DROP TABLE IF EXISTS `out_store_info`;
CREATE TABLE `out_store_info` (
  `outs_id` int NOT NULL AUTO_INCREMENT COMMENT '出库单id',
  `product_id` int DEFAULT NULL COMMENT '商品id',
  `store_id` int DEFAULT NULL COMMENT '仓库id',
  `tally_id` int DEFAULT NULL COMMENT '理货员id',
  `out_price` decimal(10,2) DEFAULT NULL COMMENT '出库价格',
  `out_num` int DEFAULT NULL COMMENT '出库数量',
  `create_by` int DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_out` varchar(10) DEFAULT '0' COMMENT '0否 1是',
  PRIMARY KEY (`outs_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='出库单表';

-- 插入管理员用户 (密码为123456的HMAC-MD5加密)
INSERT INTO `user_info` (`user_code`, `user_name`, `user_pwd`, `user_type`, `user_state`, `is_delete`, `create_by`) VALUES
('admin', '系统管理员', 'c431d451c81e75ffac75a640590ed0a1', '1', '1', '0', 1);

-- 插入初始业务数据省略（与原文件一致）...
-- (为了节省篇幅，后续 INSERT 语句请参考原文件导入)