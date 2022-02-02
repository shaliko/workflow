FROM ruby:3.1.0

RUN wget --quiet -O - /tmp/pubkey.gpg  https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq \
    && apt-get install -y ca-certificates build-essential nodejs yarn tzdata shared-mime-info \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]