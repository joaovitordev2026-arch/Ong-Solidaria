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