FROM ruby:2.7.1
USER root

RUN apt-get update -qy
RUN apt-get install -y libpq-dev libpq5 postgresql-client postgresql-client-common
RUN apt-get update && apt-get install -y vim

RUN mkdir -p /app
WORKDIR /app

RUN gem install bundler

COPY . ./
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
