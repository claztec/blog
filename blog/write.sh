#!/bin/bash
cd ./_draft/
DATE=`date +%Y-%m-%d`
FILENAME=$DATE"-draft.md"
touch $FILENAME
echo "---
layout: post
title: "제목"
author: Derek Choi
comments: true
---" > $FILENAME
echo $FILENAME "create write post"
