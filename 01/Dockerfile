FROM ubuntu:20.04

COPY main_true.sh /home/main.sh


WORKDIR /home

RUN apt update && apt install nano -y \
    && chmod +x main.sh \
# ENTRYPOINT [ "./main.sh /Users/nikitapuskarev/DO4_LinuxMonitoring_v2.0-0/src/01 4 az 5 az.az 3kb" ]
# bash main.sh /home 4 az 5 az.az 3kb