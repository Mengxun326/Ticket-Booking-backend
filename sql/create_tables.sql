-- 创建数据库
CREATE DATABASE IF NOT EXISTS ticket_booking DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ticket_booking;

-- 创建旅客信息表
CREATE TABLE IF NOT EXISTS t_passenger (
    passenger_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '旅客ID',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    id_type VARCHAR(20) NOT NULL COMMENT '证件类型',
    id_number VARCHAR(50) NOT NULL COMMENT '证件号码',
    phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    email VARCHAR(100) COMMENT '电子邮箱',
    member_level VARCHAR(20) DEFAULT 'NORMAL' COMMENT '会员等级',
    member_points INT DEFAULT 0 COMMENT '会员积分',
    register_time DATETIME NOT NULL COMMENT '注册时间',
    update_time DATETIME NOT NULL COMMENT '最后更新时间',
    UNIQUE KEY uk_id_number (id_type, id_number),
    KEY idx_phone (phone),
    KEY idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='旅客信息表';

-- 创建航班信息表
CREATE TABLE IF NOT EXISTS t_flight (
    flight_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '航班ID',
    flight_number VARCHAR(20) NOT NULL COMMENT '航班号',
    airline VARCHAR(50) NOT NULL COMMENT '航空公司',
    departure_city VARCHAR(50) NOT NULL COMMENT '出发城市',
    arrival_city VARCHAR(50) NOT NULL COMMENT '到达城市',
    departure_airport VARCHAR(100) NOT NULL COMMENT '出发机场',
    arrival_airport VARCHAR(100) NOT NULL COMMENT '到达机场',
    departure_time DATETIME NOT NULL COMMENT '计划起飞时间',
    arrival_time DATETIME NOT NULL COMMENT '计划到达时间',
    status VARCHAR(20) NOT NULL COMMENT '航班状态',
    aircraft_type VARCHAR(50) NOT NULL COMMENT '机型',
    total_seats INT NOT NULL COMMENT '总座位数',
    UNIQUE KEY uk_flight_number (flight_number, departure_time),
    KEY idx_departure (departure_city, departure_time),
    KEY idx_arrival (arrival_city, arrival_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='航班信息表';

-- 创建舱位信息表
CREATE TABLE IF NOT EXISTS t_cabin (
    cabin_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '舱位ID',
    flight_id BIGINT NOT NULL COMMENT '航班ID',
    cabin_class VARCHAR(20) NOT NULL COMMENT '舱位等级',
    seat_count INT NOT NULL COMMENT '座位数量',
    base_price DECIMAL(10,2) NOT NULL COMMENT '基础价格',
    available_seats INT NOT NULL COMMENT '剩余座位数',
    seat_layout TEXT COMMENT '座位布局',
    FOREIGN KEY (flight_id) REFERENCES t_flight(flight_id),
    UNIQUE KEY uk_flight_cabin (flight_id, cabin_class)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='舱位信息表';

-- 创建折扣信息表
CREATE TABLE IF NOT EXISTS t_discount (
    discount_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '折扣ID',
    discount_type VARCHAR(50) NOT NULL COMMENT '折扣类型',
    discount_name VARCHAR(100) NOT NULL COMMENT '折扣名称',
    discount_rate DECIMAL(4,2) NOT NULL COMMENT '折扣率',
    conditions TEXT COMMENT '使用条件',
    start_time DATETIME NOT NULL COMMENT '开始时间',
    end_time DATETIME NOT NULL COMMENT '结束时间',
    applicable_routes TEXT COMMENT '适用航线',
    applicable_cabins VARCHAR(100) COMMENT '适用舱位',
    status VARCHAR(20) NOT NULL COMMENT '状态',
    KEY idx_time_range (start_time, end_time),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='折扣信息表';

-- 创建订票信息表
CREATE TABLE IF NOT EXISTS t_booking (
    booking_id BIGINT NOT NULL COMMENT '订单ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    passenger_id BIGINT NOT NULL COMMENT '旅客ID',
    flight_id BIGINT NOT NULL COMMENT '航班ID',
    cabin_id BIGINT NOT NULL COMMENT '舱位ID',
    seat_number VARCHAR(10) COMMENT '座位号',
    booking_time DATETIME NOT NULL COMMENT '订票时间',
    order_status TINYINT NOT NULL COMMENT '订单状态',
    payment_status TINYINT NOT NULL COMMENT '支付状态',
    ticket_price DECIMAL(10,2) NOT NULL COMMENT '票价',
    actual_payment DECIMAL(10,2) NOT NULL COMMENT '实付金额',
    discount_id BIGINT COMMENT '使用折扣ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (booking_id, booking_time),
    KEY idx_user_id (user_id),
    KEY idx_passenger_id (passenger_id),
    KEY idx_flight_id (flight_id),
    KEY idx_cabin_id (cabin_id),
    KEY idx_discount_id (discount_id),
    KEY idx_booking_time (booking_time),
    KEY idx_status (order_status, payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订票信息表'
PARTITION BY RANGE (TO_DAYS(booking_time)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);

-- 创建退票信息表
CREATE TABLE IF NOT EXISTS t_refund (
    refund_id BIGINT NOT NULL COMMENT '退票ID',
    booking_id BIGINT NOT NULL COMMENT '订单ID',
    apply_time DATETIME NOT NULL COMMENT '申请时间',
    reason TEXT COMMENT '退票原因',
    status TINYINT NOT NULL COMMENT '退票状态',
    refund_amount DECIMAL(10,2) NOT NULL COMMENT '退款金额',
    fee DECIMAL(10,2) NOT NULL COMMENT '手续费',
    process_time DATETIME COMMENT '处理时间',
    processor_id BIGINT COMMENT '处理人ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (refund_id, apply_time),
    KEY idx_booking_id (booking_id),
    KEY idx_processor_id (processor_id),
    KEY idx_apply_time (apply_time),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='退票信息表'
PARTITION BY RANGE (TO_DAYS(apply_time)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);

-- 创建支付信息表
CREATE TABLE IF NOT EXISTS t_payment (
    payment_id BIGINT NOT NULL COMMENT '支付ID',
    booking_id BIGINT NOT NULL COMMENT '订单ID',
    payment_method VARCHAR(50) NOT NULL COMMENT '支付方式',
    amount DECIMAL(10,2) NOT NULL COMMENT '支付金额',
    payment_time DATETIME NOT NULL COMMENT '支付时间',
    status TINYINT NOT NULL COMMENT '支付状态',
    transaction_number VARCHAR(100) NOT NULL COMMENT '交易流水号',
    refund_status TINYINT DEFAULT 0 COMMENT '退款状态',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (payment_id, payment_time),
    UNIQUE KEY uk_transaction (transaction_number, payment_time),
    KEY idx_booking_id (booking_id),
    KEY idx_payment_time (payment_time),
    KEY idx_status (status, refund_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付信息表'
PARTITION BY RANGE (TO_DAYS(payment_time)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);

-- 创建数据字典表
CREATE TABLE IF NOT EXISTS t_dict (
    dict_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '字典ID',
    dict_type VARCHAR(50) NOT NULL COMMENT '字典类型',
    dict_code VARCHAR(50) NOT NULL COMMENT '字典编码',
    dict_value VARCHAR(100) NOT NULL COMMENT '字典值',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status VARCHAR(20) DEFAULT 'ENABLE' COMMENT '状态',
    remark VARCHAR(200) COMMENT '备注',
    create_time DATETIME NOT NULL COMMENT '创建时间',
    update_time DATETIME NOT NULL COMMENT '更新时间',
    UNIQUE KEY uk_type_code (dict_type, dict_code),
    KEY idx_type (dict_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据字典表';

-- 初始化数据字典
INSERT INTO t_dict (dict_type, dict_code, dict_value, sort_order, status, remark, create_time, update_time) VALUES
-- 证件类型
('ID_TYPE', 'IDENTITY_CARD', '身份证', 1, 'ENABLE', '中国居民身份证', NOW(), NOW()),
('ID_TYPE', 'PASSPORT', '护照', 2, 'ENABLE', '护照', NOW(), NOW()),
-- 会员等级
('MEMBER_LEVEL', 'NORMAL', '普通会员', 1, 'ENABLE', '普通会员', NOW(), NOW()),
('MEMBER_LEVEL', 'SILVER', '白银会员', 2, 'ENABLE', '白银会员', NOW(), NOW()),
('MEMBER_LEVEL', 'GOLD', '黄金会员', 3, 'ENABLE', '黄金会员', NOW(), NOW()),
('MEMBER_LEVEL', 'PLATINUM', '铂金会员', 4, 'ENABLE', '铂金会员', NOW(), NOW()),
-- 航班状态
('FLIGHT_STATUS', 'SCHEDULED', '计划', 1, 'ENABLE', '航班计划', NOW(), NOW()),
('FLIGHT_STATUS', 'BOARDING', '登机中', 2, 'ENABLE', '正在登机', NOW(), NOW()),
('FLIGHT_STATUS', 'DEPARTED', '已起飞', 3, 'ENABLE', '航班已起飞', NOW(), NOW()),
('FLIGHT_STATUS', 'ARRIVED', '已到达', 4, 'ENABLE', '航班已到达', NOW(), NOW()),
('FLIGHT_STATUS', 'CANCELLED', '已取消', 5, 'ENABLE', '航班取消', NOW(), NOW()),
-- 舱位等级
('CABIN_CLASS', 'ECONOMY', '经济舱', 1, 'ENABLE', '经济舱', NOW(), NOW()),
('CABIN_CLASS', 'BUSINESS', '商务舱', 2, 'ENABLE', '商务舱', NOW(), NOW()),
('CABIN_CLASS', 'FIRST', '头等舱', 3, 'ENABLE', '头等舱', NOW(), NOW()),
-- 订单状态
('ORDER_STATUS', 'PENDING_PAYMENT', '待支付', 1, 'ENABLE', '订单待支付', NOW(), NOW()),
('ORDER_STATUS', 'PAID', '已支付', 2, 'ENABLE', '订单已支付', NOW(), NOW()),
('ORDER_STATUS', 'COMPLETED', '已完成', 3, 'ENABLE', '订单已完成', NOW(), NOW()),
('ORDER_STATUS', 'CANCELLED', '已取消', 4, 'ENABLE', '订单已取消', NOW(), NOW()),
-- 支付状态
('PAYMENT_STATUS', 'PENDING', '待支付', 1, 'ENABLE', '待支付', NOW(), NOW()),
('PAYMENT_STATUS', 'SUCCESS', '支付成功', 2, 'ENABLE', '支付成功', NOW(), NOW()),
('PAYMENT_STATUS', 'FAILED', '支付失败', 3, 'ENABLE', '支付失败', NOW(), NOW()),
('PAYMENT_STATUS', 'REFUNDED', '已退款', 4, 'ENABLE', '已退款', NOW(), NOW()),
-- 退票状态
('REFUND_STATUS', 'PENDING', '待处理', 1, 'ENABLE', '退票申请待处理', NOW(), NOW()),
('REFUND_STATUS', 'PROCESSING', '处理中', 2, 'ENABLE', '退票处理中', NOW(), NOW()),
('REFUND_STATUS', 'COMPLETED', '已完成', 3, 'ENABLE', '退票已完成', NOW(), NOW()),
('REFUND_STATUS', 'REJECTED', '已拒绝', 4, 'ENABLE', '退票申请被拒绝', NOW(), NOW()),
-- 性别
('GENDER', 'UNKNOWN', '未知', 1, 'ENABLE', '性别未知', NOW(), NOW()),
('GENDER', 'MALE', '男', 2, 'ENABLE', '男性', NOW(), NOW()),
('GENDER', 'FEMALE', '女', 3, 'ENABLE', '女性', NOW(), NOW()),
-- 用户状态
('USER_STATUS', 'NORMAL', '正常', 1, 'ENABLE', '正常状态', NOW(), NOW()),
('USER_STATUS', 'DISABLED', '禁用', 2, 'ENABLE', '禁用状态', NOW(), NOW()),
-- 用户角色
('USER_ROLE', 'USER', '普通用户', 1, 'ENABLE', '普通用户', NOW(), NOW()),
('USER_ROLE', 'ADMIN', '管理员', 2, 'ENABLE', '系统管理员', NOW(), NOW());

-- 创建审计日志表
CREATE TABLE IF NOT EXISTS t_audit_log (
    log_id BIGINT NOT NULL COMMENT '日志ID',
    user_id BIGINT COMMENT '操作用户ID',
    operation_type VARCHAR(50) NOT NULL COMMENT '操作类型',
    target_type VARCHAR(50) NOT NULL COMMENT '操作对象类型',
    target_id VARCHAR(50) NOT NULL COMMENT '操作对象ID',
    content TEXT COMMENT '操作内容',
    ip_address VARCHAR(50) COMMENT 'IP地址',
    operation_time DATETIME NOT NULL COMMENT '操作时间',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (log_id, operation_time),
    KEY idx_user (user_id),
    KEY idx_operation (operation_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审计日志表'
PARTITION BY RANGE (TO_DAYS(operation_time)) (
    PARTITION p_2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p_2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p_2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);

-- 创建用户表
CREATE TABLE IF NOT EXISTS t_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户昵称',
    user_account VARCHAR(50) NOT NULL COMMENT '用户账号',
    avatar VARCHAR(255) COMMENT '用户头像',
    gender TINYINT DEFAULT 0 COMMENT '性别 0-未知 1-男 2-女',
    user_password VARCHAR(100) NOT NULL COMMENT '密码',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    user_status TINYINT DEFAULT 0 COMMENT '用户状态 0-正常 1-禁用',
    user_role TINYINT DEFAULT 0 COMMENT '用户角色 0-普通用户 1-管理员',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete TINYINT DEFAULT 0 COMMENT '是否删除 0-未删除 1-已删除',
    UNIQUE KEY uk_user_account (user_account),
    KEY idx_username (username),
    KEY idx_phone (phone),
    KEY idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 创建角色表
CREATE TABLE IF NOT EXISTS t_role (
    role_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色ID',
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL COMMENT '角色编码',
    role_desc VARCHAR(200) COMMENT '角色描述',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    status TINYINT DEFAULT 1 COMMENT '状态 1-启用 0-禁用',
    is_delete TINYINT DEFAULT 0 COMMENT '是否删除 0-未删除 1-已删除',
    UNIQUE KEY uk_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 创建用户角色关联表
CREATE TABLE IF NOT EXISTS t_user_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_by BIGINT NOT NULL COMMENT '创建人',
    UNIQUE KEY uk_user_role (user_id, role_id),
    KEY idx_role_id (role_id),
    FOREIGN KEY (user_id) REFERENCES t_user(id),
    FOREIGN KEY (role_id) REFERENCES t_role(role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 创建权限表
CREATE TABLE IF NOT EXISTS t_permission (
    permission_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '权限ID',
    permission_name VARCHAR(50) NOT NULL COMMENT '权限名称',
    permission_code VARCHAR(50) NOT NULL COMMENT '权限编码',
    permission_type TINYINT NOT NULL COMMENT '权限类型 1-菜单 2-按钮 3-接口',
    parent_id BIGINT DEFAULT 0 COMMENT '父权限ID',
    path VARCHAR(200) COMMENT '路径',
    component VARCHAR(200) COMMENT '前端组件',
    icon VARCHAR(100) COMMENT '图标',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态 1-启用 0-禁用',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete TINYINT DEFAULT 0 COMMENT '是否删除 0-未删除 1-已删除',
    UNIQUE KEY uk_permission_code (permission_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 创建角色权限关联表
CREATE TABLE IF NOT EXISTS t_role_permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    permission_id BIGINT NOT NULL COMMENT '权限ID',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_by BIGINT NOT NULL COMMENT '创建人',
    UNIQUE KEY uk_role_permission (role_id, permission_id),
    KEY idx_permission_id (permission_id),
    FOREIGN KEY (role_id) REFERENCES t_role(role_id),
    FOREIGN KEY (permission_id) REFERENCES t_permission(permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 初始化角色数据
INSERT INTO t_role (role_name, role_code, role_desc, create_time, update_time, status) VALUES
('普通用户', 'ROLE_USER', '系统普通用户', NOW(), NOW(), 1),
('系统管理员', 'ROLE_ADMIN', '系统管理员', NOW(), NOW(), 1);

-- 初始化基础权限数据
INSERT INTO t_permission (permission_name, permission_code, permission_type, parent_id, path, component, icon, sort_order, status, create_time, update_time) VALUES
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