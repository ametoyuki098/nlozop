<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:atom="http://www.w3.org/2005/Atom"
    exclude-result-prefixes="atom">

<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

<!-- 变量定义 -->
<xsl:variable name="title" select="/rss/channel/title | /atom:feed/atom:title"/>
<xsl:variable name="subtitle" select="/rss/channel/description | /atom:feed/atom:subtitle"/>
<xsl:variable name="home_link" select="/rss/channel/link | /atom:feed/atom:link[@rel='alternate']/@href | /atom:feed/atom:link[not(@rel)]/@href"/>

<xsl:template match="/">
<html lang="zh-CN">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="$title"/></title>
        <!-- 引入 Tailwind CSS + Typography 插件 -->
        <script src="https://cdn.tailwindcss.com?plugins=typography"></script>
        <style>
            body { font-family: -apple-system, system-ui, sans-serif; }
            /* 针对内容中图片的修复 */
            .prose img { margin: 1em auto; border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
            /* 针对 hexo 代码块的简单适配 */
            pre { background-color: #1e293b !important; color: #e2e8f0 !important; overflow-x: auto; padding: 1rem; border-radius: 0.5rem; }
        </style>
    </head>
    <body class="bg-gray-50 text-gray-800 dark:bg-gray-900 dark:text-gray-200 min-h-screen py-8 px-4">
        
        <div class="max-w-4xl mx-auto">
            <!-- 头部 -->
            <header class="mb-12 text-center space-y-3">
                <h1 class="text-3xl md:text-4xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-500 to-purple-600">
                    <xsl:value-of select="$title"/>
                </h1>
                <p class="text-gray-500 dark:text-gray-400 text-lg"><xsl:value-of select="$subtitle"/></p>
                <a href="{$home_link}" target="_blank" class="inline-block px-4 py-1.5 bg-blue-100 text-blue-700 rounded-full text-sm font-medium hover:bg-blue-200 transition">
                    访问网站
                </a>
            </header>

            <div class="space-y-8">
                <!-- 处理 Atom Entry (Hexo) -->
                <xsl:for-each select="/atom:feed/atom:entry">
                    <article class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden hover:shadow-md transition">
                        <div class="p-6 md:p-8">
                            <header class="mb-6">
                                <h2 class="text-2xl font-bold mb-2">
                                    <a href="{atom:link[@rel='alternate']/@href}" target="_blank" class="hover:text-blue-600 transition">
                                        <xsl:value-of select="atom:title"/>
                                    </a>
                                </h2>
                                <div class="text-sm text-gray-400 flex items-center gap-4">
                                    <time><xsl:value-of select="substring(atom:published, 0, 11)"/></time>
                                    <xsl:if test="atom:category">
                                        <span class="bg-gray-100 dark:bg-gray-700 px-2 py-0.5 rounded text-xs">
                                            <xsl:value-of select="atom:category/@term"/>
                                        </span>
                                    </xsl:if>
                                </div>
                            </header>

                            <!-- 
                                核心修复点：
                                1. 优先使用 atom:content (全文)，因为 Hexo 的 summary 经常是截断的。
                                2. disable-output-escaping="yes" 是必须的，否则会显示源码。
                            -->
                            <div class="prose prose-lg prose-slate dark:prose-invert max-w-none break-words">
                                <xsl:choose>
                                    <xsl:when test="atom:content">
                                        <xsl:value-of select="atom:content" disable-output-escaping="yes"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="atom:summary" disable-output-escaping="yes"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>

                            <div class="mt-6 pt-6 border-t border-gray-100 dark:border-gray-700">
                                <a href="{atom:link[@rel='alternate']/@href}" target="_blank" class="text-blue-600 hover:text-blue-800 font-medium text-sm inline-flex items-center">
                                    阅读原文 <span class="ml-1">→</span>
                                </a>
                            </div>
                        </div>
                    </article>
                </xsl:for-each>

                <!-- 处理 RSS Item (为了兼容性保留) -->
                <xsl:for-each select="/rss/channel/item">
                    <article class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 p-6">
                        <h2 class="text-xl font-bold mb-2">
                            <a href="{link}" target="_blank" class="hover:text-blue-600"><xsl:value-of select="title"/></a>
                        </h2>
                        <div class="prose prose-slate dark:prose-invert max-w-none mt-4">
                            <xsl:value-of select="description" disable-output-escaping="yes"/>
                        </div>
                    </article>
                </xsl:for-each>
            </div>

            <footer class="mt-12 mb-6 text-center text-sm text-gray-400">
                Generated by Hexo · Styled by XSLT
            </footer>
        </div>
    </body>
</html>
</xsl:template>
</xsl:stylesheet>
