# Mac-Terminal-Beautify-Patch
Mac 终端全自动美化补丁，彩色可视化安装器，国内镜像自选，无人值守一键部署。

## 项目特性
1. 彩色美化终端安装界面，废话文学交互，使用`tput`标准颜色，无转义乱码问题
2. 自带免责声明，必须输入Y同意才能继续安装
3. 三选一下载源：中科大镜像 / Gitee镜像 / 官方海外源
4. 自动识别 Apple Silicon / Intel Mac，自动适配环境变量
5. 修复 exa 废弃问题，替换为 eza 彩色目录工具
6. 纯ASCII模式主题，无需下载特殊字体，杜绝GitHub字体404报错
7. 全自动静默安装，选完源全程无需人工干预

## 包含组件
- Homebrew 国内镜像自动安装
- eza / bat / fd / fzf / autojump 终端增强工具
- Oh My Zsh 终端框架
- Powerlevel10k 高颜值提示符（无交互式配置弹窗）

## 一键恢复Mac原生默认终端
如果你不想继续使用美化终端，项目内置一键恢复脚本：
1. 进入项目文件夹
2. cd Mac-Terminal-Beautify-Patch


## 使用方法
1. 克隆本仓库
2. 克隆完后执行chmod +x install_.sh
3. 执行./install.sh
```bash
git clone https://github.com/你的GitHub用户名/Mac-Terminal-Beautify-Patch.git
cd Mac-Terminal-Beautify-Patch


