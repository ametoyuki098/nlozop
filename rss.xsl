<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:atom="http://www.w3.org/2005/Atom" 
                xmlns:media="http://search.yahoo.com/mrss/"
                exclude-result-prefixes="atom media">
    
    <xsl:output method="html" encoding="utf-8" indent="yes"/>
    
    <xsl:template match="/">
        <html lang="zh-CN">
        <head>
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <title><xsl:value-of select="/atom:feed/atom:title"/> - RSS Feed</title>
            <style>
                /* --- 基础 CSS 变量 --- */
                :root {
                    --primary-color: #2563eb;
                    --bg-color: #f8fafc;
                    --card-bg: #ffffff;
                    --text-main: #1e293b;
                    --text-secondary: #64748b;
                    --border-color: #e2e8f0;
                    --spacing: 1.5rem;
                }

                /* --- 全局样式 --- */
                body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                    background-color: var(--bg-color);
                    color: var(--text-main);
                    margin: 0;
                    padding: 0;
                    line-height: 1.6;
                }

                /* --- 布局容器 --- */
                .container {
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 2rem 1rem;
                }

                /* --- 头部区域 --- */
                header {
                    text-align: center;
                    margin-bottom: 3rem;
                    padding-bottom: 2rem;
                    border-bottom: 1px solid var(--border-color);
                }
                
                header h1 {
                    font-size: 2.25rem;
                    margin: 0 0 0.5rem 0;
                    color: var(--text-main);
                }

                header p {
                    color: var(--text-secondary);
                    font-size: 1.1rem;
                    margin: 0;
                }

                header .meta {
                    margin-top: 1rem;
                    font-size: 0.9rem;
                    color: #94a3b8;
                }

                header a {
                    color: var(--primary-color);
                    text-decoration: none;
                }

                /* --- 订阅按钮 --- */
                .subscribe-btn {
                    display: inline-block;
                    margin-top: 1rem;
                    padding: 0.5rem 1rem;
                    background-color: var(--primary-color);
                    color: white;
                    border-radius: 6px;
                    text-decoration: none;
                    font-weight: 500;
                    font-size: 0.9rem;
                }
                .subscribe-btn:hover {
                    background-color: #1d4ed8;
                }

                /* --- 文章列表 --- */
                .entries {
                    display: grid;
                    gap: 2rem;
                }

                /* --- 单个文章卡片 --- */
                .entry {
                    background: var(--card-bg);
                    border-radius: 12px;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
                    overflow: hidden;
                    border: 1px solid var(--border-color);
                    transition: transform 0.2s ease, box-shadow 0.2s ease;
                }

                .entry:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.025);
                }

                /* --- 图片样式 --- */
                .entry-image-container {
                    width: 100%;
                    height: 240px;
                    background-color: #f1f5f9;
                    overflow: hidden;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .entry-image {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                /* --- 内容区域 --- */
                .entry-content {
                    padding: 1.5rem;
                }

                .entry-title {
                    margin: 0 0 0.75rem 0;
                    font-size: 1.5rem;
                    font-weight: 700;
                }

                .entry-title a {
                    color: var(--text-main);
                    text-decoration: none;
                }

                .entry-title a:hover {
                    color: var(--primary-color);
                }

                .entry-summary {
                    color: var(--text-secondary);
                    margin-bottom: 1rem;
                    font-size: 1rem;
                    display: -webkit-box;
                    -webkit-line-clamp: 3;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                }
                
                /* 如果没有图片，增加顶部内边距以保持平衡 */
                .no-image .entry-content {
                    padding-top: 1.5rem;
                }

                /* --- 底部元数据 (日期、标签) --- */
                .entry-meta {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    font-size: 0.875rem;
                    color: #94a3b8;
                    margin-top: 1rem;
                    padding-top: 1rem;
                    border-top: 1px solid #f1f5f9;
                }

                .entry-date {
                    font-feature-settings: "tnum";
                }

                /* --- 页脚 --- */
                footer {
                    text-align: center;
                    margin-top: 4rem;
                    padding-bottom: 2rem;
                    color: #94a3b8;
                    font-size: 0.875rem;
                }
                
                /* 简单的内容图片修复 */
                .entry-summary img {
                    max-width: 100%;
                    height: auto;
                    border-radius: 6px;
                    margin: 10px 0;
                }

                /* --- 移动端优化 --- */
                @media (max-width: 600px) {
                    .container {
                        padding: 1rem;
                    }
                    header h1 {
                        font-size: 1.75rem;
                    }
                    .entry-image-container {
                        height: 180px;
                    }
                    .entry-content {
                        padding: 1.25rem;
                    }
                    .entry-title {
                        font-size: 1.25rem;
                    }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <!-- 头部信息 -->
                <header>
                    <h1>
                        <xsl:choose>
                            <xsl:when test="/atom:feed/atom:logo">
                                <img src="{/atom:feed/atom:logo}" style="height: 48px; vertical-align: middle; border-radius: 6px; margin-right: 10px;"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:value-of select="/atom:feed/atom:title"/>
                    </h1>
                    <p><xsl:value-of select="/atom:feed/atom:subtitle"/></p>
                    <div class="meta">
                        更新时间: <xsl:value-of select="/atom:feed/atom:updated"/>
                    </div>
                    <a href="{/atom:feed/atom:link[@rel='alternate']/@href}" class="subscribe-btn">访问网站主页</a>
                </header>

                <!-- 文章列表 -->
                <main class="entries">
                    <xsl:for-each select="/atom:feed/atom:entry">
                        <article class="entry">
                            <!-- 图片处理逻辑：优先查找 enclosure 或 media:thumbnail，其次尝试从 summary 中提取 img 标签 -->
                            <xsl:variable name="entry-image">
                                <xsl:choose>
                                    <!-- 1. 标准 Atom enclosure (通常用于播客封面或特色图) -->
                                    <xsl:when test="atom:link[@rel='enclosure']">
                                        <xsl:value-of select="atom:link[@rel='enclosure']/@href"/>
                                    </xsl:when>
                                    <!-- 2. Yahoo Media Namespace (media:thumbnail 或 media:content) -->
                                    <xsl:when test="media:thumbnail">
                                        <xsl:value-of select="media:thumbnail/@url"/>
                                    </xsl:when>
                                    <xsl:when test="media:content">
                                        <xsl:value-of select="media:content/@url"/>
                                    </xsl:when>
                                    <!-- 3. 如果没有特定标签，这里可以留空，依靠摘要中的HTML -->
                                    <xsl:otherwise></xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>

                            <!-- 如果找到了独立图片链接，渲染顶部大图 -->
                            <xsl:if test="$entry-image != ''">
                                <div class="entry-image-container">
                                    <img src="{$entry-image}" class="entry-image" alt="封面图" loading="lazy"/>
                                </div>
                            </xsl:if>

                            <div class="entry-content">
                                <h2 class="entry-title">
                                    <a href="{atom:link[@rel='alternate']/@href}" target="_blank">
                                        <xsl:value-of select="atom:title"/>
                                    </a>
                                </h2>
                                
                                <!-- 摘要内容：直接禁用转义以支持 HTML 图片渲染 -->
                                <div class="entry-summary">
                                    <xsl:value-of select="atom:content" disable-output-escaping="yes"/>
                                    <!-- 如果没有 content，尝试显示 summary -->
                                    <xsl:if test="not(atom:content)">
                                        <xsl:value-of select="atom:summary" disable-output-escaping="yes"/>
                                    </xsl:if>
                                </div>

                                <div class="entry-meta">
                                    <span class="entry-date">
                                        <xsl:value-of select="atom:published"/>
                                    </span>
                                    <!-- 作者 -->
                                    <xsl:if test="atom:author/atom:name">
                                        <span>By <xsl:value-of select="atom:author/atom:name"/></span>
                                    </xsl:if>
                                </div>
                            </div>
                        </article>
                    </xsl:for-each>
                </main>

                <footer>
                    <!-- 修复部分：将 HTML 实体 &bull; 替换为直接符号 • -->
                    <p>Generated by Atom Feed • Styled with XSLT</p>
                    <p>
                        <a href="{/atom:feed/atom:link[@rel='self']/@href}" style="color: #94a3b8;">View Raw XML</a>
                    </p>
                </footer>
            </div>
        </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

