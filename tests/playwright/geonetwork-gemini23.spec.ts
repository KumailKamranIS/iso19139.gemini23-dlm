import { expect, test } from '@playwright/test';

const baseURL = process.env.GN_BASE_URL ?? 'http://127.0.0.1:8080';

test('admin can see iso19139.gemini23 schema in Metadata & templates', async ({ page, request }) => {
  const loginResponse = await request.post(`${baseURL}/geonetwork/srv/api/me/login`, {
    form: { username: 'admin', password: 'admin' }
  });
  expect(loginResponse.ok()).toBeTruthy();

  await page.goto(`${baseURL}/geonetwork`, { waitUntil: 'networkidle' });

  const cookies = await request.storageState();
  await page.context().addCookies(cookies.cookies);

  await page.goto(`${baseURL}/geonetwork/srv/eng/admin.console#/metadata`, { waitUntil: 'networkidle' });

  const metadataTemplatesLink = page.getByRole('link', { name: /Metadata\s*&\s*templates/i });
  if (await metadataTemplatesLink.count()) {
    await metadataTemplatesLink.first().click();
  }

  await expect(page.getByText('iso19139.gemini23', { exact: false })).toBeVisible({ timeout: 60_000 });
});
