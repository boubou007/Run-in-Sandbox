#!/usr/bin/env node
/**
 * verify-page.mjs — vérification visuelle et technique d'une page dans un vrai navigateur.
 *
 * Implémente la phase 5 de la Skill web-design-pro : ne jamais déclarer une
 * interface correcte sans l'avoir réellement vue.
 *
 * Contrôles :
 *   - rendu desktop (1440) et mobile (390), captures enregistrées
 *   - erreurs de console
 *   - défilement horizontal
 *   - hiérarchie des titres (un seul H1, pas de saut de niveau)
 *   - images sans attribut alt
 *   - images sans dimensions explicites (cause de décalage de mise en page)
 *   - cibles tactiles inférieures à 44 px
 *   - champs de formulaire sans libellé associé
 *   - attribut lang sur <html>
 *   - rendu en mode sombre
 *
 * Usage :
 *   node verify-page.mjs <url> [dossier-sortie]
 *
 * Nécessite le paquet playwright (npm i -g playwright).
 * Sortie : rapport texte + code de sortie 1 si un contrôle bloquant échoue.
 */
import { chromium } from 'playwright';
import { mkdirSync } from 'node:fs';
import { resolve } from 'node:path';

const url = process.argv[2];
const outDir = resolve(process.argv[3] || './verification');

if (!url) {
  console.error('Usage : node verify-page.mjs <url> [dossier-sortie]');
  process.exit(2);
}
mkdirSync(outDir, { recursive: true });

const fails = [];
const warns = [];
const oks = [];
const ok   = (m) => { oks.push(m);   console.log(`  [OK]   ${m}`); };
const warn = (m) => { warns.push(m); console.log(`  [WARN] ${m}`); };
const fail = (m) => { fails.push(m); console.log(`  [FAIL] ${m}`); };

const browser = await chromium.launch();
const consoleErrors = [];
const pageErrors = [];

const context = await browser.newContext({ viewport: { width: 1440, height: 900 } });
const page = await context.newPage();
page.on('console', (m) => { if (m.type() === 'error') consoleErrors.push(m.text()); });
page.on('pageerror', (e) => pageErrors.push(e.message));

console.log(`\n  VERIFICATION NAVIGATEUR — ${url}\n`);

const resp = await page.goto(url, { waitUntil: 'networkidle' });
if (!resp || !resp.ok()) fail(`Chargement : HTTP ${resp ? resp.status() : 'aucune reponse'}`);
else ok(`Chargement : HTTP ${resp.status()}`);

// ---------- desktop
await page.screenshot({ path: `${outDir}/desktop-1440.png`, fullPage: true });
await page.screenshot({ path: `${outDir}/desktop-1440-viewport.png` });
ok('Captures desktop 1440 px enregistrees (pleine page + viewport)');

const deskScroll = await page.evaluate(() =>
  document.documentElement.scrollWidth > document.documentElement.clientWidth + 1);
deskScroll ? fail('Defilement horizontal en desktop') : ok('Aucun defilement horizontal en desktop');

// ---------- audit structurel
const audit = await page.evaluate(() => {
  const r = {};
  r.lang = document.documentElement.getAttribute('lang') || null;
  r.title = document.title || null;
  r.metaDesc = document.querySelector('meta[name="description"]')?.content || null;

  const hs = [...document.querySelectorAll('h1,h2,h3,h4,h5,h6')];
  r.h1Count = hs.filter((h) => h.tagName === 'H1').length;
  r.headingJumps = [];
  let prev = 0;
  for (const h of hs) {
    const lvl = +h.tagName[1];
    if (prev && lvl > prev + 1) r.headingJumps.push(`${'H' + prev} -> ${h.tagName}`);
    prev = lvl;
  }

  const imgs = [...document.querySelectorAll('img')];
  r.imgTotal = imgs.length;
  r.imgNoAlt = imgs.filter((i) => !i.hasAttribute('alt')).length;
  r.imgNoDims = imgs.filter((i) => !(i.getAttribute('width') && i.getAttribute('height'))).length;

  const fields = [...document.querySelectorAll('input:not([type=hidden]),select,textarea')];
  r.fieldTotal = fields.length;
  r.fieldNoLabel = fields.filter((f) => {
    if (f.getAttribute('aria-label') || f.getAttribute('aria-labelledby')) return false;
    if (f.id && document.querySelector(`label[for="${CSS.escape(f.id)}"]`)) return false;
    return !f.closest('label');
  }).length;

  return r;
});

audit.lang ? ok(`Attribut lang : "${audit.lang}"`) : fail('Attribut lang absent sur <html>');
audit.title ? ok(`Title : "${audit.title.slice(0, 60)}"`) : fail('Balise <title> absente');
audit.metaDesc ? ok('Meta description presente') : warn('Meta description absente');

if (audit.h1Count === 1) ok('Un seul H1');
else if (audit.h1Count === 0) fail('Aucun H1');
else fail(`${audit.h1Count} H1 (un seul attendu)`);

audit.headingJumps.length === 0
  ? ok('Hierarchie de titres continue')
  : fail(`Saut de niveau de titre : ${audit.headingJumps.join(', ')}`);

if (audit.imgTotal === 0) ok('Aucune image (rien a verifier)');
else {
  audit.imgNoAlt === 0 ? ok(`${audit.imgTotal} image(s), toutes avec alt`)
                       : fail(`${audit.imgNoAlt} image(s) sans attribut alt`);
  audit.imgNoDims === 0 ? ok('Toutes les images ont width et height')
                        : warn(`${audit.imgNoDims} image(s) sans dimensions explicites (risque de CLS)`);
}

if (audit.fieldTotal === 0) ok('Aucun champ de formulaire (rien a verifier)');
else audit.fieldNoLabel === 0 ? ok(`${audit.fieldTotal} champ(s), tous avec libelle`)
                              : fail(`${audit.fieldNoLabel} champ(s) sans libelle associe`);

// ---------- mobile
await page.setViewportSize({ width: 390, height: 844 });
await page.waitForTimeout(400);
await page.screenshot({ path: `${outDir}/mobile-390.png`, fullPage: true });
await page.screenshot({ path: `${outDir}/mobile-390-viewport.png` });
ok('Captures mobile 390 px enregistrees (pleine page + viewport)');

const mobScroll = await page.evaluate(() =>
  document.documentElement.scrollWidth > document.documentElement.clientWidth + 1);
mobScroll ? fail('Defilement horizontal en mobile (390 px)')
          : ok('Aucun defilement horizontal en mobile');

const smallTargets = await page.evaluate(() => {
  const sel = 'a,button,input:not([type=hidden]),select,textarea,[role=button]';
  return [...document.querySelectorAll(sel)]
    .filter((el) => {
      const r = el.getBoundingClientRect();
      const st = getComputedStyle(el);
      if (!r.width || !r.height || st.display === 'none' || st.visibility === 'hidden') return false;
      return r.height < 44 || r.width < 24;
    })
    .slice(0, 8)
    .map((el) => `${el.tagName.toLowerCase()}"${(el.textContent || '').trim().slice(0, 25)}"`);
});
smallTargets.length === 0
  ? ok('Cibles tactiles conformes (>= 44 px de hauteur)')
  : warn(`${smallTargets.length} cible(s) tactile(s) trop petite(s) : ${smallTargets.join(', ')}`);

// ---------- mode sombre
const dark = await browser.newContext({ viewport: { width: 1440, height: 900 }, colorScheme: 'dark' });
const dp = await dark.newPage();
await dp.goto(url, { waitUntil: 'networkidle' });
await dp.screenshot({ path: `${outDir}/desktop-dark.png`, fullPage: true });
await dp.screenshot({ path: `${outDir}/desktop-dark-viewport.png` });
const bodyBg = await dp.evaluate(() => getComputedStyle(document.body).backgroundColor);
ok(`Capture mode sombre enregistree (fond body : ${bodyBg})`);
if (/rgba\(0,\s*0,\s*0,\s*0\)|transparent/.test(bodyBg)) {
  warn('Le body n a pas de fond explicite : le rendu empruntera le fond de l hote');
}
await dark.close();

// ---------- piege connu : backdrop-filter et captures pleine page
const hasBackdrop = await page.evaluate(() =>
  [...document.querySelectorAll('*')].some((el) => {
    const v = getComputedStyle(el).backdropFilter;
    return v && v !== 'none';
  }));
if (hasBackdrop) {
  warn('backdrop-filter detecte : les captures PLEINE PAGE peuvent afficher du texte ' +
       'fantome (artefact de rendu, pas un defaut). Verifiez sur les captures *-viewport.png ' +
       'avant de corriger quoi que ce soit.');
}

// ---------- console
consoleErrors.length === 0 ? ok('Console sans erreur')
                           : fail(`${consoleErrors.length} erreur(s) console : ${consoleErrors.slice(0, 3).join(' | ')}`);
pageErrors.length === 0 ? ok('Aucune exception JavaScript')
                        : fail(`${pageErrors.length} exception(s) : ${pageErrors.slice(0, 3).join(' | ')}`);

await browser.close();

console.log(`\n  Captures : ${outDir}`);
console.log(`  PASS: ${oks.length}   WARNING: ${warns.length}   FAIL: ${fails.length}\n`);
process.exit(fails.length > 0 ? 1 : 0);
