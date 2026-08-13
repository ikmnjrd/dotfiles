// ~/.finicky.ts
const chromeOpeners = new Set([
  "com.anthropic.claudefordesktop",
]);

const chromeHostSuffixes = [
  "anthropic.com",
  "claude.com",
  "claude.ai",
  "gstatic.com",
  "google.com",
  "googleapis.com",
  "googleusercontent.com",
  "backlog.com",
];

const matchesHostSuffix = (host, suffix) => host === suffix || host.endsWith(`.${suffix}`);
const openInChrome = "Google Chrome";

export default {
  defaultBrowser: "Brave Browser",
  options: {
    logRequests: true,
  },
  rewrite: [
    {
      // Redirect all x.com urls to use xcancel.com
      match: "x.com/*",
      url: (url) => {
        url.host = "xcancel.com";
        return url;
      },
    },
  ],
  handlers: [
    {
      // Explicit Claude and OAuth domains, including subdomains and any path
      match: [
        "anthropic.com/*",
        "*.anthropic.com/*",
        "claude.com/*",
        "*.claude.com/*",
        "claude.ai/*",
        "*.claude.ai/*",
        "gstatic.com/*",
        "*.gstatic.com/*",
        "google.com/*",
        "*.google.com/*",
        "googleapis.com/*",
        "*.googleapis.com/*",
        "googleusercontent.com/*",
        "*.googleusercontent.com/*",
        "backlog.com/*",
        "*.backlog.com/*",
      ],
      browser: openInChrome,
    },
    {
      // Open Claude Desktop auth and Google login flows in Google Chrome
      match: (url, { opener }) =>
        (opener !== null && chromeOpeners.has(opener.bundleId)) ||
        chromeHostSuffixes.some((suffix) => matchesHostSuffix(url.host, suffix)),
      browser: openInChrome,
    },
    {
      // Open all bsky.app urls in Firefox
      match: "bsky.app/*",
      browser: "Firefox",
    },
  ],
};
