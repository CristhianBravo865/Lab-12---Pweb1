var libros = []; // Almacenar los libros

// Función para cargar los libros usando AJAX usa recuperarlibros.pl
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
    var nombreUsuario = localStorage.getItem('nombre_usuario'); // Suponiendo que guardas el nombre del usuario en localStorage
    var loginButton = document.getElementById('login-button');

    if (nombreUsuario) {
        loginButton.innerHTML = '<button id="user-button" onclick="toggleMenu()">' + nombreUsuario + '</button>';
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

// Función para cerrar sesión
function cerrarSesion() {
    localStorage.removeItem('nombre_usuario');
    window.location.href = '../index.html'; // Redirigir al inicio
}

// Llamar a la función cargarLibros cuando la página se haya cargado
window.onload = function () {
    cargarLibros();
    verificarUsuario(); // Verificar si el usuario está logueado
};
