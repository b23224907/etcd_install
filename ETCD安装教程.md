# ETCD安装教程



## 1. 执行安装脚本

- 将etcd安装到/data/etcd目录

```sh
ETCD_VER=v3.5.8

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /data/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /data/etcd && mkdir -p /data/etcd

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /data/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /data/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /data/etcd --strip-components=1
rm -f /data/etcd-${ETCD_VER}-linux-amd64.tar.gz

/data/etcd/etcd --version
/data/etcd/etcdctl version
/data/etcd/etcdutl version
```



## 2. 配置环境变量

- 编辑 .bashrc文件

```bash
sudo vim ~/.bashrc
```

- 添加环境变量

```bash
export PATH="$PATH:/data/etcd"
```

- 立即生效

```bash
source ~/.bashrc
```

- 测试（在非etcd文件夹中测试）

```bash
etcd --version
etcdctl --endpoints=localhost:2379 put foo bar
etcdctl --endpoints=localhost:2379 get foo
```



## 3. 配置etcd服务

- 创建文件夹

```bash
mkdir /var/lib/etcd;mkdir /etc/etcd; groupadd -r etcd; useradd -r -g etcd -d /var/lib/etcd -s /sbin/nologin -c "etcd user" etcd;chown -R etcd:etcd /var/lib/etcd
```

- 创建etcd配置文件

```bash
vim /etc/etcd/etcd.conf
```

```bash
#[Member]
#ETCD_CORS=""
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="http://172.16.0.7:2379,http://127.0.0.1:2379"
ETCD_NAME="controller"
#ETCD_WAL_DIR=""
#ETCD_LISTEN_PEER_URLS="http://localhost:2380"
#ETCD_MAX_SNAPSHOTS="5"
#ETCD_MAX_WALS="5"
#ETCD_SNAPSHOT_COUNT="100000"
#ETCD_HEARTBEAT_INTERVAL="100"
#ETCD_ELECTION_TIMEOUT="1000"
#ETCD_QUOTA_BACKEND_BYTES="0"
#ETCD_MAX_REQUEST_BYTES="1572864"
#ETCD_GRPC_KEEPALIVE_MIN_TIME="5s"
#ETCD_GRPC_KEEPALIVE_INTERVAL="2h0m0s"
#ETCD_GRPC_KEEPALIVE_TIMEOUT="20s"
# 10MB传输
ETCD_MAX_REQUEST_BYTES="10485760"
# 1G内存
ETCD_QUOTA_BACKEND_BYTES="1073741824"
#
#[Clustering]
#ETCD_INITIAL_ADVERTISE_PEER_URLS="http://localhost:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://172.16.0.7:2379,http://127.0.0.1:2379"
#ETCD_DISCOVERY=""
#ETCD_DISCOVERY_FALLBACK="proxy"
#ETCD_DISCOVERY_PROXY=""
#ETCD_DISCOVERY_SRV=""
#ETCD_INITIAL_CLUSTER="default=http://localhost:2380"
#ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
#ETCD_INITIAL_CLUSTER_STATE="new"
#ETCD_STRICT_RECONFIG_CHECK="true"
#ETCD_ENABLE_V2="true"
#
#[Proxy]
#ETCD_PROXY="off"
#ETCD_PROXY_FAILURE_WAIT="5000"
#ETCD_PROXY_REFRESH_INTERVAL="30000"
#ETCD_PROXY_DIAL_TIMEOUT="1000"
#ETCD_PROXY_WRITE_TIMEOUT="5000"
#ETCD_PROXY_READ_TIMEOUT="0"
#
#[Security]
#ETCD_CERT_FILE=""
#ETCD_KEY_FILE=""
#ETCD_CLIENT_CERT_AUTH="false"
#ETCD_TRUSTED_CA_FILE=""
#ETCD_AUTO_TLS="false"
#ETCD_PEER_CERT_FILE=""
#ETCD_PEER_KEY_FILE=""
#ETCD_PEER_CLIENT_CERT_AUTH="false"
#ETCD_PEER_TRUSTED_CA_FILE=""
#ETCD_PEER_AUTO_TLS="false"
#
#[Logging]
#ETCD_DEBUG="false"
#ETCD_LOG_PACKAGE_LEVELS=""
#ETCD_LOG_OUTPUT="default"
#
#[Unsafe]
#ETCD_FORCE_NEW_CLUSTER="false"
#
#[Version]
ETCD_AUTO_COMPACTION_RETENTION="1"
ETCD_AUTO_COMPACTION_MODE="periodic"
#ETCD_VERSION="false"
#ETCD_AUTO_COMPACTION_RETENTION="0"
#
#[Profiling]
#ETCD_ENABLE_PPROF="false"
#ETCD_METRICS="basic"
#
#[Auth]
#ETCD_AUTH_TOKEN="simple"

```

- 创建etcd服务

```bash
cat << EOT > /usr/lib/systemd/system/etcd.service
[Unit]
Description=etcd service
After=network.target

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
User=etcd
ExecStart=/data/etcd/etcd
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOT
```

- 开机启动

```bash
systemctl enable etcd
```

- 启动ETCD

```bash
systemctl start etcd.service
```

- 停止ETCD

```
systemctl stop etcd.service
```

- 查看ETCD运行状态

```
systemctl status etcd.service
```

- 查看ETCD监听端口

```bash
sudo netstat -tuln -p
```

