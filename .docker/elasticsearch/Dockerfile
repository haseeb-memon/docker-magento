FROM docker.elastic.co/elasticsearch/elasticsearch:6.5.4

RUN echo "xpack.security.enabled: false" >> /usr/share/elasticsearch/config/elasticsearch.yml

# Install ElasticSuite requirements (https://github.com/Smile-SA/elasticsuite/wiki/ModuleInstall)
RUN \
    elasticsearch-plugin install analysis-icu && \
    elasticsearch-plugin install analysis-phonetic

EXPOSE 9200 9300