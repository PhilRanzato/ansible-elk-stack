# ansible-elk-stack

Elk-stack deployment using Ansible

# High level guide

1. Install 
   1. Elasticsearch
   2. Logstash
   3. Kibana
2. Generate CA (if SSL)
3. Configure Elasticsearch
   1. Copy CA into elasticsearch hosts
   2. Elasticsearch instances and certificates (with elasticsearch certutil)
   3. Ship certificates to all nodes
   4. Give permissions to certificates (`chown root:elasticsearch`)
   5. Add to the elasticsearch internal keystore passwords for the certificates 
      1. `/usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password`
      2. `/usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password`
      3. `/usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.http.ssl.keystore.secure_password`
      4. `/usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.http.ssl.truststore.secure_password`
   6. `elasticsearch.yml` for all hosts
   7. jvm options
   8. underlying vm
      1. `swapoff -a`
      2. ```shell
         cat << EOF >> /etc/security/limits.conf
         elasticsearch  -  nofile  65535
         EOF
         ```
      3. `ulimit -n 65535`
      4. elasticsearch service
         ```shell
         mkdir -p /etc/systemd/system/elasticsearch.service.d
         cat << EOF > /etc/systemd/system/elasticsearch.service.d/override.conf
         [Service]
         LimitMEMLOCK=infinity
         EOF
         ```
      5. Reload the daemon `systemctl daemon-reload`
      6. If the disk of the data node is external: `chown -R elasticsearch:elasticsearch /data/elasticsearch`
4. Start elasticsearch
   1. ```shell
      systemctl start elasticsearch
      # Check nodes
      curl -k https://10.115.8.10:9200/_cat/nodes
      # Should return a security exception
      ```
   2. Setup passwords:
      ```shell
      /usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
      curl -k -u elastic:'67@22KR!mX25H' https://10.115.8.10:9200/_cat/nodes
      # Should NOT return a security exception
      ```
5. Configure Logstash
   1. Copy CA into logstash hosts
   2. From master 1: configure `instances_logstash.yml` and generate its certificates
   3. Ship logstash certificates to logstash vm
   4. Give permissions to certificates (`chown root:logstash`)
   5. `logstash.yml` for all hosts
   6. Install Java jdk
        ```shell
        sudo yum install java-11-openjdk-devel
        sudo /usr/share/logstash/bin/system-install /etc/logstash/startup.options systemd
        systemctl status logstash
        systemctl start logstash
        ```
6. Configure Kibana
   1. Copy CA into kibana hosts (`/etc/kibana/ca.crt`)
   2. Copy Kibana HTTPS certificates
   3. `kibana.yml` for all hosts
   4. Start and enable kibana
7. Install and Configure NGINX (optional)
   1. Install nginx (`yum install -y nginx`)
   2. Enable connection for nginx proxy (`setsebool httpd_can_network_connect on -P`)
   3. Configure nginx (`/etc/nginx/nginx.conf`)
   4. Start and enable nginx
8. Configure Logstash user for kibana
   1. Create `logstash_writer` user on kibana
        ```json
        POST _xpack/security/role/logstash_writer
        {
            "cluster": ["manage_index_templates", "monitor", "manage_ilm"], 
            "indices": [
                {
                "names": [ "logs-*" ], 
                "privileges": ["write","create","delete","create_index","manage","manage_ilm"]  
                }
            ]
        }
        ```
   2. Configure Logstash password for user on logstash vm
        ```shell
        cat << EOF > /etc/sysconfig/logstash
        LOGSTASH_KEYSTORE_PASS=<LOGSTASH_KEYSTORE_PASS>
        EOF
        export LOGSTASH_KEYSTORE_PASS=<LOGSTASH_KEYSTORE_PASS>
        chmod 600 /etc/sysconfig/logstash
        set -o history
        sudo -E /usr/share/logstash/bin/logstash-keystore --path.settings /etc/logstash create
        /usr/share/logstash/bin/logstash-keystore add LOGSTASH_WRITER_PASSWORD --path.settings /etc/logstash
        ```
   3. With kafka you now add kafka certificates to logstash in order to entrust communication, shoul this be done even with filebeat?
   4. Create logstash keystore and truststore
        ```shell
        keytool -genkey -keystore logstash.keystore.jks -alias logstash -dname CN=logstash -keyalg RSA -validity 3650 -storepass '<LOGSTASH_KEY_PASS>' -keypass '<LOGSTASH_KEY_PASS>' -storetype pkcs12
                
        # Export the certificate of the user from the keystore.

        keytool -certreq -keystore logstash.keystore.jks -alias logstash -file logstash.csr -storepass '<LOGSTASH_KEY_PASS>' -keypass '<LOGSTASH_KEY_PASS>'
            
        # Sign the certificate signing request with the root CA.

        openssl x509 -req -CA ca-cert -CAkey ca-key -in logstash.csr -out logstash.crt -days 3650 -CAcreateserial -passin  pass:'<CA_PWD>'

        # Import the certificate of the CA into the user keystore.

        keytool -importcert -file ca-cert -alias ca -keystore logstash.keystore.jks -storepass '<LOGSTASH_KEY_PASS>' -keypass '<LOGSTASH_KEY_PASS>' -noprompt
            
        # Import the signed certificate into the user keystore. Make sure to use the same `-alias` as you used ealier.

        keytool -importcert -file logstash.crt -alias logstash -keystore logstash.keystore.jks -storepass '<LOGSTASH_KEY_PASS>' -keypass '<LOGSTASH_KEY_PASS>'
        ```
   5. Add logstash keystore password inside logstash keystore (`/usr/share/logstash/bin/logstash-keystore add LOGSTASH_KAFKA_KEYSTORE_PASSWORD --path.settings /etc/logstash`)
   6. Add the pipelines
    
