<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:atom="http://www.w3.org/2005/Atom"
    exclude-result-prefixes="atom">

<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

<!-- 变量定义 -->
<xsl:variable name="title" select="/atom:feed/atom:title"/>
<xsl:variable name="subtitle" select="/atom:feed/atom:subtitle"/>
<xsl:variable name="home_link" select="/atom:feed/atom:link[not(@rel) or @rel='alternate']/@href"/>
<xsl:variable name="feed_updated" select="/atom:feed/atom:updated"/>

<xsl:template match="/">
<html lang="zh-CN">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="$title"/> - RSS/Atom 阅读页面</title>
        
        <!-- Tailwind CSS + Typography 插件 -->
        <script src="https://cdn.tailwindcss.com?plugins=typography"></script>
        
        <style>
            body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif; }
            
            /* Prose 基础样式优化 */
            .prose img {
                max-width: 100%;
                height: auto;
                display: block;
                margin: 1.5em auto;
                border-radius: 0.75rem;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                loading: lazy;
            }
            
            /* 代码块优化 */
            pre, code {
                background-color: #1e293b;
                color: #e2e8f0;
                border-radius: 0.5rem;
            }
            pre { padding: 1rem; overflow-x: auto; }
            
            /* 暗色模式优化 */
            @media (prefers-color-scheme: dark) {
                body { background-color: #111827; }
            }
        </style>
    </head>
    
    <body class="bg-gray-50 text-gray-800 dark:bg-gray-900 dark:text-gray-200 min-h-screen py-12 px-4">
        <div class="max-w-4xl mx-auto">
            <!-- 头部 -->
            <header class="text-center mb-12 space-y-4">
                <h1 class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-indigo-500 to-purple-600 bg-clip-text text-transparent">
                    <xsl:value-of select="$title"/>
                </h1>
                <p class="text-xl text-gray-600 dark:text-gray-400">
                    <xsl:value-of select="$subtitle"/>
                </p>
                <div class="space-x-4">
                    <a href="{$home_link}" target="_blank" class="inline-block px-6 py-3 bg-indigo-600 text-white rounded-lg font-medium hover:bg-indigo-700 transition">
                        访问博客主页
                    </a>
                    <a href="{/atom:feed/atom:link[@rel='self']/@href}" class="inline-block px-6 py-3 bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-200 rounded-lg font-medium hover:bg-gray-300 dark:hover:bg-gray-600 transition">
                        查看原始 Feed
                    </a>
                </div>
                <p class="text-sm text-gray-500 dark:text-gray-400 mt-4">
                    最后更新：<time><xsl:value-of select="substring($feed_updated, 1, 10)"/></time>
                </p>
            </header>

            <!-- 文章列表 -->
            <div class="space-y-10">
                <xsl:for-each select="/atom:feed/atom:entry">
                    <xsl:sort select="atom:updated" order="descending"/>
                    <article class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg border border-gray-200 dark:border-gray-700 overflow-hidden hover:shadow-xl transition-shadow">
                        <div class="p-8">
                            <!-- 标题与元信息 -->
                            <header class="mb-6">
                                <h2 class="text-2xl md:text-3xl font-bold mb-3">
                                    <a href="{atom:link[@rel='alternate']/@href}" target="_blank" class="text-gray-900 dark:text-gray-100 hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                                        <xsl:value-of select="atom:title"/>
                                    </a>
                                </h2>
                                <div class="flex flex-wrap items-center gap-4 text-sm text-gray-500 dark:text-gray-400">
                                    <time datetime="{atom:published}">
                                        <xsl:value-of select="substring(atom:published, 1, 10)"/>
                                    </time>
                                    <xsl:if test="atom:updated != atom:published">
                                        <span>（更新：<xsl:value-of select="substring(atom:updated, 1, 10)"/>）</span>
                                    </xsl:if>
                                    <xsl:if test="atom:category">
                                        <div class="flex flex-wrap gap-2">
                                            <xsl:for-each select="atom:category">
                                                <span class="px-3 py-1 bg-gray-100 dark:bg-gray-700 rounded-full text-xs font-medium">
                                                    <xsl:value-of select="@term"/>
                                                </span>
                                            </xsl:for-each>
                                        </div>
                                    </xsl:if>
                                </div>
                            </header>

                            <!-- 内容主体（关键修复） -->
                            <div class="prose prose-lg dark:prose-invert max-w-none">
                                <xsl:choose>
                                    <!-- 优先使用完整 content（Hexo 通常提供完整 HTML） -->
                                    <xsl:when test="atom:content">
                                        <xsl:value-of select="atom:content" disable-output-escaping="yes"/>
                                    </xsl:when>
                                    <!-- 备选：使用 summary（通常是截断的，已转义 HTML） -->
                                    <xsl:when test="atom:summary">
                                        <xsl:value-of select="atom:summary" disable-output-escaping="yes"/>
                                    </xsl:when>
                                    <!-- 都没有内容的情况 -->
                                    <xsl:otherwise>
                                        <p class="text-gray-500 italic">此文章暂无预览内容。</p>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>

                            <!-- 阅读原文链接 -->
                            <div class="mt-8 pt-6 border-t border-gray-200 dark:border-gray-700">
                                <a href="{atom:link[@rel='alternate']/@href}" target="_blank" class="inline-flex items-center text-indigo-600 dark:text-indigo-400 font-medium hover:underline">
                                    阅读完整文章 <span class="ml-2 text-xl">→</span>
                                </a>
                            </div>
                        </div>
                    </article>
                </xsl:for-each>
            </div>

            <!-- 页脚 -->
            <footer class="mt-16 text-center text-sm text-gray-500 dark:text-gray-400">
                <p>Generated by Hexo • Styled with XSLT + Tailwind CSS</p>
                <p class="mt-2">直接在浏览器打开 atom.xml 即可获得美观的阅读体验</p>
            </footer>
        </div>
    </body>
</html>
</xsl:template>
</xsl:stylesheet>
