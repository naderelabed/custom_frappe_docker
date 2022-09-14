ARG FRAPPE_VERSION
ARG ERPNEXT_VERSION

FROM naderelabed/bench:latest as assets

ARG FRAPPE_VERSION
RUN bench init --frappe-path "https://github.com/naderelabed/frappe.git" --version=version-13 --skip-redis-config-generation --verbose --skip-assets /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

# Comment following if ERPNext not required
ARG ERPNEXT_VERSION
RUN bench get-app https://github.com/naderelabed/erpnext.git --branch=version-13 --skip-assets --resolve-deps erpnext

COPY --chown=frappe:frappe repos apps

RUN bench setup requirements

RUN bench build --production --verbose --hard-link

FROM naderelabed/frappe-nginx:version-13

USER root

RUN rm -fr /usr/share/nginx/html/assets

COPY --from=assets /home/frappe/frappe-bench/sites/assets /usr/share/nginx/html/assets

USER 1000
