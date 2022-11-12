ARG FRAPPE_VERSION
ARG ERPNEXT_VERSION

FROM naderelabed/bench:latest as assets

ARG FRAPPE_VERSION
RUN bench init --frappe-path "https://github.com/naderelabed/frappe.git" --version=${FRAPPE_VERSION} --skip-redis-config-generation --verbose --skip-assets /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

# Comment following if ERPNext not required
ARG ERPNEXT_VERSION
RUN bench get-app --branch=${ERPNEXT_VERSION} --skip-assets --resolve-deps https://github.com/naderelabed/erpnext.git

COPY --chown=frappe:frappe repos apps

USER root

RUN bench setup production requirements

RUN bench build --verbose --hard-link

FROM naderelabed/frappe-nginx:${FRAPPE_VERSION}

RUN rm -fr /usr/share/nginx/html/assets

COPY --from=assets /home/frappe/frappe-bench/sites/assets /usr/share/nginx/html/assets

USER 1000
