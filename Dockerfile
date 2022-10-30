FROM ubuntu:22.04 as builder

ENV DBSURL=https://dbschema.com/download/DbSchema_linux_9_1_0.deb
ENV JAYURL=https://github.com/FirebirdSQL/jaybird/releases/download/v4.0.6/jaybird-4.0.6.java11.zip

RUN apt-get update && apt-get install -y curl unzip

# Scripts to run in builder phase
COPY builder /builder
RUN chmod +x /builder/*.bash && /builder/_run_builder.bash 

###################################################################
###################################################################

FROM mgkahn/ubuntu_22_04 as system
LABEL maintainer="Michael.Kahn@cuanschutz.edu"

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/Denver
# Fix issue with libGL on Windows
ENV LIBGL_ALWAYS_INDIRECT=1


## Programs specific to N6293
RUN apt-get update && apt-get install -y openjdk-17-jre libreoffice libreoffice-sdbc-firebird flamerobin cups printer-driver-cups-pdf iputils-ping

## Files specific to N6293
COPY --from=builder /opt/DbSchema /opt/DbSchema
COPY --from=builder /builder/jaybird-4 /usr/local/bin

COPY rootfs /
RUN chmod +x /etc/startup/*.sh

# Uses startup.sh from base image.
# Course-specific changes added to /etc/startup -- last step in startup.sh
ENTRYPOINT ["/startup.sh"]

EXPOSE 6079
EXPOSE 6081

