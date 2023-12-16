FROM ruby:3.1.0

# Establece el directorio de trabajo
WORKDIR /app

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config
# RUN apt-get update -qq && \
#     apt-get install -y nodejs postgresql-client && \
#     apt-get install -y curl && \
#     curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#     apt-get update -qq && \
#     apt-get install -y yarn

# Install application gems
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
# # Exponer el puerto 3000 para la aplicación Rails
EXPOSE 3000

# # Comando por defecto al ejecutar el contenedor
CMD ["bash","-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b '0.0.0.0'"]

