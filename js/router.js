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