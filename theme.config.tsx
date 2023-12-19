import React from 'react'
import { DocsThemeConfig } from 'nextra-theme-docs'

const config: DocsThemeConfig = {
  logo: (
    <>
    <img
      src="/assets/images/128.png"
      alt="logo"
      style={{ maxWidth: "100px", height: "auto" }}
    />
  </>
  ),
  head: (
    <>
      <link rel="icon" href="/assets/images/favicon.ico" />
    </>
  ),
  docsRepositoryBase: 'https://gitlab.com/taku-miyanaga/docs/-/tree/main',
  project: {
    link: 'hhttps://gitlab.com/taku-miyanaga/docs',
    icon: (
      <svg width="24" height="24" viewBox="0 0 256 256">
        <path
          fill="currentColor"
          d="m231.9 169.8l-94.8 65.6a15.7 15.7 0 0 1-18.2 0l-94.8-65.6a16.1 16.1 0 0 1-6.4-17.3L45 50a12 12 0 0 1 22.9-1.1L88.5 104h79l20.6-55.1A12 12 0 0 1 211 50l27.3 102.5a16.1 16.1 0 0 1-6.4 17.3Z"
        ></path>
      </svg>
    )
  },
  toc: {
    title: '目次'
  },
  editLink: {
    text: 'このページを編集'
  },
  feedback: {
    content: 'フィードバック'
  }
}

export default config
