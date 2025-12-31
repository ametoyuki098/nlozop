<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Feed 信息 -->
  <xsl:variable name="feedTitle" select="/atom:feed/atom:title"/>
  <xsl:variable name="feedDesc" select="/atom:feed/atom:subtitle"/>
  <xsl:variable name="feedLink" select="/atom:feed/atom:link[@rel='alternate']/@href"/>

  <!-- ① 获取 HTML 内容（优先 content，其次 summary） -->
  <xsl:template name="get-html">
    <xsl:choose>
      <xsl:when test="atom:content[@type='html']">
        <xsl:value-of select="atom:content" disable-output-escaping="yes"/>
      </xsl:when>
      <xsl:when test="atom:summary[@type='html']">
        <xsl:value-of select="atom:summary" disable-output-escaping="yes"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="atom:summary"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ② 去除 HTML 标签（XSLT 1.0 递归版） -->
  <xsl:template name="strip-tags">
    <xsl:param name="text"/>

    <xsl:choose>
      <xsl:when test="contains($text, '&lt;')">
        <!-- 输出标签前的文本 -->
        <xsl:value-of select="substring-before($text, '&lt;')"/>

        <!-- 递归处理标签后的文本 -->
        <xsl:call-template name="strip-tags">
          <xsl:with-param name="text" select="substring-after($text, '&gt;')"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ③ 截断文本（XSLT 1.0 版本） -->
  <xsl:template name="truncate">
    <xsl:param name="text"/>
    <xsl:param name="length"/>

    <xsl:choose>
      <xsl:when test="string-length($text) &gt; $length">
        <xsl:value-of select="substring($text, 1, $length)"/>
        <xsl:text>...</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 页面主体 -->
  <xsl:template match="/">
    <html lang="en" class="scroll-smooth">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <script src="https://cdn.tailwindcss.com"></script>
        <title><xsl:value-of select="$feedTitle" disable-output-escaping="yes"/></title>

        <style>
          .summary-img {
            max-width: 100%;
            height: auto;
            border-radius: 4px;
            margin: 8px 0;
            display: block;
          }
        </style>
      </head>

      <body class="min-h-screen font-sans bg-cover bg-fixed bg-center"
      style="background-image: url('https://87c80b6.webp.li/i/2025/12/31/st6c2h-9mcj.png');">

        <div class="fixed inset-0 bg-white/20 z-0"></div>

        <main class="container mx-auto px-4 py-8 max-w-4xl relative z-10 bg-white/70 backdrop-blur rounded-xl shadow-xl">

          <!-- Header -->
          <header class="mb-8 pb-6 border-b border-gray-200/80">
            <a href="{$feedLink}" target="_blank" class="flex items-center gap-2">
              <h1 class="text-2xl md:text-3xl font-bold text-indigo-600">
                <xsl:value-of select="$feedTitle" disable-output-escaping="yes"/>
              </h1>
            </a>
            <p class="mt-4 text-gray-700 text-lg">
              <xsl:value-of select="$feedDesc" disable-output-escaping="yes"/>
            </p>
          </header>

          <!-- Feed Entries -->
          <section class="space-y-6">
            <xsl:for-each select="/atom:feed/atom:entry">
              <article class="bg-white/80 backdrop-blur rounded-lg p-5 border border-gray-200/50">

                <details class="group">
                  <summary class="flex items-center justify-between cursor-pointer list-none">
                    <h2 class="text-lg md:text-xl font-semibold text-gray-900 group-hover:text-indigo-600 transition-colors">
                      <xsl:value-of select="atom:title" disable-output-escaping="yes"/>
                    </h2>
                    <time class="text-sm text-gray-500">
                      <xsl:value-of select="substring(atom:updated, 1, 10)"/>
                    </time>
                  </summary>

                  <div class="mt-4 pt-4 border-t border-gray-200/50 text-gray-700">

                    <!-- 获取 HTML 内容 -->
                    <xsl:variable name="html">
                      <xsl:call-template name="get-html"/>
                    </xsl:variable>

                    <!-- 显示 HTML（包含图片） -->
                    <div class="summary-html mb-4">
                      <xsl:value-of select="$html" disable-output-escaping="yes"/>
                    </div>

                    <!-- 生成纯文本摘要 -->
                    <xsl:variable name="plain">
                      <xsl:call-template name="strip-tags">
                        <xsl:with-param name="text" select="$html"/>
                      </xsl:call-template>
                    </xsl:variable>

                    <!-- 截断摘要 -->
                    <p class="summary-text text-gray-600">
                      <xsl:call-template name="truncate">
                        <xsl:with-param name="text" select="$plain"/>
                        <xsl:with-param name="length" select="200"/>
                      </xsl:call-template>
                    </p>

                    <a href="{atom:link/@href}" target="_blank"
                      class="inline-flex items-center gap-1 text-indigo-600 hover:text-indigo-400 font-medium mt-3">
                      阅读原文 →
                    </a>

                  </div>
                </details>

              </article>
            </xsl:for-each>
          </section>

          <footer class="mt-12 pt-6 border-t border-gray-200/80 text-center text-gray-500 text-sm">
            <p>由 <a href="https://rss.beauty" target="_blank" class="text-indigo-600 hover:underline">RSS.Beauty</a> 样式优化</p>
          </footer>

        </main>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

