FROM python:3-alpine AS build-image

# Setup virtualenv to build ansible-lint in
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install build dependencies and ansible-lint itself
ADD . /ansible-lint
RUN apk add gcc musl-dev libffi-dev openssl-dev
RUN pip install /ansible-lint


FROM python:3-alpine AS runtime-image

# Copy the virtualenv from the previous stage and use it
COPY --from=build-image /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install reviewdog, git and the entrypoint script
RUN apk add --no-cache git
RUN wget -q -O- https://github.com/reviewdog/reviewdog/releases/download/v0.9.17/reviewdog_0.9.17_Linux_x86_64.tar.gz | tar -xz reviewdog && mv /reviewdog /usr/local/bin/reviewdog
COPY lint-action.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
