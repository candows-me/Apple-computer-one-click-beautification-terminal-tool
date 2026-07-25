#!/bin/zsh
set -euo pipefail

# 标准tput兼容颜色，无转义乱码
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

clear
echo "${BLUE}======================================================================${RESET}"
echo "${CYAN}                ⚠️ Mac终端美化一键恢复默认脚本 ⚠️${RESET}"
echo "${BLUE}======================================================================${RESET}"
echo "${RED}======================== 恢复操作免责提示 ========================${RESET}"
echo "${WHITE}1. 本脚本会删除美化生成的 p10k、自定义.zshrc 终端配置；"
echo "${WHITE}2. 会自动还原安装Oh My Zsh前原始终端配置文件；"
echo "${WHITE}3. Homebrew、eza/bat等工具不会卸载，仅恢复终端显示样式；"
echo "${WHITE}4. 操作不可逆，请确认你不需要当前美化效果再继续。"
echo "${RED}==================================================================${RESET}"
echo ""
read "confirm?${YELLOW}确认执行恢复请输入 Y 回车，其他字符直接退出：${RESET}"

if [[ "$confirm" != "Y" && "$confirm" != "y" ]]; then
    echo ""
    echo "${RED}❌ 已取消恢复操作，脚本退出${RESET}"
    exit 0
fi

echo ""
echo "${GREEN}✅ 确认恢复，开始清理美化配置文件...${RESET}"
echo "${YELLOW}[1/4] 删除Powerlevel10k本地配置文件 ~/.p10k.zsh${RESET}"
if [[ -f ~/.p10k.zsh ]]; then
    rm -f ~/.p10k.zsh
    echo "${GREEN}✅ 已删除 .p10k.zsh 主题配置${RESET}"
else
    echo "${WHITE}💬 废话播报：找不到p10k配置，无需删除，直接跳过${RESET}"
fi

echo ""
echo "${YELLOW}[2/4] 还原原始.zshrc 终端配置${RESET}"
# 还原Oh My Zsh自动备份的原始配置
if [[ -f ~/.zshrc.pre-oh-my-zsh ]]; then
    rm -f ~/.zshrc
    cp ~/.zshrc.pre-oh-my-zsh ~/.zshrc
    echo "${GREEN}✅ 已还原安装美化前的原生终端配置${RESET}"
else
    echo "${WHITE}💬 废话播报：未找到原始备份配置，将生成空白默认zshrc${RESET}"
    echo "" > ~/.zshrc
fi

echo ""
echo "${YELLOW}[3/4] 可选：是否删除Oh My Zsh完整文件夹（输入Y删除，其他跳过）${RESET}"
read "del_omz?${YELLOW}输入Y彻底删除Oh My Zsh，直接回车保留：${RESET}"
if [[ "$del_omz" == "Y" || "$del_omz" == "y" ]]; then
    rm -rf ~/.oh-my-zsh
    echo "${GREEN}✅ 已完整删除 Oh My Zsh 文件夹${RESET}"
else
    echo "${WHITE}💬 废话播报：保留Oh My Zsh，仅关闭美化主题，后续可重新运行安装脚本${RESET}"
fi

echo ""
echo "${YELLOW}[4/4] 清理完成提示${RESET}"
echo "${BLUE}======================================================================${RESET}"
echo "${GREEN}🎉 终端已恢复Mac系统默认原生样式！${RESET}"
echo "${CYAN}💡 操作提示：完全关闭所有终端窗口，重新打开即可生效${RESET}"
echo "${WHITE}说明：eza/bat/fzf等工具仍保留在系统，只是不再自动启用美化别名"
echo "${BLUE}======================================================================${RESET}"
