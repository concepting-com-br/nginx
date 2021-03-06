FROM ghcr.io/concepting-com-br/base-image:1.0.0

LABEL maintainer="fvilarinho@concepting.com.br"

ENV HTDOCS_DIR=${HOME_DIR}/www

USER root

RUN apk update && \
    apk --no-cache add nginx

RUN mkdir -p ${HTDOCS_DIR} \ 
             /run/nginx && \
    rm -rf /etc/nginx/conf.d/default.conf

COPY htdocs ${HTDOCS_DIR}
COPY etc/nginx ${ETC_DIR}/nginx
COPY bin/startup.sh ${BIN_DIR}/child-startup.sh
COPY bin/install.sh ${BIN_DIR}/child-install.sh
COPY .env ${ETC_DIR}/

RUN ln -s ${ETC_DIR}/nginx/ssl /etc/nginx/ssl && \
    ln -s ${ETC_DIR}/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf && \
    chmod +x ${BIN_DIR}/*.sh
    
WORKDIR ${HOME_DIR}

EXPOSE 80 443

CMD ["${BIN_DIR}/child-startup.sh"]