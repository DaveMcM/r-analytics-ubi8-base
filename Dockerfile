FROM quay.io/davemcm/r-base-ubi8:latest 

ENV SUMMARY="" \
    DESCRIPTION=""

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      name="r-analytics" \
      version="4.0.2" \
      usage="" 

ENV R_VERSION 4.0.2

RUN INSTALL_PKGS="https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm" && \
    yum -y install $INSTALL_PKGS && yum clean all && rm -rf /var/cache/yum
 
RUN curl -O https://cdn.rstudio.com/r/centos-8/pkgs/R-${R_VERSION}-1-1.x86_64.rpm && \
    yum -y --enablerepo="*" install R-${R_VERSION}-1-1.x86_64.rpm && \
    yum -y update && \
    rm -f R-${R_VERSION}-1-1.x86_64.rpm && \
    yum clean all --enablerepo='*' && rm -rf /var/cache/yum

#    yum -y --enablerepo codeready-builder-for-rhel-8-x86_64-rpms install $INSTALL_PKGS && \
RUN ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R  && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R

RUN R CMD javareconf

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN mkdir -p /opt/app-root/src && chown -R 1001:0 /opt/app-root/src && chmod -R ug+rwx /opt/app-root/src 

WORKDIR /opt/app-root/src
USER 1001

CMD ["R"]
