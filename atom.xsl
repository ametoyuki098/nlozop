<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
  <!-- 输出配置：响应式HTML + UTF-8编码 -->
  <xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes"/>

  <!-- 提取Feed核心信息变量 -->
  <xsl:variable name="feedTitle" select="/atom:feed/atom:title | /rss/channel/title"/>
  <xsl:variable name="feedDesc" select="/atom:feed/atom:subtitle | /rss/channel/description"/>
  <xsl:variable name="feedLink" select="/atom:feed/atom:link[@rel='alternate']/@href | /rss/channel/link"/>

  <xsl:template match="/">
    <html lang="en" class="dark scroll-smooth">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <!-- 引入Tailwind CSS CDN（无需本地托管） -->
        <script src="https://cdn.tailwindcss.com"></script>
        <title><xsl:value-of select="$feedTitle"/></title>
        <!-- 自定义配置：颜色+字体 -->
        <script>
          tailwind.config = {
            darkMode: 'class',
            theme: {
              extend: {
                colors: {
                  primary: '#4f46e5',
                  accent: '#e879f9',
                  darkBg: '#090915',
                  darkCard: '#121220'
                },
                fontFamily: {
                  sans: ['Inter', 'system-ui', 'sans-serif']
                }
              }
            }
          }
        </script>
        <style type="text/tailwindcss">
          @layer utilities {
            .text-gradient {
              background-clip: text;
              -webkit-background-clip: text;
              -webkit-text-fill-color: transparent;
            }
            .link-animated::before {
              content: '';
              position: absolute;
              bottom: -1px;
              left: 0;
              width: 0;
              height: 1px;
              transition: width 0.2s ease;
            }
            .link-animated:hover::before {
              width: 100%;
            }
          }
        </style>
      </head>
      <body class="bg-darkBg text-gray-200 min-h-screen font-sans">
        <!-- 主容器：响应式居中 -->
        <main class="container mx-auto px-4 py-8 max-w-4xl">
          <!-- Feed头部信息 -->
          <header class="mb-8 pb-6 border-b border-gray-800">
            <a href="{$feedLink}" target="_blank" rel="noopener noreferrer" class="flex items-center gap-2">
              <!-- RSS图标 -->
              <svg class="w-8 h-8 text-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 19a1 1 0 1 0 2 0 1 1 0 1 0-2 0M4 4a16 16 0 0 1 16 16M4 11a9 9 0 0 1 9 9"/>
              </svg>
              <!-- 渐变标题 -->
              <h1 class="text-2xl md:text-3xl font-bold bg-gradient-to-r from-primary to-accent text-gradient">
                <xsl:value-of select="$feedTitle" disable-output-escaping="yes"/>
              </h1>
            </a>
            <!-- Feed描述 -->
            <p class="mt-4 text-gray-400 text-lg">
              <xsl:value-of select="$feedDesc" disable-output-escaping="yes"/>
            </p>
            <!-- 订阅工具快速链接（动态生成） -->
            <div class="mt-6 flex flex-wrap gap-3" id="subscribeLinks">
              <span class="text-sm text-gray-500">快速订阅：</span>
              <a data-href="https://feedly.com/i/subscription/feed/" class="link-animated relative text-primary hover:text-primary/80 text-sm font-medium">Feedly</a>
              <a data-href="https://www.inoreader.com/feed/" class="link-animated relative text-primary hover:text-primary/80 text-sm font-medium">Inoreader</a>
              <a data-href="https://www.newsblur.com/?url=" class="link-animated relative text-primary hover:text-primary/80 text-sm font-medium">Newsblur</a>
              <a data-href="follow://add?url=" class="link-animated relative text-primary hover:text-primary/80 text-sm font-medium">Follow</a>
              <a data-href="feed:" data-raw="true" class="link-animated relative text-primary hover:text-primary/80 text-sm font-medium">RSS Reader</a>
            </div>
          </header>

          <!-- 条目列表 -->
          <section class="space-y-6">
            <!-- 适配Atom Feed -->
            <xsl:for-each select="/atom:feed/atom:entry">
              <article class="bg-darkCard rounded-lg p-5 hover:shadow-lg hover:shadow-primary/5 transition-shadow">
                <details class="group">
                  <summary class="flex flex-col md:flex-row md:items-center justify-between cursor-pointer list-none">
                    <h2 class="text-lg md:text-xl font-semibold text-white group-hover:text-primary transition-colors">
                      <xsl:value-of select="atom:title" disable-output-escaping="yes"/>
                    </h2>
                    <time class="mt-2 md:mt-0 text-sm text-gray-500">
                      <xsl:value-of select="substring(atom:updated, 1, 10)"/>
                    </time>
                  </summary>
                  <div class="mt-4 pt-4 border-t border-gray-800 text-gray-300">
                    <!-- 显示摘要/内容 -->
                    <p class="mb-4">
                      <xsl:choose>
                        <xsl:when test="atom:summary"><xsl:value-of select="atom:summary" disable-output-escaping="yes"/></xsl:when>
                        <xsl:when test="atom:content"><xsl:value-of select="atom:content" disable-output-escaping="yes"/></xsl:when>
                        <xsl:otherwise>无摘要信息</xsl:otherwise>
                      </xsl:choose>
                    </p>
                    <!-- 阅读更多链接 -->
                    <a href="{atom:link/@href}" target="_blank" rel="noopener noreferrer" class="inline-flex items-center gap-1 text-primary hover:text-primary/80 font-medium">
                      阅读原文 →
                    </a>
                  </div>
                </details>
              </article>
            </xsl:for-each>

            <!-- 适配RSS Feed -->
            <xsl:for-each select="/rss/channel/item">
              <article class="bg-darkCard rounded-lg p-5 hover:shadow-lg hover:shadow-primary/5 transition-shadow">
                <details class="group">
                  <summary class="flex flex-col md:flex-row md:items-center justify-between cursor-pointer list-none">
                    <h2 class="text-lg md:text-xl font-semibold text-white group-hover:text-primary transition-colors">
                      <xsl:value-of select="title" disable-output-escaping="yes"/>
                    </h2>
                    <time class="mt-2 md:mt-0 text-sm text-gray-500">
                      <xsl:value-of select="substring(pubDate, 1, 16)"/>
                    </time>
                  </summary>
                  <div class="mt-4 pt-4 border-t border-gray-800 text-gray-300">
                    <p class="mb-4">
                      <xsl:value-of select="description" disable-output-escaping="yes"/>
                    </p>
                    <a href="{link}" target="_blank" rel="noopener noreferrer" class="inline-flex items-center gap-1 text-primary hover:text-primary/80 font-medium">
                      阅读原文 →
                    </a>
                  </div>
                </details>
              </article>
            </xsl:for-each>
          </section>

          <!-- 页脚 -->
          <footer class="mt-12 pt-6 border-t border-gray-800 text-center text-gray-500 text-sm">
            <p>由 <a href="https://rss.beauty" target="_blank" rel="noopener noreferrer" class="text-primary hover:underline">RSS.Beauty</a> 样式优化 | 支持 Atom/RSS 订阅流</p>
          </footer>
        </main>

        <!-- 动态生成订阅链接脚本 -->
        <script>
          document.addEventListener('DOMContentLoaded', () => {
            const feedUrl = new URL(location.href).searchParams.get('url') || location.href;
            document.querySelectorAll('[data-href]').forEach(link => {
              const raw = link.hasAttribute('data-raw');
              link.href = raw 
                ? link.getAttribute('data-href') + feedUrl 
                : link.getAttribute('data-href') + encodeURIComponent(feedUrl);
            });
          });
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

