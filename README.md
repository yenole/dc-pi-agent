# pi-agent Docker 镜像

镜像基于 Node.js 22 Debian slim，安装 Pi coding agent、全局 npm 包 `pi-web-ui` 和常用命令行工具：`git`、`curl`、`ripgrep`、`fd`、`fzf`、`jq`、`tree`、`vim`、Python 3，以及编译工具链等。容器默认启动 `pi-web-ui --no-browser`，监听所有网卡的 8787 端口。

## 构建

本地构建：

```bash
docker build -t pi-agent .
```

GitHub Actions 工作流位于 `.github/workflows/docker.yml`：只有推送版本标签（如 `v1.0.0`）时才会构建并推送名为 `pi-agent` 的镜像到 GitHub Container Registry（GHCR），镜像标签与 Git tag 一致。镜像同时支持 `linux/amd64` 和 `linux/arm64`；Docker 会根据运行设备自动选择对应架构。

推送版本标签后，可使用对应标签拉取镜像（将 `<owner>` 替换成 GitHub 用户名或组织名）：

```bash
docker pull ghcr.io/<owner>/pi-agent:v1.0.0
```

## 启动 Web UI

在项目目录运行，挂载当前目录作为工作区、映射 Web UI 端口，并使用 Docker 命名卷持久化 Pi 配置：

```bash
docker run --rm -it \
  -p 8787:8787 \
  -v "$PWD:/workspace" \
  -v pi-agent-config:/home/node/.pi \
  pi-agent
```

然后打开 <http://localhost:8787>。配置模型/认证后即可使用，配置会保存在 `pi-agent-config` 卷中。

## 直接执行命令

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -v pi-agent-config:/home/node/.pi \
  pi-agent --help
```

需要额外工具时，可在 `Dockerfile` 的 `apt-get install` 列表中添加 Debian 包，再重新构建镜像。
