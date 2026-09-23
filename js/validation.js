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