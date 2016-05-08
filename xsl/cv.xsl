<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

  <xsl:output method="html" version="5.0" indent="no"/>

  <xsl:strip-space elements="*"/>

  <xsl:variable name="CSS" as="xs:string*" select="
    ('../build/normalize.min.css', '../build/skeleton.css', '../css/main.css')
  "/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="cv">
    <html>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="head"/>
      <xsl:apply-templates select="." mode="body"/>
      <xsl:apply-templates select="socialMedia"/>
    </html>
  </xsl:template>

  <xsl:template match="cv" mode="head">
    <head>
      <meta charset="utf-8"/>

      <style type="text/css">
        <xsl:for-each select="$CSS">
          <xsl:value-of select="unparsed-text(.)"/>
        </xsl:for-each>
      </style>

      <xsl:apply-templates select="personalInfo/name" mode="head"/>
    </head>
  </xsl:template>

  <xsl:template match="cv" mode="body">
    <body>
      <xsl:apply-templates select="personalInfo"/>

      <div class="container">
        <xsl:apply-templates select="* except (personalInfo, socialMedia)"/>
      </div>
    </body>
  </xsl:template>

  <xsl:template match="name" mode="head">
    <title>
      Curriculum Vitae · <xsl:apply-templates/>
    </title>
  </xsl:template>

  <xsl:template match="personalInfo">
    <header>
      <div class="container personalInfo">
        <xsl:apply-templates select="@*"/>

        <div>
          <xsl:apply-templates select="
            picture, name, email, phoneNumber, location
          "/>
        </div>

        <xsl:apply-templates select="summary"/>
      </div>
    </header>
  </xsl:template>

  <xsl:template match="personalInfo/name">
    <h1>
      <xsl:apply-templates/>
    </h1>
  </xsl:template>

  <xsl:template match="personalInfo/email">
    <p>
      <xsl:apply-templates select="." mode="class"/>

      <a href="mailto:{.}" title="Send e-mail to {.}.">
        <xsl:apply-templates/>
      </a>
    </p>
  </xsl:template>

  <xsl:template match="personalInfo/picture">
    <img src="
      data:image/png;base64, {unparsed-text(resolve-uri(@href, base-uri()))}
    ">
      <xsl:apply-templates select="." mode="class"/>
    </img>
  </xsl:template>

  <xsl:template match="personalInfo/*" priority="-1">
    <p>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template priority="10" match="
    skills | languageSkills | education | experience | openSource
  ">
    <section>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:next-match/>
    </section>
  </xsl:template>

  <xsl:template match="skills">
    <h2>Technical skills</h2>

    <div class="row">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="skills/*">
    <div class="three columns">
      <h6>
        <xsl:value-of select="
          upper-case(substring(local-name(), 1, 1)) || substring(local-name(), 2)
        "/>
      </h6>

      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="skills/*/skill">
    <p>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="languageSkills">
    <h2>Language skills</h2>

    <dl>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <xsl:template match="languageSkills/language">
    <xsl:apply-templates select="@*"/>
  </xsl:template>

  <xsl:template match="languageSkills/language/@name">
    <dt>
      <xsl:value-of select="."/>
    </dt>
  </xsl:template>

  <xsl:template match="languageSkills/language/@proficiency">
    <dd>
      <xsl:value-of select="."/>
    </dd>
  </xsl:template>

  <xsl:template match="education">
    <h2>Education</h2>

    <div>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="experience">
    <h2>Work experience</h2>

    <div>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="a | @href">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="period">
    <div>
      <xsl:apply-templates select="." mode="class"/>

      <p class="date">
        <xsl:apply-templates select="." mode="date"/>
      </p>

      <xsl:apply-templates select="* except (degree, role)"/>
    </div>
  </xsl:template>

  <xsl:template match="period[@startDate][@endDate]" mode="date">
    <xsl:apply-templates select="@startDate"/>
    —
    <xsl:apply-templates select="@endDate"/>
  </xsl:template>

  <xsl:template match="period[@startDate][empty(@endDate)]" mode="date">
    <xsl:apply-templates select="@startDate"/> — Present
  </xsl:template>

  <xsl:template match="period/institution | period/employer">
    <h5>
      <xsl:apply-templates/>

      <small>
        <xsl:apply-templates select="
          following-sibling::degree | following-sibling::role
        "/>
      </small>
    </h5>
  </xsl:template>

  <xsl:template match="description">
    <p>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="openSource">
    <h2>Open source</h2>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="openSource/project">
    <div>
      <xsl:apply-templates select="." mode="class"/>
      <xsl:apply-templates select="* except (languages, site)"/>
    </div>
  </xsl:template>

  <xsl:template match="project/name">
    <h5>
      <a href="{following-sibling::site}">
        <xsl:apply-templates/>
      </a>

      <small>
        <xsl:apply-templates select="following-sibling::languages"/>
      </small>
    </h5>
  </xsl:template>

  <xsl:template match="project/languages">
    <xsl:value-of select="language" separator=", "/>
  </xsl:template>

  <xsl:template match="socialMedia">
    <footer>
      <xsl:apply-templates select="." mode="class"/>

      <ul>
        <xsl:apply-templates/>
      </ul>

      <p class="disclaimer">This CV was generated with XSLT from an XML source file with <a href="https://github.com/eerohele/xml-cv" title="xml-cv on GitHub.">xml-cv</a>.</p>
    </footer>
  </xsl:template>

  <xsl:template match="socialMedia/site">
    <li>
      <a>
        <xsl:apply-templates select="@href, node()"/>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="@xml:lang">
    <xsl:attribute name="lang" select="."/>
  </xsl:template>

  <xsl:template match="@startDate | @endDate">
    <time>
      <xsl:attribute name="datetime" select="."/>
      <xsl:value-of select="format-date(., '[MNn] [D], [Y]', 'en', (), ())"/>
    </time>
  </xsl:template>

  <xsl:template match="*" mode="class">
    <xsl:attribute name="class" select="local-name()"/>
  </xsl:template>

</xsl:stylesheet>
