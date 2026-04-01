import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests/playwright',
  timeout: 120_000,
  use: {
    baseURL: process.env.GN_BASE_URL ?? 'http://127.0.0.1:8080',
    trace: 'on-first-retry'
  }
});
