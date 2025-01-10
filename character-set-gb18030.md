---
title: GB18030
summary: 本文介绍 TiDB 对 GB18030 字符集的支持情况。
---

# GB18030

TiDB 从 v9.0.0 开始支持 GB18030-2022 字符集。本文档介绍 TiDB 对 GB18030 字符集的支持和兼容情况。

```sql
SHOW CHARACTER SET WHERE CHARSET = 'gb18030';
```

```
+---------+---------------------------------+--------------------+--------+
| Charset | Description                     | Default collation  | Maxlen |
+---------+---------------------------------+--------------------+--------+
| gb18030 | China National Standard GB18030 | gb18030_chinese_ci |      4 |
+---------+---------------------------------+--------------------+--------+
1 row in set (0.01 sec)
```

```
SHOW COLLATION WHERE CHARSET = 'gb18030';
```

```
+-------------+---------+-----+---------+----------+---------+---------------+
| Collation   | Charset | Id  | Default | Compiled | Sortlen | Pad_attribute |
+-------------+---------+-----+---------+----------+---------+---------------+
| gb18030_bin | gb18030 | 249 | Yes     | Yes      |       1 | PAD SPACE     |
+-------------+---------+-----+---------+----------+---------+---------------+
1 row in set (0.00 sec)
```

## 与 MySQL 的兼容性

本节介绍 TiDB 中 GB18030 字符集与 MySQL 的兼容情况。

### 排序规则兼容性

TiDB 和 MySQL 在 `gb18030` 字符集的默认排序规则上存在差异，具体如下：

- TiDB 的 `gb18030` 字符集的默认排序规则为 `gb18030_bin`。
- MySQL 的 `gb18030` 字符集的默认排序规则为 `gb18030_chinese_ci`。
- TiDB 支持的 `gb18030_bin` 与 MySQL 支持的 `gb18030_bin` 排序规则实现不同，TiDB 通过将 `gb18030` 字符集转换为 `utf8mb4` 然后进行二进制排序。

如果要使 TiDB 兼容 MySQL GB18030 字符集的排序规则，你需要在首次初始化 TiDB 集群时，将 TiDB 配置项 [`new_collations_enabled_on_first_bootstrap`](/tidb-configuration-file.md#new_collations_enabled_on_first_bootstrap) 设置为 `true` 来开启[新的排序规则框架](/character-set-and-collation.md#新框架下的排序规则支持)。开启新的排序规则框架后，查看 GB18030 字符集对应的排序规则，可以看到 TiDB GB18030 默认排序规则已经切换为 `gb18030_chinese_ci`。

```sql
SHOW CHARACTER SET WHERE CHARSET = 'gb18030';
```

```
+---------+---------------------------------+--------------------+--------+
| Charset | Description                     | Default collation  | Maxlen |
+---------+---------------------------------+--------------------+--------+
| gb18030 | China National Standard GB18030 | gb18030_chinese_ci |      4 |
+---------+---------------------------------+--------------------+--------+
1 row in set (0.01 sec)
```

```
SHOW COLLATION WHERE CHARSET = 'gb18030';
```

```
+--------------------+---------+-----+---------+----------+---------+---------------+
| Collation          | Charset | Id  | Default | Compiled | Sortlen | Pad_attribute |
+--------------------+---------+-----+---------+----------+---------+---------------+
| gb18030_bin        | gb18030 | 249 |         | Yes      |       1 | PAD SPACE     |
| gb18030_chinese_ci | gb18030 | 248 | Yes     | Yes      |       1 | PAD SPACE     |
+--------------------+---------+-----+---------+----------+---------+---------------+
2 rows in set (0.00 sec)
```

### 非法字符兼容性

* 如果系统变量 [`character_set_client`](/system-variables.md#character_set_client) 和 [`character_set_connection`](/system-variables.md#character_set_connection) 没有同时设置为 `gb18030`，TiDB 处理非法字符的方式与 MySQL 一致。
* 如果系统变量 `character_set_client` 和 `character_set_connection` 同时设置为 `gb18030`，TiDB 处理非法字符的方式与 MySQL 有如下区别：

    - MySQL 处理非法 GB18030 字符集时，对读和写操作的处理方式不同。
    - TiDB 处理非法 GB18030 字符集时，对读和写操作的处理方式相同。TiDB 在严格模式下读写非法 GB18030 字符都会报错；在非严格模式下，读写非法 GB18030 字符都会用 `?` 替换。