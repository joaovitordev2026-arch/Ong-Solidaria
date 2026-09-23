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