FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /merchants_se
COPY Gemfile /merchants_se/Gemfile
COPY Gemfile.lock /merchants_se/Gemfile.lock
RUN bundle install

# Startup script
COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Main process
CMD ["rails", "server", "-b", "0.0.0.0"]
