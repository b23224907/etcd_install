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
