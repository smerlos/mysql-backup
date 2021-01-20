# mysql backup image
FROM alpine:3.13.0

# install the necessary client
# the mysql-client must be 10.3.15 or later
RUN apk add  --update --no-cache   'mariadb-client=10.5.8-r0' 'mariadb-connector-c=3.1.11-r0' 'bash=5.1.0-r0' 'python3=3.8.7-r0' 'py3-pip=20.3.3-r0' 'samba-client=4.13.3-r1' 'shadow=4.8.1-r0' 'openssl=1.1.1i-r0' && \
    rm -rf /var/cache/apk/* && \
    touch /etc/samba/smb.conf && \
    pip3 install awscli==1.18.217

# set us up to run as non-root user
RUN groupadd -g 1005 appuser && \
    useradd -r -u 1005 -g appuser appuser
# ensure smb stuff works correctly
RUN mkdir -p /var/cache/samba && chmod 0755 /var/cache/samba && chown appuser /var/cache/samba
USER appuser

# install the entrypoint
COPY functions.sh /
COPY entrypoint /entrypoint

# start
ENTRYPOINT ["/entrypoint"]
