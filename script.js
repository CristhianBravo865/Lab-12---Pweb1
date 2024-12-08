const navbarMenu = document.querySelector(".navbar .links");
const hamburgerBtn = document.querySelector(".hamburger-btn");
const hideMenuBtn = navbarMenu.querySelector(".close-btn");
const showPopupBtn = document.querySelector(".login-btn");
const formPopup = document.querySelector(".form-popup");
const hidePopupBtn = formPopup.querySelector(".close-btn");
const signupLoginLink = formPopup.querySelectorAll(".bottom-link a");
const botonPagar = document.querySelector(".btn-pagarIndex");

//menu responsive para movil
hamburgerBtn.addEventListener("click", () => {
    navbarMenu.classList.toggle("show-menu");
});

//oculta menu para movil
hideMenuBtn.addEventListener("click", () =>  hamburgerBtn.click());

//animacion popup
showPopupBtn.addEventListener("click", () => {
    document.body.classList.toggle("show-popup");
});

//animacion popup
botonPagar.addEventListener("click", () => {
    document.body.classList.toggle("show-popup");
});

//oculta animacion popup
hidePopupBtn.addEventListener("click", () => showPopupBtn.click());

//registrarse muestra y oculta
signupLoginLink.forEach(link => {
    link.addEventListener("click", (e) => {
        e.preventDefault();
        
        formPopup.classList[link.id === 'signup-link' ? 'add' : 'remove']("show-signup");
        
        // Agregar lógica de redirección aquí
        if (link.id === 'signup-link') {
            redirectToRegistration(); // Llama a la función de redirección
        }
        if (link.id === 'recuperar') {
            redirectToRegistrations(); // Llama a la función de redirección
        }
    });
});

function redirectToProfile() {
    //lógica de verificación del usuario y contraseña(aun por completar)
    var userEmail = document.querySelector('#loginForm input[type="text"]').value;
    window.location.href = 'perfil.html?user=' + userEmail;
}
function redirectToRegistration() {
    // Lógica para redirigir a la página de registro
    window.location.href = 'registro.html';
}
function redirectToRegistrations() {
    // Lógica para redirigir a la página de registro
    window.location.href = 'recuperarPassword.html';
}

document.addEventListener("DOMContentLoaded", function () {
  var sessionUsername = sessionStorage.getItem("session_username");

  if (sessionUsername) {
      var perfilLink = document.querySelector("nav .links li a[href='perfil.html']");
      if (perfilLink) {
          perfilLink.innerText = "Perfil de " + sessionUsername;
      }
  }

  var logoutLink = document.getElementById("logout-link");

  if (logoutLink) {
      logoutLink.addEventListener("click", function (event) {
          event.preventDefault();

          sessionStorage.removeItem("session_username");
          window.location.href = "index.html";
      });
  }
});

// index