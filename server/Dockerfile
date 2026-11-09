# Mobil Arıcı backend: PocketBase v0.40.6 extended in Go (K-1, K-2).
# Build context is this folder (Coolify Base Directory /server).
# Images are pinned by tag + multi-arch index digest; bump both together.

# Go version = the `go` line of PocketBase v0.40.6's go.mod (1.27).
FROM golang:1.27.3-alpine3.24@sha256:fa3d596898d9f126af7c01d14ee7597bab3f39cccf392ef36b69fe77cd681f18 AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

# Git commit shown by GET /api/app/info. Coolify passes SOURCE_COMMIT when
# "Include Source Commit in Build" is on (server/ops/coolify.md).
ARG SOURCE_COMMIT=unknown
RUN CGO_ENABLED=0 go build -trimpath \
    -ldflags "-s -w -X main.version=${SOURCE_COMMIT}" \
    -o /out/arici .

FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

RUN apk add --no-cache ca-certificates tzdata \
    && addgroup -S -g 10001 arici \
    && adduser -S -D -H -u 10001 -G arici arici \
    && mkdir -p /pb/pb_data \
    && chown -R arici:arici /pb

COPY --from=build /out/arici /pb/arici

USER arici
WORKDIR /pb

EXPOSE 8090
VOLUME /pb/pb_data

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD wget -q -O /dev/null http://127.0.0.1:8090/api/health || exit 1

ENTRYPOINT ["/pb/arici"]
CMD ["serve", "--http", "0.0.0.0:8090", "--dir", "/pb/pb_data", "--encryptionEnv", "PB_ENCRYPTION_KEY"]
