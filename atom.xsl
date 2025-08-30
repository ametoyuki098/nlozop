<?xml version="1.0" encoding="UTF-8"?>
<!-- Minimal, readable feed preview with optional background image -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  xmlns:content="http://purl.org/rss/1.0/modules/content/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="atom content dc">

  <!-- ===== Configurable params ===== -->
  <xsl:param name="bg-url" select="''"/> <!-- 例如：https://example.com/bg.webp -->
  <xsl:param name="bg-position" select="'center top'"/>
  <xsl:param name="bg-size" select="'cover'"/>
  <xsl:param name="bg-opacity" select="'0.35'"/>   <!-- 0~1，图片层透明度 -->
  <xsl:param name="render-html" select="'yes'"/>   <!-- 内容是否保留原始HTML：yes/no -->

  <xsl:output method="html" encoding="UTF-8" indent="no"/>

  <!-- ===== Helpers ===== -->
  <xsl:variable name="feed-title">
    <xsl:choose>
      <xsl:when test="/rss/channel/title"><xsl:value-of select="/rss/channel/title"/></xsl:when>
      <xsl:when test="/atom:feed/atom:title"><xsl:value-of select="/atom:feed/atom:title"/></xsl:when>
      <xsl:otherwise>Feed</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="feed-desc">
    <xsl:choose>
      <xsl:when test="/rss/channel/description"><xsl:value-of select="/rss/channel/description"/></xsl:when>
      <xsl:when test="/atom:feed/atom:subtitle"><xsl:value-of select="/atom:feed/atom:subtitle"/></xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <html lang="zh-CN">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="$feed-title"/></title>
        <style>
          :root{
            --fg:#1a1a1a; --muted:#4b5563; --bg:#ffffff;
            --card-bg:rgba(255,255,255,.72); --border:rgba(0,0,0,.08);
            --accent:#4f46e5; --radius:14px; --shadow:0 6px 24px rgba(0,0,0,.08);
          }
          @media (prefers-color-scheme: dark){
            :root{
              --fg:#e5e7eb; --muted:#9ca3af; --bg:#0b0c0f;
              --card-bg:rgba(17,20,26,.55); --border:rgba(255,255,255,.08);
              --accent:#8b9dff; --shadow:0 8px 28px rgba(0,0,0,.45);
            }
          }
          *{box-sizing:border-box}
          html,body{margin:0;padding:0}
          body{
            color:var(--fg);
            font:16px/1.6 ui-sans-serif, -apple-system, "Segoe UI", Roboto, "Noto Sans", "Helvetica Neue", Arial, "Apple Color Emoji","Segoe UI Emoji";
            background:
              linear-gradient(180deg, #fafafa 0%, #f3f4f6 100%);
            min-height:100dvh;
          }
          @media (prefers-color-scheme: dark){
            body{
              background:
                linear-gradient(180deg, #0b0c0f 0%, #0f1115 100%);
            }
          }
          /* 当指定了背景图时，覆写上一段背景，叠加半透明可读性层 */
        </style>
        <xsl:if test="string-length($bg-url) &gt; 0">
          <style>
            body{
              background:
                linear-gradient(0deg, rgba(255,255,255,.88), rgba(255,255,255,.88)),
                url('<xsl:value-of select="$bg-url"/>') no-repeat <xsl:value-of select="$bg-position"/> fixed;
              background-size: auto, <xsl:value-of select="$bg-size"/>;
            }
            @media (prefers-color-scheme: dark){
              body{
                background:
                  linear-gradient(0deg, rgba(0,0,0,.62), rgba(0,0,0,.62)),
                  url('<xsl:value-of select="$bg-url"/>') no-repeat <xsl:value-of select="$bg-position"/> fixed;
                background-size: auto, <xsl:value-of select="$bg-size"/>;
                filter: none;
              }
            }
            /* 额外控制图片层不透明度（在浅色/深色下都生效） */
            body{ --bg-img-opacity: <xsl:value-of select="$bg-opacity"/>; }
            /* 若希望更“通透”的卡片，可降低 card 背景不透明度 */
          </style>
        </xsl:if>
        <style>
          .wrap{max-width:860px;margin:0 auto;padding:28px 16px 56px}
          header .title{font-size:28px;font-weight:700;letter-spacing:.2px;margin:8px 0}
          header .desc{color:var(--muted);margin:6px 0 10px}
          header .meta{color:var(--muted);font-size:14px}

          .list{display:grid;gap:16px;margin-top:18px}
          .item{
            background:var(--card-bg);
            border:1px solid var(--border);
            border-radius:var(--radius);
            box-shadow:var(--shadow);
            padding:16px 18px;
            backdrop-filter:saturate(1.2) blur(6px);
            -webkit-backdrop-filter:saturate(1.2) blur(6px);
            transition:transform .2s ease, box-shadow .2s ease, border-color .2s ease;
          }
          .item:hover{transform:translateY(-2px)}
          .item h3{margin:0 0 8px;font-size:18px}
          .item a{color:var(--fg);text-decoration:none;border-bottom:1px solid transparent}
          .item a:hover{color:var(--accent);border-bottom-color:var(--accent)}
          .sub{display:flex;gap:10px;flex-wrap:wrap;color:var(--muted);font-size:13px;margin:6px 0 8px}
          .content{color:var(--fg);overflow:hidden}
          .content p{margin:.4em 0}
          .content img{max-width:100%;height:auto;border-radius:10px}
          .content pre, .content code{font: 13px/1.5 ui-monospace, SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace}
          .content blockquote{margin:8px 0;padding-left:12px;border-left:3px solid var(--border);color:var(--muted)}
          footer{margin-top:28px;color:var(--muted);font-size:13px}
        </style>
      </head>
      <body>
        <div class="wrap">
          <header>
            <div class="title"><xsl:value-of select="$feed-title"/></div>
            <xsl:if test="string-length($feed-desc) &gt; 0">
              <div class="desc"><xsl:value-of select="$feed-desc"/></div>
            </xsl:if>
            <div class="meta">
              <xsl:choose>
                <xsl:when test="/rss/channel/link">
                  源站：
                  <a href="{/rss/channel/link}">
                    <xsl:value-of select="/rss/channel/link"/>
                  </a>
                </xsl:when>
                <xsl:when test="/atom:feed/atom:link[@rel='alternate']/@href">
                  源站：
                  <a href="{/atom:feed/atom:link[@rel='alternate'][1]/@href}">
                    <xsl:value-of select="/atom:feed/atom:link[@rel='alternate'][1]/@href"/>
                  </a>
                </xsl:when>
                <xsl:otherwise/>
              </xsl:choose>
            </div>
          </header>

          <main class="list">
            <xsl:for-each select="/rss/channel/item | /atom:feed/atom:entry">
              <div class="item">
                <xsl:variable name="it-title">
                  <xsl:choose>
                    <xsl:when test="title"><xsl:value-of select="title"/></xsl:when>
                    <xsl:when test="atom:title"><xsl:value-of select="atom:title"/></xsl:when>
                    <xsl:otherwise>无标题</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="it-link">
                  <xsl:choose>
                    <xsl:when test="link"><xsl:value-of select="link"/></xsl:when>
                    <xsl:when test="atom:link[@rel='alternate']/@href"><xsl:value-of select="atom:link[@rel='alternate'][1]/@href"/></xsl:when>
                    <xsl:when test="atom:link/@href"><xsl:value-of select="atom:link[1]/@href"/></xsl:when>
                    <xsl:otherwise>#</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="it-date">
                  <xsl:choose>
                    <xsl:when test="pubDate"><xsl:value-of select="pubDate"/></xsl:when>
                    <xsl:when test="dc:date"><xsl:value-of select="dc:date"/></xsl:when>
                    <xsl:when test="atom:updated"><xsl:value-of select="atom:updated"/></xsl:when>
                    <xsl:when test="atom:published"><xsl:value-of select="atom:published"/></xsl:when>
                    <xsl:otherwise/>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="it-author">
                  <xsl:choose>
                    <xsl:when test="author"><xsl:value-of select="author"/></xsl:when>
                    <xsl:when test="dc:creator"><xsl:value-of select="dc:creator"/></xsl:when>
                    <xsl:when test="atom:author/atom:name"><xsl:value-of select="atom:author/atom:name"/></xsl:when>
                    <xsl:otherwise/>
                  </xsl:choose>
                </xsl:variable>

                <h3>
                  <a href="{$it-link}">
                    <xsl:value-of select="$it-title"/>
                  </a>
                </h3>

                <div class="sub">
                  <xsl:if test="string-length($it-date) &gt; 0">
                    <span>🗓 <xsl:value-of select="$it-date"/></span>
                  </xsl:if>
                  <xsl:if test="string-length($it-author) &gt; 0">
                    <span>✍️ <xsl:value-of select="$it-author"/></span>
                  </xsl:if>
                </div>

                <div class="content">
                  <xsl:choose>
                    <xsl:when test="$render-html='yes'">
                      <xsl:choose>
                        <xsl:when test="content:encoded">
                          <xsl:copy-of select="content:encoded/node()"/>
                        </xsl:when>
                        <xsl:when test="description">
                          <xsl:copy-of select="description/node()"/>
                        </xsl:when>
                        <xsl:when test="atom:content">
                          <xsl:copy-of select="atom:content/node()"/>
                        </xsl:when>
                        <xsl:when test="atom:summary">
                          <xsl:copy-of select="atom:summary/node()"/>
                        </xsl:when>
                        <xsl:otherwise/>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(string(./description | ./atom:summary | ./atom:content | ./content:encoded))"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
              </div>
            </xsl:for-each>
          </main>

          <footer>
            预览样式启用背景图片功能 · 可在 XSL 顶部参数处更改
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
