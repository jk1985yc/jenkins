#!/bin/bash
#自定义全局变量
VERSION_PATH=/data/version
WEB_PATH=/var/www
NODE_LIST="IP"
CTIME=$(date "+%Y-%m-%d")

SSH_USER=root

#################################################################################################################################################
#判断是否正确输入需要发布的版本
if [ -z "${git}" ];then
    echo -e "发布的版本号为空，请重新输入版本号后构建......"
    exit 1
else

#判断为发布操作时，执行以下代码块
    if [[ ${status} == "Deploy" ]];then

#对节点列表进行发布代码
        for node in $NODE_LIST
        do
        	# 使用rsync的方式将workspace的代码进行同步到目标主机，并进行软链接到站点根目录
            rsync -raz --delete --progress --exclude=cache --exclude=.git --exclude=.idea ${WORKSPACE}/ $SSH_USER@$node:${VERSION_PATH}/${git}/
            ssh $SSH_USER@$node "rm -rf ${WEB_PATH}"
            ssh $SSH_USER@$node "ln -sv ${VERSION_PATH}/${git} ${WEB_PATH}"
            echo "发布成功......"
        done
    fi
fi
#判断为回滚操作时，执行以下代码块
if [[ ${status} == "Rollback" ]];then
        echo "准备回退......"

#对节点列表进行回退版本
        for node in $NODE_LIST
          do
              #判断目标主机是否存在回滚的版本
              ssh $SSH_USER@$node "ls -ld ${VERSION_PATH}/${git}"
              res=$(echo $?)
              if [[ $res == 0 ]];then
                ssh $SSH_USER@$node "unlink ${WEB_PATH}"
                ssh $SSH_USER@$node "ln -sv ${VERSION_PATH}/${git} ${WEB_PATH}"
              else
                  echo "回退版本："${git}"不存在"
                  exit 2
              fi
        done
fi

echo "已成功回退到"${git}"版本......"
