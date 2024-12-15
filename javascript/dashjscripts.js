document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById("modal");
    const tableBody = document.querySelector("#libros-table tbody");

    // Verificar si el usuario tiene permiso
    const tipoUsuario = getCookie("tipo_usuario");

    if (!tipoUsuario || tipoUsuario !== "propietario") {
        alert("Acceso denegado. Debes iniciar sesión como propietario.");
        window.location.href = "/login.html";
        return;
    }

    // Verificar sesión al cargar
    if (!getCookie("nombre_usuario")) {
        alert("Sesión inválida. Debes iniciar sesión nuevamente.");
        window.location.href = "/login.html";
        return;
    }

    // Cargar datos desde el servidor
    fetch("/cgi-bin/dashboard.pl", {
        headers: {
            "Tipo-Usuario": tipoUsuario,
        },
    })
        .then((response) => {
            if (!response.ok) {
                throw new Error("Error al cargar los datos del servidor");
            }
            return response.json();
        })
        .then((data) => {
            if (data.error) {
                alert(data.error);
                window.location.href = "/login.html";
            } else {
                renderTable(data);
            }
        })
        .catch((err) => {
            console.error("Error al cargar datos:", err);
            alert("Hubo un problema al cargar los datos. Inténtalo nuevamente más tarde.");
        });

    // Renderizar tabla
    function renderTable(libros) {
        if (libros.length === 0) {
            const row = document.createElement("tr");
            row.innerHTML = `<td colspan="7">No hay libros disponibles</td>`;
            tableBody.appendChild(row);
            return;
        }

        libros.forEach((libro) => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${libro.tienda_id}</td>
                <td>${libro.tienda_nombre}</td>
                <td>${libro.nombre}</td>
                <td>${libro.descripcion}</td>
                <td><img src="/images/${libro.imagen}" alt="${libro.nombre}" width="50"></td>
                <td>${libro.precio}</td>
                <td>${libro.stock}</td>
            `;
            tableBody.appendChild(row);
        });
    }

    // Mostrar modal
    window.showModal = function () {
        modal.style.display = "block";
    };

    // Cerrar modal
    window.closeModal = function () {
        modal.style.display = "none";
    };

    // Manejar envío del formulario
    document.getElementById("agregar-inventario-form").addEventListener("submit", function (event) {
        event.preventDefault(); // Evita el envío normal del formulario

        const form = event.target;
        const formData = new FormData(form);

        fetch("/cgi-bin/agregar_relacion_inventario.pl", {
            method: "POST",
            body: formData,
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Error al enviar el formulario");
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    alert(data.message); // Relación creada exitosamente
                    window.location.reload();
                } else {
                    alert("Error: " + data.error); // Relación ya existente
                }
            })
            .catch((err) => {
                console.error("Error al enviar formulario:", err);
                alert("Hubo un problema al agregar la relación. Inténtalo nuevamente más tarde.");
            });
    });
});
