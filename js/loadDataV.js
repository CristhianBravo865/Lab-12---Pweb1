//Cargar productos
function cargarProductos() {
    fetch('cgi-bin/get_productsV.pl')
        .then(response => response.json())
        .then(data => {
            const items = document.querySelectorAll('.item');

            data.forEach((producto, index) => {
                const item = items[index];
                item.querySelector('.titulo-item').textContent = producto.nombre;
                item.querySelector('.img-item').src = producto.imagen;
                item.querySelector('.precio-item').textContent = `s/.${producto.precio}`;
                item.setAttribute('data-indice', index + 1);

                const botonEliminar = item.querySelector('.boton-item');
                botonEliminar.setAttribute('onclick', `eliminarProducto('${producto.nombre}')`);
            });
            ocultarElementosVacios();
        })
        .catch(error => console.error('Error al obtener los productos:', error));
}

document.addEventListener("DOMContentLoaded", function () {
    cargarProductos();
});
  
//Eliminar producto
const productosContainer = document.getElementById("productos-container");
function eliminarProducto(nombre) {
    fetch('cgi-bin/eliminar_producto.pl', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ nombre: nombre }),
    })
        .then(response => response.json())
        .then(data => {
            if (data.success === 1) {
                const productoAEliminar = document.querySelector(`.item[data-nombre="${nombre}"]`);
                if (productoAEliminar) {
                    productoAEliminar.tituloItem.textContent = null;
                    productoAEliminar.imgItem.src = null;
                    productoAEliminar.precioItem.textContent = null;
                    productoAEliminar.style.display = "none";
                }
                cargarProductos();
                ocultarElementosVacios();
                ocultarUltimoProducto();
                cargarProductos();
                ocultarElementosVacios();
                // Llamar a la función para cargar productos y actualizar la interfaz
            } else {
                console.error('Error al eliminar el producto:', data.error);
            }
        })
        .catch(error => console.error('Error al eliminar el producto:', error));
}


  
//Ocultar elementos no llenados
function ocultarElementosVacios() {
    const contenedor = document.getElementById("productos-container");
    const elementos = contenedor.getElementsByClassName("item");

    for (let i = 0; i < elementos.length; i++) {
        const titulo = elementos[i].getElementsByClassName("titulo-item")[0].innerText.trim();
        const imgSrc = elementos[i].getElementsByClassName("img-item")[0].getAttribute("src").trim();
        const precio = elementos[i].getElementsByClassName("precio-item")[0].innerText.trim();

        if ((!titulo || !imgSrc || !precio) && elementos[i].style.display !== "none") {
            elementos[i].style.display = "none";
        }
    }
}

//Oculta ultimo producto
// Oculta el último producto que no sea "Agrega un producto" y que esté lleno
function ocultarUltimoProducto() {
    const productosContainer = document.getElementById("productos-container");
    const items = productosContainer.querySelectorAll('.item');
    
    // Encuentra el último producto visible que no sea "Agrega un producto" y que esté lleno
    let ultimoProductoIndex = items.length - 1;
    while (ultimoProductoIndex >= 0) {
        const ultimoProducto = items[ultimoProductoIndex];
        const titulo = ultimoProducto.querySelector('.titulo-item').textContent.trim();
        const imgSrc = ultimoProducto.querySelector('.img-item').getAttribute('src').trim();
        const precio = ultimoProducto.querySelector('.precio-item').textContent.trim();

        // Considera elementos con display: none
        const isVisible = window.getComputedStyle(ultimoProducto).display !== 'none';

        if (isVisible && titulo && imgSrc && precio && !titulo.includes('Agrega un producto')) {
            ultimoProducto.style.display = "none";
            break;
        }

        ultimoProductoIndex--;
    }
}


//Cargar credito y perfil
document.addEventListener("DOMContentLoaded", function() {
    fetch('cgi-bin/get_datos.pl')
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error en la solicitud: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Datos recibidos:', data);
            const creditoUsuario = document.getElementById('credito-nav');
            const perfilUsuario = document.getElementById('perfil-nav');

            if (creditoUsuario && data && data.credito !== undefined &&
                perfilUsuario && data && data.perfil !== undefined) {
                creditoUsuario.textContent = `s/.${data.credito}`;
                perfilUsuario.textContent = `${data.perfil}`;
            } else {
                console.error('Error: Datos no disponibles en la respuesta.');
            }
        })
        .catch(error => console.error('Error al obtener los datos del usuario:', error));
});
//Funcionalidad de interaccion SALIR
document.addEventListener("DOMContentLoaded", function() {
    document.getElementById("salir-btn").addEventListener("click", function() {
        fetch("cgi-bin/salir.pl", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Error al intentar borrar las cookies");
            }
            console.log("Cookies borradas correctamente");
            window.location.href = "index.html";
        })
        .catch(error => {
            console.error(error);
        });
    });
});
function agregarProdu(){
    console.log("...");
    var nombre = document.getElementById('nombre-popup').value;
    var imagen = document.getElementById('imagen-popup').value;
    var precio = document.getElementById('precio-popup').value;
    var stock = document.getElementById('stock-popup').value;
    
    if (nombre && imagen && precio && stock) {
        console.log("nombre: ", nombre, "imagen", imagen, "precio", precio, "stock", stock);

        fetch('cgi-bin/agregar_producto.pl', {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                nombre: nombre,
                imagen: imagen,
                precio: precio,
                stock: stock
            })
        })
        .then(response => response.json())
        .then(data => {
            console.log("Datos procesados correctamente:", data);
            // Llama a cargarProductos y ocultarElementosVacios después de procesar los datos
            //mostrarUltimoProducto();
            cargarProductos();
            ocultarElementosVacios();
            cerrarPopup();
            window.location.href = 'indexV.html';
        })
        .catch(error => {
            console.error("Error al procesar los datos:", error);
        });

    } else {
        alert('Por favor, completa todos los campos.');
    };
}
/*function mostrarUltimoProducto() {
    const productosContainer = document.getElementById("productos-container");
    const items = productosContainer.querySelectorAll('.item');

    // Encuentra el último producto visible
    let ultimoProductoIndex = items.length - 1; // Índice del último elemento
    while (ultimoProductoIndex >= 0) {
        const ultimoProducto = items[ultimoProductoIndex];
        const titulo = ultimoProducto.querySelector('.titulo-item').textContent.trim();
        const imgSrc = ultimoProducto.querySelector('.img-item').getAttribute('src').trim();
        const precio = ultimoProducto.querySelector('.precio-item').textContent.trim();

        // Considera elementos con display: none
        const isVisible = window.getComputedStyle(ultimoProducto).display !== 'none';

        if (isVisible && titulo && imgSrc && precio && !titulo.includes('Agrega un producto')) {
            ultimoProducto.style.display = "block";
            break;
        }

        ultimoProductoIndex--;
    }
}*/


//