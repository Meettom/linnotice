#!/bin/bash

# 检查 3306 端口是否有服务运行
if ! netstat -tulnp | grep ":3306" > /dev/null; then
    # 端口无服务，尝试重启 mysql。此处的指令代码可以自由修改。
    systemctl start mysql
    systemctl restart mysql

    # 调用 AokSend API 发送邮件通知
    # 邮件标题和内容变量 {{tongzhi}} 替换为实际通知信息
    NOTIFICATION="3306 端口无服务运行，已自动重启MySQL，请检查服务器状态！"

    # API 请求参数
    API_URL="https://www.aoksend.com/index/api/send_email"
    API_KEY="50ad6789000000000000000021e177c"   #替换成自己的AokSend的api_key
    TEMPLATE_ID="E_1000000000057"    #替换成自己的AokSend的邮件模板id
    TO_EMAIL="meetxxxxxx@163.com"    #替换成自己需要接收通知的邮箱

    # 使用 curl 发送请求
    curl -X POST "$API_URL" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "app_key=$API_KEY" \
        -d "to=$TO_EMAIL" \
        -d "template_id=$TEMPLATE_ID" \
        -d 'data={"tongzhi":"'"$NOTIFICATION"'"}'

    # 可选：记录日志
    echo "$(date '+%Y-%m-%d %H:%M:%S') - 3306 端口异常，已重启MySQL并发送通知" >> /var/log/port_3306_monitor.log
fi