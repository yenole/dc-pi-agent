# pi-agent Docker 镜像

镜像基于 Node.js 22 Debian slim，安装 Pi coding agent 和常用命令行工具：`git`、`curl`、`ripgrep`、`fd`、`fzf`、`jq`、`tree`、`vim`、Python 3，以及编译工具链等。容器启动时会检查 `node` 用户的 Pi 配置；若尚未安装 `pi-web-ui`，则先自动安装，然后通过 `pi "/webui start --no-browser"` 启动 Pi Web UI（容器内不尝试打开浏览器）。

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

## 启动交互会话

在项目目录运行，挂载当前目录作为工作区，并使用 Docker 命名卷持久化 Pi 配置。首次启动会自动安装 `pi-web-ui`，随后执行 `pi "/webui start --no-browser"`；后续启动检测到已安装后会跳过安装并直接执行该命令：

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -v pi-agent-config:/home/node/.pi \
  pi-agent
```

首次启动时按提示配置模型/认证。配置会保存在 `pi-agent-config` 卷中，后续运行时继续使用该卷即可。

## 直接执行命令

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -v pi-agent-config:/home/node/.pi \
  pi-agent --help
```

需要额外工具时，可在 `Dockerfile` 的 `apt-get install` 列表中添加 Debian 包，再重新构建镜像。
