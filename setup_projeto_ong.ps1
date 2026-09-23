$ErrorActionPreference = 'Stop'

Write-Host '=== PROJETO ONG - ATUALIZACAO FINAL ===' -ForegroundColor Cyan
$root = (Get-Location).Path

if (-not (Test-Path (Join-Path $root 'imagens'))) { throw 'Execute este script na raiz do projeto-ong, onde existe a pasta imagens.' }
$requiredImages = @('ong.jpg','ong.webp','projeto1.jpg','projeto1.webp','voluntariado.jpg','voluntariado.webp')
$missingImages = @($requiredImages | Where-Object { -not (Test-Path (Join-Path $root ('imagens\' + $_))) })
if ($missingImages.Count -gt 0) { throw ('Imagens obrigatorias nao encontradas: ' + ($missingImages -join ', ')) }

$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$parent = Split-Path $root -Parent
$projectName = Split-Path $root -Leaf
$backup = Join-Path $parent ($projectName + '_backup_' + $stamp)
Write-Host ('Criando backup em: ' + $backup) -ForegroundColor Yellow
Copy-Item -Path $root -Destination $backup -Recurse -Force

New-Item -ItemType Directory -Force -Path (Join-Path $root 'html') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $root 'css') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $root 'js') | Out-Null

$utf8 = [System.Text.UTF8Encoding]::new($false)
function Write-ProjectFile([string]$RelativePath, [string]$Content) {
  $target = Join-Path $root $RelativePath
  $dir = Split-Path $target -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  [System.IO.File]::WriteAllText($target, $Content, $utf8)
  Write-Host ('OK  ' + $RelativePath) -ForegroundColor Green
}

Write-ProjectFile 'index.html' @'
<!DOCTYPE html>
<html lang="pt-BR" data-theme="light" data-contrast="normal">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Plataforma web de uma ONG com projetos sociais, voluntariado e doações.">
  <title>ONG Solidária</title>
  <link rel="stylesheet" href="./css/style.css">
  <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
</head>
<body>
  <a class="skip-link" href="#app">Pular para o conteúdo principal</a>

  <header class="site-header">
    <div class="container header-inner">
      <a class="brand" href="./html/inicio.html" data-route="inicio" aria-label="ONG Solidária - página inicial">
        ONG Solidária
      </a>

      <button
        class="menu-toggle"
        id="menu-toggle"
        type="button"
        aria-label="Abrir menu de navegação"
        aria-controls="menu-principal"
        aria-expanded="false">
        <span aria-hidden="true">☰</span>
      </button>

      <nav class="navbar" aria-label="Navegação principal">
        <ul class="menu" id="menu-principal">
          <li><a href="./html/inicio.html" data-route="inicio">Início</a></li>
          <li class="has-submenu">
            <a href="./html/projetos.html" data-route="projetos">Projetos</a>
            <ul class="submenu" aria-label="Submenu de projetos">
              <li><a href="./html/projetos.html#voluntariado" data-route="projetos">Voluntariado</a></li>
              <li><a href="./html/projetos.html#doacao" data-route="projetos">Doações</a></li>
            </ul>
          </li>
          <li><a href="./html/cadastro.html" data-route="cadastro">Cadastro</a></li>
        </ul>
      </nav>

      <div class="accessibility-actions" aria-label="Preferências visuais">
        <button class="icon-button" id="theme-toggle" type="button" aria-pressed="false">
          Modo escuro
        </button>
        <button class="icon-button" id="contrast-toggle" type="button" aria-pressed="false">
          Alto contraste
        </button>
      </div>
    </div>
  </header>

  <main id="app" class="container" tabindex="-1" aria-live="polite"></main>

  <footer class="site-footer">
    <div class="container footer-inner">
      <p>&copy; 2026 ONG Solidária</p>
      <a href="./html/inicio.html" data-route="inicio">Voltar ao início</a>
    </div>
  </footer>

  <div class="toast" id="toast" role="status" aria-live="polite" aria-atomic="true" hidden>
    <span class="toast-icon" aria-hidden="true">✓</span>
    <div>
      <strong id="toast-title">Operação concluída</strong>
      <p id="toast-message">A ação foi realizada com sucesso.</p>
    </div>
  </div>

  <div class="modal-backdrop" id="modal-backdrop" hidden>
    <section
      class="modal"
      id="modal"
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
      aria-describedby="modal-description"
      tabindex="-1">
      <button class="modal-close" id="modal-close" type="button" aria-label="Fechar janela">×</button>
      <h2 id="modal-title">Informação do projeto</h2>
      <p id="modal-description">Detalhes adicionais serão apresentados aqui.</p>
      <div class="modal-actions">
        <button class="button button-primary" id="modal-confirm" type="button">Entendi</button>
      </div>
    </section>
  </div>

  <noscript>
    <div class="noscript-warning">
      O JavaScript está desativado. Utilize as páginas alternativas disponíveis no menu para navegar pelo conteúdo.
    </div>
  </noscript>

  <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
  <script type="module" src="./js/app.js"></script>
</body>
</html>
'@

Write-ProjectFile 'css/style.css' @'
:root {
  --cor-primaria: #2563eb;
  --cor-primaria-escura: #1e40af;
  --cor-secundaria: #15803d;
  --cor-destaque: #b45309;
  --cor-sucesso: #15803d;
  --cor-erro: #b91c1c;
  --cor-alerta: #92400e;
  --cor-fundo: #f8fafc;
  --cor-superficie: #ffffff;
  --cor-superficie-2: #f1f5f9;
  --cor-texto: #1f2937;
  --cor-texto-suave: #4b5563;
  --cor-borda: #cbd5e1;
  --cor-foco: #f59e0b;

  --fonte-xs: 0.875rem;
  --fonte-sm: 1rem;
  --fonte-md: 1.25rem;
  --fonte-lg: 1.75rem;
  --fonte-xl: 2.25rem;

  --espaco-xs: 0.25rem;
  --espaco-sm: 0.5rem;
  --espaco-md: 1rem;
  --espaco-lg: 1.5rem;
  --espaco-xl: 2rem;
  --espaco-xxl: 3rem;

  --raio-sm: 0.5rem;
  --raio-md: 0.875rem;
  --sombra: 0 10px 28px rgba(15, 23, 42, 0.08);
}

html[data-theme="dark"] {
  --cor-fundo: #111827;
  --cor-superficie: #1f2937;
  --cor-superficie-2: #0f172a;
  --cor-texto: #f9fafb;
  --cor-texto-suave: #d1d5db;
  --cor-borda: #64748b;
  --cor-primaria: #60a5fa;
  --cor-primaria-escura: #93c5fd;
  --cor-destaque: #fbbf24;
  --cor-sucesso: #4ade80;
  --cor-erro: #fca5a5;
  --cor-foco: #fbbf24;
}

html[data-contrast="high"] {
  --cor-fundo: #000000;
  --cor-superficie: #000000;
  --cor-superficie-2: #111111;
  --cor-texto: #ffffff;
  --cor-texto-suave: #ffffff;
  --cor-borda: #ffffff;
  --cor-primaria: #ffff00;
  --cor-primaria-escura: #ffff00;
  --cor-secundaria: #00ff66;
  --cor-destaque: #00ffff;
  --cor-sucesso: #00ff66;
  --cor-erro: #ff6b6b;
  --cor-foco: #ffff00;
}

*,
*::before,
*::after {
  box-sizing: border-box;
}

html {
  scroll-behavior: smooth;
}

body {
  margin: 0;
  min-height: 100vh;
  font-family: Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  font-size: var(--fonte-sm);
  line-height: 1.6;
  background: var(--cor-fundo);
  color: var(--cor-texto);
}

img {
  display: block;
  max-width: 100%;
  height: auto;
}

a {
  color: var(--cor-primaria-escura);
}

button,
input,
select,
textarea {
  font: inherit;
}

button,
a {
  -webkit-tap-highlight-color: transparent;
}

:focus-visible {
  outline: 3px solid var(--cor-foco);
  outline-offset: 3px;
}

.skip-link {
  position: fixed;
  left: 1rem;
  top: 1rem;
  transform: translateY(-200%);
  z-index: 1000;
  padding: 0.75rem 1rem;
  border-radius: var(--raio-sm);
  background: var(--cor-superficie);
  color: var(--cor-texto);
  box-shadow: var(--sombra);
}

.skip-link:focus {
  transform: translateY(0);
}

.container {
  width: min(1180px, calc(100% - 2rem));
  margin-inline: auto;
}

.site-header {
  position: sticky;
  top: 0;
  z-index: 50;
  background: color-mix(in srgb, var(--cor-superficie) 95%, transparent);
  border-bottom: 1px solid var(--cor-borda);
  backdrop-filter: blur(10px);
}

.header-inner {
  min-height: 74px;
  display: flex;
  align-items: center;
  gap: var(--espaco-md);
}

.brand {
  font-size: var(--fonte-md);
  font-weight: 800;
  text-decoration: none;
  color: var(--cor-texto);
  white-space: nowrap;
}

.navbar {
  margin-left: auto;
}

.menu {
  display: flex;
  align-items: center;
  gap: var(--espaco-md);
  margin: 0;
  padding: 0;
  list-style: none;
}

.menu li {
  position: relative;
}

.menu a {
  display: inline-flex;
  min-height: 44px;
  align-items: center;
  padding: 0.5rem 0.75rem;
  border-radius: var(--raio-sm);
  text-decoration: none;
  color: var(--cor-texto);
  font-weight: 650;
}

.menu a:hover,
.menu a[aria-current="page"] {
  background: var(--cor-superficie-2);
  color: var(--cor-primaria-escura);
}

.submenu {
  display: none;
  position: absolute;
  top: calc(100% + 0.25rem);
  left: 0;
  min-width: 190px;
  margin: 0;
  padding: 0.5rem;
  list-style: none;
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-md);
  background: var(--cor-superficie);
  box-shadow: var(--sombra);
}

.has-submenu:hover .submenu,
.has-submenu:focus-within .submenu {
  display: block;
}

.menu-toggle {
  display: none;
  min-width: 44px;
  min-height: 44px;
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-sm);
  background: var(--cor-superficie);
  color: var(--cor-texto);
  cursor: pointer;
}

.accessibility-actions {
  display: flex;
  gap: var(--espaco-sm);
}

.icon-button,
.button {
  min-height: 44px;
  border-radius: var(--raio-sm);
  padding: 0.65rem 1rem;
  border: 1px solid var(--cor-borda);
  cursor: pointer;
  transition: transform 0.18s ease, box-shadow 0.18s ease, background 0.18s ease;
}

.icon-button {
  background: var(--cor-superficie);
  color: var(--cor-texto);
}

.icon-button:hover,
.button:hover {
  box-shadow: 0 6px 16px rgba(15, 23, 42, 0.14);
}

.icon-button:active,
.button:active {
  transform: translateY(1px);
}

.icon-button[aria-pressed="true"] {
  border-color: var(--cor-primaria);
  box-shadow: 0 0 0 2px color-mix(in srgb, var(--cor-primaria) 24%, transparent);
}

.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  text-decoration: none;
  font-weight: 750;
}

.button-primary {
  border-color: transparent;
  background: var(--cor-primaria);
  color: #ffffff;
}

html[data-contrast="high"] .button-primary {
  color: #000000;
}

.button-secondary {
  background: var(--cor-superficie);
  color: var(--cor-texto);
}

.button:disabled {
  cursor: not-allowed;
  opacity: 0.55;
  box-shadow: none;
}

#app {
  min-height: 68vh;
  padding-block: var(--espaco-xl) var(--espaco-xxl);
}

.hero {
  padding: clamp(2rem, 5vw, 4.5rem);
  border: 1px solid var(--cor-borda);
  border-radius: 1.25rem;
  background: linear-gradient(135deg, color-mix(in srgb, var(--cor-primaria) 14%, var(--cor-superficie)), var(--cor-superficie));
  box-shadow: var(--sombra);
}

.hero-grid {
  display: grid;
  grid-template-columns: repeat(12, minmax(0, 1fr));
  gap: var(--espaco-lg);
  align-items: center;
}

.hero-copy {
  grid-column: span 7;
}

.hero-media {
  grid-column: span 5;
}

.hero-media img {
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  border-radius: 1rem;
}

.eyebrow {
  margin: 0 0 0.5rem;
  font-size: var(--fonte-xs);
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--cor-primaria-escura);
}

h1,
h2,
h3 {
  line-height: 1.2;
}

h1 {
  margin: 0 0 var(--espaco-md);
  font-size: clamp(2rem, 6vw, var(--fonte-xl));
}

h2 {
  font-size: var(--fonte-lg);
}

h3 {
  font-size: var(--fonte-md);
}

.lead {
  max-width: 65ch;
  color: var(--cor-texto-suave);
  font-size: 1.075rem;
}

.actions {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-sm);
  margin-top: var(--espaco-lg);
}

.section {
  padding-block: var(--espaco-xl);
}

.section-header {
  margin-bottom: var(--espaco-lg);
}

.grid-12 {
  display: grid;
  grid-template-columns: repeat(12, minmax(0, 1fr));
  gap: var(--espaco-md);
}

.project-card {
  grid-column: span 12;
  display: flex;
  flex-direction: column;
  gap: var(--espaco-md);
  min-height: 100%;
  padding: var(--espaco-lg);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-md);
  background: var(--cor-superficie);
  box-shadow: var(--sombra);
}

.project-card img {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
  border-radius: var(--raio-sm);
}

.project-card h2,
.project-card p {
  margin-block: 0;
}

.project-card .actions {
  margin-top: auto;
}

.badges {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.badge {
  display: inline-flex;
  align-items: center;
  min-height: 30px;
  padding: 0.2rem 0.65rem;
  border-radius: 999px;
  border: 1px solid var(--cor-borda);
  background: var(--cor-superficie-2);
  color: var(--cor-texto);
  font-size: var(--fonte-xs);
  font-weight: 800;
}

.badge-success {
  border-color: color-mix(in srgb, var(--cor-sucesso) 50%, var(--cor-borda));
  background: color-mix(in srgb, var(--cor-sucesso) 12%, var(--cor-superficie));
}

.alert {
  margin-block: var(--espaco-md);
  padding: 0.85rem 1rem;
  border-left: 5px solid;
  border-radius: var(--raio-sm);
}

.alert-success {
  border-color: var(--cor-sucesso);
  background: color-mix(in srgb, var(--cor-sucesso) 10%, var(--cor-superficie));
}

.alert-error {
  border-color: var(--cor-erro);
  background: color-mix(in srgb, var(--cor-erro) 10%, var(--cor-superficie));
}

.form-card {
  max-width: 860px;
  margin-inline: auto;
  padding: var(--espaco-lg);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-md);
  background: var(--cor-superficie);
  box-shadow: var(--sombra);
}

form {
  display: flex;
  flex-direction: column;
  gap: var(--espaco-lg);
}

fieldset {
  display: grid;
  grid-template-columns: repeat(12, minmax(0, 1fr));
  gap: var(--espaco-md);
  margin: 0;
  padding: var(--espaco-lg);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-md);
}

legend {
  padding-inline: 0.5rem;
  font-weight: 800;
}

.field {
  grid-column: span 12;
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}

.field-half {
  grid-column: span 12;
}

label {
  font-weight: 750;
}

input,
select,
textarea {
  width: 100%;
  min-height: 44px;
  padding: 0.7rem 0.8rem;
  border: 2px solid var(--cor-borda);
  border-radius: var(--raio-sm);
  background: var(--cor-superficie);
  color: var(--cor-texto);
  transition: border-color 0.18s ease, box-shadow 0.18s ease;
}

input:focus,
select:focus,
textarea:focus {
  border-color: var(--cor-primaria);
  box-shadow: 0 0 0 3px color-mix(in srgb, var(--cor-primaria) 18%, transparent);
  outline: none;
}

.campo-valido {
  border-color: var(--cor-sucesso);
}

.campo-erro {
  border-color: var(--cor-erro);
}

.mensagem-erro {
  color: var(--cor-erro);
  font-size: var(--fonte-xs);
  font-weight: 700;
}

.site-footer {
  border-top: 1px solid var(--cor-borda);
  background: var(--cor-superficie);
}

.footer-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--espaco-md);
  min-height: 88px;
  flex-wrap: wrap;
}

.toast {
  position: fixed;
  right: 1.25rem;
  bottom: 1.25rem;
  z-index: 80;
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  width: min(380px, calc(100% - 2.5rem));
  padding: 1rem;
  border-radius: var(--raio-md);
  background: #111827;
  color: #ffffff;
  box-shadow: 0 18px 45px rgba(0, 0, 0, 0.28);
}

.toast[hidden],
.modal-backdrop[hidden] {
  display: none;
}

.toast p {
  margin: 0.2rem 0 0;
  color: #e5e7eb;
}

.toast-icon {
  display: grid;
  place-items: center;
  flex: 0 0 auto;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: #16a34a;
  color: #ffffff;
  font-weight: 900;
}

.modal-backdrop {
  position: fixed;
  inset: 0;
  z-index: 90;
  display: grid;
  place-items: center;
  padding: 1rem;
  background: rgba(15, 23, 42, 0.66);
}

.modal {
  position: relative;
  width: min(540px, 100%);
  padding: 1.5rem;
  border-radius: var(--raio-md);
  background: var(--cor-superficie);
  color: var(--cor-texto);
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.35);
}

.modal-close {
  position: absolute;
  top: 0.75rem;
  right: 0.75rem;
  width: 44px;
  height: 44px;
  border: 0;
  border-radius: var(--raio-sm);
  background: transparent;
  color: var(--cor-texto);
  font-size: 1.75rem;
  cursor: pointer;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  margin-top: 1.25rem;
}

.noscript-warning {
  margin: 1rem;
  padding: 1rem;
  border: 2px solid var(--cor-erro);
  background: var(--cor-superficie);
}

.favorito {
  border-color: var(--cor-destaque);
  box-shadow: 0 0 0 2px color-mix(in srgb, var(--cor-destaque) 25%, transparent), var(--sombra);
}

html[data-contrast="high"] *,
html[data-contrast="high"] *::before,
html[data-contrast="high"] *::after {
  box-shadow: none !important;
  text-shadow: none !important;
}

html[data-contrast="high"] a {
  color: #00ffff;
}

html[data-contrast="high"] :focus-visible {
  outline-color: #ffff00;
}

/* Breakpoint 1: 480px */
@media (min-width: 480px) {
  .grid-12 {
    gap: 1.125rem;
  }
}

/* Breakpoint 2: 768px */
@media (min-width: 768px) {
  .project-card {
    grid-column: span 6;
  }

  .field-half {
    grid-column: span 6;
  }
}

/* Breakpoint 3: 1024px */
@media (min-width: 1024px) {
  .grid-12 {
    gap: var(--espaco-lg);
  }
}

/* Breakpoint 4: 1280px */
@media (min-width: 1280px) {
  .container {
    width: min(1220px, calc(100% - 3rem));
  }
}

/* Breakpoint 5: 1440px */
@media (min-width: 1440px) {
  .container {
    width: min(1320px, calc(100% - 4rem));
  }

  .grid-12 {
    gap: var(--espaco-xl);
  }
}

@media (max-width: 767px) {
  .header-inner {
    min-height: 68px;
    flex-wrap: wrap;
    padding-block: 0.65rem;
  }

  .menu-toggle {
    display: inline-grid;
    place-items: center;
    margin-left: auto;
  }

  .navbar {
    order: 4;
    width: 100%;
    margin-left: 0;
  }

  .menu {
    display: none;
    width: 100%;
    flex-direction: column;
    align-items: stretch;
    gap: 0.25rem;
    padding-block: 0.5rem;
  }

  .menu.menu-aberto {
    display: flex;
  }

  .menu a {
    width: 100%;
  }

  .submenu {
    position: static;
    display: block;
    margin-left: 1rem;
    border: 0;
    box-shadow: none;
    background: transparent;
  }

  .accessibility-actions {
    width: 100%;
    order: 5;
    flex-wrap: wrap;
  }

  .hero-copy,
  .hero-media {
    grid-column: span 12;
  }

  .footer-inner {
    align-items: flex-start;
    flex-direction: column;
    padding-block: 1rem;
  }
}

@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    scroll-behavior: auto !important;
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
  }
}
'@

Write-ProjectFile 'js/storage.js' @'
const STORAGE_KEY = "preferenciasONG";

const DEFAULTS = {
  theme: "system",
  highContrast: false,
  lastRoute: "inicio",
  favorites: []
};

function safeParse(value) {
  try {
    return JSON.parse(value);
  } catch {
    return null;
  }
}

export function getPreferences() {
  const raw = localStorage.getItem(STORAGE_KEY);
  const parsed = raw ? safeParse(raw) : null;

  return {
    ...DEFAULTS,
    ...(parsed && typeof parsed === "object" ? parsed : {}),
    favorites: Array.isArray(parsed?.favorites) ? parsed.favorites : []
  };
}

export function savePreferences(next) {
  const normalized = {
    ...DEFAULTS,
    ...next,
    favorites: Array.isArray(next?.favorites) ? next.favorites : []
  };

  localStorage.setItem(STORAGE_KEY, JSON.stringify(normalized));
  return normalized;
}

export function updatePreferences(patch) {
  return savePreferences({
    ...getPreferences(),
    ...patch
  });
}

export function toggleFavorite(projectId) {
  const preferences = getPreferences();
  const favorites = new Set(preferences.favorites);

  if (favorites.has(projectId)) {
    favorites.delete(projectId);
  } else {
    favorites.add(projectId);
  }

  return updatePreferences({
    favorites: [...favorites]
  });
}

export function clearPreferences() {
  localStorage.removeItem(STORAGE_KEY);
}
'@

Write-ProjectFile 'js/router.js' @'
const VALID_ROUTES = new Set(["inicio", "projetos", "cadastro"]);

export function getRouteFromLocation() {
  const value = location.hash.replace(/^#\/?/, "").split("?")[0].trim();
  return VALID_ROUTES.has(value) ? value : "inicio";
}

export function updateCurrentLink(route) {
  document.querySelectorAll("[data-route]").forEach((link) => {
    if (!(link instanceof HTMLAnchorElement)) return;

    if (link.dataset.route === route) {
      link.setAttribute("aria-current", "page");
    } else {
      link.removeAttribute("aria-current");
    }
  });
}

export function navigate(route, { replace = false } = {}) {
  const safeRoute = VALID_ROUTES.has(route) ? route : "inicio";
  const url = `#/${safeRoute}`;

  if (replace) {
    history.replaceState({ route: safeRoute }, "", url);
  } else {
    history.pushState({ route: safeRoute }, "", url);
  }

  window.dispatchEvent(
    new CustomEvent("app:route", {
      detail: { route: safeRoute }
    })
  );
}

export function initRouter(onRouteChange) {
  document.addEventListener("click", (event) => {
    const link = event.target.closest("a[data-route]");
    if (!link) return;

    event.preventDefault();
    navigate(link.dataset.route);
  });

  window.addEventListener("popstate", () => {
    onRouteChange(getRouteFromLocation());
  });

  window.addEventListener("app:route", (event) => {
    onRouteChange(event.detail.route);
  });

  const initial = getRouteFromLocation();

  if (!location.hash) {
    navigate(initial, { replace: true });
  } else {
    onRouteChange(initial);
  }
}
'@

Write-ProjectFile 'js/templates.js' @'
import ongWebp from "../imagens/ong.webp";
import ongJpg from "../imagens/ong.jpg";
import voluntariadoWebp from "../imagens/voluntariado.webp";
import voluntariadoJpg from "../imagens/voluntariado.jpg";
import projetoWebp from "../imagens/projeto1.webp";
import projetoJpg from "../imagens/projeto1.jpg";

export const projetos = [
  {
    id: "voluntariado",
    titulo: "Trabalho voluntário",
    categoria: "Voluntariado",
    descricao: "Pessoas interessadas podem participar das ações da ONG, contribuindo com tempo, conhecimento e habilidades.",
    imagemWebp: voluntariadoWebp,
    imagemFallback: voluntariadoJpg,
    alt: "Voluntários participando de uma atividade social"
  },
  {
    id: "doacao",
    titulo: "Faça uma doação",
    categoria: "Doação",
    descricao: "As contribuições apoiam a manutenção dos projetos e ampliam a capacidade de atendimento à comunidade.",
    imagemWebp: projetoWebp,
    imagemFallback: projetoJpg,
    alt: "Projeto social realizado pela ONG"
  }
];

function projetoCard(projeto, favorites) {
  const favorito = favorites.includes(projeto.id);

  return `
    <article class="project-card ${favorito ? "favorito" : ""}" data-projeto-id="${projeto.id}" data-aos="fade-up">
      <div class="badges">
        <span class="badge badge-success">Projeto ativo</span>
        <span class="badge">${projeto.categoria}</span>
      </div>

      <picture>
        <source srcset="${projeto.imagemWebp}" type="image/webp">
        <img src="${projeto.imagemFallback}" alt="${projeto.alt}" loading="lazy" decoding="async">
      </picture>

      <h2>${projeto.titulo}</h2>
      <p>${projeto.descricao}</p>

      <div class="actions">
        <button
          class="button button-primary"
          type="button"
          data-open-modal="${projeto.id}">
          Saiba mais
        </button>

        <button
          class="button button-secondary"
          type="button"
          data-favorite="${projeto.id}"
          aria-pressed="${favorito}">
          ${favorito ? "Remover favorito" : "Favoritar"}
        </button>
      </div>
    </article>
  `;
}

export function renderInicio() {
  return `
    <section class="hero" data-aos="fade-up">
      <div class="hero-grid">
        <div class="hero-copy">
          <p class="eyebrow">Transformação social</p>
          <h1>Conectando pessoas a oportunidades de impacto positivo</h1>
          <p class="lead">
            Nossa ONG desenvolve projetos sociais voltados à comunidade, estimula o voluntariado
            e cria caminhos acessíveis para quem deseja contribuir.
          </p>

          <div class="actions">
            <a class="button button-primary" href="./html/projetos.html" data-route="projetos">
              Conhecer projetos
            </a>
            <a class="button button-secondary" href="./html/cadastro.html" data-route="cadastro">
              Quero participar
            </a>
          </div>
        </div>

        <div class="hero-media">
          <picture>
            <source srcset="${ongWebp}" type="image/webp">
            <img
              src="${ongJpg}"
              alt="Equipe da ONG participando de uma ação social"
              decoding="async">
          </picture>
        </div>
      </div>
    </section>

    <section class="section" aria-labelledby="sobre-titulo" data-aos="fade-up">
      <div class="section-header">
        <p class="eyebrow">Sobre nós</p>
        <h2 id="sobre-titulo">Uma plataforma simples, inclusiva e orientada à comunidade</h2>
      </div>
      <p class="lead">
        O projeto foi estruturado com HTML semântico, CSS responsivo e JavaScript modular,
        priorizando acessibilidade, manutenção e boa experiência em diferentes dispositivos.
      </p>
    </section>

    <section class="section" aria-labelledby="contato-titulo" data-aos="fade-up">
      <div class="section-header">
        <p class="eyebrow">Contato</p>
        <h2 id="contato-titulo">Fale com a organização</h2>
      </div>
      <p>E-mail: contato@ong.com</p>
      <p>Telefone: (11) 99999-9999</p>
      <p>Endereço: Rua Exemplo, 100 - São Paulo</p>
    </section>
  `;
}

export function renderProjetos(preferences) {
  const favorites = preferences.favorites ?? [];

  return `
    <section class="section" aria-labelledby="projetos-titulo">
      <div class="section-header" data-aos="fade-up">
        <p class="eyebrow">Participação social</p>
        <h1 id="projetos-titulo">Projetos Sociais</h1>
        <p class="lead">
          Conheça algumas formas de colaborar com as ações da organização.
        </p>
      </div>

      <div class="grid-12" id="lista-projetos">
        ${projetos.map((projeto) => projetoCard(projeto, favorites)).join("")}
      </div>
    </section>
  `;
}

export function renderCadastro() {
  return `
    <section class="section" aria-labelledby="cadastro-titulo">
      <div class="section-header" data-aos="fade-up">
        <p class="eyebrow">Participe</p>
        <h1 id="cadastro-titulo">Cadastro</h1>
        <p class="lead">
          Preencha os dados abaixo. As informações são validadas no navegador e não são gravadas
          no localStorage.
        </p>
      </div>

      <div class="form-card" data-aos="fade-up">
        <div id="form-status" class="alert alert-error" role="alert" hidden></div>

        <form id="form-cadastro" action="#" method="post" novalidate>
          <fieldset>
            <legend>Dados pessoais</legend>

            <div class="field">
              <label for="nome">Nome completo</label>
              <input id="nome" name="nome" type="text" autocomplete="name" required minlength="3">
            </div>

            <div class="field field-half">
              <label for="nascimento">Data de nascimento</label>
              <input id="nascimento" name="nascimento" type="date" required>
            </div>

            <div class="field field-half">
              <label for="cpf">CPF</label>
              <input
                id="cpf"
                name="cpf"
                type="text"
                inputmode="numeric"
                autocomplete="off"
                placeholder="000.000.000-00"
                pattern="[0-9]{3}\\.[0-9]{3}\\.[0-9]{3}-[0-9]{2}"
                required>
            </div>
          </fieldset>

          <fieldset>
            <legend>Dados de contato</legend>

            <div class="field field-half">
              <label for="email">E-mail</label>
              <input id="email" name="email" type="email" autocomplete="email" required>
            </div>

            <div class="field field-half">
              <label for="telefone">Telefone</label>
              <input
                id="telefone"
                name="telefone"
                type="tel"
                autocomplete="tel"
                placeholder="(11) 99999-9999"
                pattern="\\([0-9]{2}\\) [0-9]{4,5}-[0-9]{4}"
                required>
            </div>
          </fieldset>

          <fieldset>
            <legend>Endereço</legend>

            <div class="field field-half">
              <label for="cep">CEP</label>
              <input
                id="cep"
                name="cep"
                type="text"
                inputmode="numeric"
                autocomplete="postal-code"
                placeholder="00000-000"
                pattern="[0-9]{5}-[0-9]{3}"
                required>
            </div>

            <div class="field field-half">
              <label for="estado">Estado</label>
              <select id="estado" name="estado" autocomplete="address-level1" required>
                <option value="">Selecione</option>
                <option value="SP">São Paulo</option>
                <option value="RJ">Rio de Janeiro</option>
                <option value="MG">Minas Gerais</option>
                <option value="PR">Paraná</option>
              </select>
            </div>

            <div class="field">
              <label for="endereco">Endereço</label>
              <input id="endereco" name="endereco" type="text" autocomplete="street-address" required>
            </div>

            <div class="field">
              <label for="cidade">Cidade</label>
              <input id="cidade" name="cidade" type="text" autocomplete="address-level2" required>
            </div>
          </fieldset>

          <div class="actions">
            <button class="button button-primary" type="submit">Enviar cadastro</button>
            <button class="button button-secondary" type="reset">Limpar</button>
          </div>
        </form>
      </div>
    </section>
  `;
}

export function renderRoute(route, preferences) {
  switch (route) {
    case "projetos":
      return renderProjetos(preferences);
    case "cadastro":
      return renderCadastro();
    case "inicio":
    default:
      return renderInicio();
  }
}
'@

Write-ProjectFile 'js/validation.js' @'
const FIELD_MESSAGES = {
  nome: "Informe o nome completo com pelo menos 3 caracteres.",
  nascimento: "Informe uma data de nascimento válida.",
  cpf: "Informe um CPF válido no formato 000.000.000-00.",
  email: "Informe um endereço de e-mail válido.",
  telefone: "Informe o telefone no formato (11) 99999-9999.",
  cep: "Informe o CEP no formato 00000-000.",
  endereco: "Informe o endereço.",
  cidade: "Informe a cidade.",
  estado: "Selecione o estado."
};

function onlyDigits(value) {
  return value.replace(/\D/g, "");
}

function isValidCPF(value) {
  const cpf = onlyDigits(value);

  if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) {
    return false;
  }

  const calcDigit = (base, factor) => {
    let total = 0;

    for (const digit of base) {
      total += Number(digit) * factor;
      factor -= 1;
    }

    const remainder = (total * 10) % 11;
    return remainder === 10 ? 0 : remainder;
  };

  const digit1 = calcDigit(cpf.slice(0, 9), 10);
  const digit2 = calcDigit(cpf.slice(0, 10), 11);

  return digit1 === Number(cpf[9]) && digit2 === Number(cpf[10]);
}

function isFutureDate(value) {
  if (!value) return false;

  const selected = new Date(`${value}T00:00:00`);
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  return selected > today;
}

function customValidity(field) {
  if (field.id === "cpf" && field.value && !isValidCPF(field.value)) {
    return false;
  }

  if (field.id === "nascimento" && field.value && isFutureDate(field.value)) {
    return false;
  }

  return field.validity.valid;
}

function getErrorElement(field) {
  const id = `${field.id}-erro`;
  let error = document.getElementById(id);

  if (!error) {
    error = document.createElement("small");
    error.id = id;
    error.className = "mensagem-erro";
    error.setAttribute("role", "alert");
    field.insertAdjacentElement("afterend", error);
  }

  return error;
}

function setFieldState(field, valid) {
  const error = getErrorElement(field);

  field.classList.toggle("campo-valido", valid);
  field.classList.toggle("campo-erro", !valid);
  field.setAttribute("aria-invalid", String(!valid));

  if (valid) {
    error.textContent = "";
    field.removeAttribute("aria-describedby");
  } else {
    error.textContent = FIELD_MESSAGES[field.id] ?? "Revise este campo.";
    field.setAttribute("aria-describedby", error.id);
  }

  return valid;
}

function validateField(field) {
  const emptyRequired = field.required && !field.value.trim();
  const valid = !emptyRequired && customValidity(field);
  return setFieldState(field, valid);
}

function resetFieldState(field) {
  field.classList.remove("campo-valido", "campo-erro");
  field.removeAttribute("aria-invalid");
  field.removeAttribute("aria-describedby");

  const error = document.getElementById(`${field.id}-erro`);
  if (error) error.textContent = "";
}

export function initFormValidation(root = document, onSuccess = () => {}) {
  const form = root.querySelector("#form-cadastro");
  if (!form) return;

  const fields = [...form.querySelectorAll("input, select, textarea")];

  fields.forEach((field) => {
    field.addEventListener("blur", () => validateField(field));

    field.addEventListener("input", () => {
      if (field.classList.contains("campo-erro")) {
        validateField(field);
      }
    });

    field.addEventListener("change", () => {
      if (field instanceof HTMLSelectElement || field.type === "date") {
        validateField(field);
      }
    });
  });

  form.addEventListener("reset", () => {
    requestAnimationFrame(() => {
      fields.forEach(resetFieldState);
      const status = root.querySelector("#form-status");
      if (status) {
        status.hidden = true;
        status.textContent = "";
      }
    });
  });

  form.addEventListener("submit", (event) => {
    event.preventDefault();

    const results = fields.map(validateField);
    const valid = results.every(Boolean);
    const status = root.querySelector("#form-status");

    if (!valid) {
      if (status) {
        status.textContent = "Existem campos que precisam ser corrigidos antes do envio.";
        status.hidden = false;
      }

      const firstInvalid = form.querySelector(".campo-erro");
      firstInvalid?.focus();
      return;
    }

    if (status) {
      status.hidden = true;
      status.textContent = "";
    }

    onSuccess(form);
    form.reset();
  });
}
'@

Write-ProjectFile 'js/ui.js' @'
import { getPreferences, updatePreferences } from "./storage.js";

let lastFocusedElement = null;
let toastTimer = null;

function getFocusable(container) {
  return [
    ...container.querySelectorAll(
      'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
    )
  ].filter((element) => !element.hasAttribute("hidden"));
}

export function closeMobileMenu() {
  const menu = document.querySelector("#menu-principal");
  const toggle = document.querySelector("#menu-toggle");

  if (!menu || !toggle) return;

  menu.classList.remove("menu-aberto");
  toggle.setAttribute("aria-expanded", "false");
  toggle.setAttribute("aria-label", "Abrir menu de navegação");
}

export function initMenu() {
  const toggle = document.querySelector("#menu-toggle");
  const menu = document.querySelector("#menu-principal");

  if (!toggle || !menu) return;

  toggle.addEventListener("click", () => {
    const open = menu.classList.toggle("menu-aberto");
    toggle.setAttribute("aria-expanded", String(open));
    toggle.setAttribute("aria-label", open ? "Fechar menu de navegação" : "Abrir menu de navegação");
  });

  menu.addEventListener("click", (event) => {
    if (event.target.closest("a")) {
      closeMobileMenu();
    }
  });
}

function resolveTheme(theme) {
  if (theme === "dark" || theme === "light") return theme;
  return matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
}

export function applyPreferences() {
  const preferences = getPreferences();
  const resolvedTheme = resolveTheme(preferences.theme);

  document.documentElement.dataset.theme = resolvedTheme;
  document.documentElement.dataset.contrast = preferences.highContrast ? "high" : "normal";

  const themeButton = document.querySelector("#theme-toggle");
  const contrastButton = document.querySelector("#contrast-toggle");

  if (themeButton) {
    const dark = resolvedTheme === "dark";
    themeButton.setAttribute("aria-pressed", String(dark));
    themeButton.textContent = dark ? "Modo claro" : "Modo escuro";
  }

  if (contrastButton) {
    contrastButton.setAttribute("aria-pressed", String(Boolean(preferences.highContrast)));
    contrastButton.textContent = preferences.highContrast ? "Contraste normal" : "Alto contraste";
  }
}

export function initPreferenceControls() {
  const themeButton = document.querySelector("#theme-toggle");
  const contrastButton = document.querySelector("#contrast-toggle");

  themeButton?.addEventListener("click", () => {
    const current = getPreferences();
    const active = resolveTheme(current.theme);
    updatePreferences({ theme: active === "dark" ? "light" : "dark" });
    applyPreferences();
  });

  contrastButton?.addEventListener("click", () => {
    const current = getPreferences();
    updatePreferences({ highContrast: !current.highContrast });
    applyPreferences();
  });
}

export function showToast(title, message) {
  const toast = document.querySelector("#toast");
  const titleElement = document.querySelector("#toast-title");
  const messageElement = document.querySelector("#toast-message");

  if (!toast || !titleElement || !messageElement) return;

  titleElement.textContent = title;
  messageElement.textContent = message;
  toast.hidden = false;

  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => {
    toast.hidden = true;
  }, 4500);
}

export function openModal({ title, description }) {
  const backdrop = document.querySelector("#modal-backdrop");
  const modal = document.querySelector("#modal");
  const titleElement = document.querySelector("#modal-title");
  const descriptionElement = document.querySelector("#modal-description");

  if (!backdrop || !modal || !titleElement || !descriptionElement) return;

  lastFocusedElement = document.activeElement;
  titleElement.textContent = title;
  descriptionElement.textContent = description;
  backdrop.hidden = false;
  modal.focus();
}

export function closeModal() {
  const backdrop = document.querySelector("#modal-backdrop");
  if (!backdrop || backdrop.hidden) return;

  backdrop.hidden = true;

  if (lastFocusedElement instanceof HTMLElement) {
    lastFocusedElement.focus();
  }
}

export function initModal() {
  const backdrop = document.querySelector("#modal-backdrop");
  const modal = document.querySelector("#modal");
  const closeButton = document.querySelector("#modal-close");
  const confirmButton = document.querySelector("#modal-confirm");

  if (!backdrop || !modal || !closeButton || !confirmButton) return;

  closeButton.addEventListener("click", closeModal);
  confirmButton.addEventListener("click", closeModal);

  backdrop.addEventListener("click", (event) => {
    if (event.target === backdrop) {
      closeModal();
    }
  });

  document.addEventListener("keydown", (event) => {
    if (backdrop.hidden) return;

    if (event.key === "Escape") {
      event.preventDefault();
      closeModal();
      return;
    }

    if (event.key !== "Tab") return;

    const focusable = getFocusable(modal);
    if (focusable.length === 0) {
      event.preventDefault();
      modal.focus();
      return;
    }

    const first = focusable[0];
    const last = focusable[focusable.length - 1];

    if (event.shiftKey && document.activeElement === first) {
      event.preventDefault();
      last.focus();
    } else if (!event.shiftKey && document.activeElement === last) {
      event.preventDefault();
      first.focus();
    }
  });
}
'@

Write-ProjectFile 'js/app.js' @'
import { initRouter, updateCurrentLink } from "./router.js";
import { renderRoute, projetos } from "./templates.js";
import { initFormValidation } from "./validation.js";
import { getPreferences, toggleFavorite, updatePreferences } from "./storage.js";
import {
  applyPreferences,
  closeMobileMenu,
  initMenu,
  initModal,
  initPreferenceControls,
  openModal,
  showToast
} from "./ui.js";

const app = document.querySelector("#app");

if (!app) {
  throw new Error("Elemento #app não encontrado.");
}

let currentRoute = "inicio";

const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

if (window.AOS) {
  window.AOS.init({
    duration: 700,
    once: true,
    offset: 80,
    disable: reduceMotion
  });
}

function routeTitle(route) {
  const titles = {
    inicio: "ONG Solidária",
    projetos: "Projetos | ONG Solidária",
    cadastro: "Cadastro | ONG Solidária"
  };

  return titles[route] ?? titles.inicio;
}

function render(route) {
  currentRoute = route;
  const preferences = getPreferences();

  updatePreferences({ lastRoute: route });

  app.innerHTML = renderRoute(route, preferences);
  document.title = routeTitle(route);
  updateCurrentLink(route);
  closeMobileMenu();

  initFormValidation(app, () => {
    showToast("Cadastro validado", "Os dados foram validados localmente com sucesso.");
  });

  window.AOS?.refreshHard();

  requestAnimationFrame(() => {
    app.focus({ preventScroll: true });
  });
}

document.addEventListener("click", (event) => {
  const favoriteButton = event.target.closest("[data-favorite]");
  if (favoriteButton) {
    const projectId = favoriteButton.dataset.favorite;
    toggleFavorite(projectId);
    render(currentRoute);
    showToast("Preferência atualizada", "O estado de favorito foi guardado neste navegador.");
    return;
  }

  const modalButton = event.target.closest("[data-open-modal]");
  if (modalButton) {
    const projeto = projetos.find((item) => item.id === modalButton.dataset.openModal);

    if (projeto) {
      openModal({
        title: projeto.titulo,
        description: projeto.descricao
      });
    }
  }
});

document.addEventListener("DOMContentLoaded", () => {
  applyPreferences();
  initMenu();
  initPreferenceControls();
  initModal();

  const preferences = getPreferences();

  if (!location.hash && preferences.lastRoute && preferences.lastRoute !== "inicio") {
    history.replaceState(
      { route: preferences.lastRoute },
      "",
      `#/${preferences.lastRoute}`
    );
  }

  initRouter((route) => {
    render(route);
  });
});
'@

Write-ProjectFile 'vite.config.js' @'
import { defineConfig } from "vite";
import { resolve } from "node:path";
import { fileURLToPath } from "node:url";

const rootDir = fileURLToPath(new URL(".", import.meta.url));

export default defineConfig({
  build: {
    outDir: "dist",
    emptyOutDir: true,
    minify: "esbuild",
    rollupOptions: {
      input: {
        app: resolve(rootDir, "index.html"),
        inicio: resolve(rootDir, "html/inicio.html"),
        projetos: resolve(rootDir, "html/projetos.html"),
        cadastro: resolve(rootDir, "html/cadastro.html")
      }
    }
  }
});
'@

Write-ProjectFile 'package.json' @'
{
  "name": "projeto-ong",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "devDependencies": {
    "vite": "^5.4.14"
  }
}
'@

Write-ProjectFile 'netlify.toml' @'
[build]
  command = "npm run build"
  publish = "dist"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
'@

Write-ProjectFile '.gitignore' @'
node_modules/
dist/
dist-unmin/
.vscode/
.DS_Store
*.log
'@

Write-ProjectFile '.nvmrc' @'
20
'@

Write-ProjectFile 'README.md' @'
# Projeto ONG Solidária

Aplicação front-end desenvolvida para uma organização do terceiro setor, com foco em acessibilidade, responsividade, modularização e experiência do utilizador.

## Tecnologias

- HTML5 semântico
- CSS3 com Design System, Grid de 12 colunas e Flexbox
- JavaScript ES6 Modules
- SPA com manipulação do DOM
- Templates dinâmicos com Template Literals
- localStorage para preferências não sensíveis
- AOS via CDN para animações leves
- Vite para desenvolvimento e build de produção
- Netlify para publicação

## Estrutura

```text
projeto-ong/
├── index.html
├── html/
│   ├── inicio.html
│   ├── projetos.html
│   └── cadastro.html
├── css/
│   └── style.css
├── imagens/
├── js/
│   ├── app.js
│   ├── router.js
│   ├── templates.js
│   ├── validation.js
│   ├── storage.js
│   └── ui.js
├── package.json
├── vite.config.js
├── netlify.toml
└── README.md
```

A pasta `html/` contém páginas alternativas para navegação sem JavaScript. A interface principal é executada como SPA a partir de `index.html`.

## Instalação local

Pré-requisito: Node.js 20 ou superior.

```bash
npm install
npm run dev
```

Abra o endereço exibido pelo Vite no terminal.

## Build de produção

```bash
npm run build
npm run preview
```

A build otimizada é gerada em `dist/`.

## Acessibilidade

O projeto utiliza landmarks semânticos, navegação por teclado, `:focus-visible`, associação entre `label` e campos, mensagens de validação acessíveis, `aria-expanded`, `aria-controls`, `role="dialog"`, `aria-modal`, `aria-live` e controlo de foco no modal.

## Persistência

O `localStorage` guarda apenas preferências não sensíveis, como tema, modo de alto contraste, última rota e projetos favoritos. Dados pessoais do formulário não são persistidos.

## Versionamento

Estratégia inspirada em GitFlow:

- `main`: versões estáveis
- `develop`: integração contínua
- `feature/*`: novas funcionalidades
- `hotfix/*`: correções urgentes

Mensagens de commit seguem Conventional Commits, como `feat:`, `fix:`, `refactor:` e `chore:`.

A primeira versão estável é `v1.0.0`, seguindo Versionamento Semântico (`MAJOR.MINOR.PATCH`).

## Deploy

A aplicação está preparada para Netlify, com:

- comando de build: `npm run build`
- diretório publicado: `dist`
- redirecionamento de SPA configurado em `netlify.toml`
'@

Write-ProjectFile 'html/inicio.html' @'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Início | ONG Solidária</title>
  <link rel="stylesheet" href="../css/style.css">
</head>
<body>
  <header class="site-header">
    <div class="container header-inner">
      <a class="brand" href="../index.html">ONG Solidária</a>
      <nav aria-label="Navegação principal">
        <ul class="menu">
          <li><a href="./inicio.html" aria-current="page">Início</a></li>
          <li><a href="./projetos.html">Projetos</a></li>
          <li><a href="./cadastro.html">Cadastro</a></li>
        </ul>
      </nav>
    </div>
  </header>
  <main class="container">
    <section class="section">
      <h1>ONG Solidária</h1>
      <picture>
        <source srcset="../imagens/ong.webp" type="image/webp">
        <img src="../imagens/ong.jpg" alt="Equipe da ONG participando de uma ação social">
      </picture>
      <h2>Sobre nós</h2>
      <p>Nossa ONG desenvolve projetos sociais com o objetivo de ajudar a comunidade e promover melhores oportunidades.</p>
    </section>
  </main>
  <footer class="site-footer">
    <div class="container footer-inner"><p>&copy; 2026 ONG Solidária</p></div>
  </footer>
</body>
</html>
'@

Write-ProjectFile 'html/projetos.html' @'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Projetos | ONG Solidária</title>
  <link rel="stylesheet" href="../css/style.css">
</head>
<body>
  <header class="site-header">
    <div class="container header-inner">
      <a class="brand" href="../index.html">ONG Solidária</a>
      <nav aria-label="Navegação principal">
        <ul class="menu">
          <li><a href="./inicio.html">Início</a></li>
          <li><a href="./projetos.html" aria-current="page">Projetos</a></li>
          <li><a href="./cadastro.html">Cadastro</a></li>
        </ul>
      </nav>
    </div>
  </header>
  <main class="container">
    <section class="section">
      <h1>Projetos Sociais</h1>
      <div class="grid-12">
        <article class="project-card" id="voluntariado">
          <span class="badge">Voluntariado</span>
          <picture>
            <source srcset="../imagens/voluntariado.webp" type="image/webp">
            <img src="../imagens/voluntariado.jpg" alt="Voluntários participando de uma atividade social">
          </picture>
          <h2>Trabalho voluntário</h2>
          <p>Pessoas interessadas podem participar das ações da ONG como voluntárias.</p>
        </article>
        <article class="project-card" id="doacao">
          <span class="badge">Doação</span>
          <picture>
            <source srcset="../imagens/projeto1.webp" type="image/webp">
            <img src="../imagens/projeto1.jpg" alt="Projeto social realizado pela ONG">
          </picture>
          <h2>Faça uma doação</h2>
          <p>As contribuições ajudam na manutenção dos projetos sociais.</p>
        </article>
      </div>
    </section>
  </main>
  <footer class="site-footer">
    <div class="container footer-inner"><p>&copy; 2026 ONG Solidária</p></div>
  </footer>
</body>
</html>
'@

Write-ProjectFile 'html/cadastro.html' @'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cadastro | ONG Solidária</title>
  <link rel="stylesheet" href="../css/style.css">
</head>
<body>
  <header class="site-header">
    <div class="container header-inner">
      <a class="brand" href="../index.html">ONG Solidária</a>
      <nav aria-label="Navegação principal">
        <ul class="menu">
          <li><a href="./inicio.html">Início</a></li>
          <li><a href="./projetos.html">Projetos</a></li>
          <li><a href="./cadastro.html" aria-current="page">Cadastro</a></li>
        </ul>
      </nav>
    </div>
  </header>
  <main class="container">
    <section class="section">
      <h1>Cadastro</h1>
      <p>Para utilizar a validação interativa completa, acesse a aplicação principal com JavaScript habilitado.</p>
      <p><a class="button button-primary" href="../index.html#/cadastro">Abrir cadastro na aplicação</a></p>
    </section>
  </main>
  <footer class="site-footer">
    <div class="container footer-inner"><p>&copy; 2026 ONG Solidária</p></div>
  </footer>
</body>
</html>
'@

if (Test-Path (Join-Path $root 'projetos.html')) { Remove-Item (Join-Path $root 'projetos.html') -Force }
if (Test-Path (Join-Path $root 'cadastro.html')) { Remove-Item (Join-Path $root 'cadastro.html') -Force }

Write-Host '=== VERIFICACOES ===' -ForegroundColor Cyan
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw 'Node.js nao encontrado. Instale o Node.js 20+ antes de continuar.' }
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { throw 'npm nao encontrado.' }
Write-Host ('Node: ' + (node -v))
Write-Host ('npm:  ' + (npm -v))
Get-ChildItem (Join-Path $root 'js') -Filter '*.js' | ForEach-Object { node --check $_.FullName; if ($LASTEXITCODE -ne 0) { throw ('Erro de sintaxe em ' + $_.Name) } }
node --check (Join-Path $root 'vite.config.js')
if ($LASTEXITCODE -ne 0) { throw 'Erro de sintaxe no vite.config.js' }

Write-Host '=== INSTALANDO DEPENDENCIAS ===' -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) { throw 'npm install falhou.' }
Write-Host '=== BUILD DE PRODUCAO ===' -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) { throw 'npm run build falhou.' }

Write-Host 'Projeto atualizado e build concluida com sucesso.' -ForegroundColor Green
Write-Host 'Para testar: npm run dev' -ForegroundColor Cyan
Write-Host 'Para testar a build: npm run preview' -ForegroundColor Cyan
Write-Host ('Backup preservado em: ' + $backup) -ForegroundColor Yellow
