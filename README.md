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
## Testes e qualidade

A aplicação foi validada em ambiente local e por meio da build de produção gerada com Vite. Os testes abrangeram navegação SPA, histórico do navegador, formulários, validações, localStorage, componentes de interface, responsividade e acessibilidade por teclado.

Também foram utilizadas as ferramentas de desenvolvimento do navegador, incluindo Console, Network e inspeção do DOM, para identificar falhas de carregamento e comportamentos inesperados.

A auditoria das dependências destinadas à produção foi executada com o comando `npm audit --omit=dev`, apresentando 0 vulnerabilidades de produção.

## Fluxo Git e Conventional Commits

O projeto adota uma estrutura baseada no GitFlow. A branch `main` representa a versão estável, enquanto `develop` concentra o desenvolvimento integrado.

Novas alterações são realizadas em branches com o prefixo `feature/` e posteriormente integradas à `develop` por meio de Pull Requests.

As mensagens de commit seguem o padrão Conventional Commits, com prefixos como `feat:`, `fix:`, `docs:`, `refactor:` e `chore:`. As versões estáveis seguem o Versionamento Semântico no formato `MAJOR.MINOR.PATCH`.

## Métricas da build

A build de produção foi gerada com Vite. A versão sem minificação apresentou 46.881 bytes, enquanto a versão minificada apresentou 36.709 bytes, correspondendo a uma redução aproximada de 21,70%.

A redução incidiu principalmente sobre os ficheiros JavaScript e CSS, diminuindo o volume de dados necessário para publicação e transferência em rede.
