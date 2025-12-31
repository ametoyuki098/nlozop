<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>

  <!-- 仅提取Atom Feed核心信息 -->
  <xsl:variable name="feedTitle" select="/atom:feed/atom:title"/>
  <xsl:variable name="feedDesc" select="/atom:feed/atom:subtitle"/>
  <xsl:variable name="feedLink" select="/atom:feed/atom:link[@rel='alternate']/@href | /atom:feed/atom:link[not(@rel)]/@href"/>

  <xsl:template match="/">
    <html class="dark scroll-smooth">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta name="referrer" content="unsafe-url"/>
        <title><xsl:value-of select="$feedTitle"/></title>
        <!-- 复用参考文档的Tailwind样式体系，确保样式兼容 -->
        <style>
          *,:after,:before{--tw-border-spacing-x:0;--tw-border-spacing-y:0;--tw-translate-x:0;--tw-translate-y:0;--tw-rotate:0;--tw-skew-x:0;--tw-skew-y:0;--tw-scale-x:1;--tw-scale-y:1;--tw-pan-x: ;--tw-pan-y: ;--tw-pinch-zoom: ;--tw-scroll-snap-strictness:proximity;--tw-gradient-from-position: ;--tw-gradient-via-position: ;--tw-gradient-to-position: ;--tw-ordinal: ;--tw-slashed-zero: ;--tw-numeric-figure: ;--tw-numeric-spacing: ;--tw-numeric-fraction: ;--tw-ring-inset: ;--tw-ring-offset-width:0px;--tw-ring-offset-color:#fff;--tw-ring-color:rgba(59,130,246,.5);--tw-ring-offset-shadow:0 0 #0000;--tw-ring-shadow:0 0 #0000;--tw-shadow:0 0 #0000;--tw-shadow-colored:0 0 #0000;--tw-blur: ;--tw-brightness: ;--tw-contrast: ;--tw-grayscale: ;--tw-hue-rotate: ;--tw-invert: ;--tw-saturate: ;--tw-sepia: ;--tw-drop-shadow: ;--tw-backdrop-blur: ;--tw-backdrop-brightness: ;--tw-backdrop-contrast: ;--tw-backdrop-grayscale: ;--tw-backdrop-hue-rotate: ;--tw-backdrop-invert: ;--tw-backdrop-opacity: ;--tw-backdrop-saturate: ;--tw-backdrop-sepia: ;--tw-contain-size: ;--tw-contain-layout: ;--tw-contain-paint: ;--tw-contain-style: }
          ::backdrop{--tw-border-spacing-x:0;--tw-border-spacing-y:0;--tw-translate-x:0;--tw-translate-y:0;--tw-rotate:0;--tw-skew-x:0;--tw-skew-y:0;--tw-scale-x:1;--tw-scale-y:1;--tw-pan-x: ;--tw-pan-y: ;--tw-pinch-zoom: ;--tw-scroll-snap-strictness:proximity;--tw-gradient-from-position: ;--tw-gradient-via-position: ;--tw-gradient-to-position: ;--tw-ordinal: ;--tw-slashed-zero: ;--tw-numeric-figure: ;--tw-numeric-spacing: ;--tw-numeric-fraction: ;--tw-ring-inset: ;--tw-ring-offset-width:0px;--tw-ring-offset-color:#fff;--tw-ring-color:rgba(59,130,246,.5);--tw-ring-offset-shadow:0 0 #0000;--tw-ring-shadow:0 0 #0000;--tw-shadow:0 0 #0000;--tw-shadow-colored:0 0 #0000;--tw-blur: ;--tw-brightness: ;--tw-contrast: ;--tw-grayscale: ;--tw-hue-rotate: ;--tw-invert: ;--tw-saturate: ;--tw-sepia: ;--tw-drop-shadow: ;--tw-backdrop-blur: ;--tw-backdrop-brightness: ;--tw-backdrop-contrast: ;--tw-backdrop-grayscale: ;--tw-backdrop-hue-rotate: ;--tw-backdrop-invert: ;--tw-backdrop-opacity: ;--tw-backdrop-saturate: ;--tw-backdrop-sepia: ;--tw-contain-size: ;--tw-contain-layout: ;--tw-contain-paint: ;--tw-contain-style: }
          /*! tailwindcss v3.4.17 | MIT License | https://tailwindcss.com */
          *,:after,:before{box-sizing:border-box;border:0 solid #e7e7f0}:after,:before{--tw-content:""}:host,html{line-height:1.5;-webkit-text-size-adjust:100%;-moz-tab-size:4;-o-tab-size:4;tab-size:4;font-family:ui-sans-serif,system-ui,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol,Noto Color Emoji;font-feature-settings:normal;font-variation-settings:normal;-webkit-tap-highlight-color:transparent}body{margin:0;line-height:inherit}
          /* 核心：添加图片适配样式，确保图片不溢出且居中 */
          .summary-img {max-width:100%;height:auto;margin:0.5rem 0;border-radius:0.5rem;display:block}
          /* 复用参考文档的链接、文本、布局样式 */
          .link{--tw-text-opacity:1;color:rgb(129 140 248/var(--tw-text-opacity,1));transition-property:color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,-webkit-backdrop-filter;transition-property:color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,backdrop-filter;transition-property:color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,backdrop-filter,-webkit-backdrop-filter;transition-timing-function:cubic-bezier(.4,0,.2,1);transition-duration:.15s}
          .link.variant-animated{position:relative}.link.variant-animated:before{position:absolute;left:0;right:0;bottom:0;height:1px;transform-origin:right;--tw-scale-x:0;transform:translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y));transition-property:color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,-webkit-backdrop-filter;transition-property:color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,backdrop-filter;transition-property:color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,backdrop-filter,-webkit-backdrop-filter;transition-timing-function:cubic-bezier(.4,0,.2,1);content:var(--tw-content);transition-duration:.2s}
          .link.variant-animated:hover:before{transform-origin:left;content:var(--tw-content);--tw-scale-x:1;transform:translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skewX(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))}
          .text-title{color:#fff}.text-body{color:#d6d6e1}.text-caption{color:#6e6e81}
          .container{width:100%}@media (min-width:640px){.container{max-width:640px}}@media (min-width:768px){.container{max-width:768px}}@media (min-width:1024px){.container{max-width:1024px}}
          .flex{display:flex}.items-center{align-items:center}.justify-between{justify-content:space-between}.gap-2{gap:.5rem}.my-6{margin-top:1.5rem;margin-bottom:1.5rem}.p-4{padding:1rem}.space-y-2>:not([hidden])~:not([hidden]){--tw-space-y-reverse:0;margin-top:calc(.5rem*(1 - var(--tw-space-y-reverse)));margin-bottom:calc(.5rem*var(--tw-space-y-reverse))}.space-y-6>:not([hidden])~:not([hidden]){--tw-space-y-reverse:0;margin-top:calc(1.5rem*(1 - var(--tw-space-y-reverse)));margin-bottom:calc(1.5rem*var(--tw-space-y-reverse))}
          .bg-gray-925{background-color:rgb(9 9 21)}.min-h-screen{min-height:100vh}.text-2xl{font-size:1.5rem;line-height:2rem}.text-lg{font-size:1.125rem;line-height:1.75rem}.text-sm{font-size:.875rem;line-height:1.25rem}.font-bold{font-weight:700}.font-semibold{font-weight:600}
        </style>
      </head>
      <!-- 复用参考文档的页面布局结构 -->
      <body class="bg-gray-925 min-h-screen font-sans leading-normal antialiased">
        <main class="container mx-auto flex min-h-screen max-w-screen-lg flex-col px-4 py-6">
          <!-- 头部信息 -->
          <header class="space-y-2 pt-2">
            <a title="{$title}" href="{$feedLink}" target="_blank" rel="noopener noreferrer">
              <h1 class="flex text-2xl">
                <!-- RSS图标 -->
                <span class="inline-block w-8 h-8 mr-2 bg-current" style="-webkit-mask-image:url('data:image/svg+xml;charset=utf-8,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'24\' height=\'24\'%3E%3Cpath fill=\'none\' stroke=\'%23000\' stroke-linecap=\'round\' stroke-linejoin=\'round\' stroke-width=\'2\' d=\'M4 19a1 1 0 1 0 2 0 1 1 0 1 0-2 0M4 4a16 16 0 0 1 16 16M4 11a9 9 0 0 1 9 9\'/%3E%3C/svg%3E');mask-image:url('data:image/svg+xml;charset=utf-8,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'24\' height=\'24\'%3E%3Cpath fill=\'none\' stroke=\'%23000\' stroke-linecap=\'round\' stroke-linejoin=\'round\' stroke-width=\'2\' d=\'M4 19a1 1 0 1 0 2 0 1 1 0 1 0-2 0M4 4a16 16 0 0 1 16 16M4 11a9 9 0 0 1 9 9\'/%3E%3C/svg%3E');"></span>
                <!-- 渐变标题 -->
                <span class="from-primary-600 to-accent-400 inline-block bg-gradient-to-r bg-clip-text font-bold text-transparent" style="background-image:linear-gradient(to right,#4f46e5,rgba(79,70,229,0)),linear-gradient(to right,#4f46e5,#e879f9);">
                  <xsl:value-of select="$feedTitle" disable-output-escaping="yes"/>
                </span>
              </h1>
            </a>
            <!-- Feed描述 -->
            <p class="text-body pt-2 text-lg py-4">
              <xsl:value-of select="$feedDesc" disable-output-escaping="yes"/>
            </p>
            <!-- 订阅链接（复用动态生成逻辑） -->
            <p class="text-body text-sm hidden" id="subscribe-links">
              You can subscribe this RSS feed by
              <a class="link intent-neutral variant-animated font-bold" title="Feedly" data-href="https://feedly.com/i/subscription/feed/" target="_blank" rel="noopener noreferrer">Feedly</a>,
              <a class="link intent-neutral variant-animated font-bold" title="Inoreader" data-href="https://www.inoreader.com/feed/" target="_blank" rel="noopener noreferrer">Inoreader</a>,
              <a class="link intent-neutral variant-animated font-bold" title="Newsblur" data-href="https://www.newsblur.com/?url=" target="_blank" rel="noopener noreferrer">Newsblur</a>
            </p>
            <script>
              // 动态生成订阅链接（复用参考文档逻辑）
              document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('a[data-href]').forEach(function (a) {
                  const url = new URL(location.href)
                  const feed = url.searchParams.get('url') || location.href
                  a.href = a.getAttribute('data-href') + encodeURIComponent(feed)
                })
                document.getElementById('subscribe-links').classList.remove('hidden')
              })
            </script>
          </header>

          <hr class="my-6"/>

          <!-- 核心：Atom条目列表（修复图片显示） -->
          <section class="flex-1 space-y-6 p-1">
            <xsl:for-each select="/atom:feed/atom:entry">
              <article class="space-y-2">
                <details>
                  <!-- 条目标题与时间 -->
                  <summary class="max-w-full truncate">
                    <xsl:if test="atom:title">
                      <h2 class="text-title inline cursor-pointer text-lg font-semibold">
                        <xsl:value-of select="atom:title" disable-output-escaping="yes"/>
                      </h2>
                    </xsl:if>
                    <xsl:if test="atom:updated">
                      <time class="text-caption ml-4 mt-1 block text-sm">
                        <xsl:value-of select="substring(atom:updated, 1, 10)"/>
                      </time>
                    </xsl:if>
                  </summary>
                  <!-- 条目摘要（关键：复用参考文档的disable-output-escaping，确保图片标签解析） -->
                  <div class="text-body px-4 py-2">
                    <p class="my-2">
                      <xsl:choose>
                        <!-- 1. 优先显示summary，启用disable-output-escaping让<img>标签正常渲染 -->
                        <xsl:when test="atom:summary">
                          <xsl:value-of select="atom:summary" disable-output-escaping="yes"/>
                        </xsl:when>
                        <!-- 2. 无summary时显示content，同样保留HTML标签解析 -->
                        <xsl:when test="atom:content">
                          <xsl:value-of select="atom:content" disable-output-escaping="yes"/>
                        </xsl:when>
                        <xsl:otherwise>无摘要内容</xsl:otherwise>
                      </xsl:choose>
                    </p>
                    <!-- 阅读原文链接 -->
                    <xsl:if test="atom:link/@href">
                      <a class="link variant-animated intent-neutral font-bold" href="{atom:link/@href}" target="_blank" rel="noopener noreferrer">
                        Read More
                      </a>
                    </xsl:if>
                  </div>
                </details>
              </article>
            </xsl:for-each>
          </section>

          <hr class="my-6"/>

          <!-- 页脚 -->
          <footer>
            <div class="flex flex-col justify-between space-y-4 md:flex-row md:space-y-0">
              <div class="space-y-4">
                <a class="flex text-2xl font-bold" href="https://rss.beauty" title="RSS.Beauty">
                  <span class="text-title inline-block w-8 h-8 mr-1 bg-current" style="-webkit-mask-image:url('data:image/svg+xml;charset=utf-8,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'24\' height=\'24\'%3E%3Cpath fill=\'none\' stroke=\'%23000\' stroke-linecap=\'round\' stroke-linejoin=\'round\' stroke-width=\'2\' d=\'M4 19a1 1 0 1 0 2 0 1 1 0 1 0-2 0M4 4a16 16 0 0 1 16 16M4 11a9 9 0 0 1 9 9\'/%3E%3C/svg%3E');mask-image:url('data:image/svg+xml;charset=utf-8,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'24\' height=\'24\'%3E%3Cpath fill=\'none\' stroke=\'%23000\' stroke-linecap=\'round\' stroke-linejoin=\'round\' stroke-width=\'2\' d=\'M4 19a1 1 0 1 0 2 0 1 1 0 1 0-2 0M4 4a16 16 0 0 1 16 16M4 11a9 9 0 0 1 9 9\'/%3E%3C/svg%3E');"></span>
                  <span class="text-title">RSS</span>.
                  <span class="from-primary-600 to-accent-400 bg-gradient-to-r bg-clip-text text-transparent" style="background-image:linear-gradient(to right,#4f46e5,#e879f9);">Beauty</span>
                </a>
                <div class="text-caption">Make Your RSS Beautiful</div>
              </div>
            </div>
          </footer>
        </main>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

