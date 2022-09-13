# syntax=docker/dockerfile:1.3

ARG ERPNEXT_VERSION
FROM naderelabed/erpnext-worker:${ERPNEXT_VERSION}

COPY repos ../apps

USER root

RUN install-app posawesome && \
    install-app wiki

USER frappe
