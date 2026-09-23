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