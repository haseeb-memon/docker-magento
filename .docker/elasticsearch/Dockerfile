FROM docker.elastic.co/elasticsearch/elasticsearch:6.5.4

RUN \
    elasticsearch-plugin install analysis-icu && \
    elasticsearch-plugin install analysis-phonetic

EXPOSE 9200 9300