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

    // Verificar al cargar para asegurar que el usuario esté registrado
    if (!getCookie("nombre_usuario")) {
        alert("Sesión inválida. Debes iniciar sesión nuevamente.");
        window.location.href = "/login.html";
    }

    // Cargar libros desde el servidor
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
            console.error("Error al cargar libros:", err);
            alert("Hubo un problema al cargar los libros. Inténtalo nuevamente más tarde.");
        });

    // Renderizar los libros en la tabla
    function renderTable(libros) {
        if (libros.length === 0) {
            const row = document.createElement("tr");
            row.innerHTML = `<td colspan="5">No hay libros disponibles</td>`;
            tableBody.appendChild(row);
            return;
        }

        libros.forEach((libro) => {
            const row = document.createElement("tr");
            row.innerHTML = `
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

    // Agregar libro
    document.getElementById("guardar-libro-btn").addEventListener("click", function () {
        const form = document.getElementById("agregar-libro-form");
        const formData = new FormData(form);

        fetch("/cgi-bin/agregarlibro.pl", {
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
                    alert("Libro agregado con éxito");
                    window.location.reload();
                } else {
                    alert("Error al agregar libro: " + data.error);
                }
            })
            .catch((err) => {
                console.error("Error al enviar formulario:", err);
                alert("Hubo un problema al agregar el libro. Inténtalo nuevamente más tarde.");
            });
    });
});
