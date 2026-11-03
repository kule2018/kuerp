# syntax=docker/dockerfile:1
# ============================================================================
# 进销存 ERP 后端镜像（NestJS + TypeORM）
#
# 构建方式：多阶段。builder 阶段装全量依赖并编译 TypeScript，
# 运行阶段只保留 dist + 生产依赖，镜像体积约为单阶段的一半，
# 同时避免把 typescript/ts-node 这类构建期工具带进生产环境。
#
# 为什么不直接用 `nest build`：本项目构建只依赖 tsc，
# 少一层 @nestjs/cli 依赖可以让构建在受限网络下更稳。
# ============================================================================

# ---------- 构建阶段 ----------
FROM node:18-alpine AS builder
WORKDIR /app

# 先只拷贝清单文件，利用 Docker 层缓存：源码改动不会触发重新装依赖
COPY package.json package-lock.json* ./
# 有 lock 用 ci（可复现），没有则退回 install
RUN npm ci || npm install

COPY tsconfig.json tsconfig.build.json ./
COPY src ./src
RUN npx tsc -p tsconfig.build.json

# ---------- 运行阶段 ----------
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production \
    TZ=Asia/Shanghai

# 时区数据：容器内 new Date() 走本地时区，否则统计报表按天分组会偏移 8 小时
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

COPY package.json package-lock.json* ./
RUN npm ci --omit=dev || npm install --omit=dev

COPY --from=builder /app/dist ./dist
# 上传目录：以卷挂载覆盖，容器重建后文件不丢
RUN mkdir -p /app/uploads
VOLUME ["/app/uploads"]

EXPOSE 3000
# 健康检查走公开的 /health（会顺带执行 SELECT 1 验证数据库连通），
# 不能用 /kuerp/xxx：那些接口要登录，探针会收到 401 而把正常服务判成不健康
HEALTHCHECK --interval=20s --timeout=5s --start-period=40s --retries=5 \
  CMD node -e "fetch('http://127.0.0.1:3000/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "dist/main.js"]
