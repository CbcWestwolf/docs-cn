---
title: TiCDC Server 配置
summary: 了解 TiCDC 详细的命令行参数和配置文件定义。
---

# TiCDC Server 配置

本文介绍 TiCDC 的命令行参数和配置文件定义。

## `cdc server` 命令行参数说明

对于 `cdc server` 命令中可用选项解释如下：

- `addr`：TiCDC 的监听地址，提供服务的 HTTP API 查询地址和 Prometheus 查询地址，默认为 `127.0.0.1:8300`。
- `advertise-addr`：TiCDC 对外开放地址，供客户端访问。如果未设置该参数值，地址默认与 `addr` 相同。
- `pd`：TiCDC 监听的 PD 节点地址，用 `,` 来分隔多个 PD 节点地址。
- `config`：可选项，表示 TiCDC 使用的配置文件地址。TiCDC 从 v5.0.0 开始支持该选项，TiUP 从 v1.4.0 开始支持在部署 TiCDC 时使用该配置。配置文件的格式说明详见：[TiCDC Changefeed 配置参数](/ticdc/ticdc-changefeed-config.md)
- `data-dir`：指定 TiCDC 使用磁盘储存文件时的目录。目前 TiCDC 内部的排序引擎和 redo log 等特性会使用该目录储存临时文件，建议确保该目录所在设备的可用空间大于等于 500 GiB。如果你使用 TiUP，本选项可以通过配置 [`cdc_servers`](/tiup/tiup-cluster-topology-reference.md#cdc_servers) 中的 `data_dir` 来指定或默认使用 `global` 中 `data_dir` 路径。
- `gc-ttl`：TiCDC 在 PD 设置的服务级别 GC safepoint 的 TTL (Time To Live) 时长，和 TiCDC 同步任务所能够停滞的时长。单位为秒，默认值为 `86400`，即 24 小时。注意：TiCDC 同步任务的停滞会影响 TiCDC GC safepoint 的推进，即会影响上游 TiDB GC 的推进，详情可以参考 [TiCDC GC safepoint 的完整行为](/ticdc/ticdc-faq.md#ticdc-gc-safepoint-的完整行为是什么)。
- `log-file`：TiCDC 进程运行时日志的输出地址，未设置时默认为标准输出 (stdout)。
- `log-level`：TiCDC 进程运行时的日志级别，默认为 `"info"`。
- `ca`：TiCDC 创建 TLS 连接时使用的 CA 证书文件路径，PEM 格式，可选。
- `cert`：TiCDC 创建 TLS 连接时使用的证书文件路径，PEM 格式，可选。
- `cert-allowed-cn`：TiCDC 创建 TLS 连接时使用的通用名称文件路径，可选。
- `key`：TiCDC 创建 TLS 连接时使用的证书密钥文件路径，PEM 格式，可选。
- `tz`：TiCDC 服务使用的时区。TiCDC 在内部转换 `TIMESTAMP` 等时间数据类型和向下游同步数据时使用该时区，默认为进程运行本地时区。（注意如果同时指定 `tz` 参数和 `sink-uri` 中的 `time-zone` 参数，TiCDC 进程内部使用 `tz` 指定的时区，sink 向下游执行时使用 `time-zone` 指定的时区，请保持二者一致。）
- `cluster-id`：TiCDC 集群的 ID。可选，默认值为 `default`。`cluster-id` 是 TiCDC 集群的唯一标识，拥有相同 `cluster-id` 的 TiCDC 节点同属一个集群。长度最大为 128，需要符合正则表达式 `^[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*$`，且不能是以下值：`owner`，`capture`，`task`，`changefeed`，`job`，`meta`。

## `cdc server` 配置文件说明

对于 `cdc server` 命令中 config 参数指定的配置文件说明如下：

```yaml
addr = "127.0.0.1:8300"
advertise-addr = ""
log-file = ""
log-level = "info"
data-dir = ""
gc-ttl = 86400 # 24 h
tz = "System"
cluster-id = "default"

[security]
  ca-path = ""
  cert-path = ""
  key-path = ""


capture-session-ttl = 10 # 10s
owner-flush-interval = 50000000 # 50 ms
processor-flush-interval = 50000000 # 50 ms
per-table-memory-quota = 10485760 # 10 MiB

[log]
  error-output = "stderr"
  [log.file]
    max-size = 300 # 300 MiB
    max-days = 0
    max-backups = 0


# [kv-client]
#   worker-concurrent = 8
#   worker-pool-size = 0
#   region-scan-limit = 40
#   region-retry-duration = 60000000000
```
