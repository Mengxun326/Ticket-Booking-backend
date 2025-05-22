# 机票预订系统数据库设计文档

## 1. 数据库概述

### 1.1 数据库名称
`ticket_booking`

### 1.2 字符集设置
- 字符集：utf8mb4
- 排序规则：utf8mb4_unicode_ci

### 1.3 系统功能模块
1. 用户权限管理
2. 旅客信息管理
3. 航班信息管理
4. 订票业务管理
5. 支付交易管理
6. 退票业务管理
7. 系统审计日志

## 2. 表结构设计

### 2.1 核心业务表

#### 2.1.1 旅客信息表 (passenger)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| passengerId | BIGINT | 旅客ID | 主键 |
| name | VARCHAR(50) | 姓名 | - |
| idType | VARCHAR(20) | 证件类型 | 联合唯一 |
| idNumber | VARCHAR(50) | 证件号码 | 联合唯一 |
| phone | VARCHAR(20) | 联系电话 | 普通索引 |
| email | VARCHAR(100) | 电子邮箱 | 普通索引 |
| memberLevel | VARCHAR(20) | 会员等级 | - |
| memberPoints | INT | 会员积分 | - |

#### 2.1.2 航班信息表 (flight)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| flightId | BIGINT | 航班ID | 主键 |
| flightNumber | VARCHAR(20) | 航班号 | 联合唯一 |
| airline | VARCHAR(50) | 航空公司 | - |
| departureCity | VARCHAR(50) | 出发城市 | 组合索引 |
| arrivalCity | VARCHAR(50) | 到达城市 | 组合索引 |
| departureTime | DATETIME | 起飞时间 | 组合索引 |
| arrivalTime | DATETIME | 到达时间 | 组合索引 |
| status | VARCHAR(20) | 航班状态 | - |

#### 2.1.3 舱位信息表 (cabin)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| cabinId | BIGINT | 舱位ID | 主键 |
| flightId | BIGINT | 航班ID | 外键 |
| cabinClass | VARCHAR(20) | 舱位等级 | - |
| seatCount | INT | 座位数量 | - |
| basePrice | DECIMAL(10,2) | 基础价格 | - |
| availableSeats | INT | 剩余座位数 | - |

### 2.2 订单相关表（分区表）

#### 2.2.1 订票信息表 (booking)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| bookingId | BIGINT | 订单ID | 联合主键 |
| bookingTime | DATETIME | 订票时间 | 联合主键 |
| userId | BIGINT | 用户ID | 普通索引 |
| passengerId | BIGINT | 旅客ID | 普通索引 |
| flightId | BIGINT | 航班ID | 普通索引 |
| cabinId | BIGINT | 舱位ID | 普通索引 |
| orderStatus | INT | 订单状态 | 组合索引 |
| paymentStatus | INT | 支付状态 | 组合索引 |

分区策略：按`bookingTime`字段按月分区

#### 2.2.2 支付信息表 (payment)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| paymentId | BIGINT | 支付ID | 联合主键 |
| paymentTime | DATETIME | 支付时间 | 联合主键 |
| bookingId | BIGINT | 订单ID | 普通索引 |
| transactionNumber | VARCHAR(100) | 交易流水号 | 联合唯一 |
| amount | DECIMAL(10,2) | 支付金额 | - |
| status | INT | 支付状态 | 组合索引 |

分区策略：按`paymentTime`字段按月分区

#### 2.2.3 退票信息表 (refund)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| refundId | BIGINT | 退票ID | 联合主键 |
| applyTime | DATETIME | 申请时间 | 联合主键 |
| bookingId | BIGINT | 订单ID | 普通索引 |
| status | INT | 退票状态 | 普通索引 |
| refundAmount | DECIMAL(10,2) | 退款金额 | - |
| fee | DECIMAL(10,2) | 手续费 | - |

分区策略：按`applyTime`字段按月分区

### 2.3 系统管理表

#### 2.3.1 用户表 (user)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| id | BIGINT | 用户ID | 主键 |
| userAccount | VARCHAR(50) | 用户账号 | 唯一索引 |
| userPassword | VARCHAR(100) | 密码 | - |
| username | VARCHAR(50) | 用户昵称 | 普通索引 |
| phone | VARCHAR(20) | 手机号 | 普通索引 |
| email | VARCHAR(100) | 邮箱 | 普通索引 |

#### 2.3.2 角色表 (role)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| roleId | BIGINT | 角色ID | 主键 |
| roleName | VARCHAR(50) | 角色名称 | - |
| roleCode | VARCHAR(50) | 角色编码 | 唯一索引 |

#### 2.3.3 权限表 (permission)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| permissionId | BIGINT | 权限ID | 主键 |
| permissionName | VARCHAR(50) | 权限名称 | - |
| permissionCode | VARCHAR(50) | 权限编码 | 唯一索引 |
| permissionType | INT | 权限类型 | - |

### 2.4 其他表

#### 2.4.1 数据字典表 (dict)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| dictId | BIGINT | 字典ID | 主键 |
| dictType | VARCHAR(50) | 字典类型 | 联合唯一 |
| dictCode | VARCHAR(50) | 字典编码 | 联合唯一 |
| dictValue | VARCHAR(100) | 字典值 | - |

#### 2.4.2 审计日志表 (auditLog)
| 字段名 | 类型 | 说明 | 索引 |
|--------|------|------|------|
| logId | BIGINT | 日志ID | 联合主键 |
| operationTime | DATETIME | 操作时间 | 联合主键 |
| userId | BIGINT | 用户ID | 普通索引 |
| operationType | VARCHAR(50) | 操作类型 | - |
| targetType | VARCHAR(50) | 操作对象类型 | - |
| targetId | VARCHAR(50) | 操作对象ID | - |

分区策略：按`operationTime`字段按月分区

## 3. 重要说明

### 3.1 分区表说明
1. 所有分区表都按月分区
2. 分区键必须包含在主键和唯一索引中
3. 分区表不支持外键约束，需要在应用层控制数据一致性

### 3.2 字典数据
系统包含以下字典类型：
1. ID_TYPE：证件类型
   - IDENTITY_CARD：身份证
   - PASSPORT：护照
2. MEMBER_LEVEL：会员等级
   - NORMAL：普通会员
   - SILVER：白银会员
   - GOLD：黄金会员
   - PLATINUM：铂金会员
3. FLIGHT_STATUS：航班状态
   - SCHEDULED：计划
   - BOARDING：登机中
   - DEPARTED：已起飞
   - ARRIVED：已到达
   - CANCELLED：已取消
4. CABIN_CLASS：舱位等级
   - ECONOMY：经济舱
   - BUSINESS：商务舱
   - FIRST：头等舱
5. ORDER_STATUS：订单状态
   - PENDING_PAYMENT：待支付
   - PAID：已支付
   - COMPLETED：已完成
   - CANCELLED：已取消
6. PAYMENT_STATUS：支付状态
   - PENDING：待支付
   - SUCCESS：支付成功
   - FAILED：支付失败
   - REFUNDED：已退款
7. REFUND_STATUS：退票状态
   - PENDING：待处理
   - PROCESSING：处理中
   - COMPLETED：已完成
   - REJECTED：已拒绝
8. GENDER：性别
   - UNKNOWN：未知
   - MALE：男
   - FEMALE：女
9. USER_STATUS：用户状态
   - NORMAL：正常
   - DISABLED：禁用
10. USER_ROLE：用户角色
    - USER：普通用户
    - ADMIN：管理员

### 3.3 注意事项
1. 所有表都包含`createTime`和`updateTime`字段用于记录创建和更新时间
2. 状态字段统一使用`INT`类型
3. 金额字段统一使用`DECIMAL(10,2)`类型
4. 所有表的主键ID需要在应用层生成（推荐使用分布式ID生成算法）

### 3.4 索引设计原则
1. 主键索引：每个表都必须有主键
2. 唯一索引：用于保证业务唯一性约束
3. 普通索引：针对常用查询条件创建
4. 组合索引：针对多字段联合查询创建

### 3.5 分区表设计说明
1. 分区表的主键必须包含分区键
2. 分区表的唯一索引必须包含分区键
3. 按月分区可以方便历史数据的归档和清理
4. 分区策略的选择基于业务访问特点和数据量

### 3.6 安全性考虑
1. 密码字段需要加密存储
2. 敏感信息（如证件号码）建议加密存储
3. 重要操作需要记录审计日志
4. 用户权限需要细粒度控制 