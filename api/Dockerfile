FROM syfxlin/judge-base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libpq-dev \
      ruby-dev \
      sudo && \
    rm -rf /var/lib/apt/lists/*

ENV PATH "/opt/.gem/bin:$PATH"
ENV GEM_HOME "/opt/.gem/"
RUN echo "gem: --no-document" > /root/.gemrc && \
    gem install \
      rails:5.0.0 \
      bundler:1.15.4 \
      pg:0.18 && \
    npm install -g aglio --unsafe

EXPOSE 3000

WORKDIR /api
COPY Gemfile* ./
RUN RAILS_ENV=production bundle

COPY . .
RUN RAILS_ENV=production bundle && \
    ./scripts/prod-gen-api-docs

CMD ["./scripts/run-server"]
