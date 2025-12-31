<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom">

  <xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes"/>

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

  <!-- ② 截断纯文本摘要（不破坏 HTML） -->
  <xsl:template name="truncate-html-text">
    <xsl:param name="html"/>
    <xsl:param name="length" select="200"/>

    <!-- 去掉所有 HTML 标签 -->
    <xsl:variable name="text" select="replace($html, '&lt;[^&gt;]+&gt;', '')"/>

    <xsl:choose>
      <xsl:when test="string-length($text) > $length">
        <xsl:value-of select="concat(substring($text, 1, $length), '...')"/>
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

        <script>
          tailwind.config = {
            theme: {
              extend: {
                colors: {
                  primary: '#4f46e5',
                  accent: '#e879f9',
                  lightBg: 'rgba(250, 250, 252, 0.8)',
                  lightCard: 'rgba(255, 255, 255, 0.9)'
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
            .summary-img {
              max-width: 100%;
              height: auto;
              border-radius: 4px;
              margin: 8px 0;
              display: block;
            }
          }
        </style>
      </head>

      <body class="min-h-screen font-sans bg-cover bg-fixed bg-center"
      style="background-image: url('https://87c80b6.webp.li/i/2025/12/31/st6c2h-9mcj.png');">

        <div class="fixed inset-0 bg-white/20 z-0"></div>

        <main class="container mx-auto px-4 py-8 max-w-4xl relative z-10 bg-lightBg bg-blur rounded-xl shadow-xl">

          <!-- Header -->
          <header class="mb-8 pb-6 border-b border-gray-200/80">
            <a href="{$feedLink}" target="_blank" class="flex items-center gap-2">
              <h1 class="text-2xl md:text-3xl font-bold bg-gradient-to-r from-primary to-accent text-gradient">
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
              <article class="bg-lightCard bg-blur rounded-lg p-5 border border-gray-200/50">

                <details class="group">
                  <summary class="flex items-center justify-between cursor-pointer list-none">
                    <h2 class="text-lg md:text-xl font-semibold text-gray-900 group-hover:text-primary transition-colors">
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

                    <!-- 显示截断后的纯文本摘要 -->
                    <p class="summary-text text-gray-600">
                      <xsl:call-template name="truncate-html-text">
                        <xsl:with-param name="html" select="$html"/>
                        <xsl:with-param name="length" select="200"/>
                      </xsl:call-template>
                    </p>

                    <a href="{atom:link/@href}" target="_blank"
                      class="inline-flex items-center gap-1 text-primary hover:text-primary/80 font-medium mt-3">
                      阅读原文 →
                    </a>

                  </div>
                </details>

              </article>
            </xsl:for-each>
          </section>

          <footer class="mt-12 pt-6 border-t border-gray-200/80 text-center text-gray-500 text-sm">
            <p>由 <a href="https://rss.beauty" target="_blank" class="text-primary hover:underline">RSS.Beauty</a> 样式优化</p>
          </footer>

        </main>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

