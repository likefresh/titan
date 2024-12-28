#!/bin/bash

# 颜色设置
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# 下载原始安装脚本
echo -e "${green}正在下载原始安装脚本...${plain}"
rm -f install.sh
wget https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh

# 修改安装脚本
echo -e "${green}正在修改安装脚本...${plain}"
# 创建新的 config_after_install 函数内容
cat > config_after_install.txt << 'EOF'
config_after_install() {
    echo -e "正在配置面板..."
    
    # 设置固定的用户名、密码和端口
    local config_username="aaa"
    local config_password="aaa111"
    local config_port="1235"
    local config_webBasePath=$(gen_random_string 15)
    local server_ip=$(curl -s https://api.ipify.org)
    
    # 应用设置
    /usr/local/x-ui/x-ui setting -username "${config_username}" -password "${config_password}" -port "${config_port}" -webBasePath "${config_webBasePath}"
    
    echo -e "###############################################"
    echo -e "${green}面板配置信息：${plain}"
    echo -e "${green}用户名: ${config_username}${plain}"
    echo -e "${green}密码: ${config_password}${plain}"
    echo -e "${green}端口: ${config_port}${plain}"
    echo -e "${green}WebBasePath: ${config_webBasePath}${plain}"
    echo -e "${green}访问地址: http://${server_ip}:${config_port}/${config_webBasePath}${plain}"
    echo -e "###############################################"
    
    /usr/local/x-ui/x-ui migrate
}
EOF

# 替换配置函数
sed -i '/^config_after_install() {/,/^}/c\'"$(cat config_after_install.txt)" install.sh
rm -f config_after_install.txt

# 设置执行权限
chmod +x install.sh

# 运行安装脚本
echo -e "${green}开始安装 x-ui...${plain}"
./install.sh

echo -e "${green}安装完成！${plain}"
echo -e "${yellow}请记住以下信息：${plain}"
echo -e "${yellow}面板地址：http://服务器IP:1235${plain}"
echo -e "${yellow}用户名：aaa${plain}"
echo -e "${yellow}密码：aaa111${plain}"
