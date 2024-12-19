var libros = [];
var carrito = [];

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
        button.onclick = function () {
            añadirAlCarrito(libro.id);
        };
        card.appendChild(button);

        container.appendChild(card);
    });
}

// Función para añadir un libro al carrito
function añadirAlCarrito(libroId) {
    var libroExistente = carrito.find(item => item.id === libroId);
    if (libroExistente) {
        libroExistente.cantidad += 1;
    } else {
        var libro = libros.find(libro => libro.id === libroId);
        if (libro) {
            carrito.push({ ...libro, cantidad: 1 });
        }
    }
    actualizarCarrito();
}

// Actualizar el contenido y el total del carrito
function actualizarCarrito() {
    var cartItemsList = document.getElementById('cart-items-list');
    var cartTotal = document.getElementById('cart-total');
    var cartItemsCount = document.getElementById('cart-items-count');

    cartItemsList.innerHTML = '';
    var total = 0;

    carrito.forEach(function (item) {
        total += item.precio * item.cantidad;

        var li = document.createElement('li');
        li.classList.add('cart-item');

        li.innerHTML = `
            ${item.nombre} - S/ ${item.precio} x ${item.cantidad}
            <button class="cart-action" onclick="cambiarCantidad(${item.id}, 1)">+</button>
            <button class="cart-action" onclick="cambiarCantidad(${item.id}, -1)">-</button>
            <button class="cart-action remove" onclick="eliminarDelCarrito(${item.id})">Eliminar</button>
        `;

        cartItemsList.appendChild(li);
    });

    cartTotal.textContent = total.toFixed(2);
    cartItemsCount.textContent = carrito.reduce((sum, item) => sum + item.cantidad, 0);
}

// Función para cambiar la cantidad de un libro en el carrito
function cambiarCantidad(libroId, cambio) {
    var libro = carrito.find(item => item.id === libroId);
    if (libro) {
        libro.cantidad += cambio;
        if (libro.cantidad <= 0) {
            eliminarDelCarrito(libroId);
        } else {
            actualizarCarrito();
        }
    }
}

// Función para eliminar un libro del carrito
function eliminarDelCarrito(libroId) {
    carrito = carrito.filter(item => item.id !== libroId);
    actualizarCarrito();
}

// Función para mostrar/ocultar el menú desplegable del carrito
function toggleCart() {
    var cartMenu = document.getElementById('cart-menu');
    cartMenu.style.display = (cartMenu.style.display === 'none' || cartMenu.style.display === '') ? 'block' : 'none';
}

// Finalizar la compra
function finalizarCompra() {
    alert('Compra finalizada. ¡Gracias por tu compra!');
    carrito = [];
    actualizarCarrito();
}

// Llamar a la función cargarLibros cuando la página se haya cargado
window.onload = function () {
    cargarLibros();
    verificarUsuario(); // Verificar si el usuario está logueado
};

// Función para filtrar los libros por el nombre
function buscarLibros() {
    var query = document.getElementById('search-input').value.toLowerCase();
    var librosFiltrados = libros.filter(function (libro) {
        return libro.nombre.toLowerCase().includes(query);
    });
    mostrarLibros(librosFiltrados);
}

// Función para verificar el usuario logueado y mostrar opciones personalizadas
function verificarUsuario() {
    var nombreUsuario = getCookie('nombre_usuario'); // Recuperar nombre del usuario de la cookie
    var loginButton = document.getElementById('login-button');
    var menu = document.getElementById('logout-menu');

    if (nombreUsuario) {
        loginButton.innerHTML = `<button id="user-button" onclick="toggleMenu()">${decodeURIComponent(nombreUsuario)}</button>`;

        var tipoUsuario = getCookie('tipo_usuario');
        menu.innerHTML = ''; // Limpiar menú antes de agregar opciones

        if (tipoUsuario === 'propietario') {
            menu.innerHTML += `
                <button class="dashboard-button" onclick="window.location.href='/dashboard.html'">Dashboard</button>
                <button class="update-button" onclick="window.location.href='/update_descripcion.html'">Descripción de Usuario</button>
            `;
        } else if (tipoUsuario === 'usuario') {
            menu.innerHTML += `
                <button class="update-button" onclick="window.location.href='/update_descripcion.html'">Descripción de Usuario</button>
            `;
        }

        menu.innerHTML += `
            <button id="logout-button" class="logout-button" onclick="cerrarSesion()">Cerrar sesión</button>
        `;
        menu.style.display = 'none'; // Iniciar con el menú oculto
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
        var c = ca[i].trim();
        if (c.indexOf(nameEQ) === 0) return decodeURIComponent(c.substring(nameEQ.length, c.length));
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
    setCookie('nombre_usuario', '', -1);
    setCookie('login_correo', '', -1);
    setCookie('tipo_usuario', '', -1);
    window.location.href = '../index.html'; // Redirigir al inicio
}
