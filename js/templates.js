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