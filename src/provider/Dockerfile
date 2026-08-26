# qtclass provider：多阶段构建（零外部依赖）。
# 运行时从环境变量读取上游基址（QTCLASS_COURSE_API_URL / QTCLASS_LEARN_API_URL，
# 由 FC 环境变量注入，见 manifests/terraform/fc.tf）。

FROM golang:1.26-alpine AS build

WORKDIR /src

ARG GOPROXY=https://goproxy.cn,direct
ENV GOPROXY=${GOPROXY}

COPY go.mod ./
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/qtclass-server ./cmd/server

FROM alpine:3.20

RUN addgroup -S app && adduser -S -G app app
COPY --from=build /out/qtclass-server /usr/local/bin/qtclass-server

USER app
EXPOSE 8080

CMD ["/usr/local/bin/qtclass-server"]
