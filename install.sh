#!/bin/zsh
set -euo pipefail
export HOMEBREW_BATCH=1
export HOMEBREW_NO_AUTO_UPDATE=0
export HOMEBREW_NO_INSTALL_CLEANUP=0

# ========== 标准兼容颜色定义（tput 全终端通用，不会乱码失效） ==========
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

clear

# ====================== 顶部标题分割线 ======================
echo "${BLUE}======================================================================${RESET}"
echo "${CYAN}                ✨ Mac终端全自动美化补丁 · 彩色美化安装器 ✨${RESET}"
echo "${BLUE}======================================================================${RESET}"
echo ""

# ====================== 免责声明区块（必须Y确认） ======================
echo "${RED}======================== 免责声明 ========================${RESET}"
echo "${WHITE}1. 本脚本仅修改终端配置文件，不会篡改系统核心系统文件；"
echo "${WHITE}2. 脚本自动安装 Homebrew、终端美化工具、Zsh 主题等开源免费软件；"
echo "${WHITE}3. 安装需联网拉取开源项目，网络波动、墙导致失败与脚本无关；"
echo "${WHITE}4. 终端异常可手动删除 ~/.zshrc、~/.p10k.zsh 一键恢复原始状态；"
echo "${WHITE}5. 脚本完全免费开源，无捆绑、无后门，不收集任何本地用户数据；"
echo "${WHITE}6. 因系统版本、网络环境差异造成安装失败，作者不承担相关责任。"
echo "${RED}=========================================================${RESET}"
echo ""
read "agree?${YELLOW}阅读并同意全部条款请输入 Y 回车继续，其他字符直接退出：${RESET}"

# 判断同意状态
if [[ "$agree" != "Y" && "$agree" != "y" ]]; then
    echo ""
    echo "${RED}❌ 未同意免责声明，安装程序直接退出${RESET}"
    exit 0
fi

echo ""
echo "${GREEN}✅ 已确认同意免责声明，正式进入美化安装流程！${RESET}"
echo "${YELLOW}💬 废话文学播报台：${RESET}"
echo "${WHITE}  1. 选好下载源后全程全自动运行，你可以摸鱼喝水刷视频；"
echo "${WHITE}  2. 彻底移除字体下载，永久解决 GitHub 404、方框乱码问题；"
echo "${WHITE}  3. ls 工具替换为新版 eza，修复 exa 已被 brew 下架报错；"
echo "${WHITE}  4. 安装卡住不用慌，只是网络短暂发呆，静静等待即可。"
echo "${BLUE}======================================================================${RESET}"
echo ""

# ====================== 下载源选择交互 ======================
echo "${CYAN}📶 请自选下载源（输入数字回车确认）：${RESET}"
echo "${WHITE}  1 → ${GREEN}中科大镜像${WHITE}（国内网速最快，国内用户首选）"
echo "${WHITE}  2 → ${GREEN}Gitee国内镜像${WHITE}（GitHub仓库国内同步，克隆稳定）"
echo "${WHITE}  3 → ${RED}官方海外源${WHITE}（必须VPN，极易超时404）"
read "source_choose?${CYAN}请输入 1 / 2 / 3：${RESET}"

# 分配源地址
if [[ "$source_choose" == "1" ]]; then
    echo ""
    echo "${GREEN}✅ 已选中【中科大国内镜像】，下载速度拉满，告别转圈加载${RESET}"
    BREW_INSTALL_URL="https://mirrors.ustc.edu.cn/misc/brew-install.sh"
    OMZ_INSTALL_URL="https://mirrors.ustc.edu.cn/misc/ohmyzsh-install.sh"
    P10K_GIT_URL="https://gitee.com/romkatv/powerlevel10k.git"
elif [[ "$source_choose" == "2" ]]; then
    echo ""
    echo "${GREEN}✅ 已选中【Gitee国内仓库镜像】，主题克隆不受GitHub访问限制${RESET}"
    BREW_INSTALL_URL="https://mirrors.ustc.edu.cn/misc/brew-install.sh"
    OMZ_INSTALL_URL="https://mirrors.ustc.edu.cn/misc/ohmyzsh-install.sh"
    P10K_GIT_URL="https://gitee.com/romkatv/powerlevel10k.git"
elif [[ "$source_choose" == "3" ]]; then
    echo ""
    echo "${RED}⚠️  警告：选择海外源，无VPN环境大概率下载失败、404报错！${RESET}"
    BREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    OMZ_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
    P10K_GIT_URL="https://github.com/romkatv/powerlevel10k.git"
else
    echo ""
    echo "${RED}❌ 输入无效！仅支持数字1、2、3，脚本退出，请重新运行${RESET}"
    exit 1
fi

echo "${BLUE}----------------------------------------------------------------------${RESET}"
echo "${YELLOW}🔍 自动扫描 Mac 硬件架构中...${RESET}"
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin"
    echo "${GREEN}✅ 扫描完成：Apple Silicon M系列芯片，路径自动适配${RESET}"
else
    BREW_PATH="/usr/local/bin"
    echo "${GREEN}✅ 扫描完成：Intel 英特尔Mac，老设备完美兼容${RESET}"
fi
echo "${BLUE}----------------------------------------------------------------------${RESET}"

# ====================== 步骤1：Homebrew 安装 ======================
echo ""
echo "${YELLOW}[1/5] 校验核心工具 Homebrew（Mac软件管理器）${RESET}"
if ! command -v brew &> /dev/null; then
    echo "${WHITE}💬 小废话：没装brew等于厨房没锅，装啥工具都费劲${RESET}"
    echo "${WHITE}通过你选定的镜像静默安装，全程无需手动确认交互...${RESET}"
    /bin/bash -c "$(curl -fsSL $BREW_INSTALL_URL)" <<EOF
y
EOF
    echo "${GREEN}✅ Homebrew 安装完成！${RESET}"
else
    echo "${GREEN}✅ 本机已存在Homebrew，跳过安装节省时间${RESET}"
fi

# 写入环境变量
eval "$($BREW_PATH/brew shellenv)"
echo 'eval "$('$BREW_PATH'/brew shellenv)"' >> ~/.zshrc
echo "${WHITE}已自动写入环境变量，新开终端自动加载，不用手动输代码${RESET}"

# ====================== 步骤2：美化工具包安装 ======================
echo ""
echo "${YELLOW}[2/5] 安装终端增强工具：eza bat fd fzf autojump${RESET}"
echo "${WHITE}💬 小废话：原生ls太简陋，eza彩色目录、bat代码高亮更好看${RESET}"
brew install --quiet eza bat fd fzf autojump
echo "${GREEN}✅ 全部终端美化工具安装完毕${RESET}"

# ====================== 步骤3：Oh My Zsh 部署 ======================
echo ""
echo "${YELLOW}[3/5] 校验 Oh My Zsh（终端美化核心）${RESET}"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "${WHITE}未检测到Oh My Zsh，使用选定镜像全自动无交互部署${RESET}"
    sh -c "$(curl -fsSL $OMZ_INSTALL_URL)" "" --unattended
    echo "${GREEN}✅ Oh My Zsh 部署完成${RESET}"
else
    echo "${GREEN}✅ Oh My Zsh 已存在，跳过下载节约流量${RESET}"
fi

# ====================== 步骤4：Powerlevel10k 主题 ======================
echo ""
echo "${YELLOW}[4/5] 安装 Powerlevel10k 高颜值提示符主题${RESET}"
if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    echo "${WHITE}开始克隆主题仓库，网络慢无需操作，安静等待完成${RESET}"
    git clone --quiet --depth=1 $P10K_GIT_URL $HOME/.oh-my-zsh/custom/themes/powerlevel10k
    echo "${GREEN}✅ 主题文件拉取完成${RESET}"
else
    echo "${GREEN}✅ 主题已存在，无需重复克隆，不占用额外硬盘空间${RESET}"
fi

# ====================== 步骤5：导入预设配置 ======================
echo ""
echo "${YELLOW}[5/5] 导入美化预设配置，启用纯ASCII模式，无特殊字体依赖${RESET}"
cp ./config/p10k.zsh ~/.p10k.zsh
cp ./config/.zshrc.template ~/.zshrc

# 完成收尾提示
echo ""
echo "${BLUE}======================================================================${RESET}"
echo "${GREEN}🎉 全部5步安装流程执行完毕！Mac终端美化完成${RESET}"
echo "${CYAN}💡 重要提示：完全关闭所有终端窗口，重新打开才会加载全部美化效果${RESET}"
echo "${WHITE}出现方框属于正常ASCII兼容模式，不需要额外下载字体${RESET}"
echo "${BLUE}======================================================================${RESET}"
