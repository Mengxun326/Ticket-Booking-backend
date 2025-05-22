-- 创建数据库
CREATE DATABASE IF NOT EXISTS ticket_booking DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ticket_booking;

-- 创建旅客信息表
CREATE TABLE IF NOT EXISTS passenger (
    passengerId BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '旅客ID',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    idType VARCHAR(20) NOT NULL COMMENT '证件类型',
    idNumber VARCHAR(50) NOT NULL COMMENT '证件号码',
    phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    email VARCHAR(100) COMMENT '电子邮箱',
    memberLevel VARCHAR(20) DEFAULT 'NORMAL' COMMENT '会员等级',
    memberPoints INT DEFAULT 0 COMMENT '会员积分',
    registerTime DATETIME NOT NULL COMMENT '注册时间',
    updateTime DATETIME NOT NULL COMMENT '最后更新时间',
    UNIQUE KEY uk_id_number (idType, idNumber),
    KEY idx_phone (phone),
    KEY idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='旅客信息表';

-- 创建航班信息表
CREATE TABLE IF NOT EXISTS flight (
    flightId BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '航班ID',
    flightNumber VARCHAR(20) NOT NULL COMMENT '航班号',
    airline VARCHAR(50) NOT NULL COMMENT '航空公司',
    departureCity VARCHAR(50) NOT NULL COMMENT '出发城市',
    arrivalCity VARCHAR(50) NOT NULL COMMENT '到达城市',
    departureAirport VARCHAR(100) NOT NULL COMMENT '出发机场',
    arrivalAirport VARCHAR(100) NOT NULL COMMENT '到达机场',
    departureTime DATETIME NOT NULL COMMENT '计划起飞时间',
    arrivalTime DATETIME NOT NULL COMMENT '计划到达时间',
    status VARCHAR(20) NOT NULL COMMENT '航班状态',
    aircraftType VARCHAR(50) NOT NULL COMMENT '机型',
    totalSeats INT NOT NULL COMMENT '总座位数',
    UNIQUE KEY uk_flight_number (flightNumber, departureTime),
    KEY idx_departure (departureCity, departureTime),
    KEY idx_arrival (arrivalCity, arrivalTime)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='航班信息表';

-- 创建舱位信息表
CREATE TABLE IF NOT EXISTS cabin (
    cabinId BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '舱位ID',
    flightId BIGINT NOT NULL COMMENT '航班ID',
    cabinClass VARCHAR(20) NOT NULL COMMENT '舱位等级',
    seatCount INT NOT NULL COMMENT '座位数量',
    basePrice DECIMAL(10,2) NOT NULL COMMENT '基础价格',
    availableSeats INT NOT NULL COMMENT '剩余座位数',
    seatLayout TEXT COMMENT '座位布局',
    FOREIGN KEY (flightId) REFERENCES flight(flightId),
    UNIQUE KEY uk_flight_cabin (flightId, cabinClass)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='舱位信息表';

-- 创建折扣信息表
CREATE TABLE IF NOT EXISTS discount (
    discountId BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '折扣ID',
    discountType VARCHAR(50) NOT NULL COMMENT '折扣类型',
    discountName VARCHAR(100) NOT NULL COMMENT '折扣名称',
    discountRate DECIMAL(4,2) NOT NULL COMMENT '折扣率',
    conditions TEXT COMMENT '使用条件',
    startTime DATETIME NOT NULL COMMENT '开始时间',
    endTime DATETIME NOT NULL COMMENT '结束时间',
    applicableRoutes TEXT COMMENT '适用航线',
    applicableCabins VARCHAR(100) COMMENT '适用舱位',
    status VARCHAR(20) NOT NULL COMMENT '状态',
    KEY idx_time_range (startTime, endTime),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='折扣信息表';

-- 创建订票信息表
CREATE TABLE IF NOT EXISTS booking (
    bookingId BIGINT NOT NULL COMMENT '订单ID',
    userId BIGINT NOT NULL COMMENT '用户ID',
    passengerId BIGINT NOT NULL COMMENT '旅客ID',
    flightId BIGINT NOT NULL COMMENT '航班ID',
    cabinId BIGINT NOT NULL COMMENT '舱位ID',
    seatNumber VARCHAR(10) COMMENT '座位号',
    bookingTime DATETIME NOT NULL COMMENT '订票时间',
    orderStatus INT NOT NULL COMMENT '订单状态',
    paymentStatus INT NOT NULL COMMENT '支付状态',
    ticketPrice DECIMAL(10,2) NOT NULL COMMENT '票价',
    actualPayment DECIMAL(10,2) NOT NULL COMMENT '实付金额',
    discountId BIGINT COMMENT '使用折扣ID',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (bookingId, bookingTime),
    KEY idx_user_id (userId),
    KEY idx_passenger_id (passengerId),
    KEY idx_flight_id (flightId),
    KEY idx_cabin_id (cabinId),
    KEY idx_discount_id (discountId),
    KEY idx_booking_time (bookingTime),
    KEY idx_status (orderStatus, paymentStatus)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订票信息表'
PARTITION BY RANGE (TO_DAYS(bookingTime)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);

-- 创建退票信息表
CREATE TABLE IF NOT EXISTS refund (
    refundId BIGINT NOT NULL COMMENT '退票ID',
    bookingId BIGINT NOT NULL COMMENT '订单ID',
    applyTime DATETIME NOT NULL COMMENT '申请时间',
    reason TEXT COMMENT '退票原因',
    status INT NOT NULL COMMENT '退票状态',
    refundAmount DECIMAL(10,2) NOT NULL COMMENT '退款金额',
    fee DECIMAL(10,2) NOT NULL COMMENT '手续费',
    processTime DATETIME COMMENT '处理时间',
    processorId BIGINT COMMENT '处理人ID',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (refundId, applyTime),
    KEY idx_booking_id (bookingId),
    KEY idx_processor_id (processorId),
    KEY idx_apply_time (applyTime),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='退票信息表'
PARTITION BY RANGE (TO_DAYS(applyTime)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);

-- 创建支付信息表
CREATE TABLE IF NOT EXISTS payment (
    paymentId BIGINT NOT NULL COMMENT '支付ID',
    bookingId BIGINT NOT NULL COMMENT '订单ID',
    paymentMethod VARCHAR(50) NOT NULL COMMENT '支付方式',
    amount DECIMAL(10,2) NOT NULL COMMENT '支付金额',
    paymentTime DATETIME NOT NULL COMMENT '支付时间',
    status INT NOT NULL COMMENT '支付状态',
    transactionNumber VARCHAR(100) NOT NULL COMMENT '交易流水号',
    refundStatus INT DEFAULT 0 COMMENT '退款状态',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (paymentId, paymentTime),
    UNIQUE KEY uk_transaction (transactionNumber, paymentTime),
    KEY idx_booking_id (bookingId),
    KEY idx_payment_time (paymentTime),
    KEY idx_status (status, refundStatus)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付信息表'
PARTITION BY RANGE (TO_DAYS(paymentTime)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);

-- 创建数据字典表
CREATE TABLE IF NOT EXISTS dict (
    dictId BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '字典ID',
    dictType VARCHAR(50) NOT NULL COMMENT '字典类型',
    dictCode VARCHAR(50) NOT NULL COMMENT '字典编码',
    dictValue VARCHAR(100) NOT NULL COMMENT '字典值',
    sortOrder INT DEFAULT 0 COMMENT '排序',
    status VARCHAR(20) DEFAULT 'ENABLE' COMMENT '状态',
    remark VARCHAR(200) COMMENT '备注',
    createTime DATETIME NOT NULL COMMENT '创建时间',
    updateTime DATETIME NOT NULL COMMENT '更新时间',
    UNIQUE KEY uk_type_code (dictType, dictCode),
    KEY idx_type (dictType)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据字典表';

-- 创建审计日志表
CREATE TABLE IF NOT EXISTS auditLog (
    logId BIGINT NOT NULL COMMENT '日志ID',
    userId BIGINT COMMENT '操作用户ID',
    operationType VARCHAR(50) NOT NULL COMMENT '操作类型',
    targetType VARCHAR(50) NOT NULL COMMENT '操作对象类型',
    targetId VARCHAR(50) NOT NULL COMMENT '操作对象ID',
    content TEXT COMMENT '操作内容',
    ipAddress VARCHAR(50) COMMENT 'IP地址',
    operationTime DATETIME NOT NULL COMMENT '操作时间',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (logId, operationTime),
    KEY idx_user (userId),
    KEY idx_operation (operationTime)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审计日志表'
PARTITION BY RANGE (TO_DAYS(operationTime)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);

-- 创建用户表
CREATE TABLE IF NOT EXISTS user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户昵称',
    userAccount VARCHAR(50) NOT NULL COMMENT '用户账号',
    avatar VARCHAR(255) COMMENT '用户头像',
    gender INT DEFAULT 0 COMMENT '性别 0-未知 1-男 2-女',
    userPassword VARCHAR(100) NOT NULL COMMENT '密码',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    userStatus INT DEFAULT 0 COMMENT '用户状态 0-正常 1-禁用',
    userRole INT DEFAULT 0 COMMENT '用户角色 0-普通用户 1-管理员',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    isDelete INT DEFAULT 0 COMMENT '是否删除 0-未删除 1-已删除',
    UNIQUE KEY uk_user_account (userAccount),
    KEY idx_username (username),
    KEY idx_phone (phone),
    KEY idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 创建角色表
CREATE TABLE IF NOT EXISTS role (
    roleId BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色ID',
    roleName VARCHAR(50) NOT NULL COMMENT '角色名称',
    roleCode VARCHAR(50) NOT NULL COMMENT '角色编码',
    roleDesc VARCHAR(200) COMMENT '角色描述',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    status INT DEFAULT 1 COMMENT '状态 1-启用 0-禁用',
    isDelete INT DEFAULT 0 COMMENT '是否删除 0-未删除 1-已删除',
    UNIQUE KEY uk_role_code (roleCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 创建用户角色关联表
CREATE TABLE IF NOT EXISTS userRole (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    userId BIGINT NOT NULL COMMENT '用户ID',
    roleId BIGINT NOT NULL COMMENT '角色ID',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    createBy BIGINT NOT NULL COMMENT '创建人',
    UNIQUE KEY uk_user_role (userId, roleId),
    KEY idx_role_id (roleId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 创建权限表
CREATE TABLE IF NOT EXISTS permission (
    permissionId BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '权限ID',
    permissionName VARCHAR(50) NOT NULL COMMENT '权限名称',
    permissionCode VARCHAR(50) NOT NULL COMMENT '权限编码',
    permissionType INT NOT NULL COMMENT '权限类型 1-菜单 2-按钮 3-接口',
    parentId BIGINT DEFAULT 0 COMMENT '父权限ID',
    path VARCHAR(200) COMMENT '路径',
    component VARCHAR(200) COMMENT '前端组件',
    icon VARCHAR(100) COMMENT '图标',
    sortOrder INT DEFAULT 0 COMMENT '排序',
    status INT DEFAULT 1 COMMENT '状态 1-启用 0-禁用',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updateTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    isDelete INT DEFAULT 0 COMMENT '是否删除 0-未删除 1-已删除',
    UNIQUE KEY uk_permission_code (permissionCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 创建角色权限关联表
CREATE TABLE IF NOT EXISTS rolePermission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    roleId BIGINT NOT NULL COMMENT '角色ID',
    permissionId BIGINT NOT NULL COMMENT '权限ID',
    createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    createBy BIGINT NOT NULL COMMENT '创建人',
    UNIQUE KEY uk_role_permission (roleId, permissionId),
    KEY idx_permission_id (permissionId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 初始化角色数据
INSERT INTO role (roleName, roleCode, roleDesc, createTime, updateTime, status) VALUES
('普通用户', 'ROLE_USER', '系统普通用户', NOW(), NOW(), 1),
('系统管理员', 'ROLE_ADMIN', '系统管理员', NOW(), NOW(), 1);

-- 初始化基础权限数据
INSERT INTO permission (permissionName, permissionCode, permissionType, parentId, path, component, icon, sortOrder, status, createTime, updateTime) VALUES
-- 用户管理
('用户管理', 'system:user:list', 1, 0, '/system/user', 'system/user/index', 'user', 1, 1, NOW(), NOW()),
('用户新增', 'system:user:add', 2, 1, NULL, NULL, NULL, 1, 1, NOW(), NOW()),
('用户编辑', 'system:user:edit', 2, 1, NULL, NULL, NULL, 2, 1, NOW(), NOW()),
('用户删除', 'system:user:delete', 2, 1, NULL, NULL, NULL, 3, 1, NOW(), NOW()),
-- 角色管理
('角色管理', 'system:role:list', 1, 0, '/system/role', 'system/role/index', 'role', 2, 1, NOW(), NOW()),
('角色新增', 'system:role:add', 2, 5, NULL, NULL, NULL, 1, 1, NOW(), NOW()),
('角色编辑', 'system:role:edit', 2, 5, NULL, NULL, NULL, 2, 1, NOW(), NOW()),
('角色删除', 'system:role:delete', 2, 5, NULL, NULL, NULL, 3, 1, NOW(), NOW()),
-- 权限管理
('权限管理', 'system:permission:list', 1, 0, '/system/permission', 'system/permission/index', 'permission', 3, 1, NOW(), NOW()),
('权限新增', 'system:permission:add', 2, 9, NULL, NULL, NULL, 1, 1, NOW(), NOW()),
('权限编辑', 'system:permission:edit', 2, 9, NULL, NULL, NULL, 2, 1, NOW(), NOW()),
('权限删除', 'system:permission:delete', 2, 9, NULL, NULL, NULL, 3, 1, NOW(), NOW()); 