# WatchCart — Java Online Watch Shopping Website

A full-stack Spring Boot e-commerce application for buying luxury and everyday watches online, backed by a PostgreSQL database.

---

## Tech Stack

| Layer      | Technology                            |
|------------|---------------------------------------|
| Backend    | Java 11 · Spring Boot 2.7 · Spring MVC |
| Security   | Spring Security 5 (BCrypt)            |
| ORM        | Spring Data JPA · Hibernate           |
| Database   | MySQL 8+                              |
| Templates  | Thymeleaf 3 + Bootstrap 5             |
| Build      | Maven 3.8+                            |

---

## Quick Start

### 1. Prerequisites

- Java 11+
- Maven 3.8+
- MySQL 8+ running locally

### 2. Import Database

```bash
# Creates watchcart_db, tables, categories, 20 watch products, sample users & orders
mysql -u root -p < sql/watchcart_db.sql
```

### 3. Configure Database Credentials

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/watchcart_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=root
```

### 4. Run the Application

```bash
mvn spring-boot:run
```

Open **http://localhost:8080**

---

## Seeded Accounts

| Role  | Email                   | Password   |
|-------|-------------------------|------------|
| Admin | admin@watchcart.com     | Admin@1234 |
| User  | dhaval@example.com      | Test@1234  |
| User  | priya@example.com       | Test@1234  |
| User  | rajan@example.com       | Test@1234  |

---

## Project Structure

```
src/main/java/com/watchcart/
├── WatchCartApplication.java
├── config/
│   └── SecurityConfig.java
├── controller/
│   ├── HomeController.java
│   ├── ProductController.java
│   ├── CartController.java
│   ├── OrderController.java
│   └── UserController.java
├── model/
│   ├── User.java · Category.java · Product.java
│   ├── Cart.java · CartItem.java
│   └── Order.java · OrderItem.java
├── repository/          ← Spring Data JPA interfaces
└── service/             ← Business logic

src/main/resources/
├── application.properties
├── templates/           ← Thymeleaf HTML pages
└── static/css/style.css

sql/watchcart_db.sql     ← Full DB schema + seed data
```

---

## Features

- Browse & search watches with pagination
- Category filtering
- Product detail page with specs & related items
- User registration & login (Spring Security)
- Shopping cart (add, update quantity, remove)
- Checkout & order placement
- Order history & detail view
- User profile management
- Admin role (extend via `/admin/**` routes)

---

## ⚠️ Security Notice — Vulnerable Dependencies

This project intentionally includes **known-vulnerable** dependency versions for **educational / security-lab use**.  
**Do NOT deploy to production.**

| Dependency                  | Version    | CVE                | CVSS  | Description                          |
|-----------------------------|------------|--------------------|-------|--------------------------------------|
| `log4j-core`                | 2.14.1     | CVE-2021-44228     | 10.0  | Log4Shell — JNDI RCE via log messages |
| `commons-collections`       | 3.2.1      | CVE-2015-6420      | 9.8   | Java deserialization gadget chain RCE |
| `jackson-databind`          | 2.9.8      | CVE-2019-14379     | 9.8   | Polymorphic deserialization RCE       |
| `spring-webmvc`             | 5.3.17     | CVE-2022-22965     | 9.8   | Spring4Shell — data binding RCE       |
| `spring-security-core`      | 5.3.8      | CVE-2021-22112     | 8.8   | Privilege escalation                  |

To scan vulnerabilities locally:

```bash
mvn org.owasp:dependency-check-maven:check
```
