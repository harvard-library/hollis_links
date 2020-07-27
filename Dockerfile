### Server ###

#https://github.com/phusion/passenger-docker
FROM phusion/passenger-jruby92

# Set correct environment variables.
ENV DEBIAN_FRONTEND noninteractive

#Change the user ID to 9902 because that is also the listviewadm user
#This allows log file writing.
RUN usermod -u 9902 app && groupmod -g 199 app

#From the docs: The image has an app user and home directory 
# /home/app. Your application is supposed to run as this user.
COPY --chown=app:app . /home/app/webapp

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  postgresql \
  bash \
  tzdata \
  openssl && \
  curl \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  gem update --system && \
  gem install bundler && \
  rm -f /etc/nginx/sites-enabled/default && \
  rm -f /etc/service/nginx/down && \
  chmod +x /home/app/webapp/bin/*.sh && \
  chown app /etc/ssl/certs && \
  chown app /etc/ssl/openssl.cnf
  

USER app 

# Set working directory
WORKDIR /home/app/webapp

RUN bundle install && \
    bundle exec rake assets:precompile && \
    printf "[SAN]\nsubjectAltName=DNS:*.hul.harvard.edu,DNS:*.lib.harvard.edu" >> /etc/ssl/openssl.cnf && \
    openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj "/C=US/ST=Massachusetts/L=Cambridge/O=Library Technology Services/CN=*.lib.harvard.edu" -extensions SAN -reqexts SAN -config /etc/ssl/openssl.cnf -keyout /etc/ssl/certs/server.key -out /etc/ssl/certs/server.crt

#Uncomment this if there is a migration to run in this image
ENTRYPOINT ["bin/entrypoint.sh"]

USER root

# Expose ports
EXPOSE 13980:3001

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]


