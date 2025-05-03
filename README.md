# 《Ticket-Booking-backend：Spring Boot 后端项目介绍与使用指南》

安徽理工大学信息安全 23-1 王智杰

## 项目简介

`Ticket-Booking-backend` 是一个使用 Spring Boot 构建的后端项目，提供了基本的用户信息管理和简单的 Web 服务接口。项目集成了 MyBatis 用于数据库操作，并通过 Maven 进行依赖管理。

## 环境要求

**Java**：JDK 1.8 及以上

**数据库**：MySQL

**开发工具**：推荐使用 IntelliJ IDEA 或 Eclipse

## 技术栈

**后端框架**：Spring Boot 2.6.13

**数据库访问**：MyBatis Spring Boot Starter 2.2.2

**数据库驱动**：MySQL Connector/J

**构建工具**：Maven

## 功能特性

**用户信息管理**：支持获取用户信息、保存用户信息。

**Web 服务接口**：提供多个 RESTful API 接口，方便前端调用。

**静态页面展示**：支持展示静态 HTML 页面。

## 项目结构



```
Ticket-Booking-backend/

├── src/

│   ├── main/

│   │   ├── java/

│   │   │   └── com/mengxun/ticketbookingbackend/

│   │   │       ├── demos/

│   │   │       │   └── web/

│   │   │       │       ├── BasicController.java    # 基本控制器，提供用户信息和静态页面接口

│   │   │       │       ├── PathVariableController.java # 路径变量控制器，提供带路径变量的接口

│   │   │       │       └── User.java               # 用户实体类

│   │   │       ├── mapper/

│   │   │       │   └── UserMapper.java             # 用户数据库操作 Mapper

│   │   │       ├── model/

│   │   │       │   └── domain/

│   │   │       │       └── User.java               # 用户实体类（数据库映射）

│   │   │       ├── service/

│   │   │       │   ├── UserService.java            # 用户数据库操作 Service 接口

│   │   │       │   └── impl/

│   │   │       │       └── UserServiceImpl.java    # 用户数据库操作 Service 实现

│   │   │       └── TicketBookingBackendApplication.java # 项目启动类

│   │   └── resources/

│   │       ├── static/

│   │       │   └── index.html    # 静态 HTML 页面

│   │       ├── generator/

│   │       │   └── mapper/

│   │       │       └── UserMapper.xml # MyBatis Mapper XML 文件

│   │       └── application.yml   # 项目配置文件

│   └── test/

│       └── java/

│           └── com/mengxun/ticketbookingbackend/

│               ├── service/

│               │   └── impl/

│               │       └── UserServiceImplTest.java # 用户服务测试类

│               └── TicketBookingBackendApplicationTests.java # 项目测试类

└── pom.xml # Maven 项目配置文件
```

## 配置步骤

### 数据库配置

在 `src/main/resources/application.yml` 文件中配置数据库连接信息：



```
spring:

&#x20; application:

&#x20;   name: ticket-booking

&#x20; datasource:

&#x20;   driver-class-name: com.mysql.cj.jdbc.Driver

&#x20;   url: jdbc:mysql://47.121.180.250:3306/ticket-booking

&#x20;   username: Ticket-Booking

&#x20;   password: S7HmK22NMYHynYKj

server:

&#x20; port: 8080

mybatis-plus:

&#x20; configuration:

&#x20;   map-underscore-to-camel-case: false
```

### MyBatis 配置

确保 `application.yml` 中的 MyBatis 配置正确。项目中使用了 MyBatis-Plus，相关配置已在 `application.yml` 中体现。

## 运行项目

### 克隆项目



```
git clone https://github.com/your-repo/Ticket-Booking-backend.git

cd Ticket-Booking-backend
```

### 构建项目



```
mvn clean install
```

### 启动项目



```
mvn spring-boot:run
```

项目启动后，访问 `http://127.0.0.1:8080` 即可看到相关服务。

## API 接口文档

### 1. 获取用户信息

**URL**：`http://127.0.0.1:8080/user`

**方法**：GET

**响应示例**：



```
{

&#x20;   "name": "theonefx",

&#x20;   "age": 666

}
```

### 2. 保存用户信息

**URL**：`http://127.0.0.1:8080/save_user?name=newName&age=11`

**方法**：GET

**响应示例**：



```
user will save: name=newName, age=11
```

### 3. 带路径变量的接口

**URL**：`http://127.0.0.1:8080/user/123/roles/222`

**方法**：GET

**响应示例**：



```
User Id : 123 Role Id : 222
```

### 4. 正则表达式路径变量接口

**URL**：`http://127.0.0.1:8080/javabeat/somewords`

**方法**：GET

**响应示例**：



```
URI Part : somewords
```

### 5. 静态页面接口

**URL**：`http://127.0.0.1:8080/html`

**方法**：GET

**响应**：返回 `src/main/resources/static/index.html` 页面内容。

## 贡献

如果你想为该项目做出贡献，请遵循以下步骤：

Fork 该项目。

创建一个新的分支：`git checkout -b feature/your-feature-name`。

提交你的更改：`git commit -m "Add some feature"`。

推送到你的分支：`git push origin feature/your-feature-name`。

发起一个 Pull Request。

## 许可证

本项目采用 [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) 许可证。