---
title: 'TiDB: lesson learned at ZaloPay'
excerpt: At ZaloPay, we use TiDB for almost significant service to store...
date: 2020-04-07T15:00:00+07:00
thumb_img_path: "/images/tidb.jpg"
template: post
subtitle: ''
content_img_path: ''
author: 'tantnd'

---

***

### Introduce ZaloPay

ZaloPay is a mobile payment application with use cases for daily life and business needs launched in 2017, relatively compare with the appearance of MoMo, GrabPay by Moca, ViettelPay,...

Similar to AliPay as one of three tenets of the “iron triangle” (the others being e-commerce and logistics). GrabPay as an enabler on the Grab ecosystem and WeChat Pay on a social media platform.

In turn, Zalo is a key product of the Vietnamese conglomerate VNG Coporation. ZaloPay is built on the top of [Zalo](https://zalo.me), the most popular messenger app in Vietnam which was launched in 2012, with > 100M active users nowaday at the time write this blog.

![ZaloPay](/images/zalopay.png)

ZaloPay ranked the 3rd payment application of the year at the 2018 Tech Awards ceremony held by [VnExpress)](https://vnexpress.vn) newspaper (The most common newspaper in Vietnam). While competitors MoMo took the top spot, followed by ViettelPay, in the recently time, the rising  reign of GrabPay by Moca, VinID powered by VinGroup, AirPay by SEA,... making the the game more intense.

***

### What is TiDB?

TiDB is developed and supported primarily by PingCAP, Inc. and licensed under Apache 2.0.

TiDB ("Ti" stands for Titanium) is an open-source NewSQL database that supports Hybrid Transactional and Analytical Processing (HTAP) workloads. It is MySQL compatible and features horizontal scalability, strong consistency, and high availability.

#### Horizontal Scalability

> TiDB expands both SQL processing and storage by simply adding new nodes. This makes infrastructure capacity planning both easier and more cost-effective than traditional relational databases which only scale vertically.

#### MySQL Compatible Syntax**

> TiDB acts like it is a MySQL 5.7 server to your applications. You can continue to use all of the existing MySQL client libraries, and in many cases, you will not need to change a single line of code in your application. Because TiDB is built from scratch, not a MySQL fork, please check out the list of known compatibility differences.

#### Distributed Transactions with Strong Consistency

> TiDB internally shards table into small range-based chunks that we refer to as "regions". Each region defaults to approximately 100MiB in size, and TiDB uses a Two-phase commit internally to ensure that regions are maintained in a transactionally consistent way.

#### Cloud Native

> TiDB is designed to work in the cloud -- public, private, or hybrid -- making deployment, provisioning, operations, and maintenance simple.
>The storage layer of TiDB, called TiKV, became a Cloud Native Computing Foundation member project in 2018. The architecture of the TiDB platform also allows SQL processing and storage to be scaled independently of each other in a very cloud-friendly manner.

#### Minimize ETL

> TiDB is designed to support both transaction processing (OLTP) and analytical processing (OLAP) workloads. This means that while you may have traditionally transacted on MySQL and then Extracted, Transformed and Loaded (ETL) data into a column store for analytical processing, this step is no longer required.

#### High Availability

> TiDB uses the Raft consensus algorithm to ensure that data is highly available and safely replicated throughout storage in Raft groups. In the event of failure, a Raft group will automatically elect a new leader for the failed member, and self-heal the TiDB cluster without any required manual intervention. Failure and self-healing operations are also transparent to applications.

***

### Why we choose TiDB over other db-engine?

Here is a comparison of the strongest candidate - MySQL - with TiDB (reference [**db-engines**](https://db-engines.com/))

***

<style>
    table {
        border-collapse: collapse;
        width: 100%;
    }
    table th:first-child, td:first-child {
        border-right: 1px solid #ccc;
    }
    td {
        border-top: 1px solid #ccc;
        padding: 0.6rem;
    }
</style>

**Name** | **MySQL** | **TiDB**
---|---|--
Description | Widely used open source RDBMS | TiDB is an open source distributed Hybrid Transactional/Analytical Processing (HTAP)database that supports MySQL and Spark SQLsyntaxes.
Primary database model | Realtional DBMS | Realtional DBMS
Secondary database models | Document store | Document store
Implementation language | C and C++ | Go, Rust
License | OpenSource | OpenSource
Server operating systems | FreeBSD, Linux, OS X, Solaris, Windows | Linux
Initial Release | 1995 | 2016
Developer | Oracle | PingCAP, Inc.
Data scheme | Yes | Yes
Typing | Yes | Yes
XML Support | Yes | No
Secondary indexes | Yes | Yes
SQL | Yes | Yes
APIs and other access methods | ADO.NET, JDBC, ODBC, Propritary native API | JDBC, ODBC, Proprietary protocol
Supported programming languages | Ada, C, C#, C++, D, Delphi, Eiffel, Erlang, Haskell, Java, JavaScript (Node.js), Objective-C, Ocaml,Perl, PHP, Python, Ruby, Scheme, TCL | Ada, C, C#, C++, D, Delphi, Eiffel, Erlang, Haskell, Java, JavaScript (Node.js), Objective-C, Ocaml, Perl, PHP, Python, Ruby, Scheme, TCL
Server-side scripts (Store procedure) | Yes | No
Trigger | Yes | No
Partitioning methods | horizontal partitioning, sharding with MySQL Cluster or MySQL Fabric | horizontal partitioning (by key range)
Replication methods  | Master-master replication, Master-slave replication | Using Raft consensus algorithm to ensure data replication with strong consistency among multiple replicas.
MapReduce | No | Yes
Consistency concepts | Immediate Consistency | Immediate Consistency
Foreign keys | Yes | No
Transaction concepts | ACID | ACID
Concurrency | Yes | Yes
Durability | Yes | Yes
In-memory capabilities | Yes | No
User concepts | Users with fine-grained authorization concept | Users with fine-grained authorization concept. No user groups or roles

***

Every products, services,... has their own specific requirement to develop. Since those figures above, we had discussed and then proposed to sort out TiDB.

***

### How does TiDB work?

It is undeniable that TiDB architecture have 4 main components

![TiDB Architecture](/images/tidb-architecture.png)

- **TiDB Server**: Sit on top of the construction, TiDB server have responsibility like the communication interface between user with the database engine server. *Receiving the SQL requests, Processing the SQL related logics, Locating the TiKV address for storing and computing data through Placement Driver (PD), Exchanging data with TiKV*
- **TiKV Server**: Like a heart, TiKV is a distributed transactional *Key-Value* engine that play a significant role in this - storing data. TiKV uses the Raft protocol for replication to ensure the data consistency and disaster recovery. Region is the basic unit to store data of TiKV
- **PD Server**: PD abbreviation for Placement Driver. By embedding etcd, using the Raft consensus algorithm, this is allows PD to support distribution and fault-tolerance, redundancy. PD play the role that storing metdata, scheduling & load-balancing, allocating the transaction ID.
- **TiSpark**: Is build for running Apache Spark on top of TiDB/TiKV. This layer provide a method to answer complex OLAP queries. With TiSpark, TiDB can intergrates with big data ecosystem, support OLTP, OLAP scenario.

***

### What TiDB can do on ZaloPay Platform infrastructure?

The E-Wallet gamming of all about the technologies giant is about to intensively more than ever before. We have to be careful in all of our decision to make our infrastructure become a example to following for other team, we have to give out many difficult decisions to make a lot of changes in the backend and infrastructure.

As our businesses are growing so fast day by day, we can easily spot that our infrastructure is the remarkable thing in the way of development. Luckily for us, almost the technical things in our architecture were carefully chosen from the very beginning. Take database systems for instance, we do not to migrate anyhtings from MySQL or whatever to the new database system.

While we're finding the solution for the explanation of database. We busted TiDB. Can easily turn out that how good in the the way of commitment, the way of interaction with each other of PingCAP team member, also TiDB is implemented by **Go** and **Rust** (matching with our product implementation languagues). We bet to choose TiDB for our database solution as a ventures.

At ZaloPay, we use TiDB as an core database for store almost of the payment transaction data, billing, config data, customer data,... of many services dots (such as billing, travelling, f&b interagtion,...). Currently, we have more than 20 nodes in our production system, storing many significant data.

Here is one of our cluster statistics

![TiDB Cluster Statistics](/images/sysinfo.png)

***

### Unique mistaken story while using TiDB

Since we're not having enough experiences in conserve and keep up with TiDB, a miscalculation had been occurred.
At our develop/sandbox/staging environment, some applications were granted permission to write data directly into TiKV cluster. As can illustrated, the application and TiDB are both writing data into TiKV cluster, mixed using like that **is not endorsed**. Other application could easily break TiDB data (called regions). Many regions has been shattered, then can not retrieve.

TiKV then goes into downright panic, TiDB server cann't reach to TiKV. We've try to recover it in many way but just can't. Then we're finding the way to reach to PingCAP Support Community. Thankfully, we've get very welcommed from PingCAP Community. I was introduced with TiDB VPE (Vice President of Engineering), many Senior Engineer of TiKV/TiDB Team... who will give a kindness help us in situation. PingCAP actually take every user’s data seriously! TiDB uses the transactional KV API. Use these two APIs together in the same cluster, otherwise they might corrupt each other’s data. Since this case, the VP Engineer said that they will provide mechanism to prevent user from mix-using the two APIs in single cluster in the future.

***

### Recommendation for other TiDB users

TiDB acts like it is a MySQL 5.7 server, support MySQL protocol, a majority of MySQL syntax. You can use all of the existing MySQL client libraries, and in many cases, you won't need to change a single line of code in your application

**But**, you're already know, "*act like*" isn't the same meaning as "*totally like*". Because TiDB is built from scratch, not a MySQL fork, for new user to TiDB, usually not read carefully the whole documentation, think TiDB syntax is completely like MySQL syntax. Sometimes, may meet some unexpected limitations with it when do some complexity queries , when use some interface tools for MySQL native like MySQL Workbench... or when try to backup and restore TiDB with mysqldump (which isn't recommended)... Should take a look around toolkits (Mydumper, Syncer, Loader, TiDB Lighting,...) that PingCAP optimized for TiDB.

**TL;DR**: TiDB server acts like MySQL 5.7 server, but not entirely equivalent with MySQL. Just make sure you know what are you doing when use tool or run SQL queries (which was downright run well with MySQL). [Check out the list of known compatibility differences](https://pingcap.com/docs/v3.0/reference/mysql-compatibility/).

***

### Postscript

At the present time, we're running TiDB and our other product on-premise (bare machine). In the future, we're planning to add more and more automation solutions for our product as it can catch up with the new technique trend as well as our business.

We would like to thank again PingCAP Community, who has wholeheartedly give a hand endeavor to tie up the knots we meet.

*This docs is refer to many original documentations from PingCAP, Wikipedia, db-engine,...*
