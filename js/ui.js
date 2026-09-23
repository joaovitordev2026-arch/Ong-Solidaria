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