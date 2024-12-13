FROM dperson/samba:latest

# copy the setup script
COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# entry point
CMD ["/usr/local/bin/setup.sh"]
