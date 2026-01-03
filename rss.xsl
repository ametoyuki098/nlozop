<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:atom="http://www.w3.org/2005/Atom"
    exclude-result-prefixes="atom">

<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- 统一变量定义：自动判断是 RSS 还是 Atom -->
<xsl:variable name="title" select="/rss/channel/title | /atom:feed/atom:title"/>
<xsl:variable name="description" select="/rss/channel/description | /atom:feed/atom:subtitle"/>
<xsl:variable name="link" select="/rss/channel/link | /atom:feed/atom:link[@rel='alternate']/@href"/>

<xsl:template match="/">
<html lang="zh-CN">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="$title"/></title>
        <!-- 引入 Tailwind CSS 和 Typography 插件 -->
        <script src="https://cdn.tailwindcss.com?plugins=typography"></script>
        <style>
            /* 自定义少量样式 */
            body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; }
            .fade-in { animation: fadeIn 0.5s ease-in-out; }
            @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        </style>
    </head>
    <body class="bg-gray-50 text-gray-800 dark:bg-gray-900 dark:text-gray-200 min-h-screen py-10 px-4 transition-colors duration-300">
        
        <div class="max-w-3xl mx-auto">
            <!-- 头部信息 -->
            <header class="mb-10 text-center space-y-4 fade-in">
                <h1 class="text-4xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
                    <xsl:value-of select="$title"/>
                </h1>
                <p class="text-lg text-gray-600 dark:text-gray-400">
                    <xsl:value-of select="$description"/>
                </p>
                <a href="{$link}" target="_blank" class="inline-flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-full text-sm font-medium transition">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path></svg>
                    访问网站
                </a>
            </header>
            
            <!-- 提示信息 -->
            <div class="bg-blue-50 dark:bg-slate-800 border-l-4 border-blue-500 p-4 mb-8 rounded-r shadow-sm">
                <p class="text-sm text-blue-700 dark:text-blue-300">
                    这是一个 RSS 订阅源。请将此 URL 复制到您的阅读器（如 Feedly, Reeder, Inoreader）中进行订阅。
                </p>
            </div>

            <!-- 文章列表 -->
            <main class="space-y-6">
                <!-- 处理 RSS Item -->
                <xsl:for-each select="/rss/channel/item">
                    <xsl:call-template name="item-card">
                        <xsl:with-param name="item_title" select="title"/>
                        <xsl:with-param name="item_link" select="link"/>
                        <xsl:with-param name="item_desc" select="description"/>
                        <xsl:with-param name="item_date" select="pubDate"/>
                    </xsl:call-template>
                </xsl:for-each>

                <!-- 处理 Atom Entry -->
                <xsl:for-each select="/atom:feed/atom:entry">
                    <xsl:call-template name="item-card">
                        <xsl:with-param name="item_title" select="atom:title"/>
                        <xsl:with-param name="item_link" select="atom:link/@href"/>
                        <xsl:with-param name="item_desc" select="atom:content | atom:summary"/>
                        <xsl:with-param name="item_date" select="atom:updated"/>
                    </xsl:call-template>
                </xsl:for-each>
            </main>

            <!-- 页脚 -->
            <footer class="mt-16 text-center text-sm text-gray-400">
                <p>Styled with XSLT &amp; Tailwind CSS</p>
            </footer>
        </div>
    </body>
</html>
</xsl:template>

<!-- 单个文章卡片的模板 -->
<xsl:template name="item-card">
    <xsl:param name="item_title"/>
    <xsl:param name="item_link"/>
    <xsl:param name="item_desc"/>
    <xsl:param name="item_date"/>

    <article class="bg-white dark:bg-gray-800 rounded-xl shadow-lg overflow-hidden hover:shadow-xl transition duration-300 border border-gray-100 dark:border-gray-700 fade-in">
        <div class="p-6">
            <header class="mb-4">
                <h2 class="text-2xl font-bold mb-2">
                    <a href="{$item_link}" target="_blank" class="text-gray-900 dark:text-white hover:text-blue-600 dark:hover:text-blue-400 transition">
                        <xsl:value-of select="$item_title"/>
                    </a>
                </h2>
                <div class="text-xs text-gray-500 font-mono">
                    <xsl:value-of select="$item_date"/>
                </div>
            </header>
            
            <!-- 使用 details/summary 来折叠长内容，保持页面整洁 -->
            <details class="group">
                <summary class="cursor-pointer text-blue-600 hover:text-blue-800 font-medium text-sm flex items-center select-none">
                    <span>阅读摘要 / 全文</span>
                    <svg class="w-4 h-4 ml-1 transition-transform group-open:rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                </summary>
                <!-- 这里使用 Tailwind Typography (prose) 自动美化 HTML 内容 -->
                <div class="mt-4 prose prose-slate dark:prose-invert max-w-none prose-img:rounded-lg prose-a:text-blue-600">
                    <xsl:value-of select="$item_desc" disable-output-escaping="yes"/>
                </div>
            </details>
        </div>
    </article>
</xsl:template>

</xsl:stylesheet>
