# syntax=docker/dockerfile:1
# ============================================================================
# 进销存 ERP 前端镜像（Vue3 + Vite 静态站点 + Nginx）
#
# 关键点：构建时把 VITE_API_BASE 置空。
# 前端 axios 的 baseURL 默认是 http://localhost:3000，那是本地开发的写法；
# 容器里若保留它，浏览器会去连用户自己电脑的 3000 端口，必然失败。
# 置空后请求变成同源相对路径（/kuerp/xxx、/api/upload…），
# 再由同镜像内的 nginx 反向代理到后端容器，部署即通。
# ============================================================================

# ---------- 构建阶段 ----------
FROM node:18-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci || npm install

COPY . .
# 同源部署：baseURL 留空，交给 nginx 反代
ARG VITE_API_BASE=""
ENV VITE_API_BASE=$VITE_API_BASE
RUN npx vite build

# ---------- 运行阶段 ----------
FROM nginx:1.25-alpine AS runner
ENV TZ=Asia/Shanghai

# 时区：日志时间与后端保持一致，排查问题不用心算 8 小时
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
HEALTHCHECK --interval=20s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
