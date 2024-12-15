var libros = []; // Almacenar los libros

// Función para cargar los libros usando AJAX desde recuperarlibros.pl
function cargarLibros() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/cgi-bin/recuperarlibros.pl', true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            libros = JSON.parse(xhr.responseText);
            mostrarLibros(libros);
        }
    };
    xhr.send();
}

// Función para mostrar los libros
function mostrarLibros(librosMostrar) {
    var container = document.getElementById('books-container');
    container.innerHTML = ''; // Limpiar los libros actuales

    librosMostrar.forEach(function (libro) {
        var card = document.createElement('div');
        card.classList.add('book-card');

        var image = document.createElement('img');
        image.src = '/images/' + libro.imagen;
        image.alt = libro.nombre;
        image.classList.add('book-image');
        card.appendChild(image);

        var title = document.createElement('h2');
        title.textContent = libro.nombre;
        title.classList.add('book-title');
        card.appendChild(title);

        var price = document.createElement('p');
        price.textContent = 'Precio: S/ ' + libro.precio;
        price.classList.add('book-price');
        card.appendChild(price);

        var button = document.createElement('button');
        button.classList.add('add-to-cart');
        button.innerHTML = '<img src="/images/carrito-de-compras.png" alt="Carrito" class="cart-icon"> Añadir';
        card.appendChild(button);

        container.appendChild(card);
    });
}

// Función para filtrar los libros por el nombre
function buscarLibros() {
    var query = document.getElementById('search-input').value.toLowerCase();
    var librosFiltrados = libros.filter(function (libro) {
        return libro.nombre.toLowerCase().includes(query);
    });
    mostrarLibros(librosFiltrados);
}

// Función para verificar si el usuario está logueado
function verificarUsuario() {
    var nombreUsuario = getCookie('nombre_usuario'); // Recuperar nombre del usuario de la cookie
    var loginButton = document.getElementById('login-button');

    if (nombreUsuario) {
        loginButton.innerHTML = '<button id="user-button" onclick="toggleMenu()">' + decodeURIComponent(nombreUsuario) + '</button>'; // Decodificar el nombre de la cookie
        document.getElementById('logout-menu').style.display = 'none'; // Iniciar con el menú oculto
    } else {
        loginButton.innerHTML = '<button onclick="window.location.href=\'../login.html\'">Login</button>';
    }
}

// Función para mostrar/ocultar el menú desplegable
function toggleMenu() {
    var menu = document.getElementById('logout-menu');
    menu.style.display = (menu.style.display === 'none' || menu.style.display === '') ? 'block' : 'none';
}

// Función para obtener una cookie por nombre
function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) === 0) return decodeURIComponent(c.substring(nameEQ.length, c.length)); // Decodificar el valor de la cookie
    }
    return null;
}

// Función para crear o actualizar una cookie
function setCookie(name, value, hours) {
    var expires = "";
    if (hours) {
        var date = new Date();
        date.setTime(date.getTime() + (hours * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
}

// Función para cerrar sesión
function cerrarSesion() {
    // Eliminar cookies de sesión
    setCookie('nombre_usuario', '', -1);
    setCookie('login_correo', '', -1);
    setCookie('tipo_usuario', '', -1);
    window.location.href = '../index.html'; // Redirigir al inicio
}

// Llamar a la función cargarLibros cuando la página se haya cargado
window.onload = function () {
    cargarLibros();
    verificarUsuario(); // Verificar si el usuario está logueado
};
