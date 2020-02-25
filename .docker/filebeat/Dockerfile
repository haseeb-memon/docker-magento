FROM docker.elastic.co/beats/filebeat:6.5.4


USER root
RUN mkdir /usr/share/filebeat/dockerlogs
RUN chown -R root /usr/share/filebeat/
RUN chmod -R go-w /usr/share/filebeat/
# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>
