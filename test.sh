#!/bin/bash

echo "//" > FLRouter/FLRouter/FLRouterURLMacro.h
echo "//  FLRouterURLMacro_h" >> FLRouter/FLRouter/FLRouterURLMacro.h
echo "//  FLAPP" >> FLRouter/FLRouter/FLRouterURLMacro.h
echo "//" >> FLRouter/FLRouter/FLRouterURLMacro.h
echo "//  Created by $USER on $(date +%Y/%m/%d).h" >> FLRouter/FLRouter/FLRouterURLMacro.h
echo "//  Copyright © $(date +%Y)年 fuliao. All rights reserved." >> FLRouter/FLRouter/FLRouterURLMacro.h
echo "//" >> FLRouter/FLRouter/FLRouterURLMacro.h
echo "//  author:wangshen email:840787626@qq.com" >> FLRouter/FLRouter/FLRouterURLMacro.h
echo "\n\n#ifndef FLRouterURLMacro_h\n#define FLRouterURLMacro_h\n\n" >> FLRouter/FLRouter/FLRouterURLMacro.h

while read line
do
    aaa=$line
    presubString=$(expr $aaa : '\([a-zA-Z0-9_/]*\/\)')
    subfixString=${aaa//$presubString/""}
    classname=${subfixString//".h"/""}
    markString="//组件$classname路由表"
    echo $markString >> FLRouter/FLRouter/FLRouterURLMacro.h
    while read line1
    do
        if [ "$line1" != "" ]; then
            selPreString=$(expr $line1 : '\([+-][ ]*([a-zA-Z]*)\)')
            if [ "$selPreString" != "" ]; then
                selSubfixString=${line1//$selPreString/""}
                selName=$(expr $selSubfixString : '\([A-Za-z0-9_]*[:|;]\)')
                selName=${selName//":"/""}
                selName=${selName//";"/""}
                defineStr="#define FLRouter_URL_"$classname"_"$selName"  "@\"FLRoute://$classname/$selName\"
                echo $defineStr >> FLRouter/FLRouter/FLRouterURLMacro.h
            fi
        fi
    done < $aaa
    echo "\n\n" >> FLRouter/FLRouter/FLRouterURLMacro.h
done < copyheaderlist.txt

echo "#endif /* FLRouterURLMacro_h */" >> FLRouter/FLRouter/FLRouterURLMacro.h
